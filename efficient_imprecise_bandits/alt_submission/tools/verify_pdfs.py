#!/usr/bin/env python3
"""Compare rendered Typst/LaTeX content, retaining provenance and draft colour.

This is an extraction audit, not a proof of mathematical or visual equivalence.
Font-dependent math encodings and fraction/superscript reading order can produce
false differences. The reports deliberately retain such differences for review.
Only layout whitespace, discretionary line-break hyphens, mathematical alphabet
styling, ligatures, and Unicode presentation variants are normalized.
"""
from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from difflib import SequenceMatcher
import json
from pathlib import Path
import re
import unicodedata

import pymupdf


DRAFT_BLUE = 0x0057D9
ROOT = Path(__file__).resolve().parents[1]


@dataclass(frozen=True)
class Character:
    value: str
    page: int
    color: int
    font: str
    x: float
    y: float

    @property
    def blue(self):
        return self.color == DRAFT_BLUE


def normalize_char(value: str) -> str:
    text = unicodedata.normalize("NFKC", value)
    return "".join(c for c in text if not 0xFE00 <= ord(c) <= 0xFE0F and c != "\u00ad")


def math_font(font: str) -> bool:
    # Covers New Computer Modern (Typst/Unicode math) and conventional TeX.
    return bool(re.search(r"Math|(?:^|[-+])CM(?:MI|SY|EX)|^CM|MS[AB]M|LMMath", font, re.I))


def extract(path: Path, role: str):
    doc = pymupdf.open(path)
    chars: list[Character] = []
    removed = []
    spans_by_color = Counter()
    glyphs_by_color = Counter()
    fonts = Counter()
    lines_seen = []
    for index, page in enumerate(doc):
        for block in page.get_text("rawdict")["blocks"]:
            if block["type"] != 0:
                continue
            for line in block["lines"]:
                text = "".join(c["c"] for s in line["spans"] for c in s["chars"])
                flat_text = re.sub(r"\s+", " ", text).strip()
                y0, y1 = line["bbox"][1], line["bbox"][3]
                reason = None
                if role == "source" and text.strip() == "Vinayak Pathak":
                    reason = "author removed as requested"
                elif y0 > page.rect.height - (75 if role == "target" else 60) and re.fullmatch(r"\s*\d+\s*", text):
                    reason = "page number"
                elif role == "target" and y1 < 58:
                    reason = "ALT running header / proceedings boilerplate"
                elif role == "target" and index == 0 and re.match(r"^(?:Anonymous Authors?|author names withheld)$", flat_text, re.I):
                    reason = "anonymous author placeholder"
                elif role == "target" and index == 0 and flat_text == "Editor: Under Review for ALT 2027":
                    reason = "ALT review-status boilerplate"
                elif role == "target" and index == 0 and flat_text.startswith("© 2027"):
                    reason = "ALT copyright boilerplate"
                if reason:
                    removed.append({"page": index + 1, "text": text, "reason": reason})
                    continue
                line_chars = []
                for span in line["spans"]:
                    color, font = span["color"], span["font"]
                    spans_by_color[f"#{color:06X}"] += 1
                    fonts[font] += len(span["chars"])
                    for c in span["chars"]:
                        glyphs_by_color[f"#{color:06X}"] += 1
                        line_chars.append(Character(c["c"], index + 1, color, font, c["origin"][0], c["origin"][1]))
                chars.extend(line_chars)
                if line_chars:
                    last = line_chars[-1]
                    chars.append(Character("\n", last.page, last.color, last.font, last.x, last.y))
                lines_seen.append({"page": index + 1, "text": text, "bbox": line["bbox"]})
    return chars, {
        "path": str(path), "pages": len(doc), "metadata": doc.metadata,
        "font_glyph_counts": dict(fonts), "color_span_counts": dict(spans_by_color),
        "color_glyph_counts": dict(glyphs_by_color), "removed_layout_lines": removed,
    }


def stream(chars: list[Character], prose=False):
    normalized = []
    for i, char in enumerate(chars):
        if prose and math_font(char.font):
            continue
        # Only a hyphen immediately preceding an extracted line break is
        # discretionary. Joining it is reported as a normalization, not an edit.
        if char.value in ("-", "‐") and i + 1 < len(chars) and chars[i + 1].value == "\n":
            continue
        for value in normalize_char(char.value):
            if not value.isspace() and (not prose or value.isalpha()):
                normalized.append(Character(value, char.page, char.color, char.font, char.x, char.y))
    return normalized


def context(chars, start, end, radius=90):
    text = "".join(c.value for c in chars[max(0,start-radius):min(len(chars),end+radius)])
    return text


def compare(a, b):
    # Characters permit colour verification through line wraps and font splits.
    av, bv = "".join(c.value for c in a), "".join(c.value for c in b)
    matcher = SequenceMatcher(None, av, bv, autojunk=False)
    differences, color_differences = [], []
    equal_count = 0
    for tag, i, j, k, l in matcher.get_opcodes():
        if tag == "equal":
            equal_count += j-i
            mismatch_runs = []
            run = None
            for offset in range(j-i):
                mismatch = a[i+offset].blue != b[k+offset].blue
                if mismatch and run is None:
                    run = offset
                if run is not None and (not mismatch or offset == j-i-1):
                    end = offset if not mismatch else offset+1
                    mismatch_runs.append((run,end))
                    run = None
            for start,end in mismatch_runs:
                color_differences.append({
                    "text": av[i+start:i+end],
                    "source_page": a[i+start].page, "target_page": b[k+start].page,
                    "source_blue": a[i+start].blue, "target_blue": b[k+start].blue,
                    "source_context": context(a,i+start,i+end),
                    "target_context": context(b,k+start,k+end),
                })
        else:
            differences.append({
                "kind": tag,
                "source": av[i:j], "target": bv[k:l],
                "source_colors": sorted({f"#{c.color:06X}" for c in a[i:j]}),
                "target_colors": sorted({f"#{c.color:06X}" for c in b[k:l]}),
                "source_page": a[min(i,len(a)-1)].page,
                "target_page": b[min(k,len(b)-1)].page,
                "source_context": context(a,i,j), "target_context": context(b,k,l),
            })
    return {
        "source_characters": len(a), "target_characters": len(b),
        "matched_characters": equal_count,
        "matched_fraction": 2*equal_count/(len(a)+len(b)),
        "difference_count": len(differences), "differences": differences,
        "replacement_color_difference_count": sum(d["source_colors"] != d["target_colors"] for d in differences if d["kind"] == "replace"),
        "color_difference_count": len(color_differences), "color_differences": color_differences,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=ROOT/"verification/source.pdf")
    parser.add_argument("--target", type=Path, default=ROOT/"efficient_imprecise_bandits.pdf")
    parser.add_argument("--report", type=Path, default=ROOT/"verification/pdf_comparison.json")
    args = parser.parse_args()
    a, source = extract(args.source, "source")
    b, target = extract(args.target, "target")
    args.report.parent.mkdir(parents=True, exist_ok=True)
    for role,chars in [("source",a),("target",b)]:
        (args.report.parent/f"pdf_comparison_{role}.txt").write_text("".join(c.value for c in chars))
    print("Comparing full content...", flush=True)
    full = compare(stream(a),stream(b))
    print("Comparing prose and colour...", flush=True)
    prose = compare(stream(a,prose=True),stream(b,prose=True))
    report = {"source": source, "target": target, "full_content": full, "prose": prose,
        "limitations": [
            "This extraction audit does not replace source-level math audit or visual page review.",
            "Math font encoding, glyph substitution, and fraction/superscript reading order can produce false differences.",
            "Prose comparison excludes math fonts, whitespace, digits, punctuation, and discretionary line-end hyphens.",
            "Unicode NFKC normalizes ligatures and mathematical alphabet styling, so these styling distinctions need source/visual review.",
            "Colour is checked on matching character runs; unmatched characters remain unverified.",
        ]}
    args.report.write_text(json.dumps(report,indent=2,ensure_ascii=False)+"\n")
    summary = ["# Rendered PDF content and draft-colour audit", "",
        f"Source: {source['pages']} pages. Target: {target['pages']} pages.",
        "The author line is intentionally excluded from comparison, as requested.", "",
        "| Stream | Source characters | Target characters | Matched | Content differences | Colour differences |",
        "| --- | ---: | ---: | ---: | ---: | ---: |"]
    for name,data in [("Full normalized content",full),("Prose letters",prose)]:
        summary.append(f"| {name} | {data['source_characters']} | {data['target_characters']} | {data['matched_fraction']:.3%} | {data['difference_count']} | {data['color_difference_count']} |")
    summary.extend(["", "## Interpretation", ""]+[f"- {v}" for v in report["limitations"]])
    summary.extend(["", "## Prose differences requiring review", ""])
    for item in prose["differences"]:
        summary.append(f"- Source p.{item['source_page']}: `{item['source']}`; target p.{item['target_page']}: `{item['target']}`. Source context: `{item['source_context']}`.")
    summary.extend(["", "## Matched prose with different draft colour", ""])
    for item in prose["color_differences"]:
        summary.append(f"- `{item['text']}`: source p.{item['source_page']} blue={item['source_blue']}; target p.{item['target_page']} blue={item['target_blue']}. Context: `{item['source_context']}`.")
    args.report.with_suffix(".md").write_text("\n".join(summary)+"\n")
    print(json.dumps({"full": {k:v for k,v in full.items() if k not in ("differences","color_differences")},
        "prose": {k:v for k,v in prose.items() if k not in ("differences","color_differences")}},indent=2))


if __name__ == "__main__":
    main()
