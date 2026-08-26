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
#show: doc => conf(
  title: [Computational Tractability of Additively Constrained Linear
Imprecise Bandits #linebreak()
#text(size: 0.65em, weight: "regular")[Euclidean balls, simplices, and general polytopes]],
  date: "August 26, 2026",
  abstract: [This note consolidates the computational classification
discussed for linear imprecise bandits with affine reward and
constraints of the form $F_0 (x , z) + F_1 (y , z) = 0$, where $F_0$ and
$F_1$ are bilinear. Three conclusions emerge. First, if the arm set is a
Euclidean ball and the outcome set is a simplex, known-model planning is
NP-hard, and consequently no polynomial-time learner can guarantee
$"poly" (L) T^(1 - alpha)$ regret for any fixed $alpha > 0$ unless
$upright(N P) subset.eq upright(B P P)$. Second, if the arm set is a
simplex and the outcome set is a Euclidean ball–indeed, any convex
set–the robust value is convex in the arm, an optimal arm is a vertex,
and Exp3 on the $d_A + 1$ vertices gives $tilde(O) (sqrt(T))$ regret in
polynomial time. Third, for a general polytope arm set and a
Euclidean-ball outcome set, complexity depends on representation: an
explicitly listed vertex set is tractable, while a succinct inequality
description is NP-hard in general, already for the cube $[- 1 , 1]^n$.

],
  cols: 1,
  margin: (x: 1in, y: 0.9in),
  fontsize: 10.5pt,
  sectionnumbering: "1.1",
  doc,
)

#outline(title: [Contents], depth: 2)
#pagebreak()

= Introduction
<introduction>
The computational question is whether one can obtain a polynomial-rate
sublinear-regret guarantee in the linear imprecise-bandit model when the
mean-outcome constraints decompose additively as

$ F (x , y , z) = F_0 (x , z) + F_1 (y , z) , $

with both $F_0$ and $F_1$ bilinear. The reward is assumed affine:

$ r (x , y) = a^tack.b x + b^tack.b y + c . $

The answer depends sharply on which set is a simplex and, for general
polytopes, on how the polytope is represented.

The two original cases have opposite classifications:

#figure(
align(center)[#table(
  columns: 4,
  align: (col, row) => (left,left,left,left,).at(col),
  inset: 6pt,
  [Arm set $A$], [Outcome set $D$], [Generic computational status],
  [Best power of $T$ in polynomial time],
  [Euclidean ball],
  [Simplex],
  [NP-hard already for known-model planning],
  [No $"poly" (L) T^(1 - alpha)$ guarantee for any fixed $alpha > 0$,
  unless $upright(N P) subset.eq upright(B P P)$],
  [Simplex],
  [Euclidean ball],
  [Tractable by Exp3 on the vertices],
  [$tilde(O) (sqrt(T))$; minimax power exponent $alpha = 1 \/ 2$],
)]
)

For the extension in which $D$ remains a Euclidean ball but $A$ is an
arbitrary convex polytope, there is no representation-independent yes/no
answer:

#figure(
align(center)[#table(
  columns: 2,
  align: (col, row) => (left,left,).at(col),
  inset: 6pt,
  [Representation of $A$], [Status],
  [$A = "conv" { x^((1)) , dots.h , x^((K)) }$ with all vertices
  explicitly listed],
  [In P; Exp3 gives $O (C sqrt(K T log K))$ expected regret],
  [$A = { x : M x lt.eq q }$ with polynomially many inequalities],
  [NP-hard in general, even for $A = [- 1 , 1]^n$],
  [Fixed-dimensional $H$-polytope, or a polytope with polynomially many
  efficiently enumerable vertices],
  [In P by vertex enumeration followed by Exp3],
)]
)

Here $L$ denotes the bit length of the instance and

$ C = max_(x in A , y in D) r (x , y) - min_(x in A , y in D) r (x , y) $

is the reward range.

The central geometric fact behind both positive results is that the
robust value is convex in the arm. Convexity is helpful when the arm
polytope has a polynomial-size accessible vertex set, but it becomes a
source of hardness when one must maximize the convex function over a
succinct polytope with exponentially many vertices.

= Model and computational conventions
<model-and-computational-conventions>
== Robust value
<robust-value>
Let $A subset.eq X$ be the compact arm set, let $D subset.eq Y$ be a
compact convex outcome set, and let $H subset.eq Z$ be the hypothesis
set. Euclidean outcome balls are understood as affine balls inside the
outcome hyperplane, as in the linear imprecise-bandit framework.

For a hypothesis $z in H$ and arm $x in A$, define the compatible
mean-outcome set

$ K_z (x) = { y in D : F_0 (x , z) + F_1 (y , z) = 0 } . $

We assume $K_z (x)$ is nonempty for every relevant $(x , z)$. The lower
or robust value of arm $x$ under $z$ is

$ v_z (x) = min_(y in K_z (x)) r (x , y) . $

The known-model planning value is

$ V_z = max_(x in A) v_z (x) . $

In the online protocol, the true hypothesis $z^star.op$ is fixed but
unknown. At round $t$, the learner chooses $x_t$, and nature chooses a
distribution over outcomes whose conditional mean belongs to
$K_(z^star.op) (x_t)$. Since the reward is affine, every compatible
conditional expected reward is at least $v_(z^star.op) (x_t)$.

The expected imprecise-bandit regret is measured against
$V_(z^star.op)$:

$ "ERg"_(z^star.op) (T) = T V_(z^star.op) - inf_(nu upright(" compatible with ") z^star.op) bb(E)_nu [sum_(t = 1)^T r (x_t , Y_t)] . $

== Computational meaning
<computational-meaning>
All sets and linear maps are represented by rational data. The input
length is $L$. A learner is polynomial-time if its total running time
through horizon $T$ is polynomial in $(L , T)$.

The hardness statements concern a guarantee of the form

$ bb(E) ["Reg"_T] lt.eq p (L) T^(1 - alpha) , $

where $p$ is a polynomial and $alpha > 0$ is a fixed constant
independent of the instance. The reductions have inverse-polynomial
objective gaps, so the conclusions apply in the standard weak or
additive-approximation model for continuous optimization.

For randomized learners, the resulting complexity consequence is

$ upright(N P) subset.eq upright(B P P) . $

For deterministic learners, the consequence is $P = N P$.

= A structural lemma: the robust value is convex
<a-structural-lemma-the-robust-value-is-convex>
== Precise statement
<precise-statement>
#strong[Lemma 1 \(convexity of the lower value).] Fix a hypothesis
$z in H$. Suppose $D$ is convex, $F_0 (dot.op , z)$ and
$F_1 (dot.op , z)$ are linear, the compatible set $K_z (x)$ is nonempty
for every $x in A$, and $r$ is affine in $(x , y)$. Then

$ x arrow.r.bar v_z (x) $

is convex on every convex subset of the arm space.

== Intuition
<intuition>
Take feasible pairs $(x_1 , y_1)$ and $(x_2 , y_2)$. Because the
constraint is additive and linear once $z$ is fixed, the convex
combination

$ #scale(x: 120%, y: 120%)[\(] lambda x_1 + (1 - lambda) x_2 , lambda y_1 + (1 - lambda) y_2 #scale(x: 120%, y: 120%)[\)] $

is again feasible. The reward of the combined pair is the corresponding
convex combination of rewards. Since $v_z$ takes a minimum over all
outcomes at the combined arm, it cannot exceed that combined reward.
This is exactly the defining inequality for convexity.

== Proof
<proof>
Fix $x_1 , x_2$ and $lambda in [0 , 1]$. Let $y_i in K_z (x_i)$ attain
the minimum defining $v_z (x_i)$; compactness guarantees minimizers
exist. Put

$ x_lambda = lambda x_1 + (1 - lambda) x_2 , #h(2em) y_lambda = lambda y_1 + (1 - lambda) y_2 . $

Convexity of $D$ gives $y_lambda in D$. Moreover,

$  & F_0 (x_lambda , z) + F_1 (y_lambda , z)\
 & = lambda #scale(x: 120%, y: 120%)[\(] F_0 (x_1 , z) + F_1 (y_1 , z) #scale(x: 120%, y: 120%)[\)] + (1 - lambda) #scale(x: 120%, y: 120%)[\(] F_0 (x_2 , z) + F_1 (y_2 , z) #scale(x: 120%, y: 120%)[\)]\
 & = 0 . $

Thus $y_lambda in K_z (x_lambda)$. Since $r$ is affine,

$ v_z (x_lambda) & lt.eq r (x_lambda , y_lambda)\
 & = lambda r (x_1 , y_1) + (1 - lambda) r (x_2 , y_2)\
 & = lambda v_z (x_1) + (1 - lambda) v_z (x_2) . $

Therefore $v_z$ is convex. $square.stroked.tiny$

== Consequence for polytopes
<consequence-for-polytopes>
#strong[Corollary 2 \(an optimal arm is a vertex).] If

$ A = "conv" (V) $

is a compact polytope, then

$ max_(x in A) v_z (x) = max_(x in V) v_z (x) . $

Indeed, if $x = sum_i lambda_i v_i$, convexity gives

$ v_z (x) lt.eq sum_i lambda_i v_z (v_i) lt.eq max_i v_z (v_i) . $

This statement is geometric, not yet algorithmic. It is useful only when
the vertices are available in polynomial time.

= Tractability when the arm vertices are explicit
<tractability-when-the-arm-vertices-are-explicit>
== The general explicit-vertex theorem
<the-general-explicit-vertex-theorem>
#strong[Theorem 3 \(Exp3 over an explicitly listed vertex set).] Suppose

$ A = "conv" { x^((1)) , dots.h , x^((K)) } , $

where the $K$ vertices are explicitly listed. Assume rewards have range
at most $C$. Then there is a polynomial-time learner satisfying

$ "ERg"_(z^star.op) (T) = O #h(-1em) (C sqrt(K T log K)) $

against every adaptive compatible nature policy.

The running time per round is $O (K)$, apart from the cost of evaluating
the observed reward.

== Intuition
<intuition-1>
The learner does not have to estimate $z^star.op$, compute $v_z (x)$, or
implement IUCB. Corollary 2 says that some vertex is maximin-optimal.
Therefore it is enough to regard the vertices as a finite adversarial
bandit and run Exp3.

Although nature can adapt to the history, the conditional expected
reward of any vertex is always at least that vertex’s lower value. Hence
the standard Exp3 comparator guarantee against the best fixed vertex is
stronger than the required imprecise-bandit guarantee.

== Proof
<proof-1>
For each round $t$ and vertex $i$, define the counterfactual conditional
expected reward

$ g_(t , i) = bb(E) #h(-1em) [r (x^((i)) , Y_t) divides cal(F)_(t - 1) , med x_t = x^((i))] . $

The nature policy specifies a valid distribution for every possible
current arm, so $g_(t , i)$ is well-defined. Compatibility implies

$ g_(t , i) gt.eq v_(z^star.op) (x^((i))) . $

Let

$ i^star.op in arg max_i v_(z^star.op) (x^((i))) . $

By Corollary 2,

$ v_(z^star.op) (x^((i^star.op))) = V_(z^star.op) . $

The adaptive-adversary Exp3 guarantee gives

$ bb(E) [sum_(t = 1)^T #scale(x: 120%, y: 120%)[\(] g_(t , i^star.op) - g_(t , I_t) #scale(x: 120%, y: 120%)[\)]] = O #h(-1em) (C sqrt(K T log K)) . $

Also,

$ g_(t , i^star.op) gt.eq V_(z^star.op) $

and

$ bb(E) [r (x_t , Y_t) divides cal(F)_(t - 1) , I_t] = g_(t , I_t) . $

Therefore

$ "ERg"_(z^star.op) (T) & = T V_(z^star.op) - bb(E) sum_(t = 1)^T r (x_t , Y_t)\
 & lt.eq bb(E) sum_(t = 1)^T #scale(x: 120%, y: 120%)[\(] g_(t , i^star.op) - g_(t , I_t) #scale(x: 120%, y: 120%)[\)]\
 & = O #h(-1em) (C sqrt(K T log K)) . $

$square.stroked.tiny$

== The simplex case
<the-simplex-case>
If $A$ is a $d_A$-dimensional simplex, then it has exactly

$ K = d_A + 1 $

vertices. Theorem 3 yields

$ #box(stroke: black, inset: 3pt, [$ "ERg"_(z^star.op) (T) = O #h(-1em) (C sqrt((d_A + 1) T log (d_A + 1))) . $]) $

The Euclidean-ball assumption on $D$ is not needed for this conclusion;
convexity of $D$ is sufficient.

The algorithm has several useful features:

- it never estimates the unknown hypothesis;
- it never solves a robust planning problem;
- it does not implement IUCB;
- it does not require a non-tangency or transversality parameter;
- it runs in time polynomial in $(d_A , T)$.

= The $sqrt(T)$ exponent is information-theoretically optimal
<the-sqrt-t-exponent-is-information-theoretically-optimal>
== Precise statement
<precise-statement-1>
#strong[Proposition 4.] Even when $A$ is a one-dimensional simplex and
$D$ is a one-dimensional affine Euclidean ball, every learner has
worst-case expected regret

$ Omega (sqrt(T)) . $

Thus the minimax power exponent is $1 \/ 2$, up to logarithmic factors
in the upper bound.

== Construction
<construction>
Let

$ A = [- 1 , 1] , #h(2em) D = { (1 , y) : lr(|y|) lt.eq 1 } . $

For a parameter $theta in [- 1 \/ 4 , 1 \/ 4]$, impose the mean
constraint

$ y = x theta . $

This has the required additive bilinear form. For example, with
homogeneous hypothesis coordinates $z = (z_0 , z_1) = (1 , theta)$, take

$ F_0 (x , z) = x z_1 , #h(2em) F_1 ((y_0 , y) , z) = - y z_0 . $

Let the reward be

$ r (x , (1 , y)) = y . $

For a known positive $theta$, the optimal arm is $x = 1$; for a known
negative $theta$, it is $x = - 1$.

Consider the two environments

$ theta_(+) = epsilon , #h(2em) theta_(-) = - epsilon . $

Under either environment, nature returns a random variable
$Y_t in { - 1 , + 1 }$ with

$ bb(E) [Y_t divides cal(F)_(t - 1) , x_t] = x_t theta . $

This is compatible because $lr(|x_t theta|) lt.eq 1 \/ 4$.

== Proof
<proof-2>
Let $P_(+)$ and $P_(-)$ be the distributions over the full interaction
history under $theta_(+)$ and $theta_(-)$. For
$lr(|x_t epsilon|) lt.eq 1 \/ 4$, the one-round conditional
Kullback–Leibler divergence between the two Rademacher laws is at most

$ 8 epsilon^2 x_t^2 lt.eq 8 epsilon^2 . $

The chain rule gives

$ "KL" (P_(+) bar.v.double P_(-)) lt.eq 8 T epsilon^2 . $

Choose

$ epsilon = frac(1, 8 sqrt(T)) . $

Then $"KL" (P_(+) bar.v.double P_(-)) lt.eq 1 \/ 8$, so Pinsker’s
inequality gives

$ "TV" (P_(+) , P_(-)) lt.eq 1 / 4 . $

Under $theta_(+)$, the expected instantaneous regret is
$epsilon (1 - x_t)$; under $theta_(-)$, it is $epsilon (1 + x_t)$.
Moreover,

$ lr(|bb(E)_(+) [x_t] - bb(E)_(-) [x_t]|) lt.eq 2 "TV" (P_(+) , P_(-)) lt.eq 1 / 2 . $

Therefore

$ R_(+) (T) + R_(-) (T) & = epsilon sum_(t = 1)^T (2 + bb(E)_(-) [x_t] - bb(E)_(+) [x_t])\
 & gt.eq 3 / 2 epsilon T . $

At least one of the two environments has regret at least

$ 3 / 4 epsilon T = 3 / 32 sqrt(T) . $

$square.stroked.tiny$

Consequently:

$ #box(stroke: black, inset: 3pt, [$ upright("simplex ") A , med upright("convex ") D quad arrow.r.double quad tilde(Theta) (sqrt(T)) upright(" as a power of ") T . $]) $

= NP-hardness when $A$ is a Euclidean ball and $D$ is a simplex
<np-hardness-when-a-is-a-euclidean-ball-and-d-is-a-simplex>
== Precise statement
<precise-statement-2>
#strong[Theorem 5.] Consider additively constrained linear imprecise
bandits with affine reward. Known-hypothesis planning is NP-hard even
when

- $A$ is a Euclidean unit ball;
- $D$ is a simplex;
- $H = [1 , 2]$ is one-dimensional;
- every $z in H$ induces the same model;
- the reward lies in $[0 , 1]$.

Consequently, for every fixed $alpha > 0$, a polynomial-time learner
satisfying

$ bb(E) ["Reg"_T] lt.eq p (L) T^(1 - alpha) $

on every such instance would imply
$upright(N P) subset.eq upright(B P P)$.

== Intuition
<intuition-2>
A simplex can split each signed coordinate into positive and negative
mass. If the constraints force

$ p_i - q_i = t_i , $

then minimizing the total non-slack mass

$ sum_i (p_i + q_i) $

produces exactly $parallel t parallel_1$. Thus the lower value can be
made proportional to

$ parallel B^tack.b x parallel_1 . $

Maximizing this norm over a Euclidean ball dualizes to a sign
optimization. For an incidence matrix, the sign optimization is exactly
MaxCut.

== Reduction from MaxCut
<reduction-from-maxcut>
Let $G = (V , E)$ be an undirected graph with

$ n = lr(|V|) , #h(2em) m = lr(|E|) gt.eq 1 . $

Orient the edges arbitrarily and let

$ B in bb(R)^(m times n) $

be the oriented edge–vertex incidence matrix. For a sign vector
$sigma in { - 1 , + 1 }^n$, the coordinate of $B sigma$ corresponding to
edge $(i , j)$ is $sigma_i - sigma_j$.

Set

$ gamma = frac(1, 2 m n) . $

=== Arm set
<arm-set>
Take

$ A = { x in bb(R)^m : parallel x parallel_2 lt.eq 1 } . $

=== Outcome simplex
<outcome-simplex>
Write an outcome as

$ y = (p , q , s) , #h(2em) p , q in bb(R)^n , quad s in bb(R) . $

Let

$ D = {(p , q , s) : p gt.eq 0 , med q gt.eq 0 , med s gt.eq 0 , med bold(1)^tack.b p + bold(1)^tack.b q + s = 1} . $

This is the simplex $Delta_(2 n + 1)$.

=== Hypotheses and constraints
<hypotheses-and-constraints>
Take

$ H = [1 , 2] $

and $W = bb(R)^n$. Define

$ F_0 (x , z) = - gamma z B^tack.b x , $

and

$ F_1 ((p , q , s) , z) = z (p - q) . $

Both maps are bilinear. Since $z eq.not 0$, the constraint

$ F_0 (x , z) + F_1 (y , z) = 0 $

is simply

$ p - q = gamma B^tack.b x . $

All hypotheses induce the same compatible sets.

=== Reward
<reward>
Define

$ r (x , (p , q , s)) = bold(1)^tack.b (p + q) . $

The reward is linear and lies in $[0 , 1]$ on $D$.

== Feasibility
<feasibility>
For $parallel x parallel_2 lt.eq 1$,

$ parallel B^tack.b x parallel_1 & lt.eq sqrt(n) thin parallel B^tack.b x parallel_2\
 & lt.eq sqrt(n) thin parallel B parallel_(upright(o p)) parallel x parallel_2\
 & lt.eq sqrt(n) thin parallel B parallel_F\
 & = sqrt(2 m n) . $

Hence

$ gamma parallel B^tack.b x parallel_1 lt.eq 1 . $

Given $t = gamma B^tack.b x$, choose

$ p_i = max (t_i , 0) , #h(2em) q_i = max (- t_i , 0) , #h(2em) s = 1 - parallel t parallel_1 . $

This is a feasible point in $D$.

== The induced robust value
<the-induced-robust-value>
#strong[Lemma 6.] For every $x in A$ and every $z in H$,

$ v_z (x) = gamma parallel B^tack.b x parallel_1 . $

=== Proof
<proof-3>
For every feasible $(p , q , s)$,

$ p_i - q_i = t_i , #h(2em) t = gamma B^tack.b x . $

Since $p_i , q_i gt.eq 0$,

$ p_i + q_i gt.eq lr(|t_i|) . $

Therefore

$ r (x , (p , q , s)) = sum_i (p_i + q_i) gt.eq sum_i lr(|t_i|) = parallel t parallel_1 . $

The feasible positive/negative decomposition above attains equality.
Thus

$ v_z (x) = parallel t parallel_1 = gamma parallel B^tack.b x parallel_1 . $

$square.stroked.tiny$

== The MaxCut identity
<the-maxcut-identity>
#strong[Lemma 7.]

$ max_(parallel x parallel_2 lt.eq 1) parallel B^tack.b x parallel_1 = 2 sqrt("MaxCut" (G)) . $

=== Proof
<proof-4>
By duality of $ell_1$ and $ell_oo$,

$ parallel B^tack.b x parallel_1 = max_(sigma in { - 1 , + 1 }^n) sigma^tack.b B^tack.b x . $

Therefore

$ max_(parallel x parallel_2 lt.eq 1) parallel B^tack.b x parallel_1 & = max_(sigma in { - 1 , + 1 }^n) max_(parallel x parallel_2 lt.eq 1) x^tack.b B sigma\
 & = max_(sigma in { - 1 , + 1 }^n) parallel B sigma parallel_2 . $

For an edge $(i , j)$,

$ (B sigma)_((i , j))^2 = (sigma_i - sigma_j)^2 = cases(delim: "{", 4 , & sigma_i eq.not sigma_j ,, 0 , & sigma_i = sigma_j .) $

Thus

$ parallel B sigma parallel_2^2 = 4 thin lr(|"cut" (sigma)|) . $

Maximizing over $sigma$ proves the claim. $square.stroked.tiny$

Combining Lemmas 6 and 7 gives

$ #box(stroke: black, inset: 3pt, [$ V_z = 2 gamma sqrt("MaxCut" (G)) . $]) $

Hence known-model planning determines MaxCut.

== Inverse-polynomial objective gap
<inverse-polynomial-objective-gap>
If the maximum cut sizes are $k$ and $k - 1$, their planning values
differ by

$ 2 gamma (sqrt(k) - sqrt(k - 1)) & = frac(2 gamma, sqrt(k) + sqrt(k - 1))\
 & gt.eq gamma / m . $

The last bound is deliberately loose but inverse-polynomial. Thus
additive approximation within $gamma \/ (3 m)$ is already enough to
recover the exact maximum-cut size.

== From low regret to an NP-hard planner
<from-low-regret-to-an-np-hard-planner>
Let nature deterministically return the minimizing feasible outcome used
in the proof of Lemma 6. Then the realized reward from arm $x_t$ is
exactly $v_z (x_t)$.

Let

$ hat(V)_T = max_(1 lt.eq t lt.eq T) v_z (x_t) . $

Pointwise,

$ V_z - hat(V)_T lt.eq 1 / T sum_(t = 1)^T #scale(x: 120%, y: 120%)[\(] V_z - v_z (x_t) #scale(x: 120%, y: 120%)[\)] . $

If the learner has expected regret at most $p (L) T^(1 - alpha)$, then

$ bb(E) [V_z - hat(V)_T] lt.eq p (L) T^(- alpha) . $

By Markov’s inequality, with probability at least $2 \/ 3$,

$ V_z - hat(V)_T lt.eq 3 p (L) T^(- alpha) . $

Choose

$ T gt.eq (frac(9 m thin p (L), gamma))^(1 \/ alpha) . $

Because $alpha$ is fixed and $gamma^(- 1) = 2 m n$, this horizon is
polynomial in $L$. The best arm played then determines the exact
maximum-cut size with probability at least $2 \/ 3$. Therefore a general
polynomial-time learner with any fixed power improvement over linear
regret would imply

$ upright(N P) subset.eq upright(B P P) . $

The hardness is present even when the hypothesis is effectively known
and nature is deterministic. It is not caused by statistical estimation,
exploration, or tangency.

= General polytope arms with a Euclidean-ball outcome set
<general-polytope-arms-with-a-euclidean-ball-outcome-set>
The simplex result does not extend to arbitrary polytopes. Convexity
still forces an optimum to a vertex, but a succinct polytope may have
exponentially many vertices. Maximizing the induced convex robust value
can encode MaxCut.

== Precise classification
<precise-classification>
#strong[Theorem 8 \(representation-dependent classification).] Let $D$
be an affine Euclidean ball and suppose the reward and constraints have
the same affine/additive-bilinear form as above.

+ If $ A = "conv" { x^((1)) , dots.h , x^((K)) } $ is given by an
  explicit list of vertices, then polynomial-time
  $ O (C sqrt(K T log K)) $ expected regret is achievable.

+ For a general rational $H$-polytope $ A = { x : M x lt.eq q } , $
  known-model planning is NP-hard. This remains true for the cube
  $A = [- 1 , 1]^n$.

+ Consequently, a polynomial-time learner with regret
  $p (L) T^(1 - alpha)$ for any fixed $alpha > 0$ on every
  inequality-described polytope would imply
  $upright(N P) subset.eq upright(B P P)$.

Part 1 is Theorem 3. The rest of this section proves Parts 2 and 3.

= NP-hardness for the cube
<np-hardness-for-the-cube>
== Precise statement
<precise-statement-3>
#strong[Theorem 9.] Known-hypothesis planning is NP-hard even under all
of the following restrictions:

- $A = [- 1 , 1]^n$, represented by $2 n$ inequalities;
- $D$ is an affine Euclidean ball;
- $H = [1 , 2]$, and every hypothesis induces the same model;
- $F = F_0 + F_1$ with both pieces bilinear;
- the reward is linear in the outcome;
- every feasible affine slice stays a constant distance away from
  tangency.

== Intuition
<intuition-3>
The Euclidean ball converts the norm of a forced coordinate vector into
a square root. If the constraint fixes

$ u = epsilon B^tack.b x , $

and nature minimizes a remaining coordinate $s$ subject to

$ parallel u parallel_2^2 + s^2 lt.eq 1 , $

then

$ v (x) = - sqrt(1 - epsilon^2 parallel B^tack.b x parallel_2^2) . $

This is strictly increasing in the convex quadratic
$parallel B^tack.b x parallel_2^2$. Maximizing that quadratic over a
cube is MaxCut.

== Reduction from MaxCut
<reduction-from-maxcut-1>
Let $G = (V , E)$ have $n$ vertices and $m gt.eq 1$ edges. Orient the
edges arbitrarily and let

$ B in bb(R)^(n times m) $

be the vertex–edge incidence matrix, so that

$ (B^tack.b x)_e = x_i - x_j $

for edge $e = (i , j)$.

Set

$ epsilon = frac(1, 4 m) . $

=== Arm polytope
<arm-polytope>
Take

$ A = [- 1 , 1]^n . $

This polytope has only $2 n$ facets but $2^n$ vertices.

=== Outcome ball
<outcome-ball>
Write outcomes as

$ y = (y_0 , u , s) , #h(2em) u in bb(R)^m , quad s in bb(R) , $

and define

$ D = {(1 , u , s) : parallel u parallel_2^2 + s^2 lt.eq 1} . $

This is a Euclidean ball in the affine hyperplane $y_0 = 1$.

=== Hypotheses and constraints
<hypotheses-and-constraints-1>
Take $H = [1 , 2]$ and $W = bb(R)^m$. Define

$ F_0 (x , z) = - epsilon z B^tack.b x , $

and

$ F_1 ((y_0 , u , s) , z) = z u . $

The constraint is

$ u = epsilon B^tack.b x , $

independently of $z$.

=== Reward
<reward-1>
Let

$ r (x , (1 , u , s)) = s . $

For any $x in [- 1 , 1]^n$,

$ parallel B^tack.b x parallel_2^2 = sum_((i , j) in E) (x_i - x_j)^2 lt.eq 4 m . $

Therefore

$ parallel epsilon B^tack.b x parallel_2^2 lt.eq frac(1, 4 m) lt.eq 1 / 4 , $

so the compatible slice is nonempty.

== The induced robust value
<the-induced-robust-value-1>
For a fixed arm $x$, nature minimizes $s$ subject to

$ u = epsilon B^tack.b x , #h(2em) parallel u parallel_2^2 + s^2 lt.eq 1 . $

Hence

$ #box(stroke: black, inset: 3pt, [$ v (x) = - sqrt(1 - epsilon^2 parallel B^tack.b x parallel_2^2) . $]) $

Since the map

$ q arrow.r.bar - sqrt(1 - epsilon^2 q) $

is strictly increasing, maximizing $v (x)$ is equivalent to maximizing

$ q (x) = parallel B^tack.b x parallel_2^2 . $

== Why the quadratic maximum is MaxCut
<why-the-quadratic-maximum-is-maxcut>
The function $q$ is convex. More concretely, with all coordinates except
$x_i$ fixed, $q$ is a convex quadratic function of $x_i$. Its maximum
over $[- 1 , 1]$ is therefore attained at an endpoint. Rounding
coordinates one at a time produces a sign vector

$ sigma in { - 1 , + 1 }^n $

without decreasing $q$.

At a sign vector,

$ q (sigma) & = sum_((i , j) in E) (sigma_i - sigma_j)^2\
 & = 4 thin lr(|"cut" (sigma)|) . $

Thus

$ max_(x in [- 1 , 1]^n) q (x) = 4 "MaxCut" (G) . $

If the maximum cut size is $k$, then the optimal planning value is

$ #box(stroke: black, inset: 3pt, [$ V_k = - sqrt(1 - frac(k, 4 m^2)) . $]) $

Therefore known-model planning determines MaxCut.

== Inverse-polynomial separation
<inverse-polynomial-separation>
Consecutive possible values satisfy

$ V_k - V_(k - 1) & = sqrt(1 - frac(k - 1, 4 m^2)) - sqrt(1 - frac(k, 4 m^2))\
 & = frac(1 \/ (4 m^2), sqrt(1 - frac(k - 1, 4 m^2)) + sqrt(1 - frac(k, 4 m^2)))\
 & gt.eq frac(1, 8 m^2) . $

Thus additive approximation within

$ delta = frac(1, 16 m^2) $

is enough to identify the exact maximum-cut size after coordinatewise
rounding.

== Low regret would solve MaxCut
<low-regret-would-solve-maxcut>
Let nature deterministically return the worst compatible outcome

$ (1 , epsilon B^tack.b x , - sqrt(1 - epsilon^2 parallel B^tack.b x parallel_2^2)) . $

Then the observed reward is exactly $v (x)$.

Suppose a polynomial-time learner satisfies

$ bb(E) ["Reg"_T] lt.eq p (L) T^(1 - alpha) . $

If the learner never plays a $delta$-optimal arm, every round has regret
more than $delta$, so

$ Pr (upright("no ") delta upright("-optimal arm in the first ") T upright(" rounds")) lt.eq frac(p (L), delta T^alpha) . $

Choose

$ T gt.eq (frac(3 p (L), delta))^(1 \/ alpha) . $

This is polynomial in the input size. With probability at least
$2 \/ 3$, the learner plays a $delta$-optimal point $x$. Round $x$
coordinatewise to a sign vector without decreasing $q (x)$, and output
the corresponding cut. The value gap proves that this is a maximum cut.

Therefore a polynomial-time $T^(1 - alpha)$-regret learner for arbitrary
inequality-described arm polytopes would imply

$ upright(N P) subset.eq upright(B P P) . $

== The reduction is not a tangency artifact
<the-reduction-is-not-a-tangency-artifact>
Every feasible slice fixes a vector $u$ satisfying

$ parallel u parallel_2 lt.eq 1 / 2 . $

The remaining cross-section in the outcome ball has radius at least

$ sqrt(1 - 1 / 4) = sqrt(3) / 2 . $

Thus the hardness persists under a constant non-tangency margin.

= What is tractable among general polytopes?
<what-is-tractable-among-general-polytopes>
The cube reduction establishes hardness of the general class, not
hardness of every individual non-simplex polytope.

== Explicit $V$-representations
<explicit-v-representations>
If

$ A = "conv" { x^((1)) , dots.h , x^((K)) } $

is given by a list of all vertices, Theorem 3 applies directly. The
running time is polynomial in the actual representation length, which
already includes $K$.

There is no contradiction with the cube hardness. Listing all cube
vertices requires $2^n$ entries, while the inequality representation
uses only $2 n$ inequalities.

== Fixed dimension
<fixed-dimension>
If the affine dimension of $A$ is a fixed constant and $A$ is described
by $M$ rational inequalities, the number of vertices is polynomial in
$M$, and standard vertex-enumeration methods run in polynomial time for
fixed dimension. One may enumerate the vertices and then run Exp3.

== Other special polytopes
<other-special-polytopes>
Any class with a polynomial-size, efficiently enumerable set containing
all possible maximizers is tractable by the same finite-arm reduction.
Conversely, a mere linear-optimization oracle for $A$ is not generally
sufficient: the objective $v_z (x)$ is convex, not linear.

The correct generic distinction is therefore approximately

$ #box(stroke: black, inset: 3pt, [$ upright("polynomially many accessible vertices") quad upright("versus") quad upright("a succinct polytope with exponentially many vertices") . $]) $

This is a sufficient-versus-hardness distinction, not a complete
characterization of every specially structured polytope.

= Consolidated classification
<consolidated-classification>
Under the standing assumptions

$ r (x , y) = a^tack.b x + b^tack.b y + c $

and

$ F (x , y , z) = F_0 (x , z) + F_1 (y , z) , $

with $F_0 , F_1$ bilinear, the results are:

#figure(
align(center)[#table(
  columns: 3,
  align: (col, row) => (left,left,left,).at(col),
  inset: 6pt,
  [Arm geometry and representation], [Outcome geometry], [Computational
  conclusion],
  [Euclidean ball],
  [Simplex],
  [Known-model planning is NP-hard; no polynomial-time
  $"poly" (L) T^(1 - alpha)$ regret for any fixed $alpha > 0$ unless
  $upright(N P) subset.eq upright(B P P)$],
  [Simplex of affine dimension $d_A$],
  [Any convex $D$, hence a Euclidean ball],
  [Exp3 on $d_A + 1$ vertices gives
  $O (C sqrt((d_A + 1) T log (d_A + 1)))$ regret],
  [General polytope with all $K$ vertices listed],
  [Euclidean ball],
  [Exp3 gives $O (C sqrt(K T log K))$ regret],
  [General polytope given by inequalities],
  [Euclidean ball],
  [NP-hard in general, already for $[- 1 , 1]^n$],
  [Fixed-dimensional inequality-described polytope],
  [Euclidean ball],
  [Polynomial-time via vertex enumeration and Exp3],
)]
)

In terms of the requested exponent $alpha$:

- For a simplex arm set, the optimal power is $alpha = 1 \/ 2$ up to
  logarithmic factors. No algorithm can obtain a uniformly better power
  because of the $Omega (sqrt(T))$ lower bound.
- For a Euclidean-ball arm set with simplex outcomes, every fixed
  $alpha > 0$ is computationally ruled out under the standard assumption
  $upright(N P) subset.eq.not upright(B P P)$.
- For arbitrary inequality-described arm polytopes with Euclidean-ball
  outcomes, the same computational impossibility holds in the worst
  case.
- For an explicitly listed $K$-vertex polytope, the power exponent is
  again $1 \/ 2$ up to logarithmic factors, with dimension dependence
  replaced by $K$.

= Why the asymmetry occurs
<why-the-asymmetry-occurs>
The same convexity phenomenon drives both sides of the classification.

When $D$ is a simplex, minimization over positive and negative masses
can create an $ell_1$ norm:

$ v (x) tilde.op parallel B^tack.b x parallel_1 . $

Maximizing this convex function over a Euclidean ball produces the
discrete sign optimization underlying MaxCut.

When $A$ is a simplex, convexity is beneficial instead. The maximum of
$v_z$ must occur at one of only $d_A + 1$ vertices, so the continuous
problem collapses to a polynomial-size finite-arm adversarial bandit.

For a general polytope, the geometric statement remains true–an optimum
is a vertex–but computational usefulness depends on whether those
vertices are explicitly accessible. A cube has a succinct facet
representation and exponentially many vertices, allowing the convex
maximization problem to hide MaxCut.

= Scope of the statements
<scope-of-the-statements>
+ #strong[Affine balls.] Outcome balls are affine Euclidean balls inside
  the outcome hyperplane, consistent with the standard imprecise-bandit
  formalism.

+ #strong[Randomized versus deterministic complexity.] The online
  reductions use randomized learners and therefore yield the consequence
  $upright(N P) subset.eq upright(B P P)$. Deterministic learners would
  yield $P = N P$.

+ #strong[Weak continuous optimization.] The reductions have
  inverse-polynomial gaps, so hardness holds for inverse-polynomial
  additive approximation; it is not an artifact of asking for exact real
  arithmetic.

+ #strong[General-class hardness.] Saying that arbitrary $H$-polytopes
  are NP-hard does not mean that every non-simplex polytope is hard.
  Explicit vertex lists, fixed dimension, and other special structures
  remain tractable.

+ #strong[No dependence on IUCB.] The positive algorithms use Exp3, not
  IUCB. The negative results are hardness results for every
  polynomial-time learner, because known-model planning itself is hard
  in the constructed instances.

= References
<references>
+ Vanessa Kosoy. #emph[Imprecise Multi-Armed Bandits: Representing
  Irreducible Uncertainty as a Zero-Sum Game];. Journal of Machine
  Learning Research 26, 2025, pp.~1–75.

+ Peter Auer, Nicolò Cesa-Bianchi, Yoav Freund, and Robert E. Schapire.
  #emph[The Nonstochastic Multiarmed Bandit Problem];. SIAM Journal on
  Computing 32\(1), 2002, pp.~48–77.

+ Tor Lattimore and Csaba Szepesvári. #emph[Bandit Algorithms];.
  Cambridge University Press, 2020.

+ Michael R. Garey and David S. Johnson. #emph[Computers and
  Intractability: A Guide to the Theory of NP-Completeness];. W. H.
  Freeman, 1979.
