"""Translate the manuscript's math from Typst's evaluated content tree.

This intentionally preserves the source's actual grouping, including grouping
that a reader might not have intended. It does not parse the math using Pandoc:
Pandoc 3.11's Typst reader changes the grouping of several source expressions.

The checked-in cache lets the manuscript converter run without Typst installed.
Regenerate it with ``python typst_math.py /path/to/efficient_imprecise_bandits.typ``
(passing the appropriate source path) in an environment with the ``typst``
Python package. The source file is only ever read.
"""

from __future__ import annotations

import json
import re
from pathlib import Path


CACHE_PATH = Path(__file__).with_name("math-cache.json")
HELPERS = r'''
#let opdist = math.op("dist")
#let opspan = math.op("span")
#let opker = math.op("ker")
#let optr = math.op("tr")
#let opdet = math.op("det")
#let opcol = math.op("col")
#let opdiag = math.op("diag")
#let opargmax = math.op("argmax")
#let opargmin = math.op("argmin")
#let poly = math.op("poly")
#let Pr = math.op("Pr")
#let cM = $cal(M)$
#let credal = math.op("CREDALMARK")
'''

SYMBOLS = {
    "×": r"\times", "Δ": r"\Delta", "Θ": r"\Theta", "Ξ": r"\Xi",
    "Φ": r"\Phi", "Ω": r"\Omega", "α": r"\alpha", "β": r"\beta",
    "γ": r"\gamma", "δ": r"\delta", "ε": r"\varepsilon", "ζ": r"\zeta",
    "η": r"\eta", "ι": r"\iota", "λ": r"\lambda", "μ": r"\mu",
    "ξ": r"\xi", "π": r"\pi", "ρ": r"\rho", "σ": r"\sigma",
    "τ": r"\tau", "ω": r"\omega", "‖": r"\Vert", "…": r"\ldots",
    "ℓ": r"\ell", "ℚ": r"\mathbb{Q}", "ℝ": r"\mathbb{R}",
    "𝔼": r"\mathbb{E}", "←": r"\leftarrow", "→": r"\to",
    "↦": r"\mapsto", "∃": r"\exists", "∅": r"\varnothing",
    "∈": r"\in", "∉": r"\notin", "∎": r"\blacksquare", "∑": r"\sum",
    "−": "-", "∗": r"\ast", "∞": r"\infty", "∩": r"\cap",
    "∼": r"\sim", "≔": r"\coloneqq", "≠": r"\ne", "≤": r"\le",
    "≥": r"\ge", "⊆": r"\subseteq", "⊈": r"\nsubseteq",
    "⋆": r"\star", "⌈": r"\lceil", "⌉": r"\rceil",
    "□": r"\square", "⟂": r"\perp", "⪯": r"\preceq",
    "⪰": r"\succeq", "{": r"\{", "}": r"\}",
}
DELIMITERS = {
    "(": "(", ")": ")", "[": "[", "]": "]", "{": r"\{",
    "}": r"\}", "|": "|", "‖": r"\Vert", "⌈": r"\lceil",
    "⌉": r"\rceil",
}


def _escape_text(value: str) -> str:
    return re.sub(r"[\\{}$&#_%]", lambda m: {
        "\\": r"\textbackslash{}", "{": r"\{", "}": r"\}",
        "$": r"\$", "&": r"\&", "#": r"\#", "_": r"\_",
        "%": r"\%",
    }[m.group()], value)


def _symbol(value: str) -> str:
    if value in SYMBOLS:
        return SYMBOLS[value]
    if len(value) == 1 and (value.isascii() and (value.isalpha() or value in "()+,.:<=>[]|")):
        return value
    raise ValueError(f"Unsupported Typst math symbol: {value!r}")


def _render(node: dict) -> str:
    kind = node["func"]
    if kind == "equation":
        return _render(node["body"])
    if kind == "symbol":
        return _symbol(node["text"])
    if kind == "text":
        text = node["text"]
        if re.fullmatch(r"\d+(?:\.\d+)?", text):
            return text
        return r"\text{\normalfont " + _escape_text(text) + "}"
    if kind == "sequence":
        # Separating tokens prevents a following variable from extending a
        # LaTeX control word. Math ignores these ordinary source spaces.
        return " ".join(_render(child) for child in node["children"] if child["func"] != "space")
    if kind == "space":
        return " "
    if kind == "styled":
        # In this manuscript the only evaluated math style is cal(...).
        # The native query deliberately hides the style-map internals, so
        # reject unfamiliar targets instead of silently assuming a style.
        child = node["child"]
        if child.get("func") != "symbol" or child.get("text") not in "ELMT":
            raise ValueError(f"Unrecognized styled mathematical content: {node!r}")
        return r"\mathcal{" + _render(child) + "}"
    if kind == "lr":
        body = node["body"]
        children = body.get("children", []) if body["func"] == "sequence" else []
        if len(children) < 2:
            raise ValueError(f"Unrecognized delimiter content: {node!r}")
        left, right = children[0], children[-1]
        if left.get("func") != "symbol" or right.get("func") != "symbol":
            raise ValueError(f"Unrecognized delimiters: {node!r}")
        l, r = DELIMITERS[left["text"]], DELIMITERS[right["text"]]
        middle = _render({"func": "sequence", "children": children[1:-1]})
        return r"\left" + l + " " + middle + r" \right" + r
    if kind == "attach":
        base = _render(node["base"])
        # Preserve the status of operators (sum, min, max, ...) so TeX can
        # place their limits correctly in inline and displayed equations.
        if node["base"]["func"] not in ("symbol", "text", "op"):
            base = "{" + base + "}"
        if "b" in node:
            base += "_{" + _render(node["b"]) + "}"
        for key in ("t", "tr"):
            if key in node:
                base += "^{" + _render(node[key]) + "}"
        if set(node) - {"func", "base", "b", "t", "tr"}:
            raise ValueError(f"Unsupported attachment: {node!r}")
        return base
    if kind == "op":
        text = node["text"]["text"]
        if text == "CREDALMARK":
            return r"\credal"
        return r"\operatorname" + ("*" if node.get("limits") else "") + "{" + _escape_text(text) + "}"
    if kind == "frac":
        return r"\frac{" + _render(node["num"]) + "}{" + _render(node["denom"]) + "}"
    if kind == "root":
        return r"\sqrt{" + _render(node["radicand"]) + "}"
    if kind == "accent":
        command = {"̂": r"\hat", "̃": r"\tilde"}[node["accent"]]
        return command + "{" + _render(node["base"]) + "}"
    if kind == "overline":
        return r"\overline{" + _render(node["body"]) + "}"
    if kind == "h":
        return {"1em": r"\quad", "0.17em": r"\,"}[node["amount"]]
    if kind == "primes":
        return " ".join([r"\prime"] * node["count"])
    if kind == "cases":
        return "\\begin{cases}\n" + " \\\\\n".join(_render(row) for row in node["children"]) + "\n\\end{cases}"
    if kind == "mat":
        return "\\begin{pmatrix}" + r" \\ ".join(" & ".join(_render(cell) for cell in row) for row in node["rows"]) + r"\end{pmatrix}"
    if kind == "binom":
        return r"\binom{" + _render(node["upper"]) + "}{" + ", ".join(_render(x) for x in node["lower"]) + "}"
    if kind == "align-point":
        return "&"
    if kind == "linebreak":
        return "\\\\\n"
    raise ValueError(f"Unsupported Typst math element: {node!r}")


def _has_alignment(node: dict) -> bool:
    """Detect equation-level alignment, without descending into cases/matrices."""
    if node["func"] in ("align-point", "linebreak"):
        return True
    if node["func"] == "sequence":
        return any(_has_alignment(child) for child in node["children"])
    if node["func"] == "equation":
        return _has_alignment(node["body"])
    return False


def query_math(expressions: list[str]) -> list[dict]:
    """Evaluate every expression in one native Typst compilation."""
    import typst
    content = HELPERS + "\n\n".join("$" + expr + "$" for expr in expressions)
    result = json.loads(typst.query(content.encode("utf-8"), "math.equation"))
    if len(result) != len(expressions):
        raise ValueError(f"Expected {len(expressions)} equations; Typst returned {len(result)}")
    return result


def render_math_ast(node: dict) -> str:
    rendered = _render(node)
    if _has_alignment(node):
        rendered = "\\begin{aligned}\n" + rendered + "\n\\end{aligned}"
    return rendered


_cache: dict[str, str] | None = None


def convert_math(expr: str, display: bool = False) -> str:
    """Return LaTeX math contents (without dollar signs or display wrappers)."""
    global _cache
    if _cache is None:
        _cache = json.loads(CACHE_PATH.read_text()) if CACHE_PATH.exists() else {}
    key = expr.strip()
    if key not in _cache:
        _cache[key] = render_math_ast(query_math([expr])[0])
    return _cache[key]


def build_cache(source: Path, destination: Path = CACHE_PATH) -> dict[str, str]:
    expressions = re.findall(r"\$(.*?)\$", source.read_text(), re.S)
    trees = query_math(expressions)
    cache = {expr.strip(): render_math_ast(tree) for expr, tree in zip(expressions, trees)}
    destination.write_text(json.dumps(cache, ensure_ascii=False, indent=2) + "\n")
    return cache


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("--output", type=Path, default=CACHE_PATH)
    args = parser.parse_args()
    cache = build_cache(args.source, args.output)
    print(f"Wrote {len(cache)} distinct math expressions to {args.output}")
