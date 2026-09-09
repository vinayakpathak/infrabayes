# A polynomial-time noisy learner with square-root regret

Research note, 4 September 2026. This is a separate derivation for the setting of
`efficient_imprecise_bandits.typ`.

The fixed-block $T^{2/3}$ bound can be improved to $\widetilde O(\sqrt T)$.
The learner below does not need to know the true hypothesis, its residual
subspace, or the non-tangency constant $S$. It uses a quadratic penalty on
lifted arm–outcome vectors, and stops each block when a single empirical
quadratic form crosses a threshold. Its planning problem has a fixed number
of quadratic constraints.

The dependence on $S^{-1}$ and reward scales is explicit below. As with the
existing manuscript, a bound whose prefactor is polynomial in description
length requires the relevant numerical parameters to be polynomially bounded;
finite binary descriptions alone do not bound their magnitudes by a polynomial.

## Normalization and statement

Translate and rescale both balls so that
$X=\{x:\|x\|_2\le1\}$ and $D=\{y:\|y\|_2\le1\}$.
Continue to write the transformed reward as
$r(x,y)=a^\top x+b^\top y+c$.
Thus the transformed $\|b\|$ is the original $R_D\|b\|$.
The non-tangency constant is unchanged by this translation and uniform
rescaling of outcome coordinates. Zero-radius balls give trivial special cases.

Let

$$
q=1+d_X+d_D,\qquad w(x,y)=(1,x,y)\in\mathbb R^q,
\qquad W=\sqrt3.
$$

For $\delta\in(0,1)$, define quantities used only in the analysis:

$$
\begin{aligned}
J_T&=\left\lceil q\log_2\left(1+\frac{3T}{q}\right)\right\rceil,\\
h_T^2&=8d_D\log\left(\frac{2d_D T^2}{\delta}\right),\\
B_T^2&=1+J_T h_T^2,\\
G&=\sqrt3(1+S^{-1})\|b\|.
\end{aligned}
$$

**Claim.** With $\lambda=\lceil\sqrt T\rceil$, the learner below has, with
probability at least $1-\delta$, realized regret at most

$$
TV^*-\sum_{t=1}^T r(x_t,y_t)
\le
\lambda(1+\sqrt3)^2(J_T+1)
+\frac{G^2 B_T^2T}{4\lambda}
+T\varepsilon,
$$

when every planning call has additive error at most $\varepsilon$.
In particular, $\delta=(T+1)^{-2}$ and $\varepsilon=(T+1)^{-2}$ give

$$
R_T=\widetilde O\left(
\left[q+(1+S^{-1})^2\|b\|^2q d_D\right]\sqrt T
\right),
$$

with a vanishing additional contribution from the failure event. The policy
runs in time polynomial in the input length and $T$, under the same weak
optimization model used in the manuscript. Neither $S$ nor $B_T$ is an
input to the policy.

## Learner

Initialize $V=I_q$. At the start of each block:

1. Define

   $$
   U_V(x)=\min_{y\in D}\left[
   r(x,y)+\lambda\,w(x,y)^\top V^{-1}w(x,y)
   \right].
   $$

   Choose $x\in X$ with $U_V(x)\ge\max_{x'\in X}U_V(x')-\varepsilon$.

2. Keep playing this arm. After $n$ observations in the block, set

   $$
   \bar y_n=\frac1n\sum_{i=1}^n y_i,
   \qquad \bar w_n=(1,x,\bar y_n).
   $$

   End the block at the first $n$ satisfying

   $$
   n\bar w_n^\top V^{-1}\bar w_n\ge1.
   $$

3. At such an endpoint, update

   $$
   V\leftarrow V+n\bar w_n\bar w_n^\top
   $$

   and begin a new block. Stop at the horizon, even if the final block has
   not crossed the threshold.

There is no anchor-sampling phase. The adversary may change its distribution
after every observation, including within a block.

## Proof

### 1. One fixed subspace contains every lifted conditional mean

Let $N=\ker C_*$, and let $Q$ be its orthogonal projector complement.
The minimum-norm solution of the true affine mean constraints is an affine
map $f(x)=Ax+d\in N^\perp$. It exists for every arm because every true fiber
is nonempty. Consequently

$$
K^*(x)=(Ax+d+N)\cap D.
$$

Since the minimum-norm solution has norm at most that of any feasible mean,
$\|Ax+d\|\le1$ on $X$. Evaluating at $0$ and at opposite unit vectors gives
$\|d\|\le1$ and $\|A\|_{\mathrm{op}}\le1$.

Define the linear map and its kernel

$$
F(s,x,y)=Qy-Ax-sd,\qquad L=\ker F.
$$

Every conditional mean $m_t$ satisfies $w(x_t,m_t)\in L$, and
$\|F\|_{\mathrm{op}}\le\sqrt3$. Hence, for $x\in X$ and $y\in D$,

$$
\operatorname{dist}(y,Ax+d+N)
=\|F(1,x,y)\|
\le\sqrt3\operatorname{dist}(w(x,y),L).
$$

The manuscript's non-tangency inequality then gives

$$
\operatorname{dist}(y,K^*(x))
\le\sqrt3(1+S^{-1})\operatorname{dist}(w(x,y),L).
\tag{1}
$$

All these objects are for analysis only.

### 2. There are logarithmically many completed blocks

For a completed block, the determinant update is

$$
\det(V+n\bar w\bar w^\top)
=\det(V)\left(1+n\bar w^\top V^{-1}\bar w\right)
\ge2\det(V).
$$

After $J$ completed blocks, $\det V\ge2^J$.
Every block average satisfies $\|\bar w\|\le\sqrt3$, so
$\operatorname{tr}V\le q+3T$. The arithmetic–geometric mean inequality gives

$$
2^J\le\det V\le(1+3T/q)^q,
$$

and therefore $J\le J_T$.

The stopping rule also controls overshoot. Within a block put
$S_n=\sum_{i=1}^n w(x,y_i)$ and use the norm induced by its fixed $V^{-1}$.
At the first crossing, for $n\ge2$,

$$
\frac{\|S_n\|_{V^{-1}}}{\sqrt n}
\le
\sqrt{\frac{n-1}{n}}
\frac{\|S_{n-1}\|_{V^{-1}}}{\sqrt{n-1}}
+\frac{\|w(x,y_n)\|_{V^{-1}}}{\sqrt n}
\le1+\sqrt3.
$$

Here $V\succeq I$. The same upper bound holds if $n=1$, or for a final
uncrossed block. Thus every block used in the regret calculation satisfies

$$
n\bar w_n^\top V^{-1}\bar w_n\le(1+\sqrt3)^2.
\tag{2}
$$

### 3. Noise has little energy perpendicular to the true subspace

Write $m_t$ for the conditional mean after the adversary has chosen the
round's distribution. The coordinates of $y_t-m_t$ are martingale
differences bounded in absolute value by $2$. Azuma–Hoeffding and a union
bound over coordinates and all at most $T^2$ deterministic time intervals
give, with probability at least $1-\delta$,

$$
n\|\bar y-\bar m\|^2\le h_T^2
\tag{3}
$$

simultaneously on every interval. This includes blocks with adaptive
starting times and endpoints; no optional-stopping assumption about their
averages is necessary.

Fix a unit vector $u\in L^\perp$. In each completed block the arm is
constant, so $(1,x,\bar m)\in L$ and

$$
n(u^\top\bar w)^2
=n\left(u^\top(0,0,\bar y-\bar m)\right)^2
\le h_T^2.
$$

It follows simultaneously for all current matrices and all such $u$ that

$$
u^\top V u\le1+J_T h_T^2=B_T^2.
$$

By the Cauchy–Schwarz inequality in the $V$ and $V^{-1}$ norms,

$$
\operatorname{dist}(w,L)
=\sup_{u\in L^\perp,\,\|u\|\le1}u^\top w
\le B_T\sqrt{w^\top V^{-1}w}.
\tag{4}
$$

### 4. The quadratic penalty gives sufficient optimism without knowing S

For any $x\in X$ and $y\in D$, project $y$ to $K^*(x)$ and use (1) and
(4). This yields

$$
v^*(x)\le r(x,y)+G B_T\sqrt{w(x,y)^\top V^{-1}w(x,y)}.
$$

Writing $\ell=\sqrt{w^\top V^{-1}w}$ and completing the square,

$$
\lambda\ell^2-G B_T\ell
\ge-\frac{G^2B_T^2}{4\lambda}.
$$

Therefore

$$
U_V(x)\ge v^*(x)-\zeta_T,
\qquad \zeta_T=\frac{G^2B_T^2}{4\lambda}.
\tag{5}
$$

Although the unknown geometric constant appears in this analysis, the
quadratic penalty itself only uses $\lambda=\lceil\sqrt T\rceil$.

For a block played at the approximate maximizer $x$, (5) gives
$U_V(x)\ge V^*-\zeta_T-\varepsilon$.
Its empirical outcome average belongs to $D$, so the definition of $U_V$
also gives

$$
U_V(x)\le r(x,\bar y)+\lambda\bar w^\top V^{-1}\bar w.
$$

Multiplying by the block length and using affineness of reward and (2),

$$
\sum_{i\text{ in block}}(V^*-r(x,y_i))
\le\lambda(1+\sqrt3)^2+n(\zeta_T+\varepsilon).
$$

Summing over at most $J_T+1$ blocks proves the claim. On the failure event,
realized regret is at most the reward range times $T$; with the stated
choice of $\delta$, its contribution to expected regret is $O(C_r/T)$.

## Polynomial-time planning

The remaining task is to maximize $U_V$ over the arm ball. The identity

$$
\lambda w^\top V^{-1}w
=\max_z\left[z^\top w-\frac{z^\top Vz}{4\lambda}\right]
$$

has maximizer $z=2\lambda V^{-1}w$. Since $V\succeq I$ and
$\|w\|\le\sqrt3$, this maximizer has norm at most $2\sqrt3\lambda$.
We can therefore restrict $z$ to $\|z\|\le4\lambda$, uniformly in $x,y$.

For each fixed $x$, the expression is affine in $y$ and concave in $z$,
and both domains are compact and convex. The minimax theorem allows the
minimum over $y$ and maximum over $z$ to be exchanged. Partitioning
$z=(z_0,z_X,z_D)$ gives

$$
U_V(x)=a^\top x+c+
\max_{\|z\|\le4\lambda}
\left[z_0+z_X^\top x-\|b+z_D\|
-\frac{z^\top Vz}{4\lambda}\right].
$$

Consequently the planning step is the following single QCQP:

$$
\max_{x,z,s}\quad
a^\top x+c+z_0+z_X^\top x-s-\frac{z^\top Vz}{4\lambda}
$$

subject to

$$
\|x\|^2\le1,\quad
\|z\|^2\le16\lambda^2,\quad
\|b+z_D\|^2\le s^2,\quad
0\le s\le H,
$$

where $H=1+\|b\|_1+4\lambda$ is a rational upper bound. Add the redundant
ellipsoidal constraint

$$
\|x\|^2+\frac{\|z\|^2}{16\lambda^2}+\frac{s^2}{H^2}\le3.
$$

There are six quadratic inequalities, independently of the dimensions,
and one is strictly convex in all variables. Thus the weak polynomial-time
QCQP result already used in the manuscript applies:
[Bienstock, *A Note on Polynomial Solvability of the CDT Problem* (2016)](https://epubs.siam.org/doi/10.1137/15M1009871).

To repair a weakly feasible solution, project $x$ and $z$ onto their balls
and set $s=\|b+z_D\|$. Constraint violations at most $\tau$ require
$O(\sqrt\tau)$ movements in these variables, or a one-sided increase of
that order in $s$. On this bounded domain the objective is Lipschitz with
a polynomially bounded constant: $\lambda\le\sqrt T+1$ and
$\|V\|\le1+3T$. The repaired objective therefore loses at most
$\operatorname{poly}(\text{data},T)\sqrt\tau$.
Choosing inverse-polynomial internal tolerance returns a feasible arm with
the required additive planning accuracy. No emptiness tests, dual multiplier
conditioning assumptions, or estimates of $S$ are needed.

## Numerical implementation

The displayed policy uses exact arithmetic to keep the proof readable.
Finite precision can be handled while preserving the same bound.
Round observed outcomes to rational points inside $D$ within error
$\tau_y=(T+1)^{-4}$, and use those points in the block averages and updates.
Then (3) holds with $h_T^2$ replaced by
$2h_T^2+2T\tau_y^2$. The norm bound and convex membership in $D$ remain
exact, and the discrepancy in accumulated reward is at most
$\|b\|T\tau_y$.

Choose rational feasible arms to the required planning accuracy on a common
grid. The surrogate is Lipschitz in $x$ with constant at most
$\|a\|+2\sqrt3\lambda$, so this additional rounding is inexpensive.
The stored matrix is then rational and positive definite, with eigenvalues
between $1$ and $1+3T$. Its updates and threshold comparisons can be carried
out exactly with polynomial bit complexity. Since there are only $O(q\log T)$
updates, sums of the rational block contributions have polynomial bit length.
All numerical errors can be absorbed into the stated planning error and
negligible reward perturbation.
