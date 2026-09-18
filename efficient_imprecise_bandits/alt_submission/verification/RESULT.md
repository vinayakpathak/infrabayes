# Submission verification

The baseline `source.pdf` was compiled afresh from the current Typst file. It has
23 pages; the anonymous ALT submission has 32 pages. The older PDF beside the
Typst source was not used as the baseline.

- The original Typst source has the same SHA-256 digest as before conversion.
- The exact manuscript title and all 39,473 normalized prose letters from the
  baseline occur in the submission, in the same order. No prose letters were
  deleted or replaced. Additional letters in the prose-only extraction are
  mathematical labels such as `max`, `in`, `out`, `NP`, and `otherwise`: Typst
  embeds these in its math font, while LaTeX uses a text font for them.
- All 50,704 matched characters in the complete extracted content have zero
  draft colour differences. Replacement runs arising from mathematical glyph
  encodings also have matching colour sets. Both PDFs use exactly `#0057D9` for the draft text and
  `#000000` for ordinary text. The independent source audit also checked the
  colours of automatic theorem and lemma headers, section headings, equation
  numbers, bibliography entries, and list markers.
- The conversion uses Typst's native mathematical content trees for all 1,245
  mathematical occurrences in the manuscript. The cached conversion contains
  737 distinct expressions, including a preamble definition. The conversion
  logic received an independent review, and the remaining PDF extraction
  differences were reviewed by type and context.
- All 32 pages were rendered and visually inspected in contact sheets. No
  clipping, overlapping content, missing glyphs, or broken layouts were found.
  Enlarged inspection confirmed the absolute-value delimiters on page 21 and
  the corrected adjacent citation `[3], [9]` on page 27.
- The author name is absent from the visible submission and the PDF's author
  metadata is empty, as requested. The official template supplies its anonymous
  author placeholder, review status, and running page furniture.
- All three official ALT class/style files are byte-identical to the files in
  the downloaded official template. The submission ZIP was unpacked into a
  separate directory and compiled successfully without external manuscript
  dependencies.

`pdf_comparison.json` retains the detailed extraction results, and
`pdf_comparison.md` records the normalization rules. Mathematical PDF text
extraction is font-dependent: for example, Typst and Computer Modern encode
norm bars and scalable delimiters differently, and they emit accents, fraction
parts, and sum limits in different reading orders. These residual extraction
differences are not missing manuscript content. The formula review and rendered
page inspection supplement the machine comparison; raw text extraction alone
does not prove mathematical equivalence.

To repeat the extraction audit from the submission directory, run
`python tools/verify_pdfs.py` with PyMuPDF installed. `source_audit.md` records
the source counters, reference numbering, bibliography, and colour scopes.
