// Compile with Typst 0.15 or later.
#set page(
  paper: "us-letter",
  fill: white,
  margin: (x: 1.05in, top: 0.85in, bottom: 0.85in),
  numbering: "1",
  number-align: center + bottom,
)
#set text(font: "New Computer Modern", size: 10pt, fill: black)
#show math.equation: set text(font: "New Computer Modern Math")
#set par(justify: true, leading: 0.55em, spacing: 0.65em)
#set heading(numbering: "1.")
#show heading.where(level: 1): set text(size: 13pt)
#show heading.where(level: 2): set text(size: 11pt)
#set math.equation(numbering: none)
#set enum(indent: 1.4em, body-indent: 0.5em)

#let draft(body) = {
  set text(fill: black)
  body
}

#let opdist = math.op("dist")
#let opker = math.op("ker")
#let optr = math.op("tr")
#let opdet = math.op("det")
#let poly = math.op("poly")

#set document(
  title: [A Polynomial-Time Noisy Learner with Square-Root Regret],
)

#draft[
#align(center)[
  #text(size: 17pt, weight: "bold")[
    A Polynomial-Time Noisy Learner\
    with Square-Root Regret
  ]
  #v(0.5em)
  Research note, 4 September 2026
]
#v(0.8em)

This is a separate derivation for the setting of
#raw("efficient_imprecise_bandits.typ").

The fixed-block $T^(2/3)$ bound can be improved to $tilde(O) (sqrt(T))$.
The learner below does not need to know the true hypothesis, its residual
subspace, or the non-tangency constant $S$. It uses a quadratic penalty on
lifted arm-outcome vectors, and stops each block when a single empirical
quadratic form crosses a threshold. Its planning problem has a fixed number
of quadratic constraints.

The dependence on $S^(-1)$ and reward scales is explicit below. As with the
existing manuscript, a bound whose prefactor is polynomial in description
length requires the relevant numerical parameters to be polynomially bounded;
finite binary descriptions alone do not bound their magnitudes by a polynomial.

= Normalization and statement

Translate and rescale both balls so that
$X={x:norm(x)_2<=1}$ and $D={y:norm(y)_2<=1}$.
Continue to write the transformed reward as
$r(x,y)=a^T x+b^T y+c$.
Thus the transformed $norm(b)$ is the original $R_D norm(b)$.
The non-tangency constant is unchanged by this translation and uniform
rescaling of outcome coordinates. Zero-radius balls give trivial special cases.

Let

$ q:=1+d_X+d_D, quad w(x,y):=(1,x,y) in RR^q,
  quad W:=sqrt(3). $

For $delta in (0,1)$, define quantities used only in the analysis:

$ J_T &:= ceil(q log_2 (1+(3T)/q)), \
  h_T^2 &:= 8d_D log((2d_D T^2)/delta), \
  B_T^2 &:= 1+J_T h_T^2, \
  G &:= sqrt(3) (1+S^(-1)) norm(b). $

*Claim.* With $lambda=ceil(sqrt(T))$, the learner below has, with
probability at least $1-delta$, realized regret at most

$ T V^star-sum_(t=1)^T r(x_t,y_t)
  <=lambda(1+sqrt(3))^2 (J_T+1)
    +(G^2 B_T^2 T)/(4lambda)+T epsilon, $

when every planning call has additive error at most $epsilon$.
In particular, $delta=(T+1)^(-2)$ and $epsilon=(T+1)^(-2)$ give

$ R_T=tilde(O) (
    [q+(1+S^(-1))^2 norm(b)^2 q d_D] sqrt(T)
  ), $

with a vanishing additional contribution from the failure event. The policy
runs in time polynomial in the input length and $T$, under the same weak
optimization model used in the manuscript. Neither $S$ nor $B_T$ is an
input to the policy.

#pagebreak()

= Learner

Initialize $V=I_q$. At the start of each block:

+ Define

  $ U_V (x):=min_(y in D) [
      r(x,y)+lambda w(x,y)^T V^(-1) w(x,y)
    ]. $

  Choose $x in X$ with
  $U_V (x)>=max_(x' in X) U_V (x')-epsilon$.

+ Keep playing this arm. After $n$ observations in the block, set

  $ overline(y)_n:=1/n sum_(i=1)^n y_i,
    quad overline(w)_n:=(1,x,overline(y)_n). $

  End the block at the first $n$ satisfying

  $ n overline(w)_n^T V^(-1) overline(w)_n>=1. $

+ At such an endpoint, update

  $ V <- V+n overline(w)_n overline(w)_n^T $

  and begin a new block. Stop at the horizon, even if the final block has
  not crossed the threshold.

There is no anchor-sampling phase. The adversary may change its distribution
after every observation, including within a block.

= Proof

== One fixed subspace contains every lifted conditional mean

Let $N=opker C_star$, and let $Q$ be the orthogonal projector onto $N^perp$.
The minimum-norm solution of the true affine mean constraints is an affine
map $f(x)=A x+d in N^perp$. It exists for every arm because every true fiber
is nonempty. Consequently

$ K^star (x)=(A x+d+N) inter D. $

Since the minimum-norm solution has norm at most that of any feasible mean,
$norm(A x+d)<=1$ on $X$. Evaluating at $0$ and at opposite unit vectors gives
$norm(d)<=1$ and $norm(A)_("op")<=1$.

Define the linear map and its kernel

$ F(s,x,y):=Q y-A x-s d, quad L:=opker F. $

Every conditional mean $m_t$ satisfies $w(x_t,m_t) in L$, and
$norm(F)_("op")<=sqrt(3)$. Hence, for $x in X$ and $y in D$,

$ opdist(y,A x+d+N)
  =norm(F(1,x,y))
  <=sqrt(3) opdist(w(x,y),L). $

The manuscript's non-tangency inequality then gives

#set math.equation(numbering: "(1)")
$ opdist(y,K^star (x))
  <=sqrt(3) (1+S^(-1)) opdist(w(x,y),L). $ <eq:lifted-geometry>
#set math.equation(numbering: none)

All these objects are for analysis only.

== There are logarithmically many completed blocks

For a completed block, the determinant update is

$ opdet(V+n overline(w) overline(w)^T)
  =opdet(V) (1+n overline(w)^T V^(-1) overline(w))
  >=2opdet(V). $

After $J$ completed blocks, $opdet V>=2^J$.
Every block average satisfies $norm(overline(w))<=sqrt(3)$, so
$optr V<=q+3T$. The arithmetic-geometric mean inequality gives

$ 2^J<=opdet V<=(1+3T/q)^q, $

and therefore $J<=J_T$.

#block(breakable: false)[
The stopping rule also controls overshoot. Within a block put
$S_n:=sum_(i=1)^n w(x,y_i)$ and use the norm induced by its fixed $V^(-1)$.
At the first crossing, for $n>=2$,

$ norm(S_n)_(V^(-1))/sqrt(n)
  &<=sqrt((n-1)/n)
    norm(S_(n-1))_(V^(-1))/sqrt(n-1)
    +norm(w(x,y_n))_(V^(-1))/sqrt(n) \
  &<=1+sqrt(3). $

Here $V succ.eq I$. The same upper bound holds if $n=1$, or for a final
uncrossed block. Thus every block used in the regret calculation satisfies

#set math.equation(numbering: "(1)")
$ n overline(w)_n^T V^(-1) overline(w)_n
  <=(1+sqrt(3))^2. $ <eq:stopping-overshoot>
#set math.equation(numbering: none)
]

== Noise has little energy perpendicular to the true subspace

Write $m_t$ for the conditional mean after the adversary has chosen the
round's distribution. The coordinates of $y_t-m_t$ are martingale
differences bounded in absolute value by $2$. Azuma-Hoeffding and a union
bound over coordinates and all at most $T^2$ deterministic time intervals
give, with probability at least $1-delta$,

#set math.equation(numbering: "(1)")
$ n norm(overline(y)-overline(m))^2<=h_T^2 $ <eq:interval-noise>
#set math.equation(numbering: none)

simultaneously on every interval. This includes blocks with adaptive
starting times and endpoints; no optional-stopping assumption about their
averages is necessary.

Fix a unit vector $u in L^perp$. In each completed block the arm is
constant, so $(1,x,overline(m)) in L$ and

$ n(u^T overline(w))^2
  =n(u^T (0,0,overline(y)-overline(m)))^2
  <=h_T^2. $

It follows simultaneously for all current matrices and all such $u$ that

$ u^T V u<=1+J_T h_T^2=B_T^2. $

By the Cauchy-Schwarz inequality in the $V$ and $V^(-1)$ norms,

#set math.equation(numbering: "(1)")
$ opdist(w,L)
  =sup_(u in L^perp, norm(u)<=1) u^T w
  <=B_T sqrt(w^T V^(-1) w). $ <eq:subspace-confidence>
#set math.equation(numbering: none)

== The quadratic penalty gives sufficient optimism without knowing $S$

For any $x in X$ and $y in D$, project $y$ to $K^star (x)$ and use
@eq:lifted-geometry and @eq:subspace-confidence. This yields

$ v^star (x)
  <=r(x,y)+G B_T sqrt(w(x,y)^T V^(-1) w(x,y)). $

Writing $ell=sqrt(w^T V^(-1) w)$ and completing the square,

$ lambda ell^2-G B_T ell>=-(G^2 B_T^2)/(4lambda). $

Therefore

#set math.equation(numbering: "(1)")
$ U_V (x)>=v^star (x)-zeta_T,
  quad zeta_T:=(G^2 B_T^2)/(4lambda). $ <eq:approximate-optimism>
#set math.equation(numbering: none)

Although the unknown geometric constant appears in this analysis, the
quadratic penalty itself only uses $lambda=ceil(sqrt(T))$.

For a block played at the approximate maximizer $x$,
@eq:approximate-optimism gives
$U_V (x)>=V^star-zeta_T-epsilon$.
Its empirical outcome average belongs to $D$, so the definition of $U_V$
also gives

$ U_V (x)<=r(x,overline(y))
  +lambda overline(w)^T V^(-1) overline(w). $

Multiplying by the block length and using affineness of reward and
@eq:stopping-overshoot, with $cal(B)$ denoting the block,

$ sum_(i in cal(B)) (V^star-r(x,y_i))
  <=lambda(1+sqrt(3))^2+n(zeta_T+epsilon). $

Summing over at most $J_T+1$ blocks proves the claim. On the failure event,
realized regret is at most the reward range times $T$; with the stated
choice of $delta$, its contribution to expected regret is $O(C_r/T)$.

#pagebreak()

= Polynomial-time planning

The remaining task is to maximize $U_V$ over the arm ball. The identity

$ lambda w^T V^(-1) w
  =max_z [z^T w-(z^T V z)/(4lambda)] $

has maximizer $z=2lambda V^(-1) w$. Since $V succ.eq I$ and
$norm(w)<=sqrt(3)$, this maximizer has norm at most $2sqrt(3) lambda$.
We can therefore restrict $z$ to $norm(z)<=4lambda$, uniformly in $x,y$.

For each fixed $x$, the expression is affine in $y$ and concave in $z$,
and both domains are compact and convex. The minimax theorem allows the
minimum over $y$ and maximum over $z$ to be exchanged. Partitioning
$z=(z_0,z_X,z_D)$ gives

$ U_V (x)=a^T x+c+
  max_(norm(z)<=4lambda) [
    z_0+z_X^T x-norm(b+z_D)-(z^T V z)/(4lambda)
  ]. $

Consequently the planning step is the following single QCQP:

$ max_(x,z,s) quad
  a^T x+c+z_0+z_X^T x-s-(z^T V z)/(4lambda) $

subject to

$ norm(x)^2<=1, quad norm(z)^2<=16lambda^2, quad
  norm(b+z_D)^2<=s^2, quad 0<=s<=H, $

where $H=1+norm(b)_1+4lambda$ is a rational upper bound. Add the redundant
ellipsoidal constraint

$ norm(x)^2+norm(z)^2/(16lambda^2)+s^2/H^2<=3. $

There are six quadratic inequalities, independently of the dimensions,
and one is strictly convex in all variables. Thus the weak polynomial-time
QCQP result already used in the manuscript applies:
#link("https://epubs.siam.org/doi/10.1137/15M1009871")[
  Bienstock, _A Note on Polynomial Solvability of the CDT Problem_ (2016).
]

To repair a weakly feasible solution, project $x$ and $z$ onto their balls
and set $s=norm(b+z_D)$. Constraint violations at most $tau$ require
$O(sqrt(tau))$ movements in these variables, or a one-sided increase of
that order in $s$. On this bounded domain the objective is Lipschitz with
a polynomially bounded constant: $lambda<=sqrt(T)+1$ and
$norm(V)<=1+3T$. The repaired objective therefore loses at most
$poly("data",T) sqrt(tau)$.
Choosing inverse-polynomial internal tolerance returns a feasible arm with
the required additive planning accuracy. No emptiness tests, dual multiplier
conditioning assumptions, or estimates of $S$ are needed.

= Numerical implementation

The displayed policy uses exact arithmetic to keep the proof readable.
Finite precision can be handled while preserving the same bound.
Round observed outcomes to rational points inside $D$ within error
$tau_y=(T+1)^(-4)$, and use those points in the block averages and updates.
Then @eq:interval-noise holds with $h_T^2$ replaced by
$2h_T^2+2T tau_y^2$. The norm bound and convex membership in $D$ remain
exact, and the discrepancy in accumulated reward is at most
$norm(b) T tau_y$.

Choose rational feasible arms to the required planning accuracy on a common
grid. The surrogate is Lipschitz in $x$ with constant at most
$norm(a)+2sqrt(3) lambda$, so this additional rounding is inexpensive.
The stored matrix is then rational and positive definite, with eigenvalues
between $1$ and $1+3T$. Its updates and threshold comparisons can be carried
out exactly with polynomial bit complexity. Since there are only $O(q log T)$
updates, sums of the rational block contributions have polynomial bit length.
All numerical errors can be absorbed into the stated planning error and
negligible reward perturbation.
]
