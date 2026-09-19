#!/usr/bin/env python3
"""Format-only conversion of this manuscript; never writes to the Typst source."""
from pathlib import Path
import re
import sys
import json
import hashlib

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT.parent / 'efficient_imprecise_bandits.typ'
sys.path.insert(0, str(ROOT / 'tools'))
from typst_math import convert_math


def escape(text):
    text = text.replace('’', "'").replace('–', '--')
    text = re.sub(r'"([^"\n]+)"', lambda m: '``' + m[1] + "''", text)
    return text.replace('\\', r'\textbackslash{}').replace('&', r'\&').replace('%', r'\%').replace('#', r'\#').replace('{', r'\{').replace('}', r'\}').replace('~', r'\textasciitilde{}')


def balanced(s, i, left='[', right=']'):
    assert s[i] == left, (i, s[i:i+80])
    start, depth, math, quote = i+1, 1, False, False
    i += 1
    while i < len(s):
        ch = s[i]
        if ch == '\\':
            i += 2
            continue
        if ch == '$':
            math = not math
        if not math:
            if left == '(' and ch == '"':
                quote = not quote
            if not quote:
                if ch == left:
                    depth += 1
                if ch == right:
                    depth -= 1
                    if not depth:
                        return s[start:i], i+1
        i += 1
    raise ValueError(f'Unclosed {left}: {s[start:start+100]}')


class Converter:
    def __init__(self):
        self.numbered = False
        self.math_count = 0
        self.draft_count = 0
        self.draft_depth = 0
        self.labels = []
        self.citations = []

    def convert(self, s):
        out, i = [], 0
        while i < len(s):
            if s[i] == '\n':
                out.append('\n')
                i += 1
                continue
            # Lists are recognized before consuming indentation.
            if i == 0 or s[i-1] == '\n':
                match = re.match(r'([ \t]*)(?:\+|\d+\.) ', s[i:])
                if match:
                    indent = len(match[1])
                    items, current, pos = [], [], i
                    while pos < len(s):
                        end = s.find('\n', pos)
                        end = len(s) if end < 0 else end+1
                        line = s[pos:end]
                        marker = re.match(r'([ \t]*)(?:\+|\d+\.) ', line)
                        if marker and len(marker[1]) == indent:
                            if current:
                                items.append(''.join(current))
                            current = [line[marker.end():]]
                        elif line.strip() and len(line)-len(line.lstrip()) <= indent:
                            break
                        else:
                            current.append(line)
                        pos = end
                    if current:
                        items.append(''.join(current))
                    out.append('\n\\begin{enumerate}\n' + ''.join('\\item ' + self.convert(item).strip() + '\n\n' for item in items) + '\\end{enumerate}\n')
                    i = pos
                    continue
                match = re.match(r'([ \t]*)(={1,3}) (.*?)(?:\n|$)', s[i:])
                if match:
                    title = match[3]
                    label = re.search(r'\s*<([^>]+)>\s*$', title)
                    label_tex = ''
                    if label:
                        title = title[:label.start()]
                        label_tex = self.label(label[1])
                    command = ['section','subsection','subsubsection'][len(match[2])-1]
                    out.append('\n\\' + command + '{' + self.convert(title) + '}' + label_tex + '\n')
                    i += match.end()
                    continue
            if s[i] == '$':
                j = s.index('$', i+1)
                expr = s[i+1:j]
                display = expr[:1].isspace() and expr[-1:].isspace()
                math = convert_math(expr, display=display)
                self.math_count += 1
                i = j+1
                label = re.match(r'\s*<([^>]+)>', s[i:])
                label_tex = ''
                if label:
                    label_tex = self.label(label[1])
                    i += label.end()
                if display:
                    env = 'equation' if self.numbered else 'equation*'
                    out.append('\n\\begin{' + env + '}\n' + math + label_tex + '\n\\end{' + env + '}\n')
                else:
                    out.append('$' + math + '$' + label_tex)
                continue
            if s.startswith('#draft[', i) or s.startswith('#[', i):
                draft = s.startswith('#draft[', i)
                body, j = balanced(s, i+(6 if draft else 1))
                if draft:
                    self.draft_count += 1
                    self.draft_depth += 1
                try:
                    converted = self.convert(body)
                finally:
                    if draft:
                        self.draft_depth -= 1
                out.append(('\\draft{' if draft else '{') + converted + '}')
                i = j
                continue
            figure = re.match(r'#(theorem|lemma|algorithm|problem)', s[i:])
            if figure:
                kind = figure[1]
                j = i+figure.end()
                title = ''
                if s[j] == '(':
                    args, j = balanced(s, j, '(', ')')
                    title_match = re.fullmatch(r'title:\s*\[(.*)\]', args, re.S)
                    if not title_match:
                        raise ValueError(args)
                    title = self.convert(title_match[1])
                body, j = balanced(s, j)
                label = re.match(r'\s*<([^>]+)>', s[j:])
                label_tex = ''
                if label:
                    label_tex = self.label(label[1])
                    j += label.end()
                converted = self.convert(body)
                if kind == 'algorithm':
                    # Floats reset the surrounding colour, so repeat a draft
                    # scope inside the float when it inherits blue from Typst.
                    contents = ('\\floatconts{' + (label[1] if label else '')
                                + '}{\\caption{' + title + '}}{\n'
                                + converted + '\n}\n')
                    if self.draft_depth:
                        contents = '\\draft{\n' + contents + '}\n'
                    out.append('\n\\begin{algorithm}[!htbp]\n' + contents
                               + '\\end{algorithm}\n\\FloatBarrier\n')
                else:
                    optional_title = '[' + title + ']' if title else ''
                    out.append('\n\\begin{' + kind + '}' + optional_title
                               + label_tex + '\n' + converted
                               + '\n\\end{' + kind + '}\n')
                i = j
                continue
            if s.startswith('#block(', i):
                args, j = balanced(s, i+6, '(', ')')
                assert args == 'breakable: false', args
                body, i = balanced(s, j)
                out.append(self.convert(body))
                continue
            if s.startswith('#set math.equation(', i):
                args, i = balanced(s, i+18, '(', ')')
                assert args in ['numbering: "(1)"', 'numbering: none'], args
                self.numbered = args != 'numbering: none'
                continue
            if s.startswith('#bibliography(', i):
                args, i = balanced(s, i+13, '(', ')')
                out.append('\n\\input{bibliography.tex}\n')
                continue
            if s.startswith('#pagebreak()', i):
                out.append('\n\\clearpage\n')
                i += len('#pagebreak()')
                continue
            if s.startswith('#heading(', i):
                args, j = balanced(s, i+8, '(', ')')
                assert args == 'level: 1, numbering: none', args
                body, i = balanced(s, j)
                out.append('\n\\section*{' + self.convert(body) + '}\n')
                continue
            if s.startswith('#counter(heading).update(0)', i):
                out.append('\n\\appendix\n\\renewcommand{\\presectionnum}{}\n\\renewcommand{\\thesubsection}{\\thesection.\\Alph{subsection}}\n')
                i += len('#counter(heading).update(0)')
                continue
            if s.startswith('#set heading(numbering: "A.")', i):
                i += len('#set heading(numbering: "A.")')
                continue
            if s[i] == '@':
                match = re.match(r'@([\w:-]+)', s[i:])
                assert match, s[i:i+80]
                ref = match[1]
                i += match.end()
                supplement = ''
                if i < len(s) and s[i] == '[':
                    supplement, i = balanced(s, i)
                if ':' in ref:
                    default = {'thm':'Theorem','lem':'Lemma','alg':'Algorithm','sec':'Section','app':'Section','eq':'Equation'}[ref.split(':')[0]]
                    out.append(escape(supplement or default) + '~\\ref{' + ref + '}')
                else:
                    refs = [ref]
                    if not supplement:
                        while True:
                            adjacent = re.match(r'\s+@([\w-]+)(?![\w:-])', s[i:])
                            if not adjacent:
                                break
                            refs.append(adjacent[1])
                            i += adjacent.end()
                    self.citations.extend(refs)
                    if len(refs) > 1:
                        # Typst's IEEE style merges adjacent citations into a
                        # numerically sorted cluster: [3], [9], for example.
                        numbers = json.loads((ROOT/'verification/reference-map.json').read_text())
                        refs.sort(key=lambda key: numbers[key])
                        out.append(', '.join('\\citep{' + key + '}' for key in refs))
                    else:
                        out.append(('\\citep[' + escape(supplement) + ']' if supplement else '\\citep') + '{' + ref + '}')
                continue
            if s[i] == '<':
                match = re.match(r'<([\w:-]+)>', s[i:])
                if match:
                    out.append(self.label(match[1]))
                    i += match.end()
                    continue
            if s[i] in '*_':
                delimiter = s[i]
                j = s.index(delimiter, i+1)
                out.append(('\\textbf{' if delimiter == '*' else '\\emph{') + self.convert(s[i+1:j]) + '}')
                i = j+1
                continue
            if s[i] in '#[]':
                raise ValueError(f'Unconverted markup at {i}: {s[i:i+100]}')
            # Group ordinary prose without touching its spelling or punctuation.
            j = i+1
            while j < len(s) and s[j] not in '$#@*_[]<\n':
                j += 1
            out.append(escape(s[i:j]))
            i = j
        return ''.join(out)

    def label(self, label):
        self.labels.append(label)
        return '\\label{' + label + '}'


def main():
    source = SOURCE.read_text()
    body = source[source.index('= Setting'):]
    body = re.sub(r'#let credal = box\(.*?\) \+ h\(0.04em\)\n', '', body, count=1, flags=re.S)
    converter = Converter()
    tex = converter.convert(body)
    (ROOT/'manuscript.tex').write_text('% Mechanically translated from the unchanged Typst manuscript.\n' + tex)
    report = {'source_sha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(), 'math_expressions':converter.math_count,'draft_scopes':converter.draft_count,'labels':converter.labels,'citations':list(dict.fromkeys(converter.citations))}
    (ROOT/'verification/conversion.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))


if __name__ == '__main__':
    main()
