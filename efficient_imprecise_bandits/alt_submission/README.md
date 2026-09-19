# ALT 2027 submission

`efficient_imprecise_bandits.pdf` is the anonymous ALT version of the current
`../efficient_imprecise_bandits.typ`, with subsequent user-requested prose and
structural revisions. The title, mathematical results, citations, and draft
colours are preserved. At the user's request, the five
NP-hardness theorem statements remain in the main body, while their proofs,
supporting lemmas, and constructions are in Appendix E. The trilinear and IUCB
statements include the definitions needed to read them independently.
Main-body theorem numbers are unchanged; equation and lemma numbers follow
the revised order.
The introduction to the square-root learner now follows the user's explanation
in terms of optimism and ending blocks sooner. Its main-body theorem is now
informal, followed by a proof sketch. The algorithm and this analysis assume
exact maximization; Section 3.1 introduces approximation error for the
polynomial-time implementation. Appendix D contains the precise bound for the
approximate variant as Theorem 10 and the complete regret and implementation proof.
Lemma 1 now states and proves the outcome-wise regret bound immediately after
the score and arm-selection rule. The block analysis and theorem sketch reuse
this lemma; its inverse-penalty term retains the necessary hidden factors.
The user has accepted Section 3's non-proof content, which now appears in
normal black. Its lemma proof and proof sketch remain in draft blue.
The author's name is omitted as requested. ALT's anonymous-title material,
running headers, typography, line wrapping, and pagination come from its template.
No abstract or keywords have been added. The original Typst file is unchanged.

## Files to edit and compile

- `efficient_imprecise_bandits.tex`: main document, template setup, and `\draft` macro.
- `manuscript.tex`: the complete manuscript body and appendices.
- `bibliography.tex`: the eleven displayed references, in the original order.
- `alt2027.cls`, `jmlr.cls`, `jmlrutils.sty`: unmodified official template files.
- `alt2027_submission.zip`: the anonymous PDF and the six source/template files
  above, ready to upload or import into Overleaf.

The manuscript uses the template's standard `theorem`, `proof`, and `algorithm`
environments and a standard `lemma` declaration with an independent counter,
preserving the existing numbers. Algorithms use the template's `\floatconts`
layout. Their contents keep the existing draft colours; no `source...`
environments remain in the active LaTeX files.
All 20 proofs and proof sketches use the native `proof` environment and its
automatic QED marker. Custom proof headings use a locally scoped `\proofname`.

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
The source has 23 pages; the revised ALT version has 34 pages. The main-body
NP-hardness section occupies pages 9--10. Appendix D starts on page 18, and
Appendix E starts on page 21.

The conversion evaluates mathematical expressions with Typst's native content
tree, preserving actual grouping and attachments. This includes any awkward
grouping already present in the source: the initial conversion did not correct
mathematics or wording. `tools/math-cache.json` retains all 737 distinct expressions, covering
1,245 mathematical occurrences in the body and one preamble definition.
The initial conversion retained all 239 original blue draft scopes. New and
revised manuscript text also uses the draft macro.

Independent checks cover all ten theorem statements, ten lemmas, two algorithms, eight
numbered equations, eleven references, and their blue/black boundaries. The
extra theorem statement is the informal version of the square-root result;
its precise statement and full proof were initially moved without textual changes,
and the statement now explicitly identifies the approximate variant.
The earlier appendix subsection is deliberately numbered `C.A`, matching the source.
The original PDF extraction comparison and visual review supplement the source conversion.
Extraction differences due to math font encodings and the order of fraction or
superscript glyphs are documented rather than treated as text edits.

`verification/hardness_reorganization.json` records the relocation audit, and
`verification/RESULT.md` describes the current version. The original conversion
reports (`pdf_comparison.*`, `source_audit.md`, `target.pdf`, and `target_*.png`)
refer to the initial 32-page version before the requested reorganization.

`tools/` and `verification/` are local conversion/audit material. They are **not**
included in the submission ZIP; the baseline and its audit retain original
author information. The anonymous PDF and packaged LaTeX files were checked
for author metadata, identifying text, local paths, and embedded attachments.

`python3 tools/convert_manuscript.py` performs the format-only conversion
from Typst using the checked-in math cache and standard environments. It overwrites `manuscript.tex` and
undoes the subsequent appendix reorganization, so do not run it to build the
current submission. Use `./build.sh` instead.
