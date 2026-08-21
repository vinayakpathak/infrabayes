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

The true feasible outcome set is $K^star (x) := K_(z^star) (x)$.

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
and the learner receives reward $r(x_t,y_t)$.

The robust value of an arm and the optimal robust value are

$ v^star (x) := min_(y in K^star (x)) r(x,y), quad
  V^star := max_(x in A) v^star (x). $

The regret over horizon $T$ is

$ R_T := T V^star - sum_(t=1)^T r(x_t,y_t). $

Finally, let

$ C_r := max_(x in A, y in D) r(x,y) - min_(x in A, y in D) r(x,y) $

denote the reward range.

#theorem(title: [efficient $T^(2/3)$ learning])[
  Suppose that the known problem data in the setting above are rational.
  For every known horizon $T$, there
  is a policy whose arithmetic and weak-optimization running time is
  polynomial in $T$ and the input bit length and which, for every true
  hypothesis satisfying the uniform non-tangency condition and every
  compatible adaptive nature policy, satisfies

  $ E[R_T] <= tilde(O)(
      P(d_A,d_D,R_A,R_D,norm(b)_2,C_r,S^(-1)) T^(2/3)), $

  where $P$ is a fixed polynomial. Apart from the uniform non-tangency
  condition on the true feasible sets, no geometric property of $Z$ is used.
] <thm:efficient-upper-bound>

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
theorem @bienstock2016cdt returns a weakly feasible, additive $delta$-optimal
solution in time polynomial in $L$ and $log(1/delta)$. The cases $R_A=0$ or
$R_D=0$ reduce immediately to a lower-dimensional problem.

To obtain a feasible arm, project the $x$-component of the weak solution onto
$A$, call it $x_delta$, and set

$ s_delta:=sqrt(R_D^2-norm(q_t (x_delta)-c_D)_2^2). $

The square root is real by the assumption of the lemma. The projection moves
$x$ by $O(sqrt(delta))$, and the violated quadratic equality implies that
$s$ changes by at most $O(delta^(1/4))$. Consequently the linear objective
changes by at most $C delta^(1/4)$, where $C>=1$ is a data-dependent constant
whose bit length is polynomial in $L$. Choose
$delta<=(epsilon/(2C))^4$ and approximate $beta_t$ to the same working
precision. The resulting arm is feasible and its robust value is within
$epsilon$ of the optimum. Since
$log(1/delta)=poly(L)+O(log(1/epsilon))$, the running time is polynomial. $qed$

Taking $epsilon=T^(-2)$ adds at most $T^(-1)$ to total regret. Since the
provisional model changes only when $N_t$ grows, the planning problem is
solved at most $d_D+1$ times. With finite-precision data, the strict comparison
in @lem:polynomial-empty-set uses the usual gray-zone convention: if the
maximum squared distance is within $epsilon_("emp")$ of $R_D^2$, enlarge the
squared outcome radius by $epsilon_("emp")$. This changes the radius by only
$O(sqrt(epsilon_("emp")))$ and is absorbed into the noisy tolerances below.

= Noisy Setting

In this section, constants hidden by $O$ and $tilde(O)$ may depend on the
fixed problem parameters. In addition, $tilde(O)$ suppresses logarithmic
factors in $T$ and $1/delta$.

#lemma[
  Fix $delta in (0,1)$ and $1<=n<=T$. There exist $d_A+1$ affinely
  independent anchor arms such that, after playing each arm for $n$ rounds
  and interpolating their empirical average outcomes, the resulting affine
  map $hat(f)$ satisfies the following with probability at least $1-delta$.
  There is an affine map $f$ and a linear subspace $N$ such that $K^star (x) = f(x) + N$ and

  $ sup_(x in A) norm(hat(f)(x)-f(x))_2
    <= tilde(O)(n^(-1/2)). $
] <lem:noisy-anchor-interpolation>

*Proof.* Let $x^((0)),dots,x^((d_A))$ be any affine basis of $A$. Play each
arm for $n$ rounds. Let $overline(y)^((i))$ be the average observed outcome
for the $i$th arm, and let $overline(m)^((i))$ be the corresponding average conditional mean. Since
$K^star (x^((i)))$ is convex, $overline(m)^((i)) in K^star (x^((i)))$.
Let $hat(f)$ and $f$ be the unique affine interpolators satisfying
$hat(f) (x^((i)))=overline(y)^((i))$ and
$f(x^((i)))=overline(m)^((i))$ for every $i$. By
@lem:noiseless-anchor-identification,
$K^star (x)=(f(x)+N) inter D$ for every $x in A$.

Within each block, $y_t-m_t$ is a martingale-difference sequence. Since $D$
is bounded, Azuma--Hoeffding and a union bound over the finitely many anchors
and outcome coordinates imply that, with probability at least $1-delta$,

$ max_(i=0,dots,d_A)
    norm(overline(y)^((i))-overline(m)^((i)))_2
  <=tilde(O)(n^(-1/2)). $

Let $alpha_0 (x),dots,alpha_(d_A) (x)$ be the affine coordinates of
$x in A$ with respect to the chosen basis. Since $A$ is compact,

$ L:=sup_(x in A) sum_(i=0)^(d_A) abs(alpha_i (x))<infinity. $

Since $hat(f)$ and $f$ are affine and agree with the corresponding values at
the anchors,

$ norm(hat(f) (x)-f(x))_2
  <=sum_(i=0)^(d_A) abs(alpha_i (x))
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
  For every current ellipsoid $cal(E)_M$, every $x in A$, and every
  $u in 3cal(E)_M$,

  $ opdist(hat(f)(x)+u,f(x)+N) <= tilde(O)(n^(-1/2)). $
] <lem:ridge-residual-learning>

*Proof.* Condition on the conclusion of @lem:noisy-anchor-interpolation.
Consider a complete block $cal(B)$ in which the arm $x$ is fixed, and define
its average conditional mean

$ overline(m):=1/n sum_(t in cal(B)) m_t. $

Every $m_t$ belongs to the convex set $K^star (x)$, so
$overline(m) in K^star (x)$. Bounded vector martingale concentration and a
union bound over all complete blocks give, with probability at least
$1-delta$,

$ norm(overline(y)-overline(m))_2<=tilde(O)(n^(-1/2)) $

simultaneously for every block. Work on this event.

For a block at arm $x$, let

$ g:=overline(m)-f(x) in N. $

Its empirical residual therefore satisfies

$ norm(hat(g)-g)_2
    <= norm(overline(y)-overline(m))_2
      +norm(hat(f)(x)-f(x))_2
    <= tilde(O)(n^(-1/2)). $

In particular, every stored residual is within
$tilde(O)(n^(-1/2))$ of $N$. Thus we may write

$ hat(G)_M=G_M+Delta_M, $

where every column of $G_M$ belongs to $N$ and every column of $Delta_M$ has
norm at most $tilde(O)(n^(-1/2))$. By
@lem:ridge-informative-blocks,

$ norm(Delta_M)_("op")
    <=norm(Delta_M)_F
    <=sqrt(M) tilde(O)(n^(-1/2))
    <=tilde(O)(n^(-1/2)). $

Let $Q_M:=[hat(G)_M,lambda I_(d_D)]$. Since
$Q_M Q_M^T=V_M$ and $Q_M$ has full row rank,

$ cal(E)_M
    ={hat(G)_M alpha+lambda w:
      norm(alpha)_2^2+norm(w)_2^2<=1}. $

Hence, for every $u in 3cal(E)_M$, there are $alpha$ and $w$ satisfying the
displayed norm constraint such that

$ u=3(G_M alpha+Delta_M alpha+lambda w). $

Because $G_M alpha in N$,

$ opdist(u,N)
    <=3(norm(Delta_M)_("op")+lambda)
    <=tilde(O)(n^(-1/2)). $

Finally,

$ opdist(hat(f)(x)+u,f(x)+N)
    <=norm(hat(f)(x)-f(x))_2+opdist(u,N)
    <=tilde(O)(n^(-1/2)). $

$qed$

#algorithm(title: [Noisy imprecise bandit $(n,lambda)$])[
  #set enum(numbering: "1.", indent: 1.5em, body-indent: 0.55em)

  *Parameters:* block length $n in NN$ and ridge parameter $lambda>0$.

  + Choose the $d_A+1$ anchor arms from
    @lem:noisy-anchor-interpolation. Play each anchor for $n$ consecutive
    rounds, compute its empirical average $overline(y)^((i))$, and construct
    the affine interpolant $hat(f)$. If the horizon ends during this phase,
    stop.

  + Set $rho:=lambda$. Initialize $M:=0$ and let $hat(G)_0$ be the matrix with
    no columns.

  + At the beginning of each subsequent block, define

    $ V_M:=lambda^2 I_(d_D)+hat(G)_M hat(G)_M^T
        in RR^(d_D times d_D), quad
      cal(E)_M:={u in RR^(d_D):u^T V_M^(-1)u<=1}. $

    Let $c_D$ be the centre of $D$, and define the expanded outcome balls

    $ D_1:={y:norm(y-c_D)_2<=R_D+rho}, quad
      D_2:={y:norm(y-c_D)_2<=R_D+2rho}. $

    For every arm $x in A$, define

    $ hat(K)_M^("in") (x):=(hat(f)(x)+2cal(E)_M) inter D_1, $

    $ hat(K)_M^("out") (x):=(hat(f)(x)+3cal(E)_M) inter D_2. $

  + If $hat(K)_M^("in") (x)=emptyset$ for some $x in A$, choose any such arm.
    Otherwise, choose

    $ x in opargmax_(x' in A)
        min_(y in hat(K)_M^("out") (x')) r(x',y). $

  + Play the chosen arm for $n$ rounds. If fewer than $n$ rounds remain, play
    until the horizon and stop without updating. Otherwise, let $overline(y)$
    be the block-average outcome and set

    $ hat(g):=overline(y)-hat(f)(x). $

  + If $hat(g) in.not cal(E)_M$ declare the block informative, set
    $hat(G)_(M+1):=[hat(G)_M,hat(g)]$, and then increase $M$ by one. Otherwise
    leave $hat(G)_M$ and $M$ unchanged. Return to Step 3 and continue until
    time $T$.
] <alg:noisy-ridge-learning>

#lemma[
  Under the uniform non-tangency condition, for every $x in A$ and every
  $y in RR^(d_D)$,

  $ opdist(y,K^star (x))
      <= O(opdist(y,f(x)+N)+opdist(y,D)). $

  Consequently, a $tilde(O)(n^(-1/2))$ error in both the affine-space and
  ball constraints remains $tilde(O)(n^(-1/2))$ after intersection.
] <lem:noisy-ball-stability>

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

$ overline(y) in (hat(f)(x)+cal(E)_M) inter D
    subset.eq hat(K)_M^("in") (x). $

In particular, this block could not have been selected by the empty-set
branch of Step 4, so its arm was selected by the planning rule. Define

$ hat(v)_M (x'):=min_(y in hat(K)_M^("out") (x')) r(x',y). $

For every $x' in A$ and $y in hat(K)_M^("out") (x')$,
@lem:ridge-residual-learning gives

$ opdist(y,f(x')+N)<=tilde(O)(n^(-1/2)). $

Also, $y in D_2$ implies
$opdist(y,D)<=2rho=tilde(O)(n^(-1/2))$. Applying
@lem:noisy-ball-stability gives

$ opdist(y,K^star (x'))
    <=tilde(O)(n^(-1/2)). $

Since the reward is Lipschitz in its outcome argument,

$ hat(v)_M (x')
    >=v^star (x')-tilde(O)(n^(-1/2)). $

Let $x^star$ maximize $v^star$. The planning rule and the fact that
$overline(y) in hat(K)_M^("out") (x)$ now give

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

= NP-hardness of IUCB

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

Computing this value is NP-hard. From $cal(T)$, construct an IUCB instance as
follows. Put

$ L:=1+sum_(i,j,k) abs(T_(i j k)), quad
  alpha:=1/(2L), quad A:={x:norm(x)_2<=1}. $

Write $z=(z_0,u)$ and $y=(w,s)$, and take

$ Z:={(z_0,u):(z_0-5/3)^2+norm(u)_2^2<=1}, quad
  D:={(w,s):norm(w)_2^2+s^2<=1}. $

For $z=(z_0,u)$, define the data in @eq:setting-compatible-set and the
reward by

$ B_z x:=-alpha cal(T)(u,x), quad C_z (w,s):=z_0 w, quad d_z:=0,
  quad r(x,(w,s)):=1/2(1+s). $

These are instances of the setting above, and

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
