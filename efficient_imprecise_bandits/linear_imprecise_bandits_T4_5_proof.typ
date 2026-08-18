// Complete proof source. Compile with Typst 0.15 or later.
// Some definitions presupposed by pandoc's typst output.
#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]
#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

#let conf(
  title: none,
  authors: (),
  keywords: (),
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  doc,
) = {
  set document(
    title: title,
    author: authors.map(author => author.name),
    keywords: keywords,
  )
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  if title != none {
    align(center)[#block(inset: 2em)[
      #text(weight: "bold", size: 1.5em)[#title]
    ]]
  }

  if authors != none and authors != [] {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] #h(1em) #abstract
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#let proof-end = $square.stroked$
#show emph: set text(fill: rgb("333333"))

#show: doc => conf(
  title: [A Polynomial-Time $tilde(O) (T^(4 / 5))$ Algorithm for Linear
Imprecise Bandits with Euclidean Balls],
  authors: (),
  date: "August 2026",
  lang: "en",
  region: "US",
  abstract: [This note gives a self-contained proof of a
$tilde(O) (T^(4 / 5))$ regret upper bound for the sampled-outcome
linear imprecise-bandit problem under the following restrictions: the
arm, outcome, and hypothesis sets are Euclidean balls in their affine
hulls; the reward is affine-linear in the arm and outcome; and the mean
constraints decompose as $F_0 (x , z) + F_1 (y , z) = 0$, with $F_0$ and
$F_1$ bilinear in their displayed arguments. The proof is not contained
in Kosoy’s original paper; that paper supplies the model and regret
definition. The new argument exploits the fact that, after fixing the
true hypothesis, all feasible-outcome affine spaces are parallel. A
small affine basis of arms identifies one feasible affine selection,
while a ridge ellipsoid learns the residual directions used by nature.
The ridge construction avoids the singular-value threshold loss in the
earlier $T^(8 / 9)$ sketch. The only remaining square-root loss is the
geometrically unavoidable instability of a nearly tangent affine slice
of a Euclidean ball.

],
  cols: 1,
  doc,
)

#outline(
  title: auto,
  depth: 3
);

= The result being proved
<the-result-being-proved>
We work in affine Euclidean coordinates. Let

$ A = c_A + R_A B_2^p ⊆ bb(R)^p , #h(2em) D = c_D + R_D B_2^q ⊆ bb(R)^q , $

where $R_A , R_D > 0$, and let $H$ be a Euclidean ball in a
finite-dimensional hypothesis space. The assumption on $H$ will not be
used by the algorithm.

For each hypothesis $z in H$ and arm $x in A$, the compatible
conditional mean outcomes are

$ K_z (x) = { y in D : F_0 (x , z) + F_1 (y , z) = 0 } . $

Here $F_0$ is bilinear in $(x , z)$ in homogeneous affine coordinates
and $F_1$ is bilinear in $(y , z)$. We assume $K_z (x)$ is nonempty for
every $(x , z)$. The reward is

$ r (x , y) = a^T x + b^T y + c . $

Let $z^star$ be the unknown true hypothesis. On round $t$, the
learner chooses $x_t in A$. Nature then chooses, possibly adaptively, a
distribution supported on $D$ whose conditional mean $m_t$ lies in
$K_(z^star) (x_t)$, and an outcome $y_t in D$ is sampled from this
distribution. Thus

$ bb(E) [y_t divides cal(F)_(t - 1) , x_t] = m_t in K_(z^star) (x_t) . $

Define the lower value and optimal lower value by

$ v (x) = min_(y in K_(z^star) (x)) r (x , y) , #h(2em) v^star = max_(x in A) v (x) . $

The realized regret is

$ "Reg"_T = T v^star - sum_(t = 1)^T r (x_t , y_t) . $

Kosoy’s expected regret is the supremum, over compatible adaptive nature
policies, of the expectation of this quantity.

#strong[Theorem 1 (sampled-outcome $T^(4 / 5)$ upper bound).] There is
a horizon-aware algorithm such that, uniformly over every
$z^star in H$ and every compatible adaptive nature policy,

$ bb(E) ["Reg"_T] ≤ tilde(O) #h(-1em) (P (p , q , R_D , parallel b parallel , C_r) T^(4 / 5)) , $

where

$ C_r = max_(x in A , y in D) r (x , y) - min_(x in A , y in D) r (x , y) $

and $P$ is a fixed polynomial. In the real-RAM model the algorithm uses
a polynomial number of arithmetic operations. With rational input data
and polynomial-precision outcome encoding, it has a weak polynomial-time
bit-model implementation.

The statement concerns the original sampled-outcome protocol. The
learner is not given the conditional means, does not assume that nature
is stationary, and does not recover the hidden hypothesis.

= Why the theorem should be true
<why-the-theorem-should-be-true>
Fix $z^star$. Because the constraint separates into an $x$ part and a
$y$ part, fixing $z^star$ turns it into an affine equation

$ B x + C y + d = 0 . #h(2em) upright("(1)") $

Consequently, the affine hull of compatible outcomes at arm $x$ is

$ L (x) = { y : B x + C y + d = 0 } , $

and every $L (x)$ has the same direction space

$ N = ker C . $

There is therefore an affine feasible selection $s : A → bb(R)^q$
such that

$ L (x) = s (x) + N . #h(2em) upright("(2)") $

The learner first estimates one such selection from $p + 1$ affinely
independent arms. Thereafter, the average outcome in any block has the
form

$ overline(y) = s (x) + g + upright("sampling noise") , #h(2em) g in N . $

The learner stores only residuals that are new in a ridge-leverage
sense. If $hat(G)$ is the matrix of stored residuals, it uses

$ V = lambda^2 I + hat(G) hat(G)^T $

and the ellipsoid

$ cal(E) = { u : u^T V^(- 1) u ≤ 1 } . #h(2em) upright("(3)") $

Two facts drive the proof.

First, the determinant of $V$ doubles whenever a new residual is stored,
so only $tilde(O) (q)$ blocks are informative. Second, the entire ridge
ellipsoid remains close to $N$. If every stored residual is within $eta$
of $N$, then every $u in cal(E)$ is within

$ sqrt(M) thin eta + lambda $

of $N$, where $M$ is the number of stored residuals. There is no
division by a small singular-value threshold. This is the improvement
over the earlier $T^(8 / 9)$ argument.

A block mean based on $n$ samples has error $tilde(O) (n^(- 1 / 2))$.
Therefore the learned affine fibers are also
$tilde(O) (n^(- 1 / 2))$-close to the true affine fibers. Intersecting
a nearly tangent affine space with a ball can take a square root, so the
robust-value error is only guaranteed to be

$ tilde(O) (n^(- 1 / 4)) . $

The total regret is therefore

$ tilde(O) (n + T n^(- 1 / 4)) , $

which is minimized at $n = T^(4 / 5)$.

A two-dimensional example explains the square root. In the unit disk,
the tangent line $v = 1$ meets the disk only at $(0 , 1)$, whereas the
parallel line $v = 1 - delta$ meets it in a chord whose left endpoint
has first coordinate

$ - sqrt(2 delta - delta^2) . $

The affine spaces are only distance $delta$ apart, but a linear
objective can change by order $sqrt(delta)$. Thus the last square root
in the proof cannot be removed by a uniform perturbation argument.

= Reduction to parallel affine slices
<reduction-to-parallel-affine-slices>
#strong[Lemma 2 (parallel-slice representation).] After fixing
$z^star$, there are matrices $B , C$ and a vector $d$ such that (1)
holds. If

$ N = ker C , $

then there is an affine map $s : A → bb(R)^q$ satisfying (2).

#strong[Proof.] In homogeneous affine coordinates, $F_0 (x , z)$ is
linear in $x$ once $z = z^star$ is fixed, and $F_1 (y , z)$ is linear
in $y$. Translating back to the affine charts of the balls produces
(1), including the constant term $d$. Every solution set of (1), as a
set in the variable $y$, has direction $ker C$. Choose any affine right
inverse on the affine image of $A$ to obtain one affine solution $s (x)$
of (1). Then every solution is $s (x) + N$. ∎

The algorithm does not know $B , C , d$, or $N$. The following concrete
construction of $s$ is what makes them unnecessary.

= An affine basis of arms
<an-affine-basis-of-arms>
Choose the anchor arms

$ x^((0)) = c_A , #h(2em) x^((j)) = c_A + R_A e_j , quad j = 1 , dots.h , p . $

For $x = c_A + R_A u$ with $parallel u parallel_2 ≤ 1$, define

$ alpha_j (x) = u_j quad (j ≥ 1) , #h(2em) alpha_0 (x) = 1 - sum_(j = 1)^p u_j . #h(2em) upright("(4)") $

Then

$ x = sum_(j = 0)^p alpha_j (x) x^((j)) , #h(2em) sum_(j = 0)^p alpha_j (x) = 1 . #h(2em) upright("(5)") $

Moreover,

$ sum_(j = 0)^p lr(|alpha_j (x)|) ≤ 1 + 2 sqrt(p) = : B_A . #h(2em) upright("(6)") $

Indeed,

$ lr(|1 - sum_j u_j|) + sum_j lr(|u_j|) ≤ 1 + lr(|sum_j u_j|) + parallel u parallel_1 ≤ 1 + 2 sqrt(p) . $

#strong[Lemma 3 (anchor means define a feasible affine selection).] For
each $j = 0 , dots.h , p$, let $m_j in L (x^((j)))$ be arbitrary. Define

$ s (x) = sum_(j = 0)^p alpha_j (x) m_j . #h(2em) upright("(7)") $

Then $s (x) in L (x)$ for every $x in A$, and hence

$ L (x) = s (x) + N . $

#strong[Proof.] Since $m_j in L (x^((j)))$,

$ C m_j + B x^((j)) + d = 0 . $

Using (5),

$ C s (x) + B x + d = sum_j alpha_j (x) C m_j + B sum_j alpha_j (x) x^((j)) + (sum_j alpha_j (x)) d = sum_j alpha_j (x) (C m_j + B x^((j)) + d) = 0 . $

Thus $s (x) in L (x)$. The direction space is $N$, so
$L (x) = s (x) + N$. ∎

= The block algorithm
<the-block-algorithm>
Fix a block length $n$. At the end we set

$ n = ⌈ T^(4 / 5) ⌉ . #h(2em) upright("(8)") $

The algorithm uses parameters $lambda > 0$ and $rho > 0$, chosen after
the concentration calculation.

== Anchor phase
<anchor-phase>
Play each anchor $x^((j))$ for $n$ rounds and let $overline(y)_j$ be its
empirical average. Define

$ hat(s) (x) = sum_(j = 0)^p alpha_j (x) overline(y)_j . #h(2em) upright("(9)") $

If the horizon ends during this phase, stop.

== Residual phase
<residual-phase>
Maintain a matrix $hat(G)$ whose columns are the stored informative
residuals. Initially it has no columns. At the start of a block, if $M$
columns have been stored, define

$ V_M = lambda^2 I + hat(G) hat(G)^T , #h(2em) cal(E)_M = { u : u^T V_M^(- 1) u ≤ 1 } . #h(2em) upright("(10)") $

Let

$ D_1 = c_D + (R_D + rho) B_2^q , #h(2em) D_2 = c_D + (R_D + 2 rho) B_2^q . #h(2em) upright("(11)") $

For each arm define an inner and outer estimated fiber:

$ hat(K)_M^("in") (x) = (hat(s) (x) + 2 cal(E)_M) ∩ D_1 , #h(2em) upright("(12)") $

$ hat(K)_M^("out") (x) = (hat(s) (x) + 3 cal(E)_M) ∩ D_2 . #h(2em) upright("(13)") $

The constants $2$ and $3$ are not statistically important. They create a
strict feasibility margin for the optimization subroutine.

At the start of the block:

+ If some $x in A$ has $hat(K)_M^("in") (x) = ∅$, choose
  any such arm.
+ Otherwise define
  $ hat(v)_M (x) = min_(y in hat(K)_M^("out") (x)) r (x , y) #h(2em) upright("(14)") $
  and choose an arm maximizing $hat(v)_M (x)$.

Play the chosen arm for $n$ rounds, unless fewer than $n$ rounds remain.
A final partial block is charged pessimistically and is not used for an
update. For a full block, let $overline(y)$ be its empirical average and
define

$ hat(g) = overline(y) - hat(s) (x) . #h(2em) upright("(15)") $

The block is called #strong[informative] when

$ hat(g)^T V_M^(- 1) hat(g) > 1 . #h(2em) upright("(16)") $

In that case append $hat(g)$ to $hat(G)$. Otherwise leave $hat(G)$
unchanged.

= Concentration for adaptive nature
<concentration-for-adaptive-nature>
For a full block $B$ in which the arm is fixed, define its latent
average conditional mean

$ m_B = 1 / n sum_(t in B) bb(E) [y_t divides cal(F)_(t - 1)] . #h(2em) upright("(17)") $

Every summand lies in the same convex set $K_(z^star) (x)$, so

$ m_B in K_(z^star) (x) . #h(2em) upright("(18)") $

#strong[Lemma 4 (simultaneous block concentration).] Let

$ epsilon_n = R_D sqrt(frac(2 q log (2 q T^3), n)) . #h(2em) upright("(19)") $

With probability at least $1 - T^(- 2)$, every full block used by the
algorithm, including all anchor blocks, satisfies

$ parallel overline(y) - m_B parallel_2 ≤ epsilon_n . #h(2em) upright("(20)") $

#strong[Proof.] Condition on the history at the start of a block. For
each coordinate $k$, the sequence

$ y_(t , k) - bb(E) [y_(t , k) divides cal(F)_(t - 1)] $

is a martingale-difference sequence. Since $D$ is a radius-$R_D$
Euclidean ball, each coordinate lies in an interval of length at most
$2 R_D$. Azuma–Hoeffding gives

$ Pr (lr(|overline(y)_k - m_(B , k)|) > u divides upright("block-start history")) ≤ 2 exp (- frac(n u^2, 2 R_D^2)) . $

If the Euclidean norm exceeds $epsilon_n$, some coordinate exceeds
$epsilon_n / sqrt(q)$. A union bound over coordinates gives failure
probability at most $T^(- 3)$ for each full block. There are at most $T$
full blocks, even though their arms are adaptively selected, so another
union bound gives total failure probability at most $T^(- 2)$. ∎

Call the event in Lemma 4 the #strong[good event];.

For each anchor block let $m_j$ denote its latent average conditional
mean and let $s$ be the affine selection (7) built from these $m_j$
values.

#strong[Lemma 5 (selection and residual error).] On the good event,

$ sup_(x in A) parallel hat(s) (x) - s (x) parallel_2 ≤ B_A epsilon_n . #h(2em) upright("(21)") $

For every later full block at arm $x$, if

$ g = m_B - s (x) , $

then $g in N$ and

$ parallel hat(g) - g parallel_2 ≤ (1 + B_A) epsilon_n = : eta_n . #h(2em) upright("(22)") $

#strong[Proof.] Equation (21) follows from (6), (9), and the anchor
concentration bounds:

$ parallel hat(s) (x) - s (x) parallel_2 ≤ sum_j lr(|alpha_j (x)|) parallel overline(y)_j - m_j parallel_2 ≤ B_A epsilon_n . $

By (18), $m_B in L (x) = s (x) + N$, hence $g in N$. Finally,

$ hat(g) - g = (overline(y) - m_B) - (hat(s) (x) - s (x)) , $

which gives (22). ∎

From now on choose

$ lambda = rho = eta_n . #h(2em) upright("(23)") $

= The ridge ellipsoid stays close to the true residual space
<the-ridge-ellipsoid-stays-close-to-the-true-residual-space>
The next identity is the reason the ridge construction avoids a
singular-value threshold.

#strong[Lemma 6 (image representation of the ridge ellipsoid).] If
$hat(G) in bb(R)^(q times M)$, then

$ cal(E)_M = { hat(G) alpha + lambda w : parallel alpha parallel_2^2 + parallel w parallel_2^2 ≤ 1 } . #h(2em) upright("(24)") $

#strong[Proof.] Let

$ Q = [hat(G) med med lambda I_q] . $

Then $Q Q^T = V_M$. The image of the Euclidean unit ball under a
full-row-rank matrix $Q$ is exactly

$ { u : u^T (Q Q^T)^(- 1) u ≤ 1 } . $

This is (24). ∎

#strong[Lemma 7 (ridge ellipsoid versus $N$).] Suppose the good event
holds and $M$ residuals have been stored. Then every $u in cal(E)_M$
satisfies

$ "dist" (u , N) ≤ sqrt(M) thin eta_n + lambda . #h(2em) upright("(25)") $

Consequently, every $u in 3 cal(E)_M$ satisfies

$ "dist" (u , N) ≤ 3 (sqrt(M) thin eta_n + lambda) . #h(2em) upright("(26)") $

#strong[Proof.] Write the stored matrix as

$ hat(G) = G + E , $

where every column of $G$ belongs to $N$ and every column of $E$ has
norm at most $eta_n$, by Lemma 5. Hence

$ parallel E parallel_("op") ≤ parallel E parallel_F ≤ sqrt(M) thin eta_n . $

For $u in cal(E)_M$, Lemma 6 gives

$ u = G alpha + E alpha + lambda w , #h(2em) parallel alpha parallel_2^2 + parallel w parallel_2^2 ≤ 1 . $

Since $G alpha in N$,

$ "dist" (u , N) ≤ parallel E alpha + lambda w parallel_2 ≤ sqrt(M) thin eta_n + lambda . $

Scaling by $3$ gives (26). ∎

The earlier thresholded-SVD sketch instead controlled a normalized
singular vector and incurred a factor $1 / lambda$. Lemma 7 controls
the whole ellipsoid without normalization, so no such factor appears.

= Only logarithmically many blocks are informative
<only-logarithmically-many-blocks-are-informative>
Define

$ R_0 = (1 + B_A) R_D . #h(2em) upright("(27)") $

This is a deterministic upper bound on every observed residual. Indeed,
$overline(y) in D$, and because the coefficients in (9) sum to one,

$ parallel hat(s) (x) - c_D parallel_2 ≤ B_A R_D . $

Thus $parallel hat(g) parallel_2 ≤ R_0$.

#strong[Lemma 8 (elliptical-potential count).] The total number $M$ of
informative blocks is at most

$ overline(M)_T = q log_2 (1 + frac(T R_0^2, q lambda^2)) . #h(2em) upright("(28)") $

#strong[Proof.] If a residual $hat(g)$ is appended, the matrix
determinant lemma gives

$ det (V_M + hat(g) hat(g)^T) = det (V_M) (1 + hat(g)^T V_M^(- 1) hat(g)) > 2 det (V_M) . #h(2em) upright("(29)") $

After $M$ informative blocks,

$ det V_M > 2^M lambda^(2 q) . #h(2em) upright("(30)") $

On the other hand,

$ "tr" V_M = q lambda^2 + sum_(i = 1)^M parallel hat(g)_i parallel_2^2 ≤ q lambda^2 + M R_0^2 . $

The arithmetic–geometric mean inequality for the eigenvalues yields

$ det V_M ≤ (lambda^2 + frac(M R_0^2, q))^q ≤ (lambda^2 + frac(T R_0^2, q))^q . #h(2em) upright("(31)") $

Combining (30) and (31) proves (28). ∎

This determinant argument is deterministic. Sampling noise may create
extra informative blocks, but it cannot create more than (28).

= Stability of affine slices of a Euclidean ball
<stability-of-affine-slices-of-a-euclidean-ball>
The following lemma is the only place where a square root is lost.

#strong[Lemma 9 (ball-slice stability).] Let

$ D_R = c + R B_2^q $

and let $L$ be an affine subspace with $L ∩ D_R ≠ ∅$.
Suppose

$ y in c + (R + tau) B_2^q , #h(2em) "dist" (y , L) ≤ delta . $

Then

$ "dist" (y , L ∩ D_R) ≤ Phi_R (delta , tau) , #h(2em) upright("(32)") $

where

$ Phi_R (delta , tau) = delta + 2 tau + sqrt(2 R (delta + tau) + (delta + tau)^2) . #h(2em) upright("(33)") $

#strong[Proof.] Translate $c$ to the origin. Radially project $y$ to the
radius-$R$ ball, obtaining $y_0$. Then

$ parallel y - y_0 parallel_2 ≤ tau , #h(2em) "dist" (y_0 , L) ≤ delta + tau = : e . #h(2em) upright("(34)") $

Let $q_0$ be the orthogonal projection of $y_0$ onto $L$. Write

$ L = p + N_L , $

where $p tack.t N_L$ is the minimum-norm point in $L$, and write
$q_0 = p + v$ with $v in N_L$. Since $L ∩ D_R$ is nonempty,
$parallel p parallel_2 ≤ R$. The intersection $L ∩ D_R$ is the
ball in $L$ centered at $p$ with radius

$ r_L = sqrt(R^2 - parallel p parallel_2^2) . $

Because $parallel q_0 parallel_2 ≤ R + e$,

$ parallel v parallel_2^2 = parallel q_0 parallel_2^2 - parallel p parallel_2^2 ≤ r_L^2 + 2 R e + e^2 . $

Hence

$ "dist" (q_0 , L ∩ D_R) ≤ sqrt(2 R e + e^2) . $

Finally,

$ "dist" (y , L ∩ D_R) ≤ parallel y - y_0 parallel_2 + parallel y_0 - q_0 parallel_2 + "dist" (q_0 , L ∩ D_R) , $

which is exactly (32)–(33). ∎

= Estimated values are nearly optimistic
<estimated-values-are-nearly-optimistic>
Let $M$ be the current number of stored residuals and define

$ Delta_M = B_A epsilon_n + 3 (sqrt(M) thin eta_n + lambda) . #h(2em) upright("(35)") $

#strong[Lemma 10 (outer estimated fibers are close to true fibers).] On
the good event, every $x in A$ and every
$y in hat(K)_M^("out") (x)$ satisfy

$ "dist" (y , K_(z^star) (x)) ≤ Phi_(R_D) (Delta_M , 2 rho) . #h(2em) upright("(36)") $

Consequently,

$ hat(v)_M (x) ≥ v (x) - parallel b parallel_2 Phi_(R_D) (Delta_M , 2 rho) . #h(2em) upright("(37)") $

#strong[Proof.] Write $y = hat(s) (x) + u$ with $u in 3 cal(E)_M$. Since
$L (x) = s (x) + N$, Lemmas 5 and 7 give

$ "dist" (y , L (x)) ≤ B_A epsilon_n + 3 (sqrt(M) thin eta_n + lambda) = Delta_M . $

Also $y in D_2 = c_D + (R_D + 2 rho) B_2^q$. Apply Lemma 9 to
$L = L (x)$, noting that

$ L (x) ∩ D = K_(z^star) (x) ≠ ∅ . $

This proves (36). For each $y$ in the estimated fiber, choose
$y prime in K_(z^star) (x)$ satisfying the distance bound. Since the
outcome part of the reward has Euclidean Lipschitz constant
$parallel b parallel_2$,

$ r (x , y) ≥ r (x , y prime) - parallel b parallel_2 Phi_(R_D) (Delta_M , 2 rho) ≥ v (x) - parallel b parallel_2 Phi_(R_D) (Delta_M , 2 rho) . $

Taking the minimum over the estimated fiber gives (37). ∎

The direction of (37) is important. The learned residual ellipsoid is
not required to contain every true residual. It is an optimistic
restricted set: every point it does contain is close to a genuinely
feasible outcome.

= Noninformative blocks have small regret
<noninformative-blocks-have-small-regret>
#strong[Lemma 11 (an empty-fiber block must be informative).] If the
algorithm chooses an arm because
$hat(K)_M^("in") (x) = ∅$, then the resulting full block
is informative.

#strong[Proof.] Suppose instead that it were noninformative. Then (16)
fails, so $hat(g) in cal(E)_M$. Since $D$ is convex and every realized
outcome is in $D$, the block average $overline(y)$ is in $D$. By (15),

$ overline(y) = hat(s) (x) + hat(g) in (hat(s) (x) + cal(E)_M) ∩ D ⊆ hat(K)_M^("in") (x) , $

contradicting emptiness. ∎

#strong[Lemma 12 (regret in a noninformative planning block).] Suppose
all inner fibers are nonempty, the algorithm chooses an exact maximizer
of (14), and the resulting full block is noninformative. Then its
average realized regret is at most

$ parallel b parallel_2 Phi_(R_D) (Delta_M , 2 rho) . #h(2em) upright("(38)") $

#strong[Proof.] Noninformativeness implies $hat(g) in cal(E)_M$.
Therefore

$ overline(y) = hat(s) (x) + hat(g) in (hat(s) (x) + cal(E)_M) ∩ D ⊆ hat(K)_M^("out") (x) . $

Hence

$ r (x , overline(y)) ≥ hat(v)_M (x) . #h(2em) upright("(39)") $

Let $x^star$ be a true optimal arm. By the choice of $x$ and Lemma
10,

$ hat(v)_M (x) ≥ hat(v)_M (x^star) ≥ v^star - parallel b parallel_2 Phi_(R_D) (Delta_M , 2 rho) . #h(2em) upright("(40)") $

Because the reward is affine and the arm is fixed throughout the block,

$ r (x , overline(y)) = 1 / n sum_(t upright(" in block")) r (x , y_t) . #h(2em) upright("(41)") $

Combining (39)–(41) proves (38). ∎

Linearity of the reward is used essentially in (41). For a merely
convex reward, Jensen’s inequality goes in a useful direction for some
parts of the analysis, but it does not give this exact identity.

= The explicit regret bound
<the-explicit-regret-bound>
Use the deterministic upper bound $overline(M)_T$ from (28) and define

$ overline(Delta)_T = B_A epsilon_n + 3 (sqrt(overline(M)_T) thin eta_n + lambda) , #h(2em) upright("(42)") $

$ Gamma_T = parallel b parallel_2 Phi_(R_D) (overline(Delta)_T , 2 rho) . #h(2em) upright("(43)") $

#strong[Proposition 13 (regret for an arbitrary block length).] On the
good event,

$ "Reg"_T ≤ C_r (p + overline(M)_T + 2) n + T Gamma_T . #h(2em) upright("(44)") $

#strong[Proof.] The $p + 1$ anchor blocks contribute at most
$C_r (p + 1) n$. By Lemma 8, at most $overline(M)_T$ later blocks are
informative; by Lemma 11 this count also includes every empty-fiber
block. Their contribution is at most $C_r overline(M)_T n$. A final
partial block contributes at most $C_r n$. Every remaining round belongs
to a noninformative planning block and is covered by Lemma 12. Summing
its average-regret bound over at most $T$ rounds gives the final term. ∎

The good event fails with probability at most $T^(- 2)$. Since regret is
at most $C_r T$ above, Proposition 13 implies

$ bb(E) ["Reg"_T] ≤ C_r (p + overline(M)_T + 2) n + T Gamma_T + C_r / T . #h(2em) upright("(45)") $

This holds for every compatible adaptive nature policy.

= Choosing the block length
<choosing-the-block-length>
We now simplify the terms in (45). By (19), (22), and (23),

$ epsilon_n = tilde(O) (n^(- 1 / 2)) , #h(2em) eta_n = lambda = rho = tilde(O) (n^(- 1 / 2)) , #h(2em) upright("(46)") $

where the hidden factors are polynomial in $p , q , R_D$ and
polylogarithmic in $T$. Equation (28) gives

$ overline(M)_T = tilde(O) (q) . #h(2em) upright("(47)") $

Therefore (42) gives

$ overline(Delta)_T = tilde(O) (n^(- 1 / 2)) . #h(2em) upright("(48)") $

Using (33),

$ Phi_(R_D) (overline(Delta)_T , 2 rho) = tilde(O) (n^(- 1 / 4)) . #h(2em) upright("(49)") $

Substituting (47)–(49) into (45),

$ bb(E) ["Reg"_T] ≤ tilde(O) (P_1 (p , q , R_D , C_r) n + P_2 (p , q , R_D , parallel b parallel_2) T n^(- 1 / 4)) . #h(2em) upright("(50)") $

The two powers of $n$ balance when

$ n = T^(4 / 5) . $

Indeed,

$ T n^(- 1 / 4) = T dot.op T^(- 1 / 5) = T^(4 / 5) . $

This proves Theorem 1.

If the horizon is too short to complete all anchor blocks, the algorithm
simply plays anchors until the horizon ends. The trivial bound $C_r T$
is then already bounded by the right side of the theorem after enlarging
the polynomial factor in $p$.

= Polynomial-time implementation
<polynomial-time-implementation>
This section proves that the optimization steps are not hidden oracles.
The argument uses weak additive optimization over a fixed number of
quadratic constraints. The statistical proof above is independent of
this section.

Write

$ hat(s) (x) = S x + s_0 . $

== Finding an empty inner fiber
<finding-an-empty-inner-fiber>
For fixed $x$, the Euclidean distance between

$ D_1 = c_D + (R_D + rho) B_2^q $

and $hat(s) (x) + 2 cal(E)_M$ is

$ d_M (x) = max_(parallel u parallel_2 ≤ 1) { u^T (hat(s) (x) - c_D) - 2 sqrt(u^T V_M u) - (R_D + rho) parallel u parallel_2 } . #h(2em) upright("(51)") $

This is the standard support-function formula for the distance between
two closed convex sets. In particular,

$ d_M (x) > 0 quad ⇔ quad hat(K)_M^("in") (x) = ∅ . #h(2em) upright("(52)") $

Maximizing (51) jointly over $x in A$ and $u$ is a fixed-constraint
QCQP after introducing nonnegative variables $t_0 , t_1$ satisfying

$ u^T V_M u ≤ t_0^2 , #h(2em) parallel u parallel_2^2 ≤ t_1^2 . $

The objective becomes

$ u^T (S x + s_0 - c_D) - 2 t_0 - (R_D + rho) t_1 , $

which is quadratic only through the bilinear term $u^T S x$. The
constraints are the arm ball, the unit ball for $u$, the two displayed
quadratic constraints, and sign constraints for $t_0 , t_1$: a constant
number independent of $p , q , T$.

== Robust planning over the outer fiber
<robust-planning-over-the-outer-fiber>
Assume every inner fiber is nonempty. Any point in an inner fiber is
strictly feasible for the corresponding outer fiber: the ellipsoid gauge
increases from $2$ to $3$, and the outcome-ball radius increases by
$rho$. Fenchel–Rockafellar duality therefore gives

$ hat(v)_M (x) = a^T x + c + b^T c_D + max_(u in bb(R)^q) { u^T (hat(s) (x) - c_D) - 3 sqrt(u^T V_M u) - (R_D + 2 rho) parallel b - u parallel_2 } . #h(2em) upright("(53)") $

For completeness, split the primal variable into $y in D_2$ and
$z in hat(s) (x) + 3 cal(E)_M$ with the constraint $y = z$. With
multiplier $u$, the Lagrangian is

$ (b - u)^T y + u^T z . $

Taking the infimum over the two ellipsoids produces (53). Strict
feasibility gives equality and dual attainment.

The dual optimizer has polynomially bounded norm. Let
$y_0 in hat(K)_M^("in") (x)$ and set

$ m = min { rho , lambda } . $

Because $V_M ≽ lambda^2 I$, the ridge ellipsoid contains
$lambda B_2^q$. Hence each of the two outer constituent sets contains
the Euclidean ball $y_0 + m B_2^q$. If $g_x (u)$ denotes the dual
objective in (53) without the arm-only terms, then

$ g_x (u) ≤ b^T y_0 - m (parallel u parallel_2 + parallel b - u parallel_2) . #h(2em) upright("(54)") $

The primal optimum is at least

$ b^T y_0 - 2 (R_D + 2 rho) parallel b parallel_2 . $

At an optimal dual point, (54) therefore implies

$ parallel u parallel_2 ≤ Q := frac(2 (R_D + 2 rho) parallel b parallel_2, m) . #h(2em) upright("(55)") $

Thus the joint maximization in (53) may be restricted to
$parallel u parallel_2 ≤ Q$. Introducing nonnegative $t_0 , t_1$
with

$ u^T V_M u ≤ t_0^2 , #h(2em) parallel b - u parallel_2^2 ≤ t_1^2 $

turns the objective into

$ a^T x + c + b^T c_D + u^T (S x + s_0 - c_D) - 3 t_0 - (R_D + 2 rho) t_1 . #h(2em) upright("(56)") $

Again this is a quadratic objective with a constant number of quadratic
constraints. All variables can be enclosed in one explicitly computed
ellipsoid. Bienstock’s fixed-constraint QCQP theorem therefore gives a
weak additive-$zeta$ solution in time polynomial in the input bit length
and $log (1 / zeta)$.

== Numerical tolerances
<numerical-tolerances>
Exact emptiness is unnecessary. Let $zeta < min { rho , lambda } / 10$
and compute

$ d_M^max = max_(x in A) d_M (x) $

to additive accuracy $zeta$.

- If the returned witness has certified distance greater than $2 zeta$,
  its inner fiber is genuinely empty, and the algorithm explores it.
- Otherwise $d_M^max ≤ 3 zeta$. For every arm, the two inner
  constituent sets are then at distance at most $3 zeta$. The outer
  intersection contains a Euclidean ball of radius at least
  $ min { lambda , rho - 3 zeta } , $ so the dual formula and polynomial
  norm bound remain valid.

An additive-$zeta_v$ error in the planning objective adds at most
$T zeta_v$ to regret. Taking, for example,

$ zeta = T^(- 8) , #h(2em) zeta_v = T^(- 3) $

makes these contributions negligible and requires only $O (log T)$ extra
precision bits. If outcomes are real-valued, round every empirical
average to precision $T^(- 12)$ before the optimization calls. This
perturbs affine-fiber distances by $O (T^(- 12))$ and robust values by
at most $O (T^(- 6))$ through Lemma 9, again negligible over $T$ rounds.
Thus the weak bit-model implementation has polynomial running time.

= Where each assumption is used
<where-each-assumption-is-used>
The proof uses the restrictions in distinct places.

- #strong[Additive constraints.] They imply the parallel-slice
  representation $L (x) = s (x) + N$. Without it, the direction space
  may depend on $x$, and the residual-learning argument fails.
- #strong[The arm set is a Euclidean ball.] This gives an explicit
  affine basis with uniformly bounded coefficient sum
  $B_A = 1 + 2 sqrt(p)$ and makes the global optimization problems
  fixed-constraint QCQPs.
- #strong[The outcome set is a Euclidean ball.] Lemma 9 gives a uniform
  square-root stability modulus even at tangency. No positive
  transversality or sine assumption is imposed.
- #strong[The reward is affine-linear.] It is Lipschitz in the outcome,
  and the reward of a block average equals the average realized reward
  exactly.
- #strong[The hypothesis set is a Euclidean ball.] The proof does not
  use this assumption. Once the true hypothesis is fixed, the learner
  works directly with observable affine slices and never decodes
  $z^star$.

= What the theorem does and does not establish
<what-the-theorem-does-and-does-not-establish>
The theorem establishes a polynomial-time, polynomial-rate,
sublinear-regret learner for the exact restricted problem. It therefore
rules out a hardness result saying that every polynomial-time learner
must have linear regret under these assumptions, unless the arithmetic
optimization model itself is changed.

It does not show that $T^(4 / 5)$ is minimax optimal. The general
information-theoretic lower bound inherited from one-dimensional
stochastic linear bandits is only $Omega (sqrt(T))$. The square-root
instability in Lemma 9 shows that $T^(4 / 5)$ is the natural rate for a
uniform estimate-then-plan analysis, but an adaptive algorithm may be
able to avoid learning irrelevant tangent fibers and obtain a better
rate.

It also does not give an efficient implementation of Kosoy’s exact IUCB
optimism problem. The algorithm here is different: it learns an affine
selection and a ridge residual ellipsoid, and solves the resulting
fixed-QCQP surrogate.

= References
<references>
Daniel Bienstock. 2016. "A Note on Polynomial Solvability of the CDT
Problem." #emph[SIAM Journal on Optimization] 26(1): 488–498. The relevant result is Theorem 1.3: a weak polynomial-time algorithm, under the fixed-system weak-feasibility framework used there, for quadratic optimization with a fixed number of quadratic constraints when one constraint is strictly convex (in particular, ellipsoidal).

Vanessa Kosoy. 2025. "Imprecise Multi-Armed Bandits: Representing
Irreducible Uncertainty as a Zero-Sum Game." #emph[Journal of Machine
Learning Research] 26: 1–75. This paper defines the imprecise-bandit
protocol and regret benchmark, proves the information-theoretic IUCB
bound, and identifies computational complexity as an open direction. The
$T^(4 / 5)$ theorem proved here is not in that paper.
