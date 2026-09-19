# Current submission verification

The anonymous ALT submission has 34 pages. At the user's request, the
NP-hardness proofs have been moved to Appendix E. The original Typst file
is unchanged; its SHA-256 digest still matches `source.sha256`.

The earlier formatting revision replaces the conversion-specific environments
with standard `theorem`, `lemma`, and ALT/JMLR `algorithm` environments. Lemmas
retain an independent counter. Algorithm captions and rules now use the
template's `\floatconts` layout, with the second algorithm explicitly kept blue
inside its float. All 45 label numbers are unchanged. Comparing the manuscript
source before and after this revision confirms that only environment syntax,
algorithm caption/label placement, draft scoping, and float barriers changed;
the prose and mathematics are unchanged. The official class/style files remain
untouched. The converter now emits the same standard environments.

The latest formatting revision uses the template's native `proof` environment
for all 20 proofs and proof sketches, including the finite-precision argument
and the four nested lemma proofs in the simplex reduction. All manual black
squares have been removed; the environment supplies each QED marker. Custom
headings are locally scoped through `\proofname`. An independent source audit
confirms that the prose, mathematics, and effective blue/black draft colours
are unchanged after accounting for the proof headings and environment syntax.
All 45 label numbers are unchanged. The rebuilt PDF still has 34 pages, and
its rendered pages were checked for proof headings, QED placement, and layout.

The standing assumption that nature follows a compatible adaptive policy has
subsequently been removed from the four learner statements that repeated it.
The probability qualifications, bounds, and proofs are unchanged. The four
affected rendered pages (7, 8, 15, and 18) were visually checked; the page count
and numbering are unchanged.

The introduction to the square-root learner has subsequently been revised
using the user's supplied wording about optimism and ending blocks sooner.
The rewrite is blue, and its discussion of outcomes is phrased in terms of
the empirical mean and the arm score. A later sentence referring to the old
opening was updated. The next paragraph now continues directly with the score
construction, without repeating the motivation. After this transition edit,
all changed rendered pages (6--11 in that revision) were visually checked.

The square-root learner now has an informal main-body theorem and a proof
sketch explaining the per-block penalty cost, the per-round optimism error,
and the choice of lambda. Its original precise theorem and complete proof
are in Appendix D (pages 18--21). At the relocation stage, the moved text was
byte-identical to its pre-move version except for the theorem label; the later
formatting revisions changed only its environment syntax. The precise result is now
Theorem 10, while the informal main-body result keeps number 3. References
from the introduction and the QCQP appendix point to the precise result
and its new location. The manuscript's existing writing guidelines already
specify this informal-theorem/proof-sketch structure.

Lemma 1 now states and proves the outcome-wise regret bound immediately after
the score definition and arm-selection rule. It uses a uniform probability
event over every block-start matrix, every positive lambda, every corresponding
score-maximizing arm, and every outcome. The hidden problem-dependent and
logarithmic factors in the inverse-lambda term are independent of lambda. The
proof uses the independently derived distance certificate in Appendix D.
The following display now bounds actual block regret, identifies its observable
term, and explains the stopping rule before the algorithm. The theorem
sketch reuses the lemma. All new text is blue; Appendix D/E source was unchanged
by the lemma addition. The new lemma and the algorithm each stay together on a page.

The current learner presentation assumes exact maximization throughout
Algorithm 2, the informal theorem, and its proof sketch. The paragraph that
introduced approximation error before the algorithm has been deleted in full.
Section 3.1 now introduces epsilon only for computational tractability and
explains the additional `T epsilon` regret. Appendix D explicitly states its
precise theorem for the approximate variant, with the polynomial-time claim
tied to positive epsilon. Its bound and detailed proof are unchanged.
This revision preserves all existing label numbers and adds only the label
for Section 3.1. Pages 7--11 and 18 were rendered and visually checked; the
other pages are unchanged. The existing lemma-introduction sentence is preserved.

The user has now accepted the non-proof content of Section 3, including
Section 3.1. Only its lemma proof and proof sketch remain in draft blue.
The colour-only revision preserves all source text and mathematics, all content
outside Section 3, and the user's intervening edits. Compared with a fresh build
of the source immediately before acceptance, the PDF text, pagination, and
reference data are unchanged; character positions agree within PDF rounding.
Pages 6--9 were visually checked, including both blue proof scopes and their
automatic QED markers. All other rendered pages are unchanged.

An intermediate revision added a two-sentence explanation of the matrix
update and ellipsoid test. The user subsequently shortened this paragraph;
the current source and rebuilt PDF retain that edit. The submission ZIP
has been refreshed to match the current source and PDF.

## Reorganization

- Section 4 contains the five hardness theorem statements, their subsection
  headings, and a short link to Appendix E. It occupies pages 9--10 and contains
  no proofs or supporting lemmas.
- Appendix E occupies pages 21--34. It contains all six supporting lemmas and
  all eleven proofs (five theorem proofs and six lemma proofs), with the original
  reduction constructions and accompanying discussion.
- The original theorem statements are preserved. Short blue definitions have
  been added inside the trilinear and IUCB statements so they can be read without
  the proof setup. New appendix headings and the appendix pointer are also blue.
- The trilinear theorem proof starts with an explicit "Proof of Theorem 6" to
  distinguish it from the supporting lemma's proof immediately above it.
- Main-body theorem numbers are unchanged. The new main-body lemma is number 1,
  the three earlier regret-analysis lemmas have numbers 2--4, and the six hardness
  lemmas have numbers 5--10. All references
  resolve to their new numbers; existing Appendix A/B/C labels are unchanged.
  Numbered equations follow the new order after moving the square-root proof.

## Checks

- At the relocation stage, the audit compared the new source with the prior source: every
  original nonblank, noncomment source line is retained, allowing only the
  explicit theorem-proof heading described above. Every original mathematical
  expression is retained. Original blue/black wrappers were moved intact.
- There are ten theorem statements (including the new informal version), ten
  lemmas, two algorithms, and eight numbered equations in the complete manuscript.
  There are no duplicate labels or unresolved references.
- The PDF compiles successfully. All changed pages were rendered and visually
  reviewed, including the new lemma and proof, the main informal result, the relocated detailed proof,
  and the Appendix D/E boundary. No new clipping,
  overflow, missing glyphs, or draft-colour problems were found.
- All 87 internal PDF links have valid destinations. The PDF author metadata
  is blank and the original author's name is absent from its text.
- The submission ZIP contains the final PDF and the six required LaTeX/class
  files. Every ZIP entry matches the current file byte for byte.

`hardness_reorganization.json` records source hashes and the structural checks
at the hardness relocation stage, before the subsequent introduction and
square-root theorem revisions.

## Original conversion baseline

The retained `source.pdf` has 23 pages and was freshly compiled from Typst.
The original 32-page ALT conversion, before this requested reorganization, is
retained as `target.pdf`. Its `pdf_comparison.*`, `source_audit.md`, and `target_*.png`
files document the initial fidelity review; they do not describe the page order
of the current PDF.

That initial audit retained all 39,473 normalized source prose letters and found
zero blue/black differences across 50,704 aligned characters. The native Typst
math conversion covers 1,245 body occurrences and 737 distinct expressions
(including a preamble definition). The official class/style files remain
byte-identical to the downloaded template.
