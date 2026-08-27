#import "@preview/cetz:0.5.2"

#set page(
  paper: "us-letter",
  margin: (x: 1.1in, top: 0.9in, bottom: 0.9in),
  fill: white,
  numbering: "1",
  number-align: center + bottom,
)
#set text(font: "New Computer Modern", size: 10pt, fill: black)
#show math.equation: set text(font: "New Computer Modern Math")
#set par(
  justify: true,
  leading: 0.55em,
  spacing: 0.55em,
  first-line-indent: 1.5em,
)
#set heading(numbering: "1.")
#show heading.where(level: 1): set text(size: 14pt, weight: "bold")
#show heading.where(level: 1): set block(above: 1.5em, below: 0.7em)
#set math.equation(numbering: none)
#set list(indent: 1.5em, body-indent: 0.5em)
#set enum(indent: 1.5em, body-indent: 0.5em)

#let thm(it) = block(width: 100%, above: 0.8em, below: 0.8em)[
  #set par(first-line-indent: 0em)
  #set align(left)
  #set text(style: "italic")
  #show strong: set text(style: "normal")
  #strong[
    #it.supplement #context it.counter.display(it.numbering)#if it.caption != none [ (#it.caption.body)].
  ] #it.body
]

#show figure.where(kind: "theorem"): thm
#show figure.where(kind: "lemma"): thm
#show figure.where(kind: "problem"): thm

#let theorem(body, title: none) = figure(
  body,
  caption: title,
  kind: "theorem",
  supplement: [Theorem],
  numbering: "1",
  outlined: false,
)

#let lemma(body) = figure(
  body,
  kind: "lemma",
  supplement: [Lemma],
  numbering: "1",
  outlined: false,
)

#let problem(body, title: none) = figure(
  body,
  caption: title,
  kind: "problem",
  supplement: [Problem],
  numbering: "1",
  outlined: false,
)

#let alg(it) = block(
  width: 100%,
  above: 0.9em,
  below: 0.9em,
  stroke: (top: 0.6pt, bottom: 0.6pt),
  inset: (y: 0.5em),
)[
  #set par(first-line-indent: 0em)
  #set align(left)
  #strong[
    #it.supplement #context it.counter.display(it.numbering)#if it.caption != none [: #it.caption.body].
  ]
  #v(0.35em)
  #it.body
]

#show figure.where(kind: "algorithm"): alg

#let algorithm(body, title: none) = figure(
  body,
  caption: title,
  kind: "algorithm",
  supplement: [Algorithm],
  numbering: "1",
  outlined: false,
)

#let note(body) = block(width: 100%, above: 0.7em, below: 0.7em)[
  #set par(first-line-indent: 0em)
  #body
]

#let opdist = math.op("dist")
#let opspan = math.op("span")
#let opker = math.op("ker")
#let optr = math.op("tr")
#let opdet = math.op("det")
#let opcol = math.op("col")
#let opdiag = math.op("diag")
#let opargmax = math.op("argmax")
#let opargmin = math.op("argmin")
#let poly = math.op("poly")
#let Pr = math.op("Pr")

#set document(
  title: [When are Imprecise Bandits Computationally Tractable?],
  author: ("Vinayak Pathak",),
)

#align(center)[
  #set par(first-line-indent: 0em)
  #text(size: 18pt, weight: "bold")[When are Imprecise Bandits Computationally Tractable?]
  #v(0.65em)
  #text(size: 11pt)[Vinayak Pathak]
]

#v(1.25em)

= Setting

Let $A subset.eq RR^(d_A)$ be the arm set and let
$D subset.eq RR^(d_D)$ be the outcome set. We assume that $A$ and $D$ are
Euclidean balls of radii $R_A$ and $R_D$ (not necessarily centred at the origin).
An element $x in A$ is called an *arm*, while an element $y in D$ is a
possible sampled outcome. The reward is affine in the arm and outcome:

$ r(x,y) := a^T x + b^T y + c. $

Let $Z subset.eq RR^(d_Z)$ denote the hypothesis set, and let
$z^star in Z$ be the unknown true hypothesis. For every $z in Z$ and $x in A$, define

#set math.equation(numbering: "(1)")
$ K_z (x) := {y in D : C_z y + B_z x + d_z = 0}. $ <eq:setting-compatible-set>
#set math.equation(numbering: none)

Here $B_z$, $C_z$, and $d_z$ of are $z$-dependent matrices and vectors of appropriate dimensions.

For arm $x$, $K_z (x)$ denotes the set of outcomes that an adversary is allowed to pick as the expected value of its distribution. The true feasible outcome set is $K^star (x) := K_(z^star) (x)$.

We assume throughout that $K^star (x)$ is nonempty for every $x in A$.

Let $N:=opker C_(z^star)$.

#lemma[
  There exists an affine map $f_z: A -> RR^(d_D)$ and a linear subspace $N_z$ independent of $x$ such that

  $ f_z (x)+N_z
      ={y in RR^(d_D):C_(z)y+B_(z)x+d_(z)=0},
      quad x in A. $

  Consequently, there exists an $f$ and $N$ such that

  $ K^star (x)=(f(x)+N) inter D, quad x in A. $
] <lem:noiseless-affine-spaces>

*Proof.* Fix $x$ and let $y_1, y_2 in K_z (x)$. Then $C_z (y_1 - y_2) = 0$, which means $y_1-y_2$ must lie in a subspace determined by $z$. We can pick some $y in K_z (x)$ arbitrarily and set $f_z (x) = y$. This is clearly an affine mapping. $qed$

Note that as the proof demonstrates, $f_z$ need not be unique. Indeed, for each $z$ there can be multiple $f_z$'s that satisfy the requirement of the lemma. However, each $z$ determines a unique $N_z$.

We also assume a uniform non-tangency condition: there is a constant
$S in (0,1]$ such that, for every $x in A$ and every
$p in RR^(d_D)$ satisfying
$C_(z^star)p+B_(z^star)x+d_(z^star)=0$ with $p in.not D$,

$ opdist(p,D) >= S opdist(p,K^star (x)). $

For a Euclidean ball, this says that the affine solution spaces defined by
the true constraints remain uniformly bounded away from tangency to $D$.
This is the transversality condition used in @kosoy2025imprecise.

The interaction proceeds for rounds $t=1,dots,T$. Let
$cal(F)_(t-1)$ denote the history before round $t$. The learner chooses an
arm $x_t in A$. Nature may then choose, adaptively as a function of the
history and $x_t$, any distribution supported on $D$ whose conditional mean

$ m_t := E[y_t | cal(F)_(t-1), x_t] $

belongs to $K^star (x_t)$. An outcome $y_t$ is sampled from this distribution,
the learner observes $y_t$, and receives reward $r(x_t,y_t)$.

The robust value of an arm and the optimal robust value are

$ v^star (x) := min_(y in K^star (x)) r(x,y), quad
  V^star := max_(x in A) v^star (x). $

The regret over horizon $T$ is

$ R_T := T V^star - sum_(t=1)^T r(x_t,y_t). $

Finally, let

$ C_r := max_(x in A, y in D) r(x,y) - min_(x in A, y in D) r(x,y) $

denote the reward range.

An *instance of a linear imprecise-bandit problem* in the additive model
considered here is a finite binary encoding $cal(I)$ of the dimensions
$d_A,d_D,d_Z$ and the constraint dimension $d_W$; rational centres and radii
specifying the balls $A$ and $D$; a compact semialgebraic hypothesis set $Z$
given by rational polynomial equalities and inequalities; rational reward
coefficients $a,b,c$; and rational coefficient arrays specifying

$ B_z:=B_0+sum_(j=1)^(d_Z) z_j B_j, quad
  C_z:=C_0+sum_(j=1)^(d_Z) z_j C_j, quad
  d_z:=d_0+sum_(j=1)^(d_Z) z_j d_j. $

Here $B_j in RR^(d_W times d_A)$, $C_j in RR^(d_W times d_D)$, and
$d_j in RR^(d_W)$. This affine dependence on $z$ is the additive-bilinear
model considered in this paper, and gives the family $z mapsto K_z (x)$ in
@eq:setting-compatible-set a finite rational description. Write $L$ for the
bit length of $cal(I)$. A *valid realization* of $cal(I)$ is a pair
$(z^star,S)$ such that $z^star in Z$, $S in (0,1]$, every
$K_(z^star) (x)$ is nonempty, and the non-tangency condition above holds with
constant $S$. Neither $z^star$ nor $S$ is part of the input given to the
learner.

For $t>=1$, let the observed history before round $t$ be

$ h_(t-1):=((x_1,y_1),dots,(x_(t-1),y_(t-1))). $

A horizon-aware randomized *policy* is a single probabilistic interactive
algorithm $pi$. Equivalently, for a private random tape $omega$ independent of
nature's randomization, its action on round $t$ has the form

$ x_t=pi_t (cal(I),1^T,h_(t-1);omega) in A. $

Thus its public input before round $t$ is exactly the instance encoding, the
unary encoding $1^T$ of the known horizon, and the observed history
$h_(t-1)$. The policy is not given $z^star$, $S$, the conditional means
$m_s$, or nature's conditional distributions. Since $r$ is known, the rewards
in previous rounds are determined by $h_(t-1)$ and need not be supplied
separately.

A *nature policy* $nu$ is a sequence of probability kernels
$nu_t (dot | h_(t-1),x)$ supported on $D$. It is compatible with $z^star$ if
the mean of $nu_t (dot | h_(t-1),x)$ belongs to $K_(z^star) (x)$ for every
$t$, history $h_(t-1)$, and arm $x in A$. Conditional on $h_(t-1)$ and $x_t$,
the outcome $y_t$ is sampled from $nu_t (dot | h_(t-1),x_t)$.

We measure computation in the arithmetic and weak-optimization model used
below, in which the coordinates of the observed outcomes are real inputs. A
policy is *polynomial-time* if one fixed polynomial in $L$ and $T$ bounds its
total running time through round $T$, including the cost and requested
accuracy of its weak-optimization calls. Since the horizon is encoded as
$1^T$, this is polynomial in the length of the public input and observed
transcript. The finite-precision implementation is given in the computational
tractability subsection.

#problem[
  Find a polynomial-time policy $pi$, a fixed constant $epsilon>0$, and a
  fixed polynomial $P$ such that, for every instance $cal(I)$, every horizon
  $T>=1$, every valid realization $(z^star,S)$, and every adaptive nature
  policy $nu$ compatible with $z^star$,

  $ E_(pi,nu)[R_T]
    <=P(d_A,d_D,L,R_A,R_D,norm(b)_2,C_r,S^(-1)) T^(1-epsilon). $

  The expectation is over the private randomization of $pi$ and the outcomes
  sampled by $nu$.
] <prob:additive-ball-learning>

#theorem(title: [efficient $T^(2/3)$ learning])[
  There is a horizon-aware policy for @prob:additive-ball-learning whose
  arithmetic and weak-optimization running time is polynomial in $T$ and the
  input bit length and which, for every true hypothesis satisfying the uniform
  non-tangency condition and every compatible adaptive nature policy,
  satisfies

  $ E[R_T] <= tilde(O)(
      P(d_A,d_D,R_A,R_D,norm(b)_2,C_r,S^(-1)) T^(2/3)), $

  where $P$ is a fixed polynomial. Apart from the uniform non-tangency
  condition on the true feasible sets, no geometric property of $Z$ is used.
] <thm:efficient-upper-bound>

Since every fixed polylogarithmic factor is $O(T^(1/12))$, this theorem solves
@prob:additive-ball-learning with, for example, $epsilon=1/4$.

= Warmup: Noiseless Setting

In this section, playing an arm $x$ reveals an exact feasible response
$y in K^star (x)$; there is no sampling noise. However, there still is the Knightian uncertainty corresponding to the adversary picking an arbitrary outcome inside $K^star (x)$.

#lemma[
  Suppose that, for every arm $x in A$, we have identified a nonempty set
  $K'(x) subset.eq K^star (x)$, and suppose that whenever the learner plays
  $x$, nature chooses an outcome in $K'(x)$. Define

  $ v'(x) := min_(y in K'(x)) r(x,y), $

  and choose

  $ x' in opargmax_(x in A) v'(x). $

  Then playing $x'$ on every round incurs nonpositive regret with
  respect to the original robust benchmark, i.e. $R_T <= 0$.
] <lem:inner-feasible-set>

#lemma[
  There exist $d_A+1$ arms $x^((0)),dots,x^((d_A)) in A$ such that, from any
  possible sequence of responses
  $y^((i)) in K^star (x^((i)))$, we can compute an affine map $hat(f)$ such that
  $ K^star (x) = (hat(f)(x) + N) inter D, quad x in A. $
] <lem:noiseless-anchor-identification>

*Proof.* Let $f$ be any affine map supplied by
@lem:noiseless-affine-spaces. Let $x^((0)), dots, x^((d_A))$ be any affine
basis of $A$. Play them in sequence and let
$y^((0)),dots, y^((d_A))$ be the corresponding outcomes chosen by the
adversary. Let $hat(f)$ be the unique affine interpolator for which
$hat(f)(x^((i))) = y^((i))$ for all $i$. Since
$y^((i)) in K^star (x^((i)))$, we have that
$hat(f)(x^((i)))+N = f(x^((i)))+N$ for all $i$. Since the $x^((i))$ form an
affine basis, $hat(f)(x)+N = f(x)+N$ for all $x in A$.
 $qed$

#algorithm(title: [Noiseless imprecise bandit])[
  #set enum(numbering: "1.", indent: 1.5em, body-indent: 0.55em)

  + Play the $d_A+1$ arms from @lem:noiseless-anchor-identification and use
    their responses to construct $hat(f)$.

  + Initialize $N_(d_A+2) := {0}$.

  + For each round $t=d_A+2,dots,T$:
    - For every $x in A$, define the provisional feasible set
      $ K'_t (x) := (hat(f)(x)+N_t) inter D. $

    - If $K'_t (x)=emptyset$ for some $x in A$, choose any such arm as
      $x_t$. Otherwise, choose
      $ x_t in opargmax_(x in A) min_(y in K'_t (x)) r(x,y). $

    - Play $x_t$ and observe $y_t$.

    - If $y_t-hat(f)(x_t) in.not N_t$, set
      $ N_(t+1) := opspan(N_t union {y_t-hat(f)(x_t)}). $
      Otherwise, set $N_(t+1):=N_t$.
] <alg:noiseless-subspace-learning>

Every $N_t$ maintained by @alg:noiseless-subspace-learning is a subspace of
$N$. Whenever it is updated, its dimension increases by one. Moreover, if a
provisional feasible set is empty, playing an arm with an empty provisional
set necessarily triggers such an update. There can therefore be at most
$dim(N) <= d_D$ update rounds.

On every remaining round, all the provisional feasible sets are nonempty and
the observed response belongs to $K'_t (x_t)$. Hence
@lem:inner-feasible-set shows that the reward on that round is at least the
original robust benchmark. Charging at most a constant regret to each of the
$d_A+1$ initial rounds and to each update round gives $R_T <= O(d_A+d_D). $

== Computational Tractability

All the steps in @alg:noiseless-subspace-learning can be carried out in
polynomial time. First, affine interpolation can be done via Gaussian elimination.

The subspace $N_t$ can be stored through an orthonormal basis. Given the new
residual

$ h_t:=y_t-hat(f)(x_t), $

project $h_t$ onto $N_t^perp$. If the projection is zero, the span does not
change. Otherwise, normalize the projection and append it to the stored
basis. This is an incremental Gram--Schmidt and takes
polynomial time.

It remains to compute the arm in the planning step.

#lemma[
  Fix a round $t$. Given rational descriptions of $A,D,hat(f)$, and $N_t$,
  one can compute, in polynomially many arithmetic operations, an arm
  $x_("emp") in A$ such that, if $K'_t (x)=emptyset$ for some $x in A$,
  then $K'_t (x_("emp"))=emptyset$.
] <lem:polynomial-empty-set>

*Proof.* Clearly, for a given $x$, the set $K'_t (x)$ is empty if and only if the distance between $c_D$ and $hat(f)(x) + N_t$ is bigger than $R_D$. Thus to decide if there exists an $x in A$ for which $K'_t (x)$ is empty, we need to find the arm that maximizes the distance between $c_D$ and $hat(f)(x) + N_t$. To see why this can be done in polynomial time, let $q_t (x)$ be the point in $hat(f)(x) + N_t$ that is closest to $c_D$. Note that $q_t (x)$ can be written as an affine function.

$ q_t (x):=c_D+(I-P_t)(hat(f)(x)-c_D). $

Here $P_t$ is the projection on $N_t$.

#figure(
  align(center, cetz.canvas({
    import cetz.draw: *

    // The outcome set D.
    circle(
      (0, 0),
      radius: 2,
      fill: rgb("#eaf2fb"),
      stroke: (paint: rgb("#3b6ea8"), thickness: 0.9pt),
    )
    content((-1.45, -1.25), [$D$])

    // The affine line through the fitted outcome in direction N_t.
    line(
      (-2.55, 1.05),
      (3.2, 1.05),
      stroke: (paint: rgb("#555555"), thickness: 1pt),
    )
    content((-2.35, 1.32), [$hat(f)(x)+N_t$], anchor: "south-west")

    // The perpendicular from c_D to the affine line.
    line(
      (0, 0),
      (0, 1.05),
      stroke: (paint: rgb("#777777"), thickness: 0.8pt, dash: "dashed"),
    )
    line(
      (0, 0.87),
      (0.18, 0.87),
      (0.18, 1.05),
      stroke: (paint: rgb("#777777"), thickness: 0.7pt),
    )

    // The centre, its projection, and the fitted outcome.
    circle((0, 0), radius: 0.065, fill: black, stroke: none)
    content((-0.12, -0.14), [$c_D$], anchor: "north-east")

    circle((0, 1.05), radius: 0.075, fill: rgb("#2468a2"), stroke: none)
    content((0.12, 1.2), [$q_t (x)$], anchor: "south-west")

    circle((2.7, 1.05), radius: 0.075, fill: rgb("#b23a48"), stroke: none)
    content((2.7, 1.2), [$hat(f)(x)$], anchor: "south")
  })),
  caption: [Two-dimensional outcome geometry when $N_t$ is one-dimensional.
    The dashed segment is orthogonal to $hat(f)(x)+N_t$, so its endpoint is
    $q_t (x)$, the point on that line closest to $c_D$.],
) <fig:q-projection>

Now we need to compute

$ x_("emp") in opargmax_(x in A) norm(q_t (x)-c_D)_2^2. $

This is a quadratic optimization problem over the Euclidean ball $A$, which is polynomial-time solvable using the result in @more1983computing. $qed$

#lemma[
  Fix a round $t$ and suppose that $K'_t (x)$ is nonempty for every $x in A$.
  Let the rational problem data have total bit length $L$. For every
  $epsilon in (0,1)$, one can compute an arm $x_epsilon in A$ in time
  $poly(L,log(1/epsilon))$ such that

  $ min_(y in K'_t (x_epsilon)) r(x_epsilon,y)
    >= max_(x in A) min_(y in K'_t (x)) r(x,y)-epsilon. $
] <lem:polynomial-robust-planning>

*Proof.* Compute the orthogonal projector $P_t$ onto $N_t$ as in the proof of
@lem:polynomial-empty-set, and define

$ q_t (x):=c_D+(I-P_t)(hat(f)(x)-c_D). $

Since every provisional set is nonempty, Pythagoras' theorem gives

$ K'_t (x)=q_t (x)+
    {u in N_t: norm(u)_2 <=
      sqrt(R_D^2-norm(q_t (x)-c_D)_2^2)}. $

Put $beta_t:=norm(P_t b)_2$. For a fixed arm $x$, minimizing the linear
reward over the displayed ball moves in direction $-P_t b$, and hence

$ v'_t (x):=min_(y in K'_t (x)) r(x,y)
  =a^T x+b^T q_t (x)+c
    -beta_t sqrt(R_D^2-norm(q_t (x)-c_D)_2^2). $

Introduce a scalar $s>=0$. Maximizing $v'_t$ is equivalent to the QCQP

$ max_(x,s) a^T x+b^T q_t (x)+c-beta_t s $

subject to

$ norm(x-c_A)_2^2<=R_A^2, quad
  s^2+norm(q_t (x)-c_D)_2^2=R_D^2, quad s>=0, $

where $c_A$ is the centre of $A$. Represent the equality by two quadratic
inequalities. If $R_A,R_D>0$, add the redundant constraint

$ norm(x-c_A)_2^2/R_A^2+s^2/R_D^2<=2. $

This is an ellipsoid in the joint variable $(x,s)$. Thus the QCQP has a fixed
number of quadratic constraints, one of which is ellipsoidal. Bienstock's
theorem @bienstock2016cdt returns, in time polynomial in $L$ and $log(1/delta)$, a solution $(x^star,s^star)$ such that for each constraint $g_i (x,s)<= 0$, we have that $g_i (x^star, s^star) <= delta$, and the value of the objective function $Phi_t (x,s):=a^T x+b^T q_t (x)+c-beta_t s$ at $(x^star, s^star)$ is $delta$-close to the optimal, i.e., for every feasible $(x,s)$, $Phi_t (x^star,s^star)>=Phi_t (x,s)-delta$.

The output $x^star$ of Bienstock's algorithm may not be a feasible arm. But to obtain a feasible arm, we can simply project
$x^star$ onto $A$ to obtain $x_epsilon$. It is easy to see that this does not change the value of the objective function too much. Indeed, set $s_epsilon:=sqrt(R_D^2-norm(q_t (x_epsilon)-c_D)_2^2).$
The projection moves
$x^star$ by $O(sqrt(delta))$, and thus moves $s^star$ by at most
$O(delta^(1/4))$. Consequently the linear objective
changes by at most $C delta^(1/4)$, where $C>=1$ is a constant. Choose
$delta<=(epsilon/(2C))^4$. The resulting arm is feasible and its robust value is within
$epsilon$ of the optimum. Since
$log(1/delta)=poly(L)+O(log(1/epsilon))$, the running time is polynomial. $qed$

Set $epsilon=T^(-2)$ in @lem:polynomial-robust-planning. On each round, the
computed arm then loses at most $T^(-2)$ relative to the exact planning
solution, so approximate planning contributes at most $T^(-1)$ to total
regret.

= Noisy Setting

In this section, constants hidden by $O$ and $tilde(O)$ may depend on the
fixed problem parameters. In addition, $tilde(O)$ suppresses logarithmic
factors in $T$ and $1/delta$.

In the noisy setting, estimating the true $N$ is tricky. To reduce the level of
noise, we can work with with average outcomes over blocks of length $n$ instead
of each individual outcome. Suppose $m_i$ is the conditional mean corresponding
to the outcome $y_i$. Then over a block of size $n$, we can bound
$norm(1/n sum y_i - 1/n sum m_i) <= O(n^(-1/2))$ with high probability. Due to
the convexity of $D$, $1/n sum m_i$ also lies in $D$, and therefore, the
"residuals" calculated using $overline(y) = 1/n sum y_i$ should be close to the
true residuals. However, it is still risky to compute the subspace containing
this residual and committing to it for the future steps. A small error in the
direction of the calculated subspace can lead to large errors further out. Thus
to get better control over the estimation errors, we approximate the subspace
$N$ with an ellipsoid. We start by computing an approximate $hat(f)$ using an
affine basis, and assume that $N$ is a unit ball of radius $lambda$ where
$lambda <= O(n^(-1/2))$. Then if a residual arrives that lies outside the
current ellipsoid, we expand the ellipsoid in a specific way along the direction
of the residual.

#lemma[
  Fix $delta in (0,1)$ and $1<=n<=T$. There exist $d_A+1$ affinely
  independent anchor arms such that, after playing each arm for $n$ rounds
  and interpolating their empirical average outcomes, the resulting affine
  map $hat(f)$ satisfies the following with probability at least $1-delta$.
  There is an affine map $f$ and a linear subspace $N$ such that
  $K^star (x)=(f(x)+N) inter D$ and

  $ sup_(x in A) norm(hat(f)(x)-f(x))_2
    <= tilde(O)(n^(-1/2)). $
] <lem:noisy-anchor-interpolation>

*Proof.* Let $x^((0)),dots,x^((d_A))$ be any affine basis of $A$. Play each
arm for $n$ rounds. Let $overline(y)^((i))$ be the average observed outcome
for arm $i$, and let $overline(m)^((i))$ be the corresponding average conditional mean. Since
$K^star (x^((i)))$ is convex, $overline(m)^((i)) in K^star (x^((i)))$.
Let $hat(f)$ and $f$ be the unique affine interpolators satisfying
$hat(f) (x^((i)))=overline(y)^((i))$ and
$f(x^((i)))=overline(m)^((i))$ for every $i$. By
@lem:noiseless-anchor-identification,
$K^star (x)=(f(x)+N) inter D$ for every $x in A$.

Within each block, $y_t-m_t$ is a martingale-difference sequence. Since $D$
is bounded, the Azuma--Hoeffding inequality for bounded martingale
differences (see @hoeffding1963probability @azuma1967weighted), together with
a union bound over the finitely many anchors and outcome coordinates, implies
that, with probability at least $1-delta$,

$ max_(0 <= i <= d_A)
    norm(overline(y)^((i))-overline(m)^((i)))_2
  <=tilde(O)(n^(-1/2)). $

Now consider an arbitrary $x in A$, and let
$alpha_0,dots,alpha_(d_A)$ be its affine coordinates with respect to the
chosen basis. Since $A$ is compact, there is a constant $L$, independent of
$x$, such that

$ sum_(i=0)^(d_A) abs(alpha_i)<=L. $

Since $hat(f)$ and $f$ are affine and agree with the corresponding values at
the anchors,

$ norm(hat(f) (x)-f(x))_2
  <=sum_(i=0)^(d_A) abs(alpha_i)
    norm(overline(y)^((i))-overline(m)^((i)))_2
  <=L tilde(O)(n^(-1/2)). $

Taking the supremum over $x in A$ proves the result. $qed$

In the noisy setting, taking the span of the observed residuals is unstable:
even a small amount of noise can introduce a spurious direction. We therefore
replace the subspace $N_t$ by a learned residual ellipsoid.

Fix $delta in (0,1)$ and $1<=n<=T$, and let $hat(f)$ and $f$ be as in
@lem:noisy-anchor-interpolation. One can choose
$lambda=tilde(O)(n^(-1/2))$ with $lambda>=n^(-1/2)$ so that, conditional on
the anchor conclusion, the conclusions of the following two lemmas hold
simultaneously throughout the horizon with probability at least $1-delta$.

#algorithm(title: [Noisy imprecise bandit $(n,lambda)$])[
  #set enum(numbering: "1.", indent: 1.5em, body-indent: 0.55em)

  *Parameters:* block length $n in NN$ and ridge parameter $lambda>0$.

  + Choose the $d_A+1$ anchor arms from
    @lem:noisy-anchor-interpolation. Play each anchor for $n$ consecutive
    rounds, compute its empirical average $overline(y)^((i))$, and construct
    the affine interpolant $hat(f)$. If the horizon ends during this phase,
    stop.

  + Initialize $M:=0$ and let $hat(G)_0$ be the matrix with no columns.

  + At the beginning of each subsequent block, define

    $ V_M:=lambda^2 I_(d_D)+hat(G)_M hat(G)_M^T
        in RR^(d_D times d_D), quad
      cal(E)_M:={u in RR^(d_D):u^T V_M^(-1)u<=1}. $

    For every arm $x in A$, define

    $ hat(K)_M (x):=(hat(f)(x)+cal(E)_M) inter D. $

  + If $hat(K)_M (x)=emptyset$ for some $x in A$, choose any such arm.
    Otherwise, choose

    $ x in opargmax_(x' in A)
        min_(y in hat(K)_M (x')) r(x',y). $

  + Play the chosen arm for $n$ rounds. If fewer than $n$ rounds remain, play
    until the horizon and stop without updating. Otherwise, let $overline(y)$
    be the block-average outcome and set

    $ hat(g):=overline(y)-hat(f)(x). $

  + If $hat(g) in.not cal(E)_M$, declare the block informative, set
    $hat(G)_(M+1):=[hat(G)_M,hat(g)]$, and then increase $M$ by one. Otherwise
    leave $hat(G)_M$ and $M$ unchanged. Return to Step 3 and continue until
    time $T$.
] <alg:noisy-ridge-learning>

#lemma[
  At most $O(log T)$ blocks of @alg:noisy-ridge-learning are informative.
] <lem:ridge-informative-blocks>

*Proof.* Enumerate the stored residuals as
$hat(g)_1,dots,hat(g)_M$. After $j$ of them have been stored,

$ V_j:=lambda^2 I_(d_D)
    +sum_(i=1)^j hat(g)_i hat(g)_i^T. $

Every block average lies in $D$. The anchor averages also lie in $D$, and
affine interpolation from the fixed anchors has uniformly bounded
coefficients on the compact set $A$. Hence
$norm(hat(g)_j)_2=O(1)$ for every block.

When $hat(g)_j$ is stored, the block is informative, so

$ hat(g)_j^T V_(j-1)^(-1)hat(g)_j>1. $

The matrix determinant lemma @bernstein2009matrix therefore gives

$ opdet(V_j)
    =opdet(V_(j-1))
      (1+hat(g)_j^T V_(j-1)^(-1)hat(g)_j)
    >2opdet(V_(j-1)). $

Since $V_0=lambda^2 I_(d_D)$, iteration yields

$ opdet(V_M)>2^M lambda^(2d_D). $

On the other hand, $M<=T/n$, and therefore

$ optr(V_M)
    =d_D lambda^2+sum_(j=1)^M norm(hat(g)_j)_2^2
    <=d_D lambda^2+O(T/n). $

Applying the arithmetic--geometric mean inequality to the eigenvalues of
$V_M$ gives

$ opdet(V_M)<= (lambda^2+O(T/n))^(d_D). $

Combining the two determinant bounds,

$ M<=d_D log_2 (1+O(T/(n lambda^2)))=O(log T), $

where the last equality uses $lambda>=n^(-1/2)$. $qed$

#lemma[
  Let $hat(f)$ be the empirical affine interpolant constructed during the
  anchor phase of @alg:noisy-ridge-learning, and let $f$ be the affine
  interpolant of the corresponding average conditional means, as in
  @lem:noisy-anchor-interpolation. For every current ellipsoid $cal(E)_M$,
  every $x in A$, and every $u in cal(E)_M$,

  $ opdist(hat(f)(x)+u,f(x)+N) <= tilde(O)(n^(-1/2)). $
] <lem:ridge-residual-learning>

*Proof.* We prove by induction on $M$.

We first show that this bound holds for the initial matrix
$V_0=lambda^2 I_(d_D)$, and then show that it remains true after every update
from $V_M$ to $V_(M+1)$.

For the initial matrix $V_0=lambda^2 I_(d_D)$, the ellipsoid $cal(E)_0$ is
the Euclidean ball of radius $lambda$. By @lem:noisy-anchor-interpolation,
there exists some $beta_n<=tilde(O)(n^(-1/2))$ such that
$norm(hat(f)(x)-f(x))_2<=beta_n$ for every $x in A$. Therefore, by the
triangle inequality, for every $x in A$ and $u in cal(E)_0$,

$ opdist(hat(f)(x)+u,f(x)+N)
    <=norm(hat(f)(x)-f(x))_2+norm(u)_2
    <=beta_n+lambda <= tilde(O)(n^(-1/2)). $

Thus the claimed bound holds when $M=0$.

Geometrically, $hat(f)(x)+cal(E)_0$ is a ball of radius $lambda$ centred at
$hat(f)(x)$, while $f(x)+N$ is the affine space that we want this ball to
remain close to. Each informative update adds a new generating direction
$hat(g)$ to the ellipsoid. The component of $hat(g)$ lying in $N$ only moves
the ellipsoid parallel to $f(x)+N$ and therefore does not increase the
distance from that affine space. Only the component orthogonal to $N$ matters.
Thus, if $hat(g)$ is within $eta_n$ of $N$, one update can increase the
distance by at most $eta_n$. An uninformative block does not change the
ellipsoid at all.

To make this precise, consider a complete block $cal(B)$ at arm $x$ and let

$ overline(m):=1/n sum_(t in cal(B)) m_t. $

Since $overline(m) in K^star (x)$, the vector
$g:=overline(m)-f(x)$ belongs to $N$. The empirical residual is
$hat(g):=overline(y)-hat(f)(x)$. Conditionally on the history at the beginning
of any adaptively selected block, the vectors $y_t-m_t$ remain martingale
differences. The same concentration argument as in
@lem:noisy-anchor-interpolation, followed by a union bound over the at most
$T/n$ complete blocks, therefore gives, simultaneously for every block,

$ norm(overline(y)-overline(m))_2<=tilde(O)(n^(-1/2)). $

Combining this with the uniform anchor-interpolation bound gives

$ norm(hat(g)-g)_2<=tilde(O)(n^(-1/2)). $

We may therefore choose $eta_n=tilde(O)(n^(-1/2))$ so that every stored
residual satisfies $opdist(hat(g),N)<=eta_n$. We prove the following more
explicit form of the induction claim:

$ opdist(hat(f)(x)+u,f(x)+N)
    <=beta_n+lambda+M eta_n, quad
  x in A, u in cal(E)_M. $

The base case above establishes this claim when $M=0$.

Now consider an update from $V_M$ to $V_(M+1)$. Suppose that the bound holds
for $M$ and that the informative block producing the update has residual
$hat(g)$. Let $Q_M:=[hat(G)_M,lambda I_(d_D)]$. Since
$Q_M Q_M^T=V_M$ and $Q_M$ has full row rank,

$ cal(E)_M={Q_M theta:norm(theta)_2<=1}. $

After storing $hat(g)$, every $u in cal(E)_(M+1)$ can therefore be written as

$ u=Q_M theta+a hat(g), quad norm(theta)_2^2+a^2<=1. $

Set $u_0:=Q_M theta$. Then $u_0 in cal(E)_M$, and since $N$ is a linear
subspace, for every $x in A$,

$ opdist(hat(f)(x)+u,f(x)+N)
    <=opdist(hat(f)(x)+u_0,f(x)+N)
      +abs(a)opdist(hat(g),N)
    <=beta_n+lambda+(M+1)eta_n. $

This proves the induction claim. By @lem:ridge-informative-blocks,
$M=O(log T)$, and therefore

$ beta_n+lambda+M eta_n=tilde(O)(n^(-1/2)). $

#h(1fr) $qed$

#lemma[
  Under the uniform non-tangency condition, for every $x in A$ and every
  $y in RR^(d_D)$,

  $ opdist(y,K^star (x))
      <=(1+S^(-1))opdist(y,f(x)+N)+S^(-1)opdist(y,D). $

  In particular, if $y in D$, then

  $ opdist(y,K^star (x))
      <=(1+S^(-1))opdist(y,f(x)+N). $
] <lem:noisy-ball-stability>

*Proof.* Let $p$ be the Euclidean projection of $y$ onto $f(x)+N$. If
$p in D$, then $p in K^star (x)$ and the result is immediate. Otherwise, the
uniform non-tangency condition and the triangle inequality give

$ opdist(p,K^star (x))
    <=S^(-1)opdist(p,D)
    <=S^(-1) (norm(y-p)_2+opdist(y,D)). $

Since $norm(y-p)_2=opdist(y,f(x)+N)$, one more application of the triangle
inequality proves the first claim. The second follows by setting
$opdist(y,D)=0$. $qed$

#lemma[
  Suppose that the conclusions of @lem:noisy-anchor-interpolation and
  @lem:ridge-residual-learning hold. Let $cal(B)$ be a complete $n$-round
  block that is declared uninformative, and let $x$ be the arm played in that
  block. Then its realized average regret satisfies

  $ 1/n sum_(t in cal(B)) (V^star-r(x,y_t))
      <= tilde(O)(n^(-1/2)). $
] <lem:noisy-uninformative-block>

*Proof.* Let $M$ be the state at the start of the block and let

$ overline(y):=1/n sum_(t in cal(B)) y_t. $

Since the block is uninformative,
$hat(g):=overline(y)-hat(f)(x)$ belongs to $cal(E)_M$.

Since $D$ is convex, $overline(y) in D$. Therefore,

$ overline(y) in (hat(f)(x)+cal(E)_M) inter D=hat(K)_M (x). $

In particular, this block could not have been selected by the empty-set
branch of Step 4, so its arm was selected by the planning rule. Define

$ hat(v)_M (x'):=min_(y in hat(K)_M (x')) r(x',y). $

For every $x' in A$ and $y in hat(K)_M (x')$,
@lem:ridge-residual-learning gives

$ opdist(y,f(x')+N)<=tilde(O)(n^(-1/2)). $

Since $y in D$, applying @lem:noisy-ball-stability gives

$ opdist(y,K^star (x'))
    <=tilde(O)(n^(-1/2)). $

Since the reward is Lipschitz in its outcome argument,

$ hat(v)_M (x')
    >=v^star (x')-tilde(O)(n^(-1/2)). $

Let $x^star$ maximize $v^star$. The planning rule and the fact that
$overline(y) in hat(K)_M (x)$ now give

$ r(x,overline(y))
    >=hat(v)_M (x)
    >=hat(v)_M (x^star)
    >=V^star-tilde(O)(n^(-1/2)). $

Finally, the reward is affine in the outcome and the arm is fixed throughout
the block, so

$ r(x,overline(y))=1/n sum_(t in cal(B)) r(x,y_t). $

This proves the average-regret bound.  $qed$

Taking $delta=(T+1)^(-2)$, $n=ceil(T^(2/3))$, and $lambda$ chosen as above
now gives the claimed regret rate. The anchor
phase, the $O(log T)$ informative blocks from
@lem:ridge-informative-blocks, and the final partial block contribute
$tilde(O)(n)$ regret. By
@lem:noisy-uninformative-block, all remaining rounds contribute
$tilde(O)(T n^(-1/2))$. Hence, when the anchor conclusion and the joint
ridge conclusion both hold,

$ R_T<=tilde(O)(n+T n^(-1/2))=tilde(O)(T^(2/3)). $

These conclusions fail with probability at most $2(T+1)^(-2)$, and
$R_T<=C_r T$ always, so taking expectations only adds $O(C_r/T)$.

== Computational Tractability

The statistical argument above presents @alg:noisy-ridge-learning using
exact emptiness tests and exact maximization over the single provisional set
$hat(K)_M (x)$. We now explain how to implement these operations with weak
finite-precision optimization. The additional sets introduced in this
section provide numerical slack only; they do not change the statistical
idea.

The matrix updates, leverage calculations, and affine interpolation are
standard polynomial-time linear algebra. Moreover,
$V_M-lambda^2 I_(d_D)$ is positive semidefinite, while
$lambda>=T^(-1/2)$ and the stored residuals have bounded norm. Hence all
inversions can be carried out to the required inverse-polynomial precision in
polynomial time. For this implementation, one may choose the centre
$c_A$ of $A$ and the arms $c_A+R_A e_i$, $i=1,dots,d_A$, as the affine
basis. Their interpolation coefficients and the resulting affine map are
computed by Gaussian elimination and matrix multiplication, with
polynomially controlled bit complexity. This conditioning detail is
irrelevant to the dependence on $n$ and was therefore omitted from the
statistical argument.

=== Empty-Fiber Certification

Fix $rho:=lambda$, let $c_D$ be the centre of $D$, and define

$ D_1:={y:norm(y-c_D)_2<=R_D+rho}, quad
  D_2:={y:norm(y-c_D)_2<=R_D+2rho}, $

$ hat(K)_M^("in") (x):=(hat(f)(x)+2cal(E)_M) inter D_1, quad
  hat(K)_M^("out") (x):=(hat(f)(x)+3cal(E)_M) inter D_2. $

The implementation tests the inner sets for emptiness and plans against the
outer sets. The exact set used in the statistical proof satisfies

$ hat(K)_M (x) subset.eq hat(K)_M^("in") (x)
    subset.eq hat(K)_M^("out") (x). $

The constants $2$ and $3$ are not important. Their role, together with the
two expanded outcome balls, is to create a strict margin between the set
containing an uninformative empirical outcome and the set used for planning.

Write $hat(f)(x)=F x+f_0$. For a fixed arm, the distance between
$hat(f)(x)+2cal(E)_M$ and $D_1$ is

$ d_M (x):=max_(norm(u)_2<=1) (
    u^T (hat(f)(x)-c_D)
    -2sqrt(u^T V_M u)
    -(R_D+rho)norm(u)_2
  ). $

This is the support-function formula for the distance between two closed
convex sets. In particular, $d_M (x)>0$ exactly when
$hat(K)_M^("in") (x)=emptyset$.

After introducing nonnegative variables $s_0,s_1$ satisfying

$ u^T V_M u<=s_0^2, quad norm(u)_2^2<=s_1^2, $

maximizing $d_M (x)$ jointly over $x in A$ and $norm(u)_2<=1$ becomes a QCQP
with a fixed number of quadratic constraints. The only coupling between the
arm and dual variables is the bilinear expression $u^T F x$. We impose the
explicit bounds $norm(u)_2<=1$, $0<=s_1<=1$, and
$0<=s_0<=sqrt(lambda_(max) (V_M))$, together with the ball constraint on $x$,
and combine them into a redundant positive-definite enclosing ellipsoid.
The weak fixed-constraint result in @app:qcqp then applies.

A weakly feasible output is corrected before it is used as a certificate:
project its $x$ and $u$ components onto their respective balls, reset
$s_0,s_1$ to the corresponding exact norms, and directly evaluate the
support-function objective. Since all variables are polynomially bounded,
using sufficiently smaller internal accuracy makes the change in objective
at most $zeta$. The corrected point is feasible, so a positive value is a
genuine certificate of emptiness.

Exact emptiness classification is unnecessary. Let
$zeta<min(rho,lambda)/10$ and solve the preceding maximization to additive
accuracy $zeta$. If an arm has certified distance greater than $2zeta$, its
inner set is genuinely empty. Otherwise every inner pair of constituent sets
is at distance at most $3zeta$. The corresponding outer intersection then
contains a Euclidean ball of radius at least

$ min(lambda,rho-3zeta). $

Indeed, the positive semidefiniteness of $V_M-lambda^2 I_(d_D)$ implies that
$cal(E)_M$ contains the Euclidean ball of radius $lambda$. The gap from
$2cal(E)_M$ to $3cal(E)_M$ therefore supplies the ellipsoid margin,
while the gap from $D_1$ to $D_2$ supplies the outcome-ball margin.

=== Robust Planning

The preceding strict-feasibility margin also makes robust planning tractable.
Fenchel--Rockafellar duality gives the following dual representation (see
@boyd2004convex):

$ min_(y in hat(K)_M^("out") (x)) r(x,y)
  =a^T x+c+b^T c_D+max_(u in RR^(d_D)) (
      u^T (hat(f)(x)-c_D)
      -3sqrt(u^T V_M u)
      -(R_D+2rho)norm(b-u)_2
    ). $

The interior ball bounds the norm of an optimal dual vector by a polynomial
in the input size, $T$, and
$min(lambda,rho-3zeta)^(-1)$. Introducing epigraph variables for the two
square roots therefore turns the joint maximization over $x$ and $u$ into a
bounded QCQP with a fixed number of quadratic constraints.
@app:qcqp[Appendix] gives an additive-$zeta_v$ optimal arm in polynomial time. As in
the emptiness problem, a weakly feasible solution is projected onto the arm
ball and its epigraph variables are conservatively increased. The resulting
loss is absorbed into $zeta_v$.

=== Finite-Precision Comparisons

The remaining comparisons use the same kind of gray zone. Let $tilde(y)$
denote the rounded block average used by the implementation, and choose the
rounding precision $tau$ so that
$norm(tilde(y)-overline(y))_2<=tau<=rho$. Define the residual used in the
leverage test to be $hat(g):=tilde(y)-hat(f)(x)$. Since
$overline(y) in D$, the expanded ball $D_1$ absorbs the rounding error and
$tilde(y) in D_1$.

Let $ell:=hat(g)^T V_M^(-1)hat(g)$ and compute an approximation
$tilde(ell)$ satisfying $abs(tilde(ell)-ell)<=gamma/2$. Append the residual
only if $tilde(ell)-gamma/2>1$. Such an update has $ell>1$ and therefore
retains the determinant-doubling argument in
@lem:ridge-informative-blocks. Otherwise $ell<=1+gamma$, so, for
$gamma<=1$,

$ hat(g) in sqrt(1+gamma)cal(E)_M subset.eq 2cal(E)_M. $

Finally, the proof of @lem:ridge-residual-learning is unchanged when
$cal(E)_M$ is multiplied by any fixed constant. Thus points in the outer
ellipsoid remain $tilde(O)(n^(-1/2))$-close to $f(x)+N$, while points in
$D_2$ are at distance at most $2rho$ from $D$. Applying
@lem:noisy-ball-stability shows that every point in an outer fiber is
$tilde(O)(n^(-1/2))$-close to the corresponding true feasible set.

It remains to connect this numerical wrapper to the statistical proof. If a
complete block is not appended, its rounded residual lies in
$2cal(E)_M$, and therefore

$ tilde(y) in hat(K)_M^("in") (x)
    subset.eq hat(K)_M^("out") (x). $

Consequently, a complete block selected using a certified empty inner fiber
must be appended; otherwise the displayed membership would contradict
emptiness. Every complete block that is not appended is therefore a planning
block. For such a block, define

$ hat(v)_M^("out") (x')
    :=min_(y in hat(K)_M^("out") (x')) r(x',y). $

The preceding outer-fiber bound and the Lipschitz property of the reward give,
uniformly in $x'$,

$ hat(v)_M^("out") (x')
    >=v^star (x')-tilde(O)(n^(-1/2)). $

If the weak planner returns an additive-$zeta_v$ maximizer and $x^star$
maximizes $v^star$, then

$ r(x,overline(y))
  >=r(x,tilde(y))-norm(b)_2 tau
  >=hat(v)_M^("out") (x)-norm(b)_2 tau
  >=hat(v)_M^("out") (x^star)-zeta_v-norm(b)_2 tau
  >=V^star-tilde(O)(n^(-1/2))-zeta_v-norm(b)_2 tau. $

Affineness again identifies $r(x,overline(y))$ with the realized average
reward in the block. Thus certified empty-fiber blocks and leverage updates
are charged to the same $O(log T)$ informative blocks as before, while every
other complete block has average regret at most
$tilde(O)(n^(-1/2))+zeta_v+norm(b)_2 tau$.

Taking $rho=lambda=tilde(O)(n^(-1/2))$ and choosing, for example,
$zeta=(T+1)^(-8)$, $gamma=(T+1)^(-8)$,
$zeta_v=(T+1)^(-3)$, and $tau=(T+1)^(-12)$ makes every
numerical error negligible or absorbs it into the existing
$tilde(O)(n^(-1/2))$ bound. These choices require only $O(log T)$ additional
precision bits, and the planning error contributes at most $T zeta_v$ to
regret. Hence the weak bit-model implementation remains polynomial-time and
has the same regret rate.

= NP-hardness

In this section we show that several natural variations of
@prob:additive-ball-learning are NP-hard. Thus in some sense, the problem is
the hardest problem that's still tractable.

We first show that efficient planning can be reduced to efficient learning.
Most proofs below show that planning is already NP-hard. Due to the reduction
from planning to learning, this shows that learning is also NP-hard.

#lemma[
  Fix a rational imprecise-bandit instance of bit length $L$ and a hypothesis
  $z$ such that $K_z (x)$ is nonempty for every $x in A$, and write

  $ v_z (x):=min_(y in K_z (x)) r(x,y), quad
    V_z:=max_(x in A) v_z (x). $

  Suppose that, for every rational arm $x$ produced by the learner, one can
  compute an exact rational outcome

  $ y_z (x) in opargmin_(y in K_z (x)) r(x,y) $

  in time polynomial in $L$ and the encoding length of $x$. Suppose also
  that, for some fixed $beta>0$ and polynomial $P$, a polynomial-time learner
  guarantees

  $ E[R_T]<=P(L) T^(1-beta) $

  against every compatible nature policy. Then, for every $epsilon in (0,1)$,
  one can compute in time $poly(L,1/epsilon)$ an arm $hat(x)$ and its value
  $hat(V):=v_z (hat(x))$ such that

  $ Pr(0<=V_z-hat(V)<=epsilon)>=2/3. $

  If the learner is deterministic, the resulting planner satisfies
  $0<=V_z-hat(V)<=epsilon$ with certainty.
] <lem:planning-from-learning>

*Proof.* Run the learner for

$ T:=ceil((3P(L)/epsilon)^(1/beta)) $

rounds with true hypothesis $z$, and let nature put a point mass on
$y_z (x_t)$ after each arm $x_t$. Choose

$ hat(t) in opargmax_(t=1,dots,T) v_z (x_t) $

and return $hat(x):=x_(hat(t))$ and $hat(V):=v_z (hat(x))$.

Since nature always returns a minimizing outcome,

$ 0<=V_z-hat(V)
  <=1/T sum_(t=1)^T (V_z-v_z (x_t))
  =R_T/T. $

Consequently,

$ E[V_z-hat(V)]<=P(L) T^(-beta)<=epsilon/3. $

Markov's inequality gives the claimed probability. The horizon and the
simulation time are polynomial in $L$ and $1/epsilon$ because $beta$ is
fixed. If the learner is deterministic, then the simulation is deterministic
and the displayed bound holds without taking an expectation. $qed$

== D = simplex, A = ball, F = F0 + F1

We first replace the Euclidean outcome ball in @prob:additive-ball-learning
by a simplex. Even known-hypothesis planning then becomes NP-hard.

#theorem[
  There is a polynomial-time reduction from MAX-CUT to rational
  imprecise-bandit instances for which $A$ is a Euclidean unit ball, $D$ is
  a simplex, $Z=[1,2]$, the maps $F_0$ and $F_1$ are bilinear, and the reward
  is linear and takes values in $[0,1]$. Every $K_z (x)$ is nonempty, and
  every $z in Z$ induces the same model.

  For these instances, approximating the known-hypothesis value

  $ V_z:=max_(x in A) min_(y in K_z (x)) r(x,y) $

  to inverse-polynomial additive accuracy is NP-hard. Consequently, if, for
  some fixed $beta>0$, a randomized polynomial-time learner guaranteed

  $ E[R_T]<=P(L) T^(1-beta) $

  on every such instance, where $L$ is the input bit length and $P$ is a
  polynomial, then $"NP" subset.eq "BPP"$. For a deterministic learner, the
  same conclusion would be $"P"="NP"$.
] <thm:additive-simplex-np-hardness>

*Proof.* We reduce from MAX-CUT @garey1979computers. Let $G=(V,E)$ have
$n$ vertices and $m>=1$ edges. Orient the edges arbitrarily, let
$B_G in RR^(m times n)$ be the resulting edge-vertex incidence matrix, and
put

$ gamma:=1/(2m n), quad
  A:={x in RR^m:norm(x)_2<=1}, quad Z:=[1,2]. $

Write an outcome as $y=(p,q,s) in RR^n times RR^n times RR$ and take

$ D:={(p,q,s):p_i>=0, q_i>=0 " for " i=1,dots,n,
      s>=0, sum_(i=1)^n (p_i+q_i)+s=1}. $

With $W=RR^n$, define

$ F_0 (x,z):=-gamma z B_G^T x, quad
  F_1 ((p,q,s),z):=z(p-q), $

and

$ r(x,(p,q,s)):=sum_(i=1)^n (p_i+q_i). $

Both constraint maps are bilinear, and the reward lies in $[0,1]$ on $D$.
Since $z!=0$, compatibility is equivalent to

$ p-q=gamma B_G^T x, $

so it is independent of $z$.

The incidence matrix has $norm(B_G)_F=sqrt(2m)$. Hence every $x in A$
satisfies

$ norm(B_G^T x)_1
  <=sqrt(n) norm(B_G^T x)_2
  <=sqrt(n) norm(B_G)_F norm(x)_2
  <=sqrt(2m n). $

For $t:=gamma B_G^T x$, it follows that $norm(t)_1<=1$. The choice

$ p_i:=max(t_i,0), quad q_i:=max(-t_i,0), quad
  s:=1-norm(t)_1 $

therefore belongs to $D$ and satisfies $p-q=t$, proving that every
$K_z (x)$ is nonempty.

For any compatible $(p,q,s)$, nonnegativity gives
$p_i+q_i>=abs(p_i-q_i)=abs(t_i)$. The preceding positive-negative
decomposition attains equality in every coordinate, and therefore

$ v_z (x):=min_(y in K_z (x)) r(x,y)
    =gamma norm(B_G^T x)_1. $

By duality of the $ell_1$ and $ell_oo$ norms,

$ norm(B_G^T x)_1
  =max_(sigma in {-1,1}^n) sigma^T B_G^T x. $

Consequently,

$ max_(x in A) norm(B_G^T x)_1
  =max_(sigma in {-1,1}^n) norm(B_G sigma)_2. $

For a sign vector $sigma$ and an edge $e={i,j}$, the corresponding
coordinate satisfies

$ (B_G sigma)_e^2=(sigma_i-sigma_j)^2
  =cases(4 & "if " sigma_i!=sigma_j, 0 & "otherwise"). $

Thus $norm(B_G sigma)_2^2$ is four times the size of the cut encoded by
$sigma$. If $M_G$ denotes the maximum cut size, then

$ V_z=2gamma sqrt(M_G). $

The values corresponding to consecutive cut sizes satisfy, for
$k=1,dots,m$,

$ 2gamma (sqrt(k)-sqrt(k-1))
  =2gamma/(sqrt(k)+sqrt(k-1))
  >=gamma/m. $

The tolerance $gamma/(3m)$ is inverse-polynomial in the encoding length.
Approximating the candidate values $2gamma sqrt(k)$ to polynomially many
bits, an estimate of $V_z$ within this tolerance identifies $M_G$. This
proves the planning claim.

The positive-negative decomposition displayed above is an exact rational
minimizing outcome and is computable in polynomial time from every rational
arm. Applying @lem:planning-from-learning with $epsilon=gamma/(3m)$
therefore supplies, with probability at least $2/3$, the estimate used in the
preceding paragraph. This would place MAX-CUT in $"BPP"$ and hence imply
$"NP" subset.eq "BPP"$. For a deterministic learner, the estimate is
deterministic and gives $"P"="NP"$. $qed$

== D = ball, A = polytope, F = F0 + F1

We now keep the Euclidean outcome ball and the additive bilinear constraint,
but allow the arm set to be a polytope given by rational inequalities. Even
the cube, which has only $2n$ such inequalities but $2^n$ vertices, makes
known-hypothesis planning NP-hard.

#theorem[
  There is a polynomial-time reduction from MAX-CUT to rational
  imprecise-bandit instances for which $A=[-1,1]^n$, represented by $2n$
  inequalities, $D$ is a Euclidean unit ball, $Z=[1,2]$, the maps $F_0$ and
  $F_1$ are bilinear, and the reward is linear. Every $K_z (x)$ is nonempty,
  every $z in Z$ induces the same model, and the uniform non-tangency condition
  holds with an absolute constant.

  For these instances, approximating the known-hypothesis value

  $ V_z:=max_(x in A) min_(y in K_z (x)) r(x,y) $

  to inverse-polynomial additive accuracy is NP-hard. Consequently, if, for
  some fixed $beta>0$, a randomized polynomial-time learner guaranteed

  $ E[R_T]<=P(L) T^(1-beta) $

  on every such instance, where $L$ is the input bit length and $P$ is a
  polynomial, then $"NP" subset.eq "BPP"$. For a deterministic learner, the
  same conclusion would be $"P"="NP"$.
] <thm:additive-polytope-np-hardness>

*Proof.* We again reduce from MAX-CUT. Let $G=(V,E)$ have $n$ vertices and
$m>=1$ edges. Orient the edges arbitrarily and let
$B_G in RR^(m times n)$ be the edge-vertex incidence matrix, so that

$ (B_G x)_e=x_i-x_j $

for an edge $e={i,j}$. Put

$ epsilon:=1/(4m), quad A:=[-1,1]^n, quad Z:=[1,2]. $

Write outcomes as $y=(u,s) in RR^m times RR$ and take

$ D:={(u,s):norm(u)_2^2+s^2<=1}. $

With $W=RR^m$, define

$ F_0 (x,z):=-epsilon z B_G x, quad F_1 ((u,s),z):=z u, $

and let $r(x,(u,s)):=s$. Both constraint maps are bilinear and the reward is
linear. Since $z!=0$, compatibility is equivalent to

$ u=epsilon B_G x, $

and is therefore independent of $z$. Moreover, every $x in A$ satisfies

$ norm(B_G x)_2^2
    =sum_({i,j} in E) (x_i-x_j)^2
    <=4m, $

so

$ norm(epsilon B_G x)_2^2<=1/(4m)<=1/4. $

Thus every compatible fiber is nonempty. Minimizing $s$ over that fiber gives

$ v_z (x)=-sqrt(1-epsilon^2 norm(B_G x)_2^2). $

Set $q(x):=norm(B_G x)_2^2$. With every coordinate except $x_i$ fixed,
$q(x)$ is a convex quadratic in $x_i$, so replacing $x_i$ by one of the
endpoints of $[-1,1]$ does not decrease $q$. Applying this replacement one
coordinate at a time produces a sign vector $sigma in {-1,1}^n$ with
$q(sigma)>=q(x)$. At a sign vector,

$ q(sigma)
    =sum_({i,j} in E) (sigma_i-sigma_j)^2
    =4 thin lr(|"cut" (sigma)|). $

Consequently,

$ max_(x in [-1,1]^n) q(x)=4 "MaxCut" (G). $

The displayed robust value is strictly increasing in $q(x)$. If the maximum
cut has size $k$, the planning value is therefore

$ V_k=-sqrt(1-k/(4m^2)). $

For $k=1,dots,m$, consecutive possible values satisfy

$ V_k-V_(k-1)
  =frac(1/(4m^2),
      sqrt(1-(k-1)/(4m^2))+sqrt(1-k/(4m^2)))
  >=1/(8m^2). $

Hence an estimate of $V_z$ within

$ Delta:=1/(32m^2) $

identifies $k$ after the $m+1$ candidate values are computed to polynomially
many bits. This proves the planning claim.

We next derive the learning consequence. The exact minimizing outcome
displayed above need not be rational, so we use a rational feasible
approximation rather than invoke @lem:planning-from-learning. Suppose the
claimed learner exists and set

$ eta:=Delta/6, quad
  T:=ceil((6P(L)/Delta)^(1/beta)). $

In the weak bit model the learner outputs rationally encoded arms. For each
played arm $x_t$, rational binary search for a square root computes $a_t$ in
polynomial time such that

$ 0<=sqrt(1-epsilon^2 q(x_t))-a_t<=eta, quad
  a_t^2<=1-epsilon^2 q(x_t). $

Let nature return the point

$ y_t:=(epsilon B_G x_t,-a_t). $

This is a rational point of $K_z (x_t)$, and its reward satisfies

$ 0<=r(x_t,y_t)-v_z (x_t)<=eta. $

Writing $V_z=V_k$ and

$ S_T:=sum_(t=1)^T (V_z-v_z (x_t)), $

we therefore have

$ S_T<=R_T+T eta. $

Taking expectations under the learner's randomization gives

$ E[S_T]<=P(L) T^(1-beta)+T eta. $

If the learner never plays a $Delta$-optimal arm, then $S_T>Delta T$.
Markov's inequality and the choices of $T$ and $eta$ imply

$ Pr("no " Delta "-optimal arm is played")
  <=P(L)/(Delta T^beta)+eta/Delta
  <=1/3. $

Select a played arm maximizing the rational quantity $q(x_t)$ and round its
coordinates to endpoints without decreasing $q$. With probability at least
$2/3$, the resulting sign vector has robust value at least $V_k-Delta$. A cut
of size at most $k-1$ would instead have robust value at most
$V_(k-1)<=V_k-1/(8m^2)<V_k-Delta$. The rounded sign vector therefore encodes
a maximum cut. The horizon, the square-root approximations, and the rounding
all have polynomial bit complexity, proving $"NP" subset.eq "BPP"$. If the
learner is deterministic, the same argument succeeds with certainty and gives
$"P"="NP"$.

It remains to verify non-tangency. For a fixed $x$, put

$ a:=norm(epsilon B_G x)_2, quad rho:=sqrt(1-a^2)>=sqrt(3)/2. $

The ambient affine solution space and its intersection with $D$ are

$ L_z (x)={(epsilon B_G x,s):s in RR}, quad
  K_z (x)={(epsilon B_G x,s):abs(s)<=rho}. $

If $p=(epsilon B_G x,s) in L_z (x)$ lies outside $D$ and $t:=abs(s)>rho$,
then

$ opdist(p,K_z (x))=t-rho, quad
  opdist(p,D)=sqrt(a^2+t^2)-1. $

Factoring the second expression gives

$ frac(opdist(p,D),opdist(p,K_z (x)))
  =frac(t+rho,sqrt(a^2+t^2)+1)
  >=rho
  >=sqrt(3)/2. $

Indeed, after clearing the positive denominator, subtracting $rho$, and
squaring, the first inequality is equivalent to
$(1-rho^2)(t^2-rho^2)>=0$. Thus the uniform non-tangency condition holds with
$S=sqrt(3)/2$. $qed$

== D = ball, A = ball, F = trilinear

In this subsection, we retain the Euclidean arm and outcome balls from
@prob:additive-ball-learning but drop the additive restriction and allow a
general trilinear constraint map. It is convenient to use
the homogeneous outcome formulation. Thus, if $Y$ is the ambient outcome
space, $W$ is the constraint space, and

$ F:RR^(d_A) times RR^(d_Z) times Y -> W $

is linear in each argument separately, define

$ L_z (x):=opker F_(x,z), quad
  K_z (x):=L_z (x) inter D, quad
  v_z (x):=min_(y in K_z (x)) r(x,y), quad
  V_z:=max_(x in A) v_z (x). $

Here $D$ is a Euclidean ball in the affine normalization hyperplane, hence a
Euclidean ball in its affine hull. The construction below shows that allowing
the coefficients of the outcome constraint to depend on the arm makes even
known-hypothesis planning hard.

Let $G=(V,E)$ be an undirected graph with $V={1,dots,n}$ and
$E={e_1,dots,e_m}$, where $m>=1$ and $e_ell={i_ell,j_ell}$. Put $d:=n+m$.
For $q=(u,w) in RR^n times RR^m$, define the homogeneous cubic

$ p_G (q):=sum_(ell=1)^m u_(i_ell) u_(j_ell) w_ell. $

#lemma[
  If $omega(G)$ is the clique number of $G$, then

  $ max_(norm(q)_2=1) p_G (q)^2
      =2/27 (1-1/omega(G)). $
] <lem:clique-cubic>

*Proof.* Write $rho:=norm(u)_2$ and $sigma:=norm(w)_2$. For fixed $u$ and
$sigma$, Cauchy–Schwarz gives

$ max_(norm(w)_2=sigma) p_G (u,w)
    =sigma sqrt(sum_(ell=1)^m u_(i_ell)^2 u_(j_ell)^2). $

Writing $u=rho s$ with $norm(s)_2=1$ and setting $pi_i:=s_i^2$, the
Motzkin–Straus theorem @motzkin1965maxima gives

$ max_(norm(s)_2=1) sum_({i,j} in E) s_i^2 s_j^2
  =max_(pi_i>=0, sum_i pi_i=1) sum_({i,j} in E) pi_i pi_j
  =1/2 (1-1/omega(G)). $

Finally,

$ max_(rho^2+sigma^2=1, rho>=0, sigma>=0) rho^2 sigma
    =2/(3 sqrt(3)). $

Squaring the product of these two maxima proves the identity. Since $p_G$ is
odd, its maximum, rather than only its maximum absolute value, is the positive
square root of the displayed quantity. $qed$

#theorem[
  There is a polynomial-time reduction from CLIQUE to rational
  imprecise-bandit instances for which $A$ is a full-dimensional Euclidean
  ball, $D$ is a Euclidean ball in its affine hull, $Z=[1,2]$ is a
  one-dimensional Euclidean ball, the reward is linear, and $F$ is
  trilinear. Every set $K_z (x)$ is a singleton independent of $z$, and the
  uniform non-tangency condition holds. Even the corresponding distance
  inequality over the full homogeneous kernel holds with a constant
  $S>0.88$.

  For these instances, approximating $V_z$ to inverse-polynomial additive
  accuracy is NP-hard even when $z$ is known. Consequently, if, for some
  fixed $beta>0$, a randomized polynomial-time learner guaranteed

  $ E[R_T]<=P(L) T^(1-beta) $

  on every such instance for a polynomial $P$, then $"NP" subset.eq "BPP"$.
  For a deterministic learner, the same conclusion would be $"P" = "NP"$.
] <thm:trilinear-balls-np-hardness>

*Proof.* We may restrict CLIQUE to instances with $m>=1$ and
$3<=k<=n$, since the excluded cases are polynomial-time decidable. Starting
from $(G,k)$, use the cubic $p_G$ above and write an arm as
$x=(x_0,xi) in RR times RR^d$. Take

$ A:={(x_0,xi):(x_0-5/3)^2+norm(xi)_2^2<=1}. $

This is a full-dimensional Euclidean ball and $x_0>=2/3$ throughout $A$.
Moreover, the normalized coordinate $q:=xi/x_0$ ranges over exactly the ball
$norm(q)_2<=3/4$. Indeed,

$ 1-(x_0-5/3)^2-9/16 x_0^2=-(15x_0-16)^2/144<=0, $

so every attainable ratio has norm at most $3/4$. Conversely, for any such
$q$, the choice $x_0=16/15$ and $xi=x_0 q$ belongs to $A$.

Let $Z:=[1,2]$. Introduce the ambient outcome and constraint spaces

$ Y:=RR times RR^d times RR^(d times d) times RR^(d times d times d), $

$ W:=RR^d times RR^(d times d) times RR^(d times d times d), $

and write $y=(y_0,eta,Theta,Xi) in Y$. With the normalization functional
$mu(y):=y_0$, the outcome set is the affine Euclidean unit ball

$ D:={(1,eta,Theta,Xi):
      norm(eta)_2^2+norm(Theta)_F^2+norm(Xi)_F^2<=1}. $

For $x=(x_0,xi)$, $z in RR$, and $y in Y$, define $F(x,z,y)$ coordinatewise
by

$ F_i (x,z,y):=z (x_0 eta_i-1/2 xi_i y_0), $

$ F_(i j) (x,z,y):=z (x_0 Theta_(i j)-xi_i eta_j), $

$ F_(i j ell) (x,z,y):=z (x_0 Xi_(i j ell)-xi_i Theta_(j ell)). $

Each term contains one coordinate from each of $x$, $z$, and $y$, so $F$ is
trilinear. Define the reward by

$ r(x,y):=1/m sum_(ell=1)^m Xi_(i_ell, j_ell, n+ell). $

It is linear and independent of $x$; its coefficient vector has Euclidean
norm $1/sqrt(m)<=1$.

Fix $x in A$ and $z in Z$. Since $z x_0!=0$ and $y_0=1$ on $D$, the equations
$F(x,z,y)=0$ can be solved recursively. They force the unique candidate

$ eta_i=1/2 q_i, quad
  Theta_(i j)=1/2 q_i q_j, quad
  Xi_(i j ell)=1/2 q_i q_j q_ell. $

If $t:=norm(q)_2<=3/4$, the squared norm of its nonconstant outcome
coordinates is

$ 1/4 (t^2+t^4+t^6)<=4329/16384<1. $

Thus the candidate lies in $D$, proving that $K_z (x)$ is precisely this
singleton. It does not depend on $z$. The operator $F_(x,z):Y->W$ is also
onto: set $y_0=0$ and solve successively for $eta$, $Theta$, and $Xi$ for an
arbitrary right-hand side.

On the normalization hyperplane, the affine solution space is the singleton
$K_z (x)$, so the intrinsic non-tangency condition in
@prob:additive-ball-learning is
automatic. In fact, a stronger homogeneous version holds. Surjectivity and
the dimensions of $Y$ and $W$ show that $L_z (x)$ is the line spanned by
$y(x)=(1,g(q))$, where $g(q):=(eta,Theta,Xi)$ is given by the displayed
recursion. If $p=tau y(x) in L_z (x)$ lies outside $D$, then

$ opdist(p,D)>=abs(tau-1), quad
  opdist(p,K_z (x))=abs(tau-1) sqrt(1+norm(g(q))_2^2). $

Consequently the ambient homogeneous distance inequality holds uniformly
with

$ S>=1/sqrt(1+4329/16384)=128/sqrt(20713)>0.88. $

Because the compatible outcome is unique, evaluating the reward at that
outcome gives

$ v_z (x)=1/(2m) p_G (q). $

The ratio $q$ fills the radius-$3/4$ ball, so homogeneity and
@lem:clique-cubic imply, for every $z in Z$,

$ V_z
  =27/(128m) max_(norm(h)_2=1) p_G (h)
  =27/(128m) sqrt(2/27) sqrt(1-1/omega(G)). $

For $j=2,dots,n$, let

$ U_j:=27/(128m) sqrt(2/27) sqrt(1-1/j). $

If $omega(G)>=k$, then $V_z>=U_k$; if $omega(G)<=k-1$, then
$V_z<=U_(k-1)$. The two cases have gap

$ U_k-U_(k-1)
  >=27/(128m) sqrt(2/27) 1/(2k(k-1))
  =Omega(1/(m k^2)). $

Since $sqrt(2/27)>1/4$ and $m<=n^2$, the gap $Delta_k:=U_k-U_(k-1)$
satisfies

$ Delta_k>1/(40m k(k-1))>=1/(40m n^2). $

Set $epsilon:=1/(500m n^2)$. Using polynomially many bits, one can compute a
rational $tau_k$ such that

$ abs(tau_k-1/2 (U_k+U_(k-1)))<=epsilon. $

An $epsilon$-additive estimate of $V_z$ lies above $tau_k$ when
$omega(G)>=k$ and below it when $omega(G)<=k-1$, because
$2epsilon<Delta_k/2$. It therefore decides whether $G$ contains a $k$-clique.
The constructed instance has dimension $O(d^3)$, and all its defining
coefficients are rational with polynomial encoding length. This proves the
planning claim.

The displayed recursion computes the unique compatible outcome exactly in
polynomial time from every rational arm; in particular, $x_0>=2/3$ keeps the
division $q=xi/x_0$ bounded. Applying @lem:planning-from-learning with the
displayed $epsilon$ therefore supplies, with probability at least $2/3$, an
additive estimate to which the preceding threshold argument applies. This
would place CLIQUE in $"BPP"$ and hence imply $"NP" subset.eq "BPP"$. For a
deterministic learner, the estimate is deterministic and gives
$"P" = "NP"$. $qed$


== IUCB is NP-hard even when A and D are Euclidean balls

Given rational descriptions of
$A$, $D$, $Z$, the affine reward $r$, and the maps defining $K_z (x)$, let

$ v_z (x):=min_(y in K_z (x)) r(x,y). $

The *exact IUCB optimism problem* asks for the value

$ V_("IUCB"):=max_(z in Z,x in A) v_z (x). $

This is the optimization performed on the first round of IUCB, when its
confidence set is all of $Z$. The associated search problem asks for a
globally optimal first arm

$ x^star in opargmax_(x in A) max_(z in Z) v_z (x). $

#theorem[
  Even when $A$, $D$, and $Z$ are Euclidean balls and planning for every
  fixed hypothesis is polynomial-time, computing the exact first optimistic
  value or a globally optimal first arm of IUCB is NP-hard.
] <thm:iucb-np-hardness>

*Proof.* We reduce from the exact tensor spectral-norm problem. Given a
rational order-three tensor $cal(T) in QQ^(m times d times d_A)$, viewed as a
bilinear map $cal(T):RR^d times RR^(d_A) -> RR^m$, this problem asks to
compute

$ norm(cal(T))_sigma:=max_(norm(u)_2<=1,norm(x)_2<=1)
    norm(cal(T)(u,x))_2. $

Computing this value is NP-hard @hillar2013most. From $cal(T)$, construct an IUCB
instance as follows. Put

$ L:=1+sum_(i,j,k) abs(T_(i j k)), quad
  alpha:=1/(2L), quad A:={x:norm(x)_2<=1}. $

Write $z=(z_0,u)$ and $y=(w,s)$, and take

$ Z:={(z_0,u):(z_0-5/3)^2+norm(u)_2^2<=1}, quad
  D:={(w,s):norm(w)_2^2+s^2<=1}. $

For $z=(z_0,u)$, define the data in @eq:setting-compatible-set and the
reward by

$ B_z x:=-alpha cal(T)(u,x), quad C_z (w,s):=z_0 w, quad d_z:=0,
  quad r(x,(w,s)):=1/2(1+s). $

These are instances of @prob:additive-ball-learning, and

$ K_z (x)={(w,s) in D:w=alpha/z_0 cal(T)(u,x)}. $

The definition of $Z$ gives $z_0>=2/3$ and

$ norm(u)_2/z_0<=3/4, $

because
$1-(z_0-5/3)^2-9z_0^2/16=-(15z_0-16)^2/144<=0$.
Equality holds at $z_0=16/15$ and $norm(u)_2=4/5$ in every direction.
Also $norm(cal(T)(u,x))_2<=L norm(u)_2 norm(x)_2$, so the fixed $w$ in
$K_z (x)$ has norm at most $3alpha L/4=3/8$. Thus every $K_z (x)$ is
nonempty, and the uniform non-tangency condition holds with
$S>=sqrt(55)/8$. For this instance, nature chooses
$s=-sqrt(1-norm(w)_2^2)$ when evaluating $v_z (x)$, whence

$ v_z (x)=h(alpha/z_0 norm(cal(T)(u,x))_2), quad
  h(t):=1/2(1-sqrt(1-t^2)). $

For fixed $z$, a top right singular vector of
$M_u x:=cal(T)(u,x)$ maximizes $v_z (x)$, so fixed-hypothesis planning is
polynomial-time. IUCB instead optimizes jointly over $Z$ and $A$. Since $h$
is strictly increasing and the ratio above attains $3/4$ in every direction,

$ V_("IUCB")=h(3alpha/4 norm(cal(T))_sigma), $

Since

$ norm(cal(T))_sigma=4/(3alpha)
    sqrt(1-(1-2V_("IUCB"))^2), $

exact IUCB optimism would solve the tensor spectral-norm problem. If IUCB returns
only a globally optimal arm $x^star$, one SVD of
$N_x u:=cal(T)(u,x^star)$ computes

$ max_(z in Z) v_z (x^star)=h(3alpha/4 sigma_max (N_x))=V_("IUCB"), $

so the same inverse recovers $norm(cal(T))_sigma$. Producing a globally
optimal first arm is therefore NP-hard as well. $qed$

#pagebreak()
#counter(heading).update(0)
#set heading(numbering: "A.")

= Quadratically constrained quadratic programming <app:qcqp>

For symmetric matrices $Q_i in RR^(d times d)$, a *quadratically constrained
quadratic program* (QCQP) in $z in RR^d$ has the form

$ min_(z in RR^d) g_0 (z) quad "subject to" quad
  g_i (z)<=0, quad i=1,dots,m, $

where $g_i (z):=z^T Q_i z+2p_i^T z+r_i$; for complexity statements, all
entries are rational. A quadratic equality $h(z)=0$ is exactly the pair
$h(z)<=0$ and $-h(z)<=0$ @bienstock2016cdt.

QCQP describes algebraic form, whereas convex programming describes geometry.
The displayed minimization problem is a convex program when every $Q_i$,
$i=0,dots,m$, is positive semidefinite and all equalities are affine
@boyd2004convex. Without those restrictions it can be nonconvex: general QCQP
is NP-hard even when only the objective is quadratic and its Hessian has one
negative eigenvalue @pardalos1991negative.

The polynomial-time conclusion for our nonconvex instance has two steps.

+ First, fix the number $m$ of constraints. Bienstock's theorem states that,
  for rational quadratics $g_0,dots,g_m$, if at least one constraint
  $g_i (z)<=0$ has a positive-definite quadratic part, then for every
  $epsilon in (0,1)$ an algorithm runs in time
  $poly(L,log(1/epsilon))$, where $L$ is the input bit length, and either
  proves infeasibility or returns $hat(z)$ such that

  $ g_i (hat(z))<=epsilon, quad i=1,dots,m, $

  and $g_0 (hat(z))<=g_0 (z)+epsilon$ for every feasible $z$
  @bienstock2016cdt. The underlying weak-feasibility step reduces to a fixed
  number of homogeneous quadratic equations on a sphere, handled by
  Barvinok's method; binary search then gives the objective guarantee
  @barvinok1993feasibility @bienstock2016cdt.

+ Second, our planning problem is a QCQP with a fixed number of constraints,
  one of which is the strictly convex joint-ellipsoid constraint when
  $R_A,R_D>0$. Thus it satisfies Bienstock's hypotheses. Applying the theorem
  to the negative objective computes the planning maximum to weak additive
  accuracy $epsilon$ in time $poly(L,log(1/epsilon))$. If either radius is
  zero, the problem first reduces to a lower-dimensional instance.

#bibliography(
  "imprecise_bandits_T8_9_upper_bound_clean.bib",
  title: [References],
  style: "ieee",
)
