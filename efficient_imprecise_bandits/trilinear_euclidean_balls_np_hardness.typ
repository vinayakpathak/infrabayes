// Self-contained Typst source. Generated with Pandoc and then styled.
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

#show quote.where(block: true): it => block(
  width: 100%,
  breakable: true,
  inset: 9pt,
  radius: 3pt,
  fill: rgb("#f4f7fb"),
  stroke: 0.7pt + rgb("#7890aa"),
)[#it.body]

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
  set par(justify: true, leading: 0.65em)
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
  title: [NP-Hardness of Learning in Trilinear Imprecise Bandits with
Euclidean Balls],
  abstract: [We prove that allowing the constraint map of a linear
imprecise bandit to be genuinely trilinear reintroduces computational
hardness even under strong geometric restrictions. The arm set is a
full-dimensional Euclidean ball, the outcome set is an affine Euclidean
ball, and the admissible hypothesis set is a one-dimensional Euclidean
ball. The reward is linear, every compatible mean-outcome set is a
singleton, all admissible hypotheses induce exactly the same model, and
the instance has a constant non-tangency parameter. Nevertheless,
known-model planning is NP-hard to inverse-polynomial additive accuracy.
Consequently, a polynomial-time learner with regret bounded by
$"poly" (L) T^(1 - beta)$ for any fixed $beta > 0$ would imply
$"NP" subset.eq "BPP"$; for deterministic learners it
would imply $"P" = "NP"$.

],
  margin: (x: 0.88in, y: 0.82in),
  fontsize: 10.5pt,
  sectionnumbering: "1.1",
  cols: 1,
  doc,
)

#align(center)[
  #text(size: 11pt, style: "italic")[A self-contained reduction from CLIQUE]
]
#v(0.6em)

#outline(
  title: auto,
  depth: 3
);

= Model and terminology
<model-and-terminology>
Let $A$ be the compact arm set, let $Y$ be the outcome vector space, let
$mu in Y^(\*)$ be the normalizing functional, and let

$ D subset.eq mu^(- 1) (1) $

be the compact convex outcome set. Let $Z$ be the ambient parameter
vector space and let $H subset.eq Z$ be the compact set of admissible
hypotheses. Let $W$ be the constraint space. A constraint map

$ F : A times Z times Y arrow.r W $

induces, for every arm $x in A$ and hypothesis $z in H$, the linear
subspace

$ K_z (x) := ker F_(x , z) $

and the compatible mean-outcome set

$ K_z (x)^(+) := K_z (x) sect D . $

For a reward $r : A times D arrow.r bb(R)$, define the lower value

$ v_z (x) := min_(y in K_z (x)^(+)) r (x , y) . $

Known-model planning is the optimization problem

$ "OPT" (z) := max_(x in A) v_z (x) . $

The online regret against the true hypothesis $z^star.op$ is measured
relative to $"OPT" (z^star.op)$, as in the linear imprecise-bandit
framework.

#quote(block: true)[
#strong[Notation concerning the hypothesis ball.] In the usual
formulation, $Z$ is an ambient vector space and therefore is not itself
a compact Euclidean ball. The meaningful geometric restriction is that
the admissible set $H subset.eq Z$ is a Euclidean ball. Our construction
takes $Z = bb(R)$ and $H = [1 , 2]$.
]

= Main theorem
<main-theorem>
#quote(block: true)[
#strong[Theorem 1 \(hardness with Euclidean balls).] There is a
polynomial-time mapping from graphs $G$ to rationally represented linear
imprecise-bandit instances with all of the following properties:

+ $A$ is a full-dimensional Euclidean ball.
+ $D$ is an affine Euclidean ball in $mu^(- 1) (1)$.
+ $Z = bb(R)$ and $H = [1 , 2]$ is a nondegenerate Euclidean ball.
+ $F$ is trilinear in $(x , z , y)$.
+ The reward is linear in $y$ and independent of $x$.
+ For every $x in A$ and $z in H$, the operator
  $F_(x , z) : Y arrow.r W$ is onto.
+ For every $x in A$ and $z in H$, $K_z (x)^(+)$ is a singleton.
+ $K_z (x)^(+)$ is independent of $z$.
+ The non-tangency parameter satisfies $S > 0.85$.

Computing $"OPT" (z)$ to inverse-polynomial additive accuracy is
NP-hard, even when $z$ is known. Consequently, for every fixed
$beta > 0$, the existence of a randomized polynomial-time learner
satisfying

$ bb(E) ["Reg"_T] lt.eq "poly" (L) T^(1 - beta) $

on every instance in this class would imply
$"NP" subset.eq "BPP"$. For deterministic learners, it
would imply $"P" = "NP"$.
]

The online learning problem is not itself a decision language, so the
precise complexity statement is #emph[NP-hardness of learning];. A
threshold or promise-gap version of the restricted planning problem can
be formulated as an NP-hard decision problem. We do not claim that the
general continuous online problem is NP-complete.

= Intuition
<intuition>
The decomposable restriction

$ F (x , z , y) = F_0 (x , z) + F_1 (y , z) $

forbids products between nonconstant arm coordinates and nonconstant
outcome coordinates. A genuinely trilinear map permits constraints such
as

$ x_0 a_i = x_i y_0 , $

$ x_0 b_(i j) = x_i a_j , $

$ x_0 c_(i j k) = x_i b_(j k) . $

When $x_0 eq.not 0$ and $y_0 = 1$, these equations recursively force

$ a_i prop x_i / x_0 , #h(2em) b_(i j) prop frac(x_i x_j, x_0^2) , #h(2em) c_(i j k) prop frac(x_i x_j x_k, x_0^3) . $

A reward that is merely linear in the third-order outcome coordinates
therefore becomes an arbitrary cubic polynomial in the normalized arm
coordinates. Maximizing an appropriate cubic form over a Euclidean
sphere reveals the clique number of a graph.

The construction below packages this monomial-lifting mechanism inside
genuine Euclidean balls while keeping every feasible outcome strictly
inside the outcome ball.

= The cubic source problem
<the-cubic-source-problem>
Let $G = (V , E)$ be an undirected graph with

$ n := lr(|V|) , #h(2em) m := lr(|E|) gt.eq 1 . $

Enumerate the edges as

$ E = { e_1 , dots.h , e_m } , #h(2em) e_k = { i_k , j_k } . $

Let

$ d := n + m $

and write a vector $q in bb(R)^d$ as

$ q = (u_1 , dots.h , u_n , w_1 , dots.h , w_m) . $

Define the homogeneous cubic form

$ p_G (q) := sum_(k = 1)^m u_(i_k) u_(j_k) w_k . $

#quote(block: true)[
#strong[Lemma 2 \(cubic clique identity).] Let $omega (G)$ denote the
clique number of $G$. Then

$ max_(parallel q parallel_2 = 1) p_G (q)^2 = 2 / 27 (1 - frac(1, omega (G))) . $
]

#emph[Proof.] Write $q = (u , w)$, let $a = parallel u parallel_2$ and
$b = parallel w parallel_2$, and suppose $a^2 + b^2 = 1$. For fixed $u$
and fixed $b$, Cauchy–Schwarz gives

$ max_(parallel w parallel_2 = b) p_G (u , w) = b sqrt(sum_(k = 1)^m u_(i_k)^2 u_(j_k)^2) . $

If $u = a s$ with $parallel s parallel_2 = 1$, this becomes

$ a^2 b sqrt(sum_(k = 1)^m s_(i_k)^2 s_(j_k)^2) . $

Set $pi_i = s_i^2$. Then $pi$ lies in the probability simplex. The
Motzkin–Straus theorem gives

$ max_(pi_i gt.eq 0\
sum_i pi_i = 1) sum_({ i , j } in E) pi_i pi_j = 1 / 2 (1 - frac(1, omega (G))) . $

Finally,

$ max_(a^2 + b^2 = 1\
a , b gt.eq 0) a^2 b = frac(2, 3 sqrt(3)) , $

attained at $a^2 = 2 \/ 3$ and $b^2 = 1 \/ 3$. Multiplying the two
factors and squaring yields

$ max_(parallel q parallel_2 = 1) p_G (q)^2 = 4 / 27 dot.op 1 / 2 (1 - frac(1, omega (G))) = 2 / 27 (1 - frac(1, omega (G))) . #h(2em) square.stroked.tiny $

The values corresponding to different clique numbers have an
inverse-polynomial separation. For $2 lt.eq k lt.eq n$,

$  & sqrt(1 - 1 / k) - sqrt(1 - frac(1, k - 1))\
 & quad = frac(1, k (k - 1) (sqrt(1 - 1 \/ k) + sqrt(1 - 1 \/ (k - 1))))\
 & quad gt.eq frac(1, 2 k (k - 1)) . $

This gap will turn an inverse-polynomial additive planner into an
algorithm for CLIQUE.

= Bandit construction
<bandit-construction>
Fix a graph $G$ and the associated integers $n , m , d$.

== Arm ball
<arm-ball>
Let the arm vector be

$ x = (x_0 , v) in bb(R) times bb(R)^d . $

Define

$ A := {(x_0 , v) : (x_0 - 5 / 3)^2 + parallel v parallel_2^2 lt.eq 1} . $

This is a full-dimensional Euclidean ball. Every $x in A$ satisfies

$ x_0 gt.eq 2 / 3 > 0 . $

Define the normalized arm coordinate

$ q := v / x_0 . $

#quote(block: true)[
#strong[Lemma 3 \(ratio geometry of the arm ball).] The set of
attainable normalized vectors $q = v \/ x_0$ is exactly the Euclidean
ball

$ {q in bb(R)^d : parallel q parallel_2 lt.eq 3 / 4} . $

In particular,

$ max_(x in A) frac(parallel v parallel_2, x_0) = 3 / 4 . $
]

#emph[Proof.] For any $x in A$,

$ parallel v parallel_2^2 lt.eq 1 - (x_0 - 5 / 3)^2 . $

The inequality $parallel v parallel_2 \/ x_0 lt.eq 3 \/ 4$ is equivalent
to

$ 1 - (x_0 - 5 / 3)^2 lt.eq 9 / 16 x_0^2 . $

After rearranging,

$ 1 - (x_0 - 5 / 3)^2 - 9 / 16 x_0^2 = - (15 x_0 - 16)^2 / 144 lt.eq 0 . $

Conversely, take any $q$ with $parallel q parallel_2 lt.eq 3 \/ 4$ and
set

$ x_0 = 16 / 15 , #h(2em) v = x_0 q . $

Then

$ (x_0 - 5 / 3)^2 + parallel v parallel_2^2 = 9 / 25 + 256 / 225 parallel q parallel_2^2 lt.eq 9 / 25 + 16 / 25 = 1 . $

Thus $(x_0 , v) in A$, and every vector in the radius-$3 \/ 4$ ball is
attained. $square.stroked.tiny$

== Hypothesis ball
<hypothesis-ball>
Take

$ Z := bb(R) , #h(2em) H := [1 , 2] = {z in bb(R) : lr(|z - 3 / 2|) lt.eq 1 / 2} . $

The interval $H$ is a nondegenerate one-dimensional Euclidean ball. It
is shifted away from zero because trilinearity would otherwise force
$F (x , 0 , y) = 0$, which is incompatible with surjectivity onto a
nonzero constraint space $W$.

== Outcome ball
<outcome-ball>
Let the outcome vector have coordinates

$ y = (y_0 , a , b , c) , $

where

$ a in bb(R)^d , #h(2em) b in bb(R)^(d times d) , #h(2em) c in bb(R)^(d times d times d) . $

Let $mu (y) = y_0$, and define

$ D := {(y_0 , a , b , c) : y_0 = 1 , med parallel a parallel_2^2 + parallel b parallel_F^2 + parallel c parallel_F^2 lt.eq 1} . $

Thus $D$ is the unit Euclidean ball inside the affine hyperplane
$mu^(- 1) (1)$.

== Constraint map
<constraint-map>
Let the constraint space be

$ W := bb(R)^d xor bb(R)^(d times d) xor bb(R)^(d times d times d) . $

For $x = (x_0 , v)$, $z in Z$, and $y = (y_0 , a , b , c)$, define
$F (x , z , y)$ coordinatewise by

$ F_i (x , z , y) := z (x_0 a_i - 1 / 2 v_i y_0) , $

$ F_(i j) (x , z , y) := z (x_0 b_(i j) - v_i a_j) , $

$ F_(i j k) (x , z , y) := z (x_0 c_(i j k) - v_i b_(j k)) . $

Each term contains one coordinate from $x$, one from $z$, and one from
$y$. Hence $F$ is linear separately in all three arguments and is
therefore trilinear.

== Linear reward
<linear-reward>
Recall that the first $n$ coordinates of $q$ correspond to vertices and
the last $m$ coordinates correspond to edges. Define

$ r (x , y) := r (y) := 1 / m sum_(k = 1)^m c_(i_k , j_k , n + k) . $

This reward is linear in $y$ and independent of $x$.

It also satisfies the standard Lipschitz normalization. Write the
outcome as $(y_0 , u)$, where $u = (a , b , c)$. The absolute convex
hull of

$ D = { (1 , u) : parallel u parallel_2 lt.eq 1 } $

is

$ [- 1 , 1] times B_2 , $

whose Minkowski norm is

$ parallel (t , u) parallel = max { lr(|t|) , parallel u parallel_2 } . $

The coefficient vector of $r$ has $m$ nonzero entries, each equal to
$1 \/ m$, and therefore has Euclidean norm $1 \/ sqrt(m) lt.eq 1$. Hence
$r$ is $1$-Lipschitz in the outcome argument.

= Validity of the construction
<validity-of-the-construction>
#quote(block: true)[
#strong[Lemma 4 \(unique compatible outcome).] For every
$x = (x_0 , v) in A$ and $z in H$, the set $K_z (x)^(+)$ is the
singleton containing

$ y (x) = (1 , a (q) , b (q) , c (q)) , $

where $q = v \/ x_0$ and

$ a_i (q) = 1 / 2 q_i , #h(2em) b_(i j) (q) = 1 / 2 q_i q_j , #h(2em) c_(i j k) (q) = 1 / 2 q_i q_j q_k . $

In particular, $K_z (x)^(+)$ is independent of $z$.
]

#emph[Proof.] Since $z eq.not 0$, $x_0 eq.not 0$, and $y_0 = 1$ on $D$,
the equations $F (x , z , y) = 0$ can be solved recursively. The first
family gives

$ a_i = frac(v_i, 2 x_0) = 1 / 2 q_i . $

The second family gives

$ b_(i j) = v_i / x_0 a_j = 1 / 2 q_i q_j . $

The third family gives

$ c_(i j k) = v_i / x_0 b_(j k) = 1 / 2 q_i q_j q_k . $

Thus there is at most one compatible point in $D$. It remains to check
that this point belongs to $D$. If
$t = parallel q parallel_2 lt.eq 3 \/ 4$, then

$ parallel a parallel_2^2 = 1 / 4 t^2 , #h(2em) parallel b parallel_F^2 = 1 / 4 t^4 , #h(2em) parallel c parallel_F^2 = 1 / 4 t^6 . $

Consequently,

$ parallel a parallel_2^2 + parallel b parallel_F^2 + parallel c parallel_F^2 = 1 / 4 (t^2 + t^4 + t^6) lt.eq 4329 / 16384 < 1 . $

Therefore the recursively defined point lies in $D$, proving existence
and uniqueness. The scalar $z$ cancels from every equation, so the
singleton is independent of $z$. $square.stroked.tiny$

#quote(block: true)[
#strong[Lemma 5 \(surjectivity).] For every $x in A$ and $z in H$, the
linear operator

$ F_(x , z) : Y arrow.r W $

is onto.
]

#emph[Proof.] Fix a target $(alpha , beta , gamma) in W$ and set
$y_0 = 0$. Since $z x_0 eq.not 0$, solve recursively:

$ a_i = frac(alpha_i, z x_0) , $

$ b_(i j) = frac(beta_(i j) \/ z + v_i a_j, x_0) , $

$ c_(i j k) = frac(gamma_(i j k) \/ z + v_i b_(j k), x_0) . $

These choices satisfy $F (x , z , y) = (alpha , beta , gamma)$.
Equivalently, after ordering the variables as $a , b , c$, the relevant
matrix is block lower triangular with diagonal coefficient
$z x_0 eq.not 0$. Hence $F_(x , z)$ is onto. $square.stroked.tiny$

= The planning objective
<the-planning-objective>
#quote(block: true)[
#strong[Lemma 6 \(the lower value is the graph cubic).] For every
$x = (x_0 , v) in A$ and every $z in H$,

$ v_z (x) = frac(1, 2 m) p_G #h(-1em) (v / x_0) . $
]

#emph[Proof.] By Lemma 4, the compatible mean set is the singleton
$y (x)$. Evaluating the reward at this point gives

$ v_z (x) & = 1 / m sum_(k = 1)^m c_(i_k , j_k , n + k) (q)\
 & = 1 / m sum_(k = 1)^m 1 / 2 q_(i_k) q_(j_k) q_(n + k)\
 & = frac(1, 2 m) p_G (q) , $

where $q = v \/ x_0$. $square.stroked.tiny$

#quote(block: true)[
#strong[Proposition 7 \(optimal planning value).] For every $z in H$,

$ "OPT" (z) = frac(27, 128 m) max_(parallel h parallel_2 = 1) p_G (h) , $

and therefore

$ "OPT" (z)^2 = (frac(27, 128 m))^2 2 / 27 (1 - frac(1, omega (G))) . $
]

#emph[Proof.] By Lemma 3, $q = v \/ x_0$ ranges over the radius-$3 \/ 4$
ball. By Lemma 6 and homogeneity of $p_G$,

$ "OPT" (z) & = frac(1, 2 m) max_(parallel q parallel_2 lt.eq 3 \/ 4) p_G (q)\
 & = frac(1, 2 m) (3 / 4)^3 max_(parallel h parallel_2 = 1) p_G (h)\
 & = frac(27, 128 m) max_(parallel h parallel_2 = 1) p_G (h) . $

The squared identity follows from Lemma 2. $square.stroked.tiny$

= NP-hardness of planning
<np-hardness-of-planning>
For an integer $k$ with $2 lt.eq k lt.eq n$, define

$ V_k := frac(27, 128 m) sqrt(2 / 27) sqrt(1 - 1 / k) . $

If $omega (G) gt.eq k$, then $"OPT" (z) gt.eq V_k$. If
$omega (G) lt.eq k - 1$, then $"OPT" (z) lt.eq V_(k - 1)$. Moreover,

$ V_k - V_(k - 1) & gt.eq frac(27, 128 m) sqrt(2 / 27) frac(1, 2 k (k - 1))\
 & = Omega #h(-1em) (frac(1, m k^2)) . $

Since $m lt.eq n^2$ and $k lt.eq n$, this is inverse polynomial in the
graph size. A rational midpoint between sufficiently accurate rational
approximations to $V_k$ and $V_(k - 1)$ can be computed using
polynomially many bits.

#quote(block: true)[
#strong[Theorem 8 \(planning hardness).] An algorithm that computes
$"OPT" (z)$ for the constructed instances to additive accuracy

$ epsilon lt.eq 1 / 3 (V_k - V_(k - 1)) $

in time polynomial in the instance size and $log (1 \/ epsilon)$ would
decide CLIQUE in polynomial time. Hence known-model planning is NP-hard
to inverse-polynomial additive accuracy.
]

#emph[Proof.] Given $(G , k)$, construct the bandit instance and obtain
an approximation $hat(V)$ to $"OPT" (z)$. Compare $hat(V)$ with a
rational threshold lying strictly between $V_(k - 1)$ and $V_k$. The
approximation guarantee prevents the two cases $omega (G) lt.eq k - 1$
and $omega (G) gt.eq k$ from being confused.

The construction has dimension polynomial in $n + m$: in particular, the
third-order outcome block has $d^3$ coordinates. All coefficients are
rational with polynomial bit complexity. Thus the reduction is
polynomial time. $square.stroked.tiny$

= From low regret to efficient planning
<from-low-regret-to-efficient-planning>
The preceding hardness result is already present when the model is known
and deterministic. It therefore transfers directly to online learning.

Let

$ V^star.op := max_(x in A) v_z (x) . $

Run a learner for $T$ rounds against the deterministic nature policy
that returns the unique feasible outcome $y (x_t)$ after arm $x_t$ is
played. Let

$ hat(x) in arg max_(1 lt.eq t lt.eq T) v_z (x_t) $

be the best arm played by the learner. Pointwise,

$ V^star.op - v_z (hat(x)) & lt.eq 1 / T sum_(t = 1)^T #scale(x: 120%, y: 120%)[\(] V^star.op - v_z (x_t) #scale(x: 120%, y: 120%)[\)]\
 & = "Reg"_T / T . $

#quote(block: true)[
#strong[Lemma 9 \(low regret gives an approximate planner).] Suppose a
learner satisfies

$ bb(E) ["Reg"_T] lt.eq P (L) T^(1 - beta) $

for some fixed $beta > 0$ and polynomial $P$, where $L$ is the input
length. Then

$ bb(E) #h(-1em) [V^star.op - v_z (hat(x))] lt.eq P (L) T^(- beta) . $

In particular, by Markov’s inequality,

$ Pr #h(-1em) (V^star.op - v_z (hat(x)) > 3 P (L) T^(- beta)) lt.eq 1 / 3 . $
]

Choose

$ T gt.eq (frac(9 P (L), V_k - V_(k - 1)))^(1 \/ beta) . $

Because the gap is inverse polynomial and $beta$ is fixed, this horizon
is polynomial in the graph size. With probability at least $2 \/ 3$, the
best arm played has value accurate enough to distinguish the two clique
cases.

#quote(block: true)[
#strong[Theorem 10 \(learning hardness).] If a randomized
polynomial-time learner achieved

$ bb(E) ["Reg"_T] lt.eq "poly" (L) T^(1 - beta) $

for any fixed $beta > 0$ on every instance in the constructed class,
then CLIQUE would have a randomized polynomial-time algorithm and
therefore

$ "NP" subset.eq "BPP" . $

If the learner were deterministic, the same reduction would imply

$ "P" = "NP" . $
]

The reduction does not exploit exploration, observational noise,
uncertainty about $z$, or adversarial choice among multiple feasible
means. Every one of those features has been removed. The only
computational obstruction is optimization of the nonlinear arm-value
function induced by the trilinear constraints.

= Constant non-tangency
<constant-non-tangency>
Let

$ u (q) := (a (q) , b (q) , c (q)) $

be the nonconstant part of the unique feasible outcome. Lemma 4 gives

$ parallel u (q) parallel_2^2 lt.eq 4329 / 16384 . $

For the affine unit ball

$ D = { (1 , u) : parallel u parallel_2 lt.eq 1 } , $

the ball-slice bound for the sine parameter gives, for a singleton
affine slice at $(1 , u (q))$,

$ sin #h(-1em) (K_z (x)^(♭) , D) gt.eq sqrt(1 - parallel u (q) parallel_2^2) . $

Therefore the uniform non-tangency parameter satisfies

$ S & gt.eq sqrt(1 - 4329 / 16384)\
 & = sqrt(12055) / 128\
 & approx 0.858 . $

#quote(block: true)[
#strong[Proposition 11 \(hardness away from tangency).] The reduction
satisfies the uniform bound

$ S gt.eq sqrt(12055) / 128 > 0.85 . $

Hence the computational hardness is not caused by affine slices
approaching tangency with the outcome ball.
]

= Conclusion
<conclusion>
The reduction establishes the following computational message:

#quote(block: true)[
#strong[General trilinear constraints plus Euclidean balls already give
NP-hard known-model planning and NP-hard low-regret learning.]
]

The Euclidean geometry removes polyhedral or combinatorial
irregularities from the feasible sets, but it does not stop trilinear
constraints from lifting arm coordinates to degree-three monomials. This
is precisely the mechanism that disappears under the decomposable
restriction $F_0 (x , z) + F_1 (y , z)$.

The clean terminology is therefore

$ #box(stroke: black, inset: 3pt, [$ upright("learning is NP-hard under these restrictions") $]) , $

not that the online learning problem itself is NP-complete.

= References
<references>
+ Vanessa Kosoy. "Imprecise Multi-Armed Bandits: Representing
  Irreducible Uncertainty as a Zero-Sum Game." #emph[Journal of Machine
  Learning Research] 26 \(2025), 1–75.

+ Theodore S. Motzkin and Ernst G. Straus. "Maxima for Graphs and a New
  Proof of a Theorem of Turan." #emph[Canadian Journal of Mathematics]
  17 \(1965), 533–540.

+ Yurii Nesterov. "Squared Functional Systems and Optimization
  Problems." In #emph[High Performance Optimization];, Kluwer Academic
  Publishers, 2000, 405–440.

+ Etienne de Klerk. "The Complexity of Optimizing over a Simplex,
  Hypercube or Sphere: A Short Survey." #emph[Central European Journal
  of Operations Research] 16 \(2008), 111–125.

+ Christopher J. Hillar and Lek-Heng Lim. "Most Tensor Problems Are
  NP-Hard." #emph[Journal of the ACM] 60\(6) \(2013), Article 45.
