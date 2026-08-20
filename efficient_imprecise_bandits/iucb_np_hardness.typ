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
  font: "New Computer Modern",
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
  title: [Exact IUCB Optimism Is NP-Hard],
  date: "August 2026",
  abstract: [We construct a linear imprecise-bandit instance in which
the arm, outcome, and hypothesis sets are Euclidean balls, the reward is
linear, and the constraints decompose as a bilinear function of the arm
and hypothesis plus a bilinear function of the outcome and hypothesis.
Planning for every fixed hypothesis is polynomial-time by singular-value
decomposition, but the first global optimism problem solved by IUCB is
NP-hard. The reduction is from the spectral norm of an order-three
tensor.

],
  margin: (x: 1in, y: 0.9in),
  fontsize: 10.5pt,
  sectionnumbering: "1.1",
  cols: 1,
  doc,
)

#outline(
  title: auto,
  depth: 3
);

= Main theorem
<main-theorem>
Let

$ cal(T) in bb(Q)^(m times d_z times d_x) $

be a rational order-three tensor, viewed as the bilinear map

$ cal(T) : bb(R)^(d_z) times bb(R)^(d_x) arrow.r bb(R)^m , #h(2em) [cal(T) (u , x)]_i = sum_(j = 1)^(d_z) sum_(k = 1)^(d_x) T_(i j k) u_j x_k . $

Its spectral norm is

$ parallel cal(T) parallel_sigma := max_(parallel w parallel_2 lt.eq 1\
parallel u parallel_2 lt.eq 1\
parallel x parallel_2 lt.eq 1) lr(|w^tack.b cal(T) (u , x)|) . $

Because the maximizing vector $w$ can be chosen in the direction of
$cal(T) (u , x)$,

$ parallel cal(T) parallel_sigma = max_(parallel u parallel_2 lt.eq 1\
parallel x parallel_2 lt.eq 1) parallel cal(T) (u , x) parallel_2 . $

#quote(block: true)[
#strong[Theorem.] From any rational order-three tensor $cal(T)$, one can
construct in polynomial time a linear imprecise-bandit instance
satisfying all of the following:

+ The arm set $A$, outcome set $D$, and hypothesis set $H$ are Euclidean
  balls. As usual in the imprecise-bandit formalism, $D$ is an affine
  Euclidean ball contained in the outcome hyperplane $mu^(- 1) (1)$.
+ The reward is linear in $(x , y)$; in fact, it is independent of the
  meaningful arm coordinates.
+ On the outcome hyperplane, the constraints have the form
  $ F_0 (x , z) + F_1 (y , z) = 0 , $ where $F_0$ is bilinear in
  $(x , z)$ and $F_1$ is bilinear in $(y , z)$.
+ For every fixed hypothesis $z in H$, an optimal arm can be computed in
  polynomial time by an SVD.
+ Computing IUCB’s first optimistic value
  $ max_(z in H , thin x in A) "ME"_z [r divides x] $ is NP-hard.

The hardness occurs before any observations are collected, because IUCB
begins with confidence set $C_0 = H$.
]

The proof is a reduction from tensor spectral norm. Hillar and Lim prove
that computing this norm is NP-hard and that no FPTAS exists for it
unless $"P" = "NP"$.

= Intuition
<intuition>
Fixing the hypothesis $z$ fixes one input of the tensor. The map

$ x arrow.r.bar cal(T) (u , x) $

then becomes an ordinary matrix. Planning asks for the largest norm of
this matrix applied to a unit vector, and is therefore solved by a top
singular vector.

IUCB does something stronger. It jointly chooses the hypothesis
direction $u$ and the arm $x$. Its optimism problem becomes

$ max_(parallel u parallel_2 lt.eq 1 , thin parallel x parallel_2 lt.eq 1) parallel cal(T) (u , x) parallel_2 , $

which is the spectral norm of an order-three tensor. Thus the
computational jump is

$ upright("matrix spectral norm") quad arrow.r quad upright("tensor spectral norm") . $

The construction below embeds this objective into the lower prevision of
a linear imprecise bandit while preserving Euclidean-ball geometry.

= Construction
<construction>
== Rational scaling
<rational-scaling>
Let

$ L := 1 + sum_(i , j , k) lr(|T_(i j k)|) , #h(2em) alpha := frac(1, 2 L) . $

The number $L$ is rational and has polynomial encoding length. Moreover,

$ parallel cal(T) (u , x) parallel_2 lt.eq L $

whenever $parallel u parallel_2 lt.eq 1$ and
$parallel x parallel_2 lt.eq 1$.

== Arm space
<arm-space>
Take

$ A := { x in bb(R)^(d_x) : parallel x parallel_2 lt.eq 1 } . $

Thus $A$ is the ordinary unit Euclidean ball.

== Hypothesis space
<hypothesis-space>
Write a hypothesis as

$ z = (z_0 , u) in bb(R) times bb(R)^(d_z) $

and define

$ H := {(z_0 , u) : (z_0 - 5 / 3)^2 + parallel u parallel_2^2 lt.eq 1} . $

This is a full-dimensional Euclidean ball. Every point in $H$ satisfies

$ z_0 gt.eq 2 / 3 > 0 . $

The nonzero first coordinate makes the constraint operator onto and
allows division by $z_0$.

== Outcome space
<outcome-space>
Let

$ Y := bb(R)^(1 + m + 1) $

with coordinates $y = (y_0 , p , q)$, where $p in bb(R)^m$ and
$q in bb(R)$. Define

$ mu (y_0 , p , q) := y_0 $

and take the affine Euclidean unit ball

$ D := {(1 , p , q) : parallel p parallel_2^2 + q^2 lt.eq 1} . $

This is the standard notion of a Euclidean outcome ball in the
imprecise-bandit framework: it is a Euclidean ball inside the affine
hyperplane $mu^(- 1) (1)$.

== Additively decomposable constraints
<additively-decomposable-constraints>
On $D$, define

$ F_0 (x , (z_0 , u)) := - alpha cal(T) (u , x) $

and

$ F_1 ((1 , p , q) , (z_0 , u)) := z_0 p . $

The first map is bilinear in $(x , z)$ and the second is bilinear in
$(y , z)$. Hence the mean constraint is

$ F_0 (x , z) + F_1 (y , z) = 0 , $

or equivalently

$ z_0 p = alpha cal(T) (u , x) . $

To express the same constraint in the homogeneous notation used for
linear imprecise bandits, define

$ tilde(F) #scale(x: 120%, y: 120%)[\(] x , (z_0 , u) , (y_0 , p , q) #scale(x: 120%, y: 120%)[\)] := z_0 p - alpha y_0 cal(T) (u , x) . $

On the outcome hyperplane $y_0 = 1$, this is exactly the additive
constraint above. For fixed $x$ and $z$, the map

$ y arrow.r.bar tilde(F) (x , z , y) $

is linear. It is onto because $z_0 eq.not 0$: for any $a in bb(R)^m$,
choosing

$ y_0 = 0 , #h(2em) p = a / z_0 , #h(2em) q = 0 $

gives $tilde(F) (x , z , y) = a$.

The constraint fixes

$ p = alpha / z_0 cal(T) (u , x) . $

We will prove below that

$ frac(parallel u parallel_2, z_0) lt.eq 3 / 4 $

throughout $H$. Consequently,

$ parallel p parallel_2 lt.eq alpha 3 / 4 L < 3 / 8 , $

so the compatible mean set always intersects $D$.

== Linear reward
<linear-reward>
Define

$ r #scale(x: 120%, y: 120%)[\(] x , (y_0 , p , q) #scale(x: 120%, y: 120%)[\)] := frac(y_0 + q, 2) . $

This reward is linear in $y$ and independent of $x$. On $D$, it lies in
$[0 , 1]$. It also satisfies the usual Lipschitz normalization: the
absolute convex hull of $D$ has unit ball

$ [- 1 , 1] times B_2^(m + 1) , $

whose dual norm assigns value one to the displayed reward functional.

= Computing the lower value
<computing-the-lower-value>
Fix $z = (z_0 , u) in H$ and $x in A$. The constraint fixes $p$, while
$q$ is constrained by

$ q^2 lt.eq 1 - parallel p parallel_2^2 . $

Nature minimizes the linear reward by choosing

$ q_min = - sqrt(1 - parallel p parallel_2^2) . $

Therefore

$ v_z (x) & := "ME"_z [r divides x]\
 & = 1 / 2 (1 - sqrt(1 - alpha^2 / z_0^2 parallel cal(T) (u , x) parallel_2^2)) . $

Define

$ h (t) := 1 / 2 (1 - sqrt(1 - t^2)) , #h(2em) 0 lt.eq t < 1 . $

The function $h$ is strictly increasing. Hence maximizing $v_z (x)$ is
equivalent to maximizing

$ frac(parallel cal(T) (u , x) parallel_2, z_0) . $

= Lemma 1: fixed-hypothesis planning is polynomial-time
<lemma-1-fixed-hypothesis-planning-is-polynomial-time>
#quote(block: true)[
#strong[Lemma 1.] For every fixed hypothesis $z = (z_0 , u) in H$, an
optimal arm can be computed in polynomial time to any prescribed
inverse-polynomial accuracy.
]

== Intuition
<intuition-1>
Once $u$ is fixed, the tensor becomes a matrix in its remaining argument
$x$.

== Proof
<proof>
Fix $z$ and define the matrix

$ M_u in bb(R)^(m times d_x) $

by

$ M_u x := cal(T) (u , x) . $

Since $z_0$ is fixed, planning is equivalent to

$ max_(parallel x parallel_2 lt.eq 1) parallel M_u x parallel_2 = sigma_max (M_u) . $

An optimal arm is a top right singular vector of $M_u$. The matrix can
be formed in polynomial time, and a leading singular vector can be
computed to any inverse-polynomial accuracy in polynomial time. Thus
known-hypothesis planning is efficient. $square.stroked.tiny$

= Lemma 2: the hypothesis ball contributes exactly a factor of $3 \/ 4$
<lemma-2-the-hypothesis-ball-contributes-exactly-a-factor-of-34>
#quote(block: true)[
#strong[Lemma 2.] For the ball $H$ above,
$ max_((z_0 , u) in H) frac(parallel u parallel_2, z_0) = 3 / 4 . $
]

== Intuition
<intuition-2>
The center and radius of $H$ were chosen so that the largest slope from
the origin tangent to the ball is exactly $3 \/ 4$.

== Proof
<proof-1>
The definition of $H$ gives

$ parallel u parallel_2^2 lt.eq 1 - (z_0 - 5 / 3)^2 . $

A direct calculation yields

$ 1 - (z_0 - 5 / 3)^2 - 9 / 16 z_0^2 = - (15 z_0 - 16)^2 / 144 lt.eq 0 . $

Therefore

$ parallel u parallel_2^2 lt.eq 9 / 16 z_0^2 , $

so

$ frac(parallel u parallel_2, z_0) lt.eq 3 / 4 . $

Equality is attained at

$ z_0 = 16 / 15 , #h(2em) parallel u parallel_2 = 4 / 5 , $

because

$ (16 / 15 - 5 / 3)^2 + (4 / 5)^2 = (- 3 / 5)^2 + (4 / 5)^2 = 1 . $

Hence the maximum ratio is exactly $3 \/ 4$. $square.stroked.tiny$

= Lemma 3: IUCB optimism is tensor spectral norm
<lemma-3-iucb-optimism-is-tensor-spectral-norm>
#quote(block: true)[
#strong[Lemma 3.] The first IUCB optimistic value is
$ V_(upright(I U C B)) = h #h(-1em) (frac(3 alpha, 4) parallel cal(T) parallel_sigma) . $
]

== Intuition
<intuition-3>
IUCB jointly chooses the direction $u$ hidden inside the hypothesis and
the arm $x$. The remaining norm over the outcome direction is precisely
the third factor in the tensor spectral norm.

== Proof
<proof-2>
IUCB starts with $C_0 = H$ and solves

$ V_(upright(I U C B)) = max_(z in H , thin x in A) v_z (x) . $

Since $h$ is increasing,

$ V_(upright(I U C B)) = h #h(-1em) (alpha max_((z_0 , u) in H\
parallel x parallel_2 lt.eq 1) frac(parallel cal(T) (u , x) parallel_2, z_0)) . $

For a fixed direction $hat(u)$ and arm $x$, bilinearity gives

$ cal(T) (u , x) = parallel u parallel_2 cal(T) (hat(u) , x) . $

Lemma 2 therefore implies

$  & max_((z_0 , u) in H\
parallel x parallel_2 lt.eq 1) frac(parallel cal(T) (u , x) parallel_2, z_0)\
 & #h(2em) = 3 / 4 max_(parallel hat(u) parallel_2 lt.eq 1\
parallel x parallel_2 lt.eq 1) parallel cal(T) (hat(u) , x) parallel_2\
 & #h(2em) = 3 / 4 parallel cal(T) parallel_sigma . $

Substituting proves the claim. $square.stroked.tiny$

= Completing the NP-hardness proof
<completing-the-np-hardness-proof>
Lemma 3 gives the explicit identity

$ V_(upright(I U C B)) = 1 / 2 (1 - sqrt(1 - frac(9 alpha^2, 16) parallel cal(T) parallel_sigma^2)) . $

This transformation is known, strictly increasing, and invertible. In
particular,

$ parallel cal(T) parallel_sigma = frac(4, 3 alpha) sqrt(1 - (1 - 2 V_(upright(I U C B)))^2) . $

Thus an algorithm that computes the exact first IUCB optimistic value
would compute the spectral norm of an arbitrary rational order-three
tensor. Tensor spectral norm is NP-hard, so exact IUCB optimism is
NP-hard. This proves the theorem.

= Hardness when the implementation outputs only an arm
<hardness-when-the-implementation-outputs-only-an-arm>
The conclusion does not require an IUCB implementation to print the
optimistic value or hypothesis. Suppose it outputs only a globally
optimal arm $x^star.op$.

For this fixed arm, define the matrix

$ N_x : bb(R)^(d_z) arrow.r bb(R)^m , #h(2em) N_x u := cal(T) (u , x) . $

The same calculation gives

$ max_(z in H) v_z (x) = h #h(-1em) (frac(3 alpha, 4) sigma_max (N_x)) . $

Consequently, after receiving $x^star.op$, one ordinary SVD computes

$ max_(z in H) v_z (x^star.op) = max_(z in H , thin x in A) v_z (x) = V_(upright(I U C B)) . $

The inverse formula above then recovers
$parallel cal(T) parallel_sigma$. Hence producing a globally optimal
IUCB arm is NP-hard as well.

= Approximation hardness
<approximation-hardness>
The reduction also rules out an FPTAS for the optimism problem unless
$"P" = "NP"$.

Suppose an algorithm returned a lower approximation $hat(V)$ satisfying

$ (1 - epsilon) V_(upright(I U C B)) lt.eq hat(V) lt.eq V_(upright(I U C B)) . $

For $0 lt.eq V < 1 \/ 2$, the inverse of $h$ is

$ h^(- 1) (V) = 2 sqrt(V (1 - V)) . $

Let

$ t := frac(3 alpha, 4) parallel cal(T) parallel_sigma , #h(2em) hat(t) := 2 sqrt(hat(V) (1 - hat(V))) . $

Since $hat(V) lt.eq V_(upright(I U C B))$,

$ hat(t) / t & = sqrt(frac(hat(V) (1 - hat(V)), V_(upright(I U C B)) (1 - V_(upright(I U C B)))))\
 & gt.eq sqrt(1 - epsilon) . $

Thus an FPTAS for $V_(upright(I U C B))$ would give an FPTAS for tensor
spectral norm after a polynomial rescaling of the requested accuracy.
Hillar and Lim prove that no such FPTAS exists unless $"P" = "NP"$.

This does not rule out every coarse heuristic or local optimizer. It
shows that the global optimism guarantee used by literal IUCB cannot, in
general, be supplied by a generic polynomial-time exact or fully
polynomial approximation procedure.

= Why this does not make learning NP-hard
<why-this-does-not-make-learning-np-hard>
The reduction separates #emph[IUCB implementation] from #emph[learning];.
Under the true hypothesis

$ z^star.op = (z_0^star.op , u^star.op) , $

the constrained mean of the observable $p$ coordinate is

$ bb(E) [p divides x] = alpha / z_0^star.op cal(T) (u^star.op , x) . $

This is a linear map of the arm $x$. By repeatedly playing basis arms, a
learner can estimate the columns of the actual matrix

$ M^star.op x := alpha / z_0^star.op cal(T) (u^star.op , x) , $

and then compute a top singular vector of $M^star.op$.

IUCB instead searches simultaneously over every still-possible $u$ and
every arm $x$, thereby solving the tensor problem. A different learner
estimates the single matrix that actually governs the environment.
Therefore the reduction proves the sharper statement

$ #box(stroke: black, inset: 3pt, [$ upright("fixed-model planning is easy, learning can be easy, but literal IUCB optimism is NP-hard.") $]) $

= References
<references>
+ Christopher J. Hillar and Lek-Heng Lim. "Most Tensor Problems Are
  NP-Hard." #emph[Journal of the ACM] 60\(6), Article 45, 2013. Theorems
  1.8 and 1.9 establish NP-hardness of tensor spectral norm and
  inverse-polynomial relative approximation hardness.

+ Vanessa Kosoy. "Imprecise Multi-Armed Bandits: Representing
  Irreducible Uncertainty as a Zero-Sum Game." #emph[Journal of Machine
  Learning Research] 26, 2025. Algorithm 1 initializes $C_0 = H$ and
  selects an optimistic hypothesis by maximizing the lower prevision
  over the current confidence set; the paper explicitly leaves
  computational complexity open.
