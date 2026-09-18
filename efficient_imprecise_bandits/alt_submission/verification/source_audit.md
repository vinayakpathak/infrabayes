# Current-source fidelity audit

The regenerated baseline is `source.pdf`, compiled from the current `.typ` with Typst 0.15.0. It has 23 pages. The sibling `../efficient_imprecise_bandits.pdf` predates current source edits and must **not** be used as the baseline: it contains obsolete learners and 26 pages. No source Typst edits were made for this audit. User-authorized exception: the new submission omits author identity.

## Exact automatic counters

The original has independent theorem, lemma, and algorithm counters, uninterrupted across the appendices. Do not use the template's default shared theorem counter.

| Kind | Number | Source label | Header color | Body color |
|---|---:|---|---|---|
| Theorem | 1 | `thm:efficient-upper-bound` | blue | blue |
| Theorem | 2 | `thm:hard-ellipsoid-warmup` | black | black |
| Theorem | 3 | `thm:soft-square-root` | blue | blue |
| Theorem | 4 | `thm:additive-simplex-np-hardness` | black | black |
| Theorem | 5 | `thm:additive-polytope-np-hardness` | black | blue |
| Theorem | 6 | `thm:trilinear-balls-np-hardness` | black | blue |
| Theorem | 7 | `thm:iucb-np-hardness` | black | blue |
| Theorem | 8 | `thm:easy-planning-hard-learning` | black | blue |
| Theorem | 9 | `thm:hard-ellipsoid-regret` | blue | blue |
| Lemma | 1 | `lem:planning-from-learning` | black | black |
| Lemma | 2 | `lem:simplex-cut-norm` | black | black |
| Lemma | 3 | `lem:simplex-duality` | black | black |
| Lemma | 4 | none (line 952) | black | black |
| Lemma | 5 | `lem:simplex-arm-value` | black | black |
| Lemma | 6 | `lem:clique-cubic` | black | blue |
| Lemma | 7 | `lem:subspace-reward-bound` | blue | blue |
| Lemma | 8 | `lem:interval-noise` | blue | blue |
| Lemma | 9 | `lem:subspace-distance-bound` | blue | blue |
| Algorithm | 1 | `alg:hard-ellipsoid-warmup` | black | black |
| Algorithm | 2 | `alg:soft-square-root` | blue | blue |

Only Theorems 1 and 2 have caption names: `(efficient $\sqrt{T}$ learning)` and `(Informal)`. All other statement headers end directly after their number and period. Both algorithm headers are simply `Algorithm 1.` / `Algorithm 2.`; no caption names.

Eight numbered displays, rendered as `(1)` through `(8)`, occur in this order:

1. `eq:setting-compatible-set`
2. `eq:soft-block-cost`
3. `eq:soft-subspace-certificate`
4. `eq:soft-optimism`
5. `eq:soft-conjugate-planner`
6. `eq:soft-interval-noise`
7. `eq:hard-subspace-certificate`
8. `eq:hard-optimism`

Inline equation references read `Equation 1` etc., not `(1)`. Section references read `Section 2.1` etc. Explicit appendix reference supplements read `Appendix A`, `Appendix B`, `Appendix C`, and `Appendix C.A`.

## Headings

The exact title is **When are Imprecise Bandits Computationally Tractable?** No abstract exists in the source; do not introduce one.

- 1. Setting
- 1.1. Linear Imprecise Bandits
- 2. Warmup: A $T^{2/3}$ Learner
- 2.1. Computational tractability
- 3. A $\sqrt{T}$ learner
- 4. NP-hardness
- 4.1. D = simplex, X = ball (the D and X here are ordinary text, as in the source)
- 4.2. A Euclidean outcome ball and a polytope of arms
- 4.3. Trilinear constraints with Euclidean arm and outcome balls
- 4.4. Computing IUCB's first arm is NP-hard even for Euclidean balls
- 4.5. Efficient planning does not imply efficient learning
- References (unnumbered, blue title, black entries)
- Appendix (unnumbered, blue)
- A. Quadratically constrained quadratic programming
- B. MAX-CUT
- C. Regret analysis of the $T^{2/3}$ learner
- C.A. Finite-precision implementation

The last label really renders **C.A.** under Typst's `A.` heading numbering; it is not C.1. This was checked in the compiled baseline.

## Color and typography pitfalls

The draft color is exactly hexadecimal `0057D9`. There are 239 explicit `#draft[` scopes. Neutral `#[...]` groups inherit their surrounding color; they do not reset it to black. Several theorem/lemma bodies are blue while their automatic headings remain black, as shown above. Do not make whole environments blue merely because their bodies contain draft macros.

The entire second learner, beginning at source line 469, is blue, but its section heading and first introductory paragraph are black. Computational tractability (section 2.1) is wholly blue. In the simplex hardness subsection most theorem/lemma statements are black, while the planning-from-learning proof and Lemma 3/4/5 proofs are blue. Main section 4.2 onward is predominantly blue, but the automatic statement headers noted above remain black. Appendix C's full enclosing scope is blue, including its subordinate statements and heading C.A. The appendix A enumerated items wrap only their body in draft, so enum markers need separate attention.

The source's `credal` operator is a drawn empty square, not a mathematical power-set P. Display this before D. `qed` is a filled square. Retain all mathematical literal distinctions, even apparent inconsistencies: the introductory noiseless-world prose has $\mathbb R^{1+d_Z+d_D}$; the simplex theorem has ordinary $E[R_T]$, while other expectation symbols use blackboard bold; the easy-planning theorem proof likewise has ordinary $E[\mathcal L_N]$. These are source content, not errors to repair during conversion.

## References

There are 11 rendered IEEE references, in first-citation order, mapped in `reference-map.json`. The `.bib` file has four uncited entries that must not be added. `bibliography.tex` transcribes the rendered visible bibliography, including the use of `p.` (not `pp.`) in Hillar--Lim's article locator and the book/reference punctuation. The Auer citation locator must render `[2, Theorem 5.1]`. Typst merges the adjacent Barvinok/Bienstock citations into a sorted cluster, rendered `[3], [9]`; this was checked in the baseline PDF. Typst renders titles in their supplied capitalization; avoid silently recasing via another bibliography style. Hyperlinks must inherit the actual source color rather than imposing a separate link color.
