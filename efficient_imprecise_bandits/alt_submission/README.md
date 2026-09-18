# ALT 2027 submission

`efficient_imprecise_bandits.pdf` is the anonymous ALT version of the current
`../efficient_imprecise_bandits.typ`. The title, prose, mathematics, order,
statement and equation numbering, citations, and draft colours are preserved.
The author's name is omitted as requested. ALT's anonymous-title material,
running headers, typography, line wrapping, and pagination come from its template.
No abstract, keywords, or other manuscript content has been added.

## Files to edit and compile

- `efficient_imprecise_bandits.tex`: main document, template setup, and `\draft` macro.
- `manuscript.tex`: the complete manuscript body and appendices.
- `bibliography.tex`: the eleven displayed references, in the original order.
- `alt2027.cls`, `jmlr.cls`, `jmlrutils.sty`: unmodified official template files.
- `alt2027_submission.zip`: the anonymous PDF and the six source/template files
  above, ready to upload or import into Overleaf.

Run from this folder:

```sh
./build.sh
```

Alternatively, use `latexmk -pdf efficient_imprecise_bandits.tex` or
`tectonic efficient_imprecise_bandits.tex`. No BibTeX step is needed: the
bibliography is typeset explicitly to retain exactly the reference wording
shown in the original PDF.

Draft passages use `\draft{...}`, with the same `#0057D9` blue as Typst.
The macro accepts multiple paragraphs and displayed equations. To accept a
passage without changing its wording, remove just `draft`, leaving `{...}`.

## Official template

Downloaded on 2026-09-18 from the template link on
[ALT 2027's official submission instructions](https://algorithmiclearningtheory.org/alt2027/submission-instructions/):
[ALT 2027 template ZIP](https://www.surbhigoel.com/assets/files/alt2027-template.zip).
The original ZIP and sample are retained in `template/`.
The main document uses `\documentclass[anon]{alt2027}` and the sample's Times font.

## Fidelity checks

The sibling PDF predates the current Typst source. Therefore `verification/source.pdf`
was freshly compiled from the unchanged source with Typst 0.15.0 and used as the
baseline. Its SHA-256 source fingerprint is recorded in `verification/source.sha256`.
The source has 23 pages; the ALT version has 32 pages.

The conversion evaluates mathematical expressions with Typst's native content
tree, preserving actual grouping and attachments. This includes any awkward
grouping already present in the source: this task did not correct mathematics
or wording. `tools/math-cache.json` retains all 737 distinct expressions, covering
1,245 mathematical occurrences in the body and one preamble definition.
The 239 blue draft scopes include 238 in the body and the References heading.

Independent checks cover all nine theorems, nine lemmas, two algorithms, eight
numbered equations, eleven references, and their blue/black boundaries. The
appendix subsection is deliberately numbered `C.A`, matching the source.
PDF extraction comparison and visual review supplement the source conversion.
Extraction differences due to math font encodings and the order of fraction or
superscript glyphs are documented rather than treated as text edits.

`tools/` and `verification/` are local conversion/audit material. They are **not**
included in the submission ZIP; the baseline and its audit retain original
author information. The anonymous PDF and packaged LaTeX files were checked
for author metadata, identifying text, local paths, and embedded attachments.

To repeat the format conversion from the Typst source using the checked-in math
cache, run `python3 tools/convert_manuscript.py`. This overwrites `manuscript.tex`,
so do not run it after making independent LaTeX edits unless that is intended.
