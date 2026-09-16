#set page(
  paper: "us-letter",
  margin: (x: 1.1in, top: 0.9in, bottom: 0.9in),
  fill: white,
  numbering: "1",
  number-align: center + bottom,
)
#set text(font: "New Computer Modern", size: 10pt, fill: black)
#show math.equation: set text(font: "New Computer Modern Math")

#let draft(body) = {
  set text(fill: rgb("#0057d9"))
  body
}

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
#let cM = $cal(M)$

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

#let credal = box(
  width: 0.68em,
  height: 0.68em,
  baseline: bottom,
  stroke: 0.055em,
) + h(0.04em)

An instance of the imprecise bandits problem is a tuple $cM = (X, D, H, r)$, where $X$ is a set of arms, $D$ is a set of possible outcomes, $H$ is a set of mappings of type $X -> credal D$ where $credal D$ denotes the set of credal sets over $D$, and $r: X times D -> RR$ is a reward function.

The imprecise bandits game is played between a learner and an adversary for $T$ rounds (both adversary and learner know $T$). At the beginning of the game, the adversary picks some $h^star in H$. The learner knows $X, D, H, r$, and $T$, but does not have knowledge of $h^star$. Then, at each round $t$:
1. Learner picks an arm $x_t in X$.
2. Adversary picks a distribution $P_t in h^star (x_t)$.
3. An outcome $y_t ~ P_t$ is drawn and shown to the learner as feedback.
4. Learner gets reward $r(x_t, y_t)$.

Given a hypothesis $h in H$, we define the value functions:

$ v_h (x) := min_(P in h(x)) EE_(y ~ P) [r(x,y)], quad
  V_h := max_(x in X) v_h (x). $

We use the shorthand $v^* (x)$ and $V^star$ to denote the value functions corresponding to the true hypothesis $h^star$.

The regret over horizon $T$ is

$ R_T := T V^star - EE [sum_(t=1)^T r(x_t,y_t)]. $

Here the expectation in the second term is taken wrt the randomness in the learner's and the adversary's strategies as well as the randomness arising from sampling $y_t ~ P_t$.

We are interested in learner strategies that can achieve a sublinear (in $T$) regret for all true hypotheses $h^star in H$. We say that an imprecise bandits instance $cM = (X, D, H, r)$ has a _statistically efficient_ learner if such a learner strategy exists.

*Computational tractability.* In this paper, we are interested in studying the computational complexity of the learner. A _learner policy_ $pi$ is a randomized algorithm that takes as input a history $h_t = ((x_i,y_i))_(i=1)^t$ and the description of the problem instance $cM$ and returns a next arm $x_(t+1)$. The computational complexity of the problem depends crucially on the exact nature of access the policy is given to $cM$. For example, on one extreme, one can consider a non-uniform access such that a policy $pi^cM$ is merely indexed by the instance $cM$ as opposed to $cM$ being an input to a computational procedure. However, this makes several instances rather trivial. In this paper we mostly consider specific encodings of $cM$. We also occasionally assume $pi$ to have oracle access to $cM$ with certain specific oracles. We will make these assumptions clear in the respective sections.

We will say that a learner is _computationally efficient_ if it runs in time polynomial in the size of its input and achieves a regret $R_T <= poly(|cM|)T^(1-alpha)$ for some $alpha > 0$.

== Linear Imprecise Bandits

For most of this work, we study the following linear specialization of the
instance $cM=(X,D,H,r)$ defined above. Let
$X subset.eq RR^(d_X)$ be the arm set, and let
$D subset.eq RR^(d_D)$ be the outcome set. We assume that $X$ and $D$ are
Euclidean balls of radii $R_X$ and $R_D$ (not necessarily centred at the origin).
The reward is affine in the arm and outcome:

$ r(x,y) := a^T x + b^T y + c. $

Let the hypothesis class $H$ be parametrized by $Z subset.eq RR^(d_Z)$.
For every $z in Z$, we define the hypothesis $h_z$ by first defining the possible expected values of the distributions that $h_z$ is allowed to choose. In particular, let

#set math.equation(numbering: "(1)")
$ K_z (x) := {y in D : C_z y + B_z x + d_z = 0}. $ <eq:setting-compatible-set>
#set math.equation(numbering: none)

#draft[
Here $B_z$, $C_z$, and $d_z$ are matrices and vectors of appropriate
dimensions that depend affinely on $z$. Now, hypothesis
$h_z: X -> credal D$ is given by
]

$ h_z (x) := {P in Delta D : EE_(y ~ P)[y] in K_z (x)}. $

Let $z^star in Z$ represent the true
hypothesis, so that $h^star=h_(z^star)$. The true feasible mean set is
$K^star (x):=K_(z^star) (x)$.

#draft[We also assume a uniform non-tangency condition: there is a constant
$S in (0,1]$ such that, for every $x in X$ and every
$p in RR^(d_D)$ satisfying
$C_(z^star)p+B_(z^star)x+d_(z^star)=0$ with $p in.not D$,

$ opdist(p,D) >= S opdist(p,K^star (x)). $

For a Euclidean ball, this says that the affine solution spaces defined by
the true constraints remain uniformly bounded away from tangency to $D$.
This is the transversality condition used in @kosoy2025imprecise.
]


Because $r$ is affine in its outcome argument, the value functions defined
above satisfy

$ v^* (x)
    =min_(P in h^star (x)) EE_(y ~ P)[r(x,y)]
    =min_(y in K^star (x)) r(x,y), quad
  V^star := max_(x in X) v^* (x). $

The regret over horizon $T$ is

$ R_T := T V^star - EE [sum_(t=1)^T r(x_t,y_t)]. $

#draft[
To define the computational problem, we fix a finite representation scheme
for the data defining $cM$, and let $|cM|$ denote the length of its
description. We represent $X$ and $D$ by their centres and radii, $r$ by its
coefficients, and $H$ by a description of $Z$ together with the affine map
$z mapsto (B_z,C_z,d_z)$. We restrict attention to succinctly represented
instances, for which $|cM| <= poly(d_X,d_D,d_Z)$.
]

Now we state our main result.

#draft[#theorem(title: [efficient $sqrt(T)$ learning])[
  There exists a policy for linear imprecise bandits as defined above that,
  for every time horizon $T$ and every true hypothesis $h^star in H$,
  runs in time polynomial in $|cM|$ and $T$ and achieves regret

  $ R_T <= tilde(O)(sqrt(T)). $

  The hidden factor depends polynomially on the dimensions, $S^(-1)$,
  and the reward range. The precise dependence is given in
  @thm:soft-square-root.
] <thm:efficient-upper-bound>

This dependence on $T$ is tight up to logarithmic factors: we can reuse
the $Omega(sqrt(T))$ worst-case lower bound for stochastic bandits
@auer2002nonstochastic[Theorem 5.1]. To see this, take
$X=[-1,1]$, $D=[0,1]$, $r(x,y)=y$, and, for unknown
$mu=(mu_1,mu_2) in [0,1]^2$, set

$ K_mu (x)=\{(1-x)/2 mu_1+(1+x)/2 mu_2\}. $

These are affine constraints of the required form, with $S=1$.
Given a two-armed Bernoulli bandit with means $mu_1$ and $mu_2$, we can
simulate a play of $x$ by pulling its first arm with probability
$(1-x)/2$ and its second arm otherwise, and returning the observed reward
as $y$. This gives a compatible outcome distribution at $x$ and preserves
expected regret, since $V^star=max(mu_1,mu_2)$. Thus a better worst-case
regret bound here would give a better bound for two-armed stochastic bandits.
]

#[
= Warmup: A $T^(2/3)$ Learner <sec:hard-ellipsoid-warmup>

For an arm $x$ and outcome $y$, consider the vector $w(x,y) = (1,x,y)$.
This vector lies in $RR^(1+d_X+d_D)$, and the constraints defining the
feasible set of outcomes, $C_(z^star) y + B_(z^star) x + d_(z^star) = 0$,
determine a linear subspace of this vector space. Define $cal(L):=opker mat(d_(z^star), B_(z^star), C_(z^star)).$ A conditional mean $m$ is feasible at $x$ precisely when
$m in D$ and $w(x,m) in cal(L)$.
]#[The learner’s task is to learn enough about $cal(L)$ to get low regret.
Of course, we may never learn all of $cal(L)$. For example, if nature keeps
choosing conditional means in a strictly smaller subspace, then we cannot
distinguish that subspace from the true $cal(L)$. But this is fine, since we do
not need to learn directions that nature never uses.]

The fact that we never get to observe the true conditional mean, but only a noisy observation of it, adds an extra complication. In a noiseless world, a new observation tells us a new direction of $cal(L)$. Thus we can simply maintain a linear subspace of $RR^(1+d_Z+d_D)$, and incrementally grow it every time we get new information. However, in the presence of noise, no observation can be used to add an entire direction with certainty. Instead, we encode our knowledge of $cal(L)$ with an _ellipsoid_, and incrementally grow it as we get new information. The details are written below.

#[
We first translate and rescale the balls so that
$X={x:norm(x)_2<=1}$ and $D={y:norm(y)_2<=1}$. We continue to write the
reward as $r(x,y)=a^T x+b^T y+c$ and the true subspace as $cal(L)$ in
these coordinates. The new $norm(b)_2$ equals $R_D norm(b)_2$ in the
original coordinates, and the non-tangency constant $S$ stays the same.
Write $q:=1+d_X+d_D$ for the number of coordinates of $w(x,y)$.
For a positive-definite matrix $V$, write
$norm(w)_(V^(-1)):=sqrt(w^T V^(-1)w)$.

#block(breakable: false)[
Define $p_V (x,y):=norm(w(x,y))_(V^(-1))^2,$ and $E_V:={w in RR^q:norm(w)_(V^(-1))^2<=1}.$
]

Here $E_V$ is the ellipsoid we described above, which we incrementally
expand as we get new information about $cal(L)$.
The algorithm works in blocks of length $n$ (we will choose $n$ later
to get a small regret). At the beginning of each block, we choose an
arm $x$ and play the same arm throughout the block.
The ellipsoid $E_V$ stays fixed during these rounds.

To choose an arm, we use our current guess for the feasible conditional
means. For each $x$, this consists of the $m in D$ with
$(1,x,m) in E_V$. If some arm has no such $m$, we choose it to learn
more about it. Otherwise, we choose the arm with the largest worst-case
reward over its guessed feasible means.

At the end of a full block, we average its $n$ observations to get
$overline(y)$. We then check whether $(1,x,overline(y))$ lies in $E_V$.
If it does not, we enlarge the ellipsoid to include it. Otherwise, we
leave the ellipsoid unchanged.

For the time being, we assume that we can carry out the rule for
choosing an arm exactly. We will consider the computational aspects
of the algorithm later.

#algorithm[
  Fix a block length $n in {1,dots,T}$ and initialize $V:=n^(-1)I_q$.
  At the start of each block:

  + For each arm, let

    $ hat(K)_V (x):={y in D:p_V (x,y)<=1}. $

    If any of these sets is empty, choose an arm $x$ with
    $hat(K)_V (x)=emptyset$. Otherwise, define

    $ H_V (x):=min_(y in hat(K)_V (x)) r(x,y), $

    and choose

    $ x in opargmax_(x' in X) H_V (x'). $

  + Play $x$ for $n$ rounds, or until the horizon if fewer rounds remain.
    Let $overline(y)$ be the empirical mean of observed outcomes and
    $overline(w):=w(x,overline(y))$.

  + If the block has length $n$ and $p_V (x,overline(y))>1$, update
    $V<-V+overline(w)overline(w)^T$. Otherwise leave $V$ unchanged.
] <alg:hard-ellipsoid-warmup>

#theorem(title: [Informal])[
  For fixed problem parameters, @alg:hard-ellipsoid-warmup with exact
  planning has expected regret

  $ R_T<=tilde(O)(n+T/sqrt(n)). $

  In particular, choosing $n=ceil(T^(2/3))$ gives
  $R_T<=tilde(O)(T^(2/3))$.
] <thm:hard-ellipsoid-warmup>
]

#[
*Proof sketch.* We will show that, with high probability, throughout the
$T$ time steps, every point in $E_V$ is at most about $1/sqrt(n)$ away
from the true $cal(L)$ (@lem:subspace-distance-bound). We ignore
constants depending on the fixed problem parameters and logarithmic
factors in this sketch.

Now consider an uninformative block, meaning a full block in which we
do not update $V$. The arm $x$ that we play during this block is picked
by maximizing $H_V$. Since the block is uninformative, its
empirical mean outcome satisfies $w(x,overline(y)) in E_V$. These two
facts, together with the distance bound and @lem:subspace-reward-bound,
imply that the average reward is at least $V^star$ minus about
$1/sqrt(n)$. Thus the block's regret (the best arm's guaranteed reward
$n V^star$ minus the reward we actually achieved) is at most about
$n/sqrt(n)=sqrt(n)$.

On the other hand, for an informative block, the empirical mean can
lie outside the ellipsoid, so we only have the trivial regret bound
of $O(n)$.

Finally, the update rule for $V$ ensures that there are at most
$O(log T)$ informative blocks: each update more than doubles the
determinant, whose total growth is bounded by a polynomial in $T$
(see the proof of @thm:hard-ellipsoid-regret). There are at most $T/n$
uninformative blocks, so the total regret is about $n log T+sqrt(n) T/n$.

Ignoring logarithmic factors, this bound is minimized by choosing
$n=ceil(T^(2/3))$, giving an upper bound of
$tilde(O)(T^(2/3))$ on the regret. $qed$

The precise statement and proof are in @app:hard-ellipsoid-analysis[Appendix].
]

#draft[
== Computational tractability <sec:hard-computation>

The matrix updates and the test $p_V (x,overline(y))>1$ can be computed
in polynomial time. The main issue is choosing an arm: we need to find
an empty guessed feasible set, or maximize the worst-case reward if
all these sets are nonempty. We now show how to carry out these steps
to finite precision while retaining the $tilde(O)(T^(2/3))$ regret bound.

Exact emptiness tests can be unstable when the two constraints just
touch. To allow some numerical slack, the implementation uses

$ hat(K)_V^("in") (x):={y in D:p_V (x,y)<=4}, quad
  hat(K)_V^("out") (x):={y in D:p_V (x,y)<=9}. $

It looks for an arm whose inner set is empty, and otherwise plans
against the outer sets. The update rule still uses $p_V>1$. Thus we
only change the arm-selection rule by constant factors in the
ellipsoid's radius.

To find an empty inner set, let $d_V (x)$ be the Euclidean distance
between $2E_V$ and $\{(1,x,y):y in D\}$. Writing $z=(z_0,z_X,z_D)$,
the support functions of the ellipsoid and the unit ball give

$ d_V (x)=max_(norm(z)_2<=1)
    [z_0+z_X^T x-2sqrt(z^T V z)-norm(z_D)_2]. $

In particular, $d_V (x)>0$ certifies that the inner set is empty.
Maximize this expression jointly over $x in X$ and $z$, to additive
accuracy $eta:=1/(10n)$. If the returned lower bound exceeds $eta$,
play the corresponding arm. Otherwise $d_V (x)<=2eta$ for every arm.
The gap between $2E_V$ and $3E_V$ then guarantees that every outer set
is nonempty, with enough room to carry out the remaining optimization.

Define the value used for planning by

$ H_V^("out") (x):=min_(y in hat(K)_V^("out") (x)) r(x,y). $

Convex duality gives

$ H_V^("out") (x)=a^T x+c+max_(norm(z)_2<=M)
    [z_0+z_X^T x-3sqrt(z^T V z)-norm(b+z_D)_2], $

where $M:=4n(1+norm(b)_1)$ suffices. The strict margin obtained above
is what lets us bound the dual variable uniformly over all arms.

Both maximizations reduce to a quadratic program with a fixed number
of quadratic constraints. For example, replace the two norms in the
last display by nonnegative variables $t,s$ satisfying
$z^T V z<=t^2$ and $norm(b+z_D)_2^2<=s^2$. The objective becomes
quadratic in $(x,z,t,s)$. All variables have explicit bounds, so we
can also add a redundant enclosing ball. Bienstock's theorem
@bienstock2016cdt, stated in @app:qcqp[Appendix], solves these problems
to weak additive accuracy in polynomial time. The dual formulas,
the bound on $M$, and the conversion of a weak solution into a valid
arm and a certified lower bound are justified in
@app:hard-computation[Appendix].

The regret argument still works. An empty inner set forces an update,
whereas an uninformative block has its empirical mean in the outer
set. Points in $3E_V$ are at most three times as far from $cal(L)$
as the earlier bound for $E_V$. Thus the two types of blocks still
cost $tilde(O)(n)$ and $tilde(O)(sqrt(n))$, respectively. Maximizing
$H_V^("out")$ to additive accuracy $epsilon$ adds at most $T epsilon$
to the regret. Taking $epsilon=(T+1)^(-2)$, and rounding the observations
to the precision specified in the appendix, gives a polynomial-time
implementation with the same $tilde(O)(T^(2/3))$ rate.

]

#[
= A $sqrt(T)$ learner <sec:soft-square-root>

In the previous section, our bound on the regret incurred during a block
depended on two things: (a) the set of outcomes considered in $H_V$ to
pick the arm for that block, and (b) where the empirical mean of the
actual outcomes lay relative to that set. The learner closes its eyes
during the block, and only looks at the end to see whether
$w(x,overline(y))$ lies inside or outside the ellipsoid $E_V$. Ideally,
if the observations collected so far have an empirical mean
$overline(y)$ with $w(x,overline(y))$ already far outside $E_V$, that
should suggest that the $V$ picked for the block was not appropriate
and we need to update it soon. In this section, we construct a learner
that monitors an observable quantity that lets us bound the regret
accumulated throughout the block, and updates $V$ as soon as this
quantity becomes large. This is the main insight that leads to a $sqrt(T)$ regret.
]

#draft[
To do this, we need an arm-selection rule that gives us a bound we can
evaluate throughout the block, even when $w(x,overline(y))$ lies outside
$E_V$. We obtain this by replacing the hard constraint $p_V (x,y)<=1$
in $H_V$ with a penalty. For a parameter $lambda>0$, which we will
choose later to get a small regret, define

$ U_V (x):=min_(y in D) [r(x,y)+lambda p_V (x,y)]. $

We pick the arm $x$ by maximizing $U_V$. By definition, every outcome
$y in D$ satisfies $U_V (x)-r(x,y)<=lambda p_V (x,y)$. This is what
the penalty buys us: even if an outcome is outside our guessed
feasible set, we still have a bound on how far its reward can fall
below the score. We will show that the chosen arm's score is at least
$V^star$ up to a small error, so controlling this shortfall will also
let us control regret.

To use this bound during a block, we keep $V$ fixed and play the same
arm $x$ repeatedly, but recompute the empirical mean after every
observation. Let $overline(y)_n$ be the mean of the first $n$ outcomes
in the block. Since the reward is affine, the reward accumulated so far
is $n r(x,overline(y)_n)$. Applying the inequality above to this mean
gives

$ n U_V (x)-sum_(i=1)^n r(x,y_i)
    <=lambda n p_V (x,overline(y)_n). $

The right-hand side is the observable quantity described in the first
paragraph. We can compute it after every observation, and it bounds
how far our accumulated reward falls below $n U_V (x)$. We end the
block and update $V$ the first time this bound reaches $lambda$, or
equivalently, when $n p_V (x,overline(y)_n)>=1$. Before this happens,
the accumulated reward falls short of $n U_V (x)$ by less than
$lambda$.

A large empirical penalty can therefore make us update after only a
few observations. A small one lets us keep playing the arm for longer.
The factor $n$ accounts for how long we have been playing: we may need
to update even while the empirical mean satisfies the ellipsoid
constraint, because its penalty has been multiplied by a large block
length. Thus we choose when to update $V$ by monitoring this bound
throughout the block, rather than waiting for a fixed number of rounds.

We use the same coordinates and notation as in the previous section, and set
$lambda:=ceil(sqrt(T))$.

#algorithm[
  Initialize $V:=I_q$. At the start of each block:

  + Define

    $ U_V (x):=min_(y in D) [r(x,y)+lambda p_V (x,y)], $

    and choose an arm $x in X$ with
    $U_V (x)>=max_(x' in X) U_V (x')-epsilon$.

  + Play $x$ repeatedly. After $n$ observations in the block, let

    $ overline(y)_n:=1/n sum_(i=1)^n y_i, quad
      overline(w)_n:=w(x,overline(y)_n). $

    End the block the first time

    $ n p_V (x,overline(y)_n)>=1. $

  + Update $V<-V+n overline(w)_n overline(w)_n^T$ and start a new block.
    At the horizon, stop even if the current block has not ended.
] <alg:soft-square-root>

We give a block mean weight $n$ because averages from longer blocks are
more accurate. This is consistent with the earlier update: multiplying
the warmup matrix by $n$ gives
$I_q+sum_j n overline(w)_j overline(w)_j^T$. We now allow the block
length to vary and use the quadratic form as a penalty.

For the analysis, fix $delta in (0,1)$ and use the quantities
$J_("max"),h_T,B_T,G,C_r$ defined in @app:hard-ellipsoid-analysis[Appendix].
We use the concentration bound from @lem:interval-noise and adapt the
proof of @lem:subspace-distance-bound to the new matrix update.

#theorem[
  Suppose nature follows any compatible adaptive policy. Then
  @alg:soft-square-root, run in exact arithmetic, satisfies with
  probability at least $1-delta$,

  $ T V^star-sum_(t=1)^T r(x_t,y_t)
      <=4lambda(J_("max")+1)+(G^2 B_T^2 T)/(4lambda)+T epsilon, $

  where each planning call maximizes $U_V$ to within $epsilon$. We can
  implement the algorithm in time polynomial in $abs(cM)$ and $T$
  under the weak finite-precision model. Taking
  $epsilon=delta=(T+1)^(-2)$ gives expected regret

  $ R_T<=tilde(O)(
      [q+(1+S^(-1))^2 norm(b)_2^2 q d_D]sqrt(T)
    )+O(C_r/T). $

  The learner does not need to know $S$ or the analysis quantities
  $J_("max"),h_T,B_T,G$.
] <thm:soft-square-root>

*Proof.* As before, each completed block at least doubles the
determinant. The stopping rule gives

$ opdet(V+n overline(w)overline(w)^T)
    =opdet(V)(1+n p_V (x,overline(y)))>=2opdet(V). $

Since $norm(overline(w))_2^2<=3$, the final trace is at most $q+3T$.
Thus, if we complete $J$ blocks,
$2^J<=opdet V<=(1+3T/q)^q$, so $J<=J_("max")$.

We also need to bound how far $n p_V (x,overline(y)_n)$ can jump above
one on the last observation. For $n>=2$, convexity gives

$ n p_V (x,overline(y)_n)
    <=(n-1)p_V (x,overline(y)_(n-1))+p_V (x,y_n)<1+3=4. $

The first term is less than one because we did not stop at $n-1$.
The second is at most three because $V succ.eq I_q$ and
$p_V (x,y_n)<=norm(w(x,y_n))_2^2<=3$. If we stop at $n=1$, the bound is
at most three. If the horizon ends before the test succeeds, it is less
than one. Thus every block satisfies

#set math.equation(numbering: "(1)")
$ n p_V (x,overline(y))<=4. $
  <eq:soft-block-cost>
#set math.equation(numbering: none)

We now adapt the proof of @lem:subspace-distance-bound. Number the
completed blocks $j=1,dots,J$, and let $n_j$ be the length of block $j$. Write $x_j$
for its arm, $overline(y)_j$ and $overline(m)_j$ for its average
observation and conditional mean, and
$overline(w)_j:=w(x_j,overline(y)_j)$. The matrix now has the form

$ V=I_q+sum_(j=1)^J n_j overline(w)_j overline(w)_j^T. $

By @lem:interval-noise, with probability at least $1-delta$, the bound
$(u^T overline(w)_j)^2<=h_T^2/n_j$ holds simultaneously for all completed
blocks and all $u in cal(L)^perp$ with $norm(u)_2<=1$. On this event,

$ u^T V u<=1+sum_(j=1)^J n_j (h_T^2/n_j)
    =1+J h_T^2<=B_T^2. $

This is where the weight $n_j$ matters: it cancels the $1/n_j$ in the
squared noise bound. Each block contributes at most $h_T^2$, however
long it is. Applying Cauchy--Schwarz and taking the supremum over these
$u$ gives

#set math.equation(numbering: "(1)")
$ opdist(w,cal(L))<=B_T norm(w)_(V^(-1)). $
  <eq:soft-subspace-certificate>
#set math.equation(numbering: none)

Next, we compare the score with the true value of an arm.
@lem:subspace-reward-bound gives, for every $x in X$ and $y in D$,

$ v^star (x)<=r(x,y)+G B_T sqrt(p_V (x,y)). $

The error bound grows with $sqrt(p_V (x,y))$, while the penalty grows with
$p_V (x,y)$. Writing $u:=sqrt(p_V (x,y))$ and completing the square,

$ r(x,y)+lambda p_V (x,y)
    >=v^star (x)+lambda u^2-G B_T u
    >=v^star (x)-(G^2 B_T^2)/(4lambda). $

Taking the minimum over $y in D$, we see that the score underestimates
the true value by at most $zeta_T$:

#set math.equation(numbering: "(1)")
$ U_V (x)>=v^star (x)-zeta_T, quad
  zeta_T:=(G^2 B_T^2)/(4lambda). $
  <eq:soft-optimism>
#set math.equation(numbering: none)

We choose an arm whose score is within $epsilon$ of the highest score,
so $U_V (x)>=V^star-zeta_T-epsilon$. The block's empirical mean is in
$D$, and the reward is affine. Its regret is therefore at most

$ n(V^star-r(x,overline(y)))
    <=lambda n p_V (x,overline(y))+n(zeta_T+epsilon)
    <=4lambda+n(zeta_T+epsilon). $

Adding this over at most $J_("max")+1$ blocks proves the high-probability
bound. If the noise bound fails, regret is still at most $C_r T$,
so taking expectations adds at most $C_r T delta$.

The difference from the warmup is that we now pay at most $4lambda$
in penalty per block, no matter how long the block lasts. We also pay
for the score underestimating the true value, but this costs only
$zeta_T$ per round, which decreases as $1/lambda$. The two terms to
balance are therefore $lambda J_("max")$ and $T/lambda$, giving the
square-root rate.

We still need to implement the planning step. First, rewrite the penalty as

$ lambda w^T V^(-1)w
    =max_z [z^T w-(z^T V z)/(4lambda)]. $

The maximizer is $z=2lambda V^(-1)w$. Since $V succ.eq I_q$ and
$norm(w)_2<=sqrt(3)$, we can restrict the maximum to the ball
$norm(z)_2<=4lambda$ for every $x in X$ and $y in D$. For fixed $x$,
the expression is affine in $y$ and concave in $z$, and both domains
are compact and convex. We can therefore exchange the minimum and
maximum. Writing $z=(z_0,z_X,z_D)$ gives

#set math.equation(numbering: "(1)")
$ U_V (x)=a^T x+c+max_(norm(z)_2<=4lambda)
    [z_0+z_X^T x-norm(b+z_D)_2-(z^T V z)/(4lambda)]. $
  <eq:soft-conjugate-planner>
#set math.equation(numbering: none)

#block(breakable: false)[
We can now maximize $U_V$ by solving the QCQP

$ max_(x,z,s) quad
    a^T x+c+z_0+z_X^T x-s-(z^T V z)/(4lambda) $

subject to

$ norm(x)_2^2<=1, quad norm(z)_2^2<=16lambda^2, quad
  norm(b+z_D)_2^2<=s^2, quad 0<=s<=H, $

where $H:=1+norm(b)_1+4lambda$ is rational. We also add the redundant
constraint

$ norm(x)_2^2+norm(z)_2^2/(16lambda^2)+s^2/H^2<=3. $
]

This gives six quadratic inequalities. The last has a positive-definite
quadratic part in all variables, so we can apply Bienstock's
weak-optimization theorem @bienstock2016cdt as described in @app:qcqp.

The solver may return a point that slightly violates the constraints.
We can make its output $(hat(x),hat(z),hat(s))$ feasible by projecting
$hat(x)$ and $hat(z)$ onto their respective balls. Call the resulting
points $x'$ and $z'$, and put $s':=norm(b+z'_D)_2$. If each constraint
violation is at most $tau<=1$, then

$ norm(x'-hat(x))_2<=sqrt(tau), quad
  norm(z'-hat(z))_2<=sqrt(tau), quad s'-hat(s)<=4sqrt(tau). $

The last bound only controls an increase, but this is all we need: the
objective has coefficient $-1$ on $s$. Since
$norm(V)_("op")<=1+3T$, the repair decreases the objective by at most
$K_T sqrt(tau)$, where we can take the rational bound

$ K_T:=20(1+norm(a)_1+lambda+T). $

Choose $tau<=min(1/4,(epsilon/(4(K_T+1)))^2)$. Including the solver's
objective error, the objective at the repaired point is then within
$epsilon/2$ of the optimum. By @eq:soft-conjugate-planner, the same lower bound holds for
$U_V (x')$. The number of precision bits we need is polynomial in
$abs(cM)$, $log(T+1)$, and $log(1/epsilon)$, even when the reward
coefficients are large.

Finally, we round the played arms and observed outcomes to common
rational grids inside their unit balls. Truncating each coordinate
toward zero keeps these points in the balls. The function $U_V$ is
Lipschitz in $x$ with constant at most
$norm(a)_2+2sqrt(3)lambda$, so we choose the arm grid finely enough
that rounding costs at most $epsilon/2$. For outcomes, keep the
Euclidean error at most $tau_y:=(T+1)^(-4)$ and use the rounded
observations in the block averages and updates. Their interval averages
still satisfy @eq:soft-interval-noise after replacing $h_T^2$ by
$2h_T^2+2T tau_y^2$. The bounds on the determinant and the penalty per block stay the
same. Replacing actual rewards by rewards at the rounded observations
changes the cumulative reward by at most $norm(b)_2 T tau_y$. We
therefore obtain the same expected-regret rate, with universal changes
to the displayed high-probability constants.

The stored matrices are rational, with eigenvalues between $1$ and
$1+3T$. The common grids keep bit lengths polynomial when we form block
averages, update and invert the matrices, and compare the stopping
quantity with its threshold exactly. There are at most $J_("max")+1$
planning calls, and the QCQP reduction above makes each call run in
polynomial time. This proves the computational claim. $qed$
]

= NP-hardness

In this section we show that several natural variations of the linear imprecise bandits problem are NP-hard. Thus in some sense, the problem is
the hardest problem that's still tractable.

We first show that efficient planning can be reduced to efficient learning.
Most proofs below show that planning is already NP-hard. Due to the reduction
from planning to learning, this shows that learning is also NP-hard.

#lemma[
  #[
  Fix a linear imprecise bandit instance $cM$.
  Suppose that, for every hypothesis $z in Z$, every arm $x$, and every $eta in (0,1)$, one can compute an outcome
  $y_(z,eta) (x)$ satisfying
  ]

  #[
  $y_(z,eta) (x) in K_z (x)$ and $0<=r(x,y_(z,eta) (x))-v_z (x)<=eta$
  in time polynomial in $|cM|$ and $1/eta$.
  Suppose also that, for some fixed $beta>0$ and polynomial $P$, a
  polynomial-time learner guarantees
  ]
  #[$R_T<=P(|cM|) T^(1-beta)$]

  #[
  Then, for every $z in Z$ and every $epsilon in (0,1)$, one can compute in
  time $poly(|cM|,1/epsilon)$ an arm $hat(x)$ such
  that with probability at least 2/3, $|V_z-v_z (hat(x))|<=epsilon$.
  ]]
 <lem:planning-from-learning>

#draft[
*Proof.* Fix $z in Z$ and $epsilon in (0,1)$, set $eta:=epsilon/6$, and
simulate the learner on $cM$ for
]

#draft[
$ T:=ceil(max(1,(6P(|cM|)/epsilon)^(1/beta))) $
]

#draft[
rounds. Whenever the learner plays $x_t$, let nature use the point mass at
$y_(z,eta) (x_t)$. This is allowed because
$y_(z,eta) (x_t) in K_z (x_t)$. Record the rewards and choose the round
with the largest reward:
]

#draft[
$ tilde(v)_t:=r(x_t,y_(z,eta) (x_t)), quad
  hat(t) in opargmax_(t=1,dots,T) tilde(v)_t, $
]

#draft[
and return $hat(x):=x_(hat(t))$.
]

#draft[
The approximation guarantee gives
$v_z (hat(x))>=tilde(v)_(hat(t))-eta$. Our choice of $hat(t)$ therefore gives
]

#draft[
$ 0<=V_z-v_z (hat(x))
  <=V_z-tilde(v)_(hat(t))+eta
  <=V_z-1/T sum_(t=1)^T tilde(v)_t+eta. $
]

#draft[
Taking expectations and using the definition of $R_T$ for this nature policy,
]

#draft[
$ EE[V_z-v_z (hat(x))]
  <=R_T/T+eta
  <=P(|cM|) T^(-beta)+eta
  <=epsilon/3. $
]

#draft[
The gap $V_z-v_z (hat(x))$ is nonnegative, so Markov's inequality shows
that it exceeds $epsilon$ with probability at most $1/3$.
The horizon and the simulation time are polynomial in $|cM|$ and $1/epsilon$
because $beta$ is fixed. $qed$
]

Below we show that the "smoothness" of $X$ and $D$ are crucial for efficiency. It is easy to land in the NP-hard territory if we make either $X$ or $D$ a convex shape with edges and corners.


== D = simplex, X = ball

First we show that if, instead of a Euclidean ball, we allow $D$ to be a simplex, then even known hypothesis planning becomes NP-hard. Then, using the planning to learning reduction (@lem:planning-from-learning), we conclude that learning is NP-hard.

#theorem[
  Consider a variation of the linear imprecise bandits problem where $D$ is allowed to be a simplex. If, for
  some fixed $beta>0$, a randomized polynomial-time learner guarantees $E[R_T]<=P(|cM|) T^(1-beta)$ for every instance $cM$, then $"NP" subset.eq "BPP"$. If a deterministic learner achieves the same regret guarantee, then $"P"="NP"$.

 <thm:additive-simplex-np-hardness>
]

*Proof.* We reduce from MAX-CUT, as defined in @app:max-cut[Appendix]. Let $(G,k)$ be an
instance, where $G=(V,E)$ has $n$ vertices and $m>=1$ edges and
$k in {1,dots,m}$. Orient the edges arbitrarily and let
$B_G in RR^(m times n)$ be the resulting edge-vertex incidence matrix, i.e., if
$e={i,j}$ is oriented from $j$ to $i$, then row $e$ has $1$ in column $i$,
$-1$ in column $j$, and zeros elsewhere. Put

$ X:={x in RR^m:norm(x)_2<=1}, quad Z:=[1,2]. $

Write an outcome as $y=(p,q,s) in RR^n times RR^n times RR$ and take

$ D:={(p,q,s):p_i>=0, q_i>=0 " for " i=1,dots,n,
      s>=0, sum_(i=1)^n (p_i+q_i)+s=1}. $

Let $gamma>0$ be a constant to be chosen later. For every $z in Z$, let


$ K_z (x):={(p,q,s) in D:p-q=gamma B_G^T x}. $

This is of the form in @eq:setting-compatible-set, where

$ C_z (p,q,s):=p-q, quad
  B_z x:=-gamma B_G^T x, quad d_z:=0. $

Let the reward be

$ r(x,(p,q,s)):=sum_(i=1)^n (p_i+q_i). $

The maps $z mapsto B_z$, $z mapsto C_z$, and $z mapsto d_z$ are constant,
hence affine, as required, and the reward lies in $[0,1]$ on $D$.

In particular, $K_z (x)$ is independent of $z$.

Next we show that, for every $z in Z$, $(G,k)$ is a yes-instance of MAX-CUT
if and only if the constructed imprecise bandit instance has an arm $x in X$
satisfying


$ v_z (x)>=2gamma sqrt(k). $

A vector $sigma in {-1,1}^n$ represents a partition of the vertices of $G$
into the two sides ${i:sigma_i=1}$ and ${i:sigma_i=-1}$. Let
$c_G (sigma)$ denote the number of edges between these sides.

#lemma[
  For every $sigma in {-1,1}^n$,

  $ norm(B_G sigma)_2=2sqrt(c_G (sigma)). $
] <lem:simplex-cut-norm>

*Proof.* Fix $sigma in {-1,1}^n$. For every edge $e={i,j}$,

$ (B_G sigma)_e^2=(sigma_i-sigma_j)^2
  =cases(4 & "if " sigma_i!=sigma_j, 0 & "otherwise"). $

Summing over $e in E$ and taking the square root proves the identity. $qed$

For the forward implication, suppose $(G,k)$ is a yes-instance. Choose
$sigma$ such that $c_G (sigma)>=k$, and define the arm

$ x_sigma:=B_G sigma/norm(B_G sigma)_2. $

Since $c_G (sigma)>=k>=1$, @lem:simplex-cut-norm shows that $x_sigma$ is
well-defined. Moreover, we get the following inequality.

#lemma[
  For every $sigma in {-1,1}^n$ such that $B_G sigma!=0$, we have
  $norm(B_G^T x_sigma)_1>=norm(B_G sigma)_2$. Moreover, equality holds when
  $sigma$ maximizes $norm(B_G sigma)_2$ over ${-1,1}^n$; in particular,
  equality holds for at least one $sigma$.
] <lem:simplex-duality>

#draft[
*Proof.* Choosing the sign of each coordinate gives
]

#draft[
$ norm(B_G^T x_sigma)_1
    =max_(tau in {-1,1}^n) tau^T B_G^T x_sigma
    =max_(tau in {-1,1}^n) x_sigma^T B_G tau. $
]

#draft[
Taking $tau=sigma$ yields
$norm(B_G^T x_sigma)_1>=x_sigma^T B_G sigma=norm(B_G sigma)_2$.
Now let $sigma^star$ maximize $norm(B_G sigma)_2$. Since $m>=1$, this maximum
is positive, so $x_(sigma^star)$ is well-defined. For every
$tau in {-1,1}^n$, Cauchy–Schwarz gives
]

#draft[
$ x_(sigma^star)^T B_G tau
    <=norm(x_(sigma^star))_2 norm(B_G tau)_2
    <=norm(B_G sigma^star)_2. $
]

#draft[
Taking the maximum over $tau$ gives the reverse inequality, proving
equality. $qed$
]

The lemma above gives us a way to link properties of cuts with properties of arms. The missing ingredient is to show that the value of an arm has something to do with $norm(B_G^T x)_1$. We show this in the next two lemmas.

By construction, $x_sigma in X$. Since $K_z (x)$ is independent of $z$, write
$K(x):=K_z (x)={(p,q,s) in D:p-q=gamma B_G^T x}.$

#lemma[
  For every $x in X$, the vector $t:=gamma B_G^T x$ satisfies
  $norm(t)_1<=gamma sqrt(2m n)$. Therefore, if
  $gamma<=1/sqrt(2m n)$, then $norm(t)_1<=1$.
]

#draft[
*Proof.* Each edge coordinate $x_e$ contributes $x_e$ and $-x_e$ to two
coordinates of $B_G^T x$ before contributions from different edges are
added. The triangle inequality therefore gives
]

#draft[
$ norm(t)_1=gamma norm(B_G^T x)_1
  <=2gamma norm(x)_1
  <=2gamma sqrt(m) norm(x)_2
  <=2gamma sqrt(m)
  <=gamma sqrt(2m n), $
]

#draft[
where the second inequality is Cauchy–Schwarz, the third uses
$norm(x)_2<=1$, and the last uses $n>=2$, which follows from $m>=1$. $qed$
]

#lemma[
  Suppose $gamma<=1/sqrt(2m n)$. For each arm $x in X$, set
  $t:=gamma B_G^T x$. Then $K(x)$ is nonempty, and for all $z$,
  $v_z (x)=min_(y in K(x)) r(x,y)=norm(t)_1=gamma norm(B_G^T x)_1$. Moreover, the minimum is attained at the outcome $y=(p,q,s)$ given by
  $p_i:=max(t_i,0)$, $q_i:=max(-t_i,0)$, and $s:=1-norm(t)_1$.
] <lem:simplex-arm-value>

#draft[
*Proof.* Fix $x in X$ and set $t:=gamma B_G^T x$. The preceding lemma
gives $norm(t)_1<=1$. For the outcome in the statement, $p,q,s$ are
nonnegative, $p-q=t$, and
]

#draft[
$ sum_(i=1)^n (p_i+q_i)+s=norm(t)_1+1-norm(t)_1=1. $
]

#draft[
Thus this outcome belongs to $K(x)$. For any $(p,q,s) in K(x)$,
nonnegativity gives $p_i+q_i>=abs(p_i-q_i)=abs(t_i)$ for every $i$, and hence
$r(x,(p,q,s))>=norm(t)_1$. The outcome in the statement attains equality in
every coordinate, so its reward is the minimum. $qed$
]

Note that this also shows that given an arm $x$, we can compute $v_z (x)$ efficiently, which is one of the prerequisites for the application of @lem:planning-from-learning.

For the final step, apply @lem:simplex-arm-value, @lem:simplex-duality, and
@lem:simplex-cut-norm to obtain

$ v_z (x_sigma)
    =gamma norm(B_G^T x_sigma)_1
    >=gamma norm(B_G sigma)_2
    =2gamma sqrt(c_G (sigma))
    >=2gamma sqrt(k). $

For the reverse implication, suppose there is an arm $x in X$ satisfying
$v_z (x)>=2gamma sqrt(k)$. By $ell_1$--$ell_oo$ duality, choose
$sigma in {-1,1}^n$ such that

$ norm(B_G^T x)_1=sigma^T B_G^T x. $

Using @lem:simplex-arm-value and @lem:simplex-cut-norm,

$ 2gamma sqrt(k)
    <=v_z (x)
    =gamma norm(B_G^T x)_1
    =gamma x^T B_G sigma
    <=gamma norm(x)_2 norm(B_G sigma)_2
    <=2gamma sqrt(c_G (sigma)). $

Since $gamma>0$, this implies $c_G (sigma)>=k$, so $(G,k)$ is a yes-instance.
This proves the claimed equivalence.

To apply @lem:planning-from-learning, we need to show that _approximate_
planning is hard. Although the lemma returns only an approximate optimizer,
this is sufficient because the maximum cut size $M_G$ is an integer between
$0$ and $m$, and the corresponding planning values are
$V_z=2gamma sqrt(M_G)$. Taking $gamma:=1/(2m n)$ ensures that every
$K_z (x)$ is nonempty and that consecutive planning values are separated by
at least $1/(2m^2 n)$. Thus an additive approximation with error
$epsilon:=1/(6m^2 n)$ distinguishes $M_G>=k$ from $M_G<=k-1$.

By @lem:simplex-arm-value, we can compute both the value of the returned arm
and a minimizing outcome in polynomial time. We can therefore decide MAX-CUT
by comparing the returned arm's value with the midpoint between
$2gamma sqrt(k-1)$ and $2gamma sqrt(k)$, computed to sufficient precision.
Hence @lem:planning-from-learning implies that a randomized polynomial-time
learner would place MAX-CUT in $"BPP"$, and therefore that
$"NP" subset.eq "BPP"$. A deterministic learner would instead imply
$"P"="NP"$. $qed$


#draft[
== A Euclidean outcome ball and a polytope of arms
]

#draft[
We now keep the Euclidean outcome ball and the additive bilinear constraint,
but allow the arm set to be a polytope given by rational inequalities.
Planning is NP-hard even when the hypothesis is known and the arm set is
the cube. The cube has only $2n$ defining inequalities, but $2^n$ vertices.
]

#theorem[
  #draft[
  Suppose we allow $X$ to be a polytope in the linear imprecise bandits
  problem. If, for some fixed $beta>0$ and polynomial $P$, a randomized
  polynomial-time learner guarantees $R_T<=P(|cM|) T^(1-beta)$ for every
  instance $cM$, then
  $"NP" subset.eq "BPP"$. If a deterministic learner achieves the same
  regret guarantee, then $"P"="NP"$.
  ]
] <thm:additive-polytope-np-hardness>

#draft[
*Proof.* We again reduce from MAX-CUT. Let $G=(V,E)$ have $n$ vertices and
$m>=1$ edges. Orient the edges arbitrarily and let
$B_G in RR^(m times n)$ be the edge-vertex incidence matrix, so that
]

#draft[
$ (B_G x)_e=x_i-x_j $
]

#draft[
for an edge $e={i,j}$. Put
]

#draft[
$ epsilon:=1/(4m), quad X:=[-1,1]^n, quad Z:=[1,2]. $
]

#draft[
Write outcomes as $y=(u,s) in RR^m times RR$ and take
]

#draft[
$ D:={(u,s):norm(u)_2^2+s^2<=1}. $
]

#draft[
With $W=RR^m$, define
]

#draft[
$ F_0 (x,z):=-epsilon z B_G x, quad F_1 ((u,s),z):=z u, $
]

#draft[
The constraint is $F_0 (x,z)+F_1 ((u,s),z)=0$, and the reward is
$r(x,(u,s)):=s$. Both constraint maps are bilinear and the reward is
linear. Since $z!=0$, the constraint is equivalent to
]

#draft[
$ u=epsilon B_G x, $
]

#draft[
so the feasible outcomes do not depend on $z$. Every $x in X$ satisfies
]

#draft[
$ norm(B_G x)_2^2
    =sum_({i,j} in E) (x_i-x_j)^2
    <=4m, $
]

#draft[
so
]

#draft[
$ norm(epsilon B_G x)_2^2<=1/(4m)<=1/4. $
]

#draft[
Thus the feasible outcome set $K_z (x)$ is nonempty for every $x in X$
and $z in Z$. Minimizing $s$ over this set gives
]

#draft[
$ v_z (x)=-sqrt(1-epsilon^2 norm(B_G x)_2^2). $
]

#draft[
Set $q(x):=norm(B_G x)_2^2$. With every coordinate except $x_i$ fixed,
$q(x)$ is a convex quadratic in $x_i$, so replacing $x_i$ by one of the
endpoints of $[-1,1]$ does not decrease $q$. Applying this replacement one
coordinate at a time produces a sign vector $sigma in {-1,1}^n$ with
$q(sigma)>=q(x)$. At a sign vector,
]

#draft[
$ q(sigma)
    =sum_({i,j} in E) (sigma_i-sigma_j)^2
    =4 thin lr(|"cut" (sigma)|). $
]

#draft[
Consequently,
]

#draft[
$ max_(x in [-1,1]^n) q(x)=4 "MaxCut" (G). $
]

#draft[
Since $v_z (x)$ is strictly increasing in $q(x)$, if the maximum cut has
size $k$, the optimal robust value is
]

#draft[
$ V_k=-sqrt(1-k/(4m^2)). $
]

#draft[
For $k=1,dots,m$, consecutive possible values satisfy
]

#draft[
$ V_k-V_(k-1)
  =frac(1/(4m^2),
      sqrt(1-(k-1)/(4m^2))+sqrt(1-k/(4m^2)))
  >=1/(8m^2). $
]

#draft[
Hence an estimate of $V_z$ within
]

#draft[
$ Delta:=1/(32m^2) $
]

#draft[
identifies $k$ after we compute the $m+1$ candidate values to polynomially
many bits. Thus approximating the optimal robust value is NP-hard.
]

#draft[
We now show how to use the learner to find a maximum cut. To simulate
the learner, we need rational outcomes in $K_z (x)$. The outcome attaining
$v_z (x)$ need not be rational, so we compute a rational feasible
approximation. Suppose the learner in the theorem exists and set
]

#draft[
$ eta:=Delta/6, quad
  T:=ceil((6P(|cM|)/Delta)^(1/beta)). $
]

#draft[
In the weak bit model the learner outputs rationally encoded arms. For each
played arm $x_t$, we can use binary search to compute a rational $a_t$ in
polynomial time such that
]

#draft[
$ 0<=sqrt(1-epsilon^2 q(x_t))-a_t<=eta, quad
  a_t^2<=1-epsilon^2 q(x_t). $
]

#draft[
Let nature return the point
]

#draft[
$ y_t:=(epsilon B_G x_t,-a_t). $
]

#draft[
This is a rational point of $K_z (x_t)$, and its reward satisfies
]

#draft[
$ 0<=r(x_t,y_t)-v_z (x_t)<=eta. $
]

#draft[
Writing $V_z=V_k$ and
]

#draft[
$ S_T:=sum_(t=1)^T (V_z-v_z (x_t)), $
]

#draft[
the definition of expected regret gives
]

#draft[
$ E[S_T]<=R_T+T eta. $
]

#draft[
Applying the learner's regret guarantee,
]

#draft[
$ E[S_T]<=P(|cM|) T^(1-beta)+T eta. $
]

#draft[
If the learner never plays a $Delta$-optimal arm, then $S_T>Delta T$.
Markov's inequality and the choices of $T$ and $eta$ imply
]

#draft[
$ Pr("no " Delta "-optimal arm is played")
  <=P(|cM|)/(Delta T^beta)+eta/Delta
  <=1/3. $
]

#draft[
Select a played arm maximizing the rational quantity $q(x_t)$ and round its
coordinates to endpoints without decreasing $q$. With probability at least
$2/3$, the resulting sign vector has robust value at least $V_k-Delta$. A cut
of size at most $k-1$ would instead have robust value at most
$V_(k-1)<=V_k-1/(8m^2)<V_k-Delta$. The rounded sign vector therefore encodes
a maximum cut. The horizon, the square-root approximations, and the rounding
all have polynomial bit complexity, proving $"NP" subset.eq "BPP"$. If the
learner is deterministic, the same argument succeeds with certainty and gives
$"P"="NP"$.
]

#draft[
It remains to verify non-tangency. For a fixed $x$, put
]

#draft[
$ a:=norm(epsilon B_G x)_2, quad rho:=sqrt(1-a^2)>=sqrt(3)/2. $
]

#draft[
The outcomes satisfying the affine constraint form the line $L_z (x)$,
whose intersection with $D$ is $K_z (x)$:
]

#draft[
$ L_z (x)={(epsilon B_G x,s):s in RR}, quad
  K_z (x)={(epsilon B_G x,s):abs(s)<=rho}. $
]

#draft[
If $p=(epsilon B_G x,s) in L_z (x)$ lies outside $D$ and $t:=abs(s)>rho$,
then
]

#draft[
$ opdist(p,K_z (x))=t-rho, quad
  opdist(p,D)=sqrt(a^2+t^2)-1. $
]

#draft[
Factoring the second expression gives
]

#draft[
$ frac(opdist(p,D),opdist(p,K_z (x)))
  =frac(t+rho,sqrt(a^2+t^2)+1)
  >=rho
  >=sqrt(3)/2. $
]

#draft[
To check the first inequality, multiply by the positive denominator,
subtract $rho$ from both sides, and square. This gives the equivalent inequality
$(1-rho^2)(t^2-rho^2)>=0$. Thus the uniform non-tangency condition holds with
$S=sqrt(3)/2$. $qed$
]

#draft[
== Trilinear constraints with Euclidean arm and outcome balls
]

#draft[
We keep the Euclidean arm and outcome balls, but allow the coefficients in
the equations for $y$ to depend on $x$. We add an outcome coordinate
that is fixed to one, so that the constraints are linear in the full
outcome vector with no constant term. Let $Y$ be the ambient outcome
space, let $W$ be the constraint space, and let
]

#draft[
$ F:RR^(d_X) times RR^(d_Z) times Y -> W $
]

#draft[
be linear in each argument separately. For each $x$ and $z$, write
$F_(x,z) (y):=F(x,z,y)$ and define
]

#draft[
$ L_z (x):=opker F_(x,z), quad
  K_z (x):=L_z (x) inter D, quad
  v_z (x):=min_(y in K_z (x)) r(x,y), quad
  V_z:=max_(x in X) v_z (x). $
]

#draft[
Here $D$ is a Euclidean ball in the hyperplane where the added
coordinate equals one. We will show that planning is now NP-hard even
when $z$ is known.
]

#draft[
Let $G=(V,E)$ be an undirected graph with $V={1,dots,n}$ and
$E={e_1,dots,e_m}$, where $m>=1$ and $e_ell={i_ell,j_ell}$. Put $d:=n+m$.
For $q=(u,w) in RR^n times RR^m$, define the homogeneous cubic
]

#draft[
$ p_G (q):=sum_(ell=1)^m u_(i_ell) u_(j_ell) w_ell. $
]

#lemma[
  #draft[
  If $omega(G)$ is the clique number of $G$, then
  ]

  #draft[
  $ max_(norm(q)_2=1) p_G (q)^2
      =2/27 (1-1/omega(G)). $
  ]
] <lem:clique-cubic>

#draft[
*Proof.* Write $rho:=norm(u)_2$ and $sigma:=norm(w)_2$. For fixed $u$ and
$sigma$, Cauchy–Schwarz gives
]

#draft[
$ max_(norm(w)_2=sigma) p_G (u,w)
    =sigma sqrt(sum_(ell=1)^m u_(i_ell)^2 u_(j_ell)^2). $
]

#draft[
Write $u=rho s$ with $norm(s)_2=1$ and set $pi_i:=s_i^2$. The
Motzkin–Straus theorem @motzkin1965maxima gives
]

#draft[
$ max_(norm(s)_2=1) sum_({i,j} in E) s_i^2 s_j^2
  =max_(pi_i>=0, sum_i pi_i=1) sum_({i,j} in E) pi_i pi_j
  =1/2 (1-1/omega(G)). $
]

#draft[
Finally,
]

#draft[
$ max_(rho^2+sigma^2=1, rho>=0, sigma>=0) rho^2 sigma
    =2/(3 sqrt(3)). $
]

#draft[
Substituting these bounds into the first display and squaring proves
the claim. Since $p_G$ is odd, its
maximum equals its maximum absolute value. $qed$
]

#theorem[
  #draft[
  There is a polynomial-time reduction from CLIQUE to imprecise-bandit
  instances with rational coefficients for which $X$ is a full-dimensional
  Euclidean ball, $D$ is a Euclidean ball in its affine hull, $Z=[1,2]$ is a
  one-dimensional Euclidean ball, the reward is linear, and $F$ is
  trilinear. Every set $K_z (x)$ is a singleton independent of $z$.
  The non-tangency inequality holds uniformly for every point in
  $L_z (x)$ outside $D$, with a constant $S>0.88$.
  ]

  #draft[
  For these instances, approximating $V_z$ to inverse-polynomial additive
  accuracy is NP-hard even when $z$ is known. Thus, if, for some
  fixed $beta>0$, a randomized polynomial-time learner guaranteed
  ]

  #draft[
  $ R_T<=P(|cM|) T^(1-beta) $
  ]

  #draft[
  on every such instance for a polynomial $P$, then $"NP" subset.eq "BPP"$.
  For a deterministic learner, the same conclusion would be $"P" = "NP"$.
  ]
] <thm:trilinear-balls-np-hardness>

#draft[
*Proof.* We may restrict CLIQUE to instances with $m>=1$ and
$3<=k<=n$, since we can decide the other cases in polynomial time. Given
$(G,k)$, use the cubic $p_G$ above and write an arm as
$x=(x_0,xi) in RR times RR^d$. Take
]

#draft[
$ X:={(x_0,xi):(x_0-5/3)^2+norm(xi)_2^2<=1}. $
]

#draft[
This is a full-dimensional Euclidean ball and $x_0>=2/3$ throughout $X$.
The ratio $q:=xi/x_0$ ranges over exactly the ball
$norm(q)_2<=3/4$. Indeed,
]

#draft[
$ 1-(x_0-5/3)^2-9/16 x_0^2=-(15x_0-16)^2/144<=0, $
]

#draft[
so every ratio has norm at most $3/4$. Conversely, for any such
$q$, the choice $x_0=16/15$ and $xi=x_0 q$ belongs to $X$.
]

#draft[
Let $Z:=[1,2]$, and take the outcome and constraint spaces to be
]

#draft[
$ Y:=RR times RR^d times RR^(d times d) times RR^(d times d times d), $
]

#draft[
$ W:=RR^d times RR^(d times d) times RR^(d times d times d), $
]

#draft[
and write $y=(y_0,eta,Theta,Xi) in Y$. We fix $y_0=1$ and take the
remaining coordinates to lie in the Euclidean unit ball:
]

#draft[
$ D:={(1,eta,Theta,Xi):
      norm(eta)_2^2+norm(Theta)_F^2+norm(Xi)_F^2<=1}. $
]

#draft[
For $x=(x_0,xi)$, $z in RR$, and $y in Y$, define $F(x,z,y)$ coordinatewise
by
]

#draft[
$ F_i (x,z,y):=z (x_0 eta_i-1/2 xi_i y_0), $
]

#draft[
$ F_(i j) (x,z,y):=z (x_0 Theta_(i j)-xi_i eta_j), $
]

#draft[
$ F_(i j ell) (x,z,y):=z (x_0 Xi_(i j ell)-xi_i Theta_(j ell)). $
]

#draft[
Each term contains one coordinate from each of $x$, $z$, and $y$, so $F$ is
trilinear. Define the reward by
]

#draft[
$ r(x,y):=1/m sum_(ell=1)^m Xi_(i_ell, j_ell, n+ell). $
]

#draft[
It is linear and independent of $x$; its coefficient vector has Euclidean
norm $1/sqrt(m)<=1$.
]

#draft[
Fix $x in X$ and $z in Z$. Since $z x_0!=0$ and $y_0=1$ on $D$, we can solve
$F(x,z,y)=0$ first for $eta$, then for $Theta$, and then for $Xi$. This gives
]

#draft[
$ eta_i=1/2 q_i, quad
  Theta_(i j)=1/2 q_i q_j, quad
  Xi_(i j ell)=1/2 q_i q_j q_ell. $
]

#draft[
Writing $t:=norm(q)_2<=3/4$, the squared norm of $(eta,Theta,Xi)$ is
]

#draft[
$ 1/4 (t^2+t^4+t^6)<=4329/16384<1. $
]

#draft[
Thus this point lies in $D$, so $K_z (x)$ is a singleton independent of $z$.
The map $F_(x,z):Y->W$ is also onto: for any right-hand side, set $y_0=0$
and solve successively for $eta$, $Theta$, and $Xi$.
]

#draft[
Within the hyperplane $y_0=1$, the equations have just one solution, and
that solution lies in $D$. So there are no solutions outside $D$ to check
in the non-tangency condition. We can also prove the distance inequality
for points in the full kernel $L_z (x)$. Since $F_(x,z)$ is onto and the
dimension of $Y$ is one more than that of $W$, this kernel is the line
spanned by $y(x)=(1,g(q))$, where $g(q):=(eta,Theta,Xi)$ is given by the
equations above. If $p=tau y(x) in L_z (x)$ lies outside $D$, then
]

#draft[
$ opdist(p,D)>=abs(tau-1), quad
  opdist(p,K_z (x))=abs(tau-1) sqrt(1+norm(g(q))_2^2). $
]

#draft[
Thus the non-tangency inequality holds for all these points with
]

#draft[
$ S>=1/sqrt(1+4329/16384)=128/sqrt(20713)>0.88. $
]

#draft[
Evaluating the reward at the unique point in $K_z (x)$ gives
]

#draft[
$ v_z (x)=1/(2m) p_G (q). $
]

#draft[
Since $q$ ranges over the radius-$3/4$ ball, homogeneity and
@lem:clique-cubic imply, for every $z in Z$,
]

#draft[
$ V_z
  =27/(128m) max_(norm(h)_2=1) p_G (h)
  =27/(128m) sqrt(2/27) sqrt(1-1/omega(G)). $
]

#draft[
For $j=2,dots,n$, let
]

#draft[
$ U_j:=27/(128m) sqrt(2/27) sqrt(1-1/j). $
]

#draft[
If $omega(G)>=k$, then $V_z>=U_k$; if $omega(G)<=k-1$, then
$V_z<=U_(k-1)$. The gap between these bounds satisfies
]

#draft[
$ U_k-U_(k-1)
  >=27/(128m) sqrt(2/27) 1/(2k(k-1))
  =Omega(1/(m k^2)). $
]

#draft[
Since $sqrt(2/27)>1/4$ and $m<=n^2$, the gap $Delta_k:=U_k-U_(k-1)$
satisfies
]

#draft[
$ Delta_k>1/(40m k(k-1))>=1/(40m n^2). $
]

#draft[
Set $epsilon:=1/(500m n^2)$. Using polynomially many bits, we can compute a
rational $tau_k$ such that
]

#draft[
$ abs(tau_k-1/2 (U_k+U_(k-1)))<=epsilon. $
]

#draft[
An estimate of $V_z$ with additive error at most $epsilon$ lies above
$tau_k$ when $omega(G)>=k$ and below it when $omega(G)<=k-1$, because
$2epsilon<Delta_k/2$. It therefore decides whether $G$ contains a $k$-clique.
The constructed instance has dimension $O(d^3)$, and all its defining
coefficients are rational with polynomial encoding length. This proves the
planning claim.
]

#draft[
Given any rational arm, we can compute the unique point in $K_z (x)$
exactly in polynomial time using the equations above; $x_0>=2/3$ ensures
that we can divide by $x_0$. We can therefore simulate nature by returning
this point. Applying @lem:planning-from-learning with the chosen $epsilon$
gives an estimate of $V_z$ with additive error at most $epsilon$, with
probability at least $2/3$. Comparing it with $tau_k$ decides CLIQUE, so
$"NP" subset.eq "BPP"$. For a deterministic learner, the estimate is
deterministic and gives
$"P" = "NP"$. $qed$
]


#draft[
== Computing IUCB's first arm is NP-hard even for Euclidean balls
]

#draft[
Suppose we are given rational descriptions of $X$, $D$, $Z$, the affine
reward $r$, and the maps defining $K_z (x)$. For each hypothesis $z$, let
]

#draft[
$ v_z (x):=min_(y in K_z (x)) r(x,y). $
]

#draft[
On its first round, IUCB's confidence set is all of $Z$, so its optimistic
value is
]

#draft[
$ V_("IUCB"):=max_(z in Z,x in X) v_z (x). $
]

#draft[
We will show that computing this value exactly is NP-hard. The same is
true of finding an arm
]

#draft[
$ x^star in opargmax_(x in X) max_(z in Z) v_z (x). $
]

#theorem[
  #draft[
  Computing $V_("IUCB")$ exactly or finding a globally optimal first arm
  of IUCB is NP-hard, even when $X$, $D$, and $Z$ are Euclidean balls and
  planning for each fixed hypothesis takes polynomial time.
  ]
] <thm:iucb-np-hardness>

#draft[
*Proof.* Given a rational order-three tensor
$cal(T) in QQ^(m times d times d_X)$, we can view it as a bilinear map
$cal(T):RR^d times RR^(d_X) -> RR^m$. Its spectral norm is
]

#draft[
$ norm(cal(T))_sigma:=max_(norm(u)_2<=1,norm(x)_2<=1)
    norm(cal(T)(u,x))_2. $
]

#draft[
Computing this value exactly is NP-hard @hillar2013most. We construct an
IUCB instance from $cal(T)$ so that an optimal first arm lets us recover
this norm. Let
]

#draft[
$ H:=1+sum_(i,j,k) abs(T_(i j k)), quad
  alpha:=1/(2H), quad X:={x:norm(x)_2<=1}. $
]

#draft[
Write $z=(z_0,u)$ and $y=(w,s)$, and take
]

#draft[
$ Z:={(z_0,u):(z_0-5/3)^2+norm(u)_2^2<=1}, quad
  D:={(w,s):norm(w)_2^2+s^2<=1}. $
]

#draft[
For $z=(z_0,u)$, define the constraint coefficients in
@eq:setting-compatible-set and the reward by
]

#draft[
$ B_z x:=-alpha cal(T)(u,x), quad C_z (w,s):=z_0 w, quad d_z:=0,
  quad r(x,(w,s)):=1/2(1+s). $
]

#draft[
The feasible outcomes at arm $x$ are then
]

#draft[
$ K_z (x)={(w,s) in D:w=alpha/z_0 cal(T)(u,x)}. $
]

#draft[
The definition of $Z$ gives $z_0>=2/3$ and
]

#draft[
$ norm(u)_2/z_0<=3/4, $
]

#draft[
because
$1-(z_0-5/3)^2-9z_0^2/16=-(15z_0-16)^2/144<=0$.
Equality holds at $z_0=16/15$ and $norm(u)_2=4/5$ in every direction.
Also, $norm(cal(T)(u,x))_2<=H norm(u)_2 norm(x)_2$, so the constraint fixes
$w$ to a vector of norm at most $3alpha H/4=3/8$. Thus every $K_z (x)$ is
nonempty, and the uniform non-tangency condition holds with
$S>=sqrt(55)/8$. To minimize the reward, nature chooses the smallest
feasible $s$, namely $s=-sqrt(1-norm(w)_2^2)$. If we write
$h(t):=1/2(1-sqrt(1-t^2))$, then
]

#draft[
$ v_z (x)=h(alpha/z_0 norm(cal(T)(u,x))_2). $
]

#draft[
For fixed $z$, define the matrix $M_u$ by $M_u x:=cal(T)(u,x)$. A top
right singular vector of $M_u$ maximizes $v_z (x)$, so planning takes
polynomial time when $z$ is known. But IUCB must optimize over both $z$
and $x$. Since $h$ is strictly increasing and $norm(u)_2/z_0$ can equal
$3/4$ in every direction,
]

#draft[
$ V_("IUCB")=h(3alpha/4 norm(cal(T))_sigma). $
]

#draft[
We can therefore recover the tensor norm from the optimistic value:
]

#draft[
$ norm(cal(T))_sigma=4/(3alpha)
    sqrt(1-(1-2V_("IUCB"))^2). $
]

#draft[
If we are given only a globally optimal arm $x^star$, define the matrix
$N_x$ by $N_x u:=cal(T)(u,x^star)$. Computing its largest singular value
gives
]

#draft[
$ max_(z in Z) v_z (x^star)=h(3alpha/4 sigma_max (N_x))=V_("IUCB"). $
]

#draft[
The same formula then recovers $norm(cal(T))_sigma$, so finding a globally
optimal first arm is NP-hard as well. $qed$
]

#draft[
== Efficient planning does not imply efficient learning
]

#draft[
An efficient planner for every hypothesis does not always give an
efficient learner, so the converse of @lem:planning-from-learning fails.
We show this with finite arm and hypothesis sets that have short
descriptions. We also allow the reward to be linear in the arm and in the
outcome separately, so it can contain products of arm and outcome
coordinates.
]

#theorem[
  #draft[
  There is a family of rational imprecise-bandit instances indexed by
  integers $2<=k<=n$, with descriptions of length polynomial in $n$.
  Each instance has finite arm and hypothesis sets, an outcome set that is a
  rational polytope, constraints $F=F_0+F_1$ with $F_0=0$ and $F_1$ bilinear
  in the outcome and hypothesis, and a reward
  in $[0,1]$ that is linear in the arm and in the outcome separately.
  An exact planner takes $O(n^2)$ time when the hypothesis is known.
  ]

  #draft[
  Suppose that, for some fixed $beta>0$ and polynomial $P$, one uniform
  randomized policy runs in time polynomial in the description length
  $|cM|$ and horizon $N$ and has expected regret at most
  ]

  #draft[
  $ P(|cM|) N^(1-beta) $
  ]

  #draft[
  for every instance in this family, every true hypothesis, and every
  compatible nature policy. Then $"CLIQUE" in "RP"$ and hence
  $"NP"="RP"$. The same conclusion holds if the guarantee is required
  only against stationary deterministic nature policies. A deterministic
  learner with the same guarantee would imply $"P"="NP"$.
  ]
] <thm:easy-planning-hard-learning>

#draft[
*Proof.* Fix $2<=k<=n$, and let
]

#draft[
$ E_n:={{i,j}:1<=i<j<=n}, quad
  m:=binom(n,2), quad q:=binom(k,2). $
]

#draft[
For every $k$-element set $T subset.eq [n]$, define $x^T in RR^m$ by
]

#draft[
$ x_e^T:=cases(
    1/q & "if " e subset.eq T,
    0 & "otherwise",
  ), quad e in E_n, $
]

#draft[
and take
]

#draft[
$ X:={x^T:T subset.eq [n], abs(T)=k}. $
]

#draft[
An arm is represented succinctly by the vertex set $T$. For every
$k$-element set $U subset.eq [n]$, define $z^U in RR^(1+m)$ by
]

#draft[
$ z_0^U:=1, quad
  z_e^U:=cases(
    1 & "if " e subset.eq U,
    0 & "otherwise",
  ), $
]

#draft[
and let $Z:={z^U:U subset.eq [n], abs(U)=k}$.
]

#draft[
Write an outcome as $y=(y_0,g,s) in RR^(1+2m)$ and set
]

#draft[
$ D:={(1,g,s):g in [0,1]^m, s in [-1,1]^m}. $
]

#draft[
With constraint space $W=RR^m$, let $F_0 (x,z):=0$ and define
]

#draft[
$ (F_1 (y,z))_e
    :=z_e (g_e-y_0-s_e)+z_0 s_e, quad e in E_n. $
]

#draft[
For $z in Z$, set
]

#draft[
$ K_z (x):={y in D:F_0 (x,z)+F_1 (y,z)=0}, quad
  h_z (x):={Q in Delta D:EE_(y ~ Q)[y] in K_z (x)}, $
]

#draft[
and let $H:={h_z:z in Z}$.
]

#draft[
The maps $F_0$ and $F_1$ are bilinear in their displayed arguments. Since
$y_0$ is an outcome coordinate, we can write the constraint as $C_z y=0$,
with $B_z=0$, $d_z=0$, and $z mapsto C_z$ linear. For $z=z^U$,
]

#draft[
$ (F_1 (y,z^U))_e=cases(
    g_e-y_0 & "if " e subset.eq U,
    s_e & "otherwise".
  ) $
]

#draft[
Thus, inside $D$, the constraints force $g_e=1$ for every
$e subset.eq U$ and $s_e=0$ for every $e subset.eq.not U$. The remaining
$g_e$ coordinates are free to vary in $[0,1]$. The feasible set is nonempty: take
$g_e=1$ on the edges of $U$, $g_e=0$ elsewhere, and $s=0$. Moreover,
$y mapsto F_1 (y,z^U)$ is onto $W$: given $w in W$, set $y_0=0$, use
$g_e=w_e$ and $s_e=0$ on the edges of $U$, and use $g_e=0$ and $s_e=w_e$
elsewhere.
]

#draft[
Define the reward
]

#draft[
$ r(x,(y_0,g,s)):=sum_(e in E_n) x_e g_e. $
]

#draft[
The learner is given a succinct description of the entire instance
$cM=(X,D,H,r)$, including $Z$, $F_0$, and $F_1$; only the true $U$ is hidden.
The reward lies in $[0,1]$ on $X times D$. For an arm $x^T$, nature
minimizes it by setting every graph coordinate not forced by $U$ to zero, so
]

#draft[
$ v_(z^U) (x^T)
    =binom(abs(U inter T),2)/q. $
]

#draft[
Thus $V_(z^U)=1$, uniquely attained by $x^U$. Given $z^U$, an exact planner
returns $x^U$ by setting $x_e^U=z_e^U/q$ for every $e in E_n$, which takes
$O(m)=O(n^2)$ time.
]

#draft[
We now show that a learner with the stated regret bound would solve
CLIQUE. Given a graph $G=([n],E(G))$ and target clique size $k$
@garey1979computers, let
]

#draft[
$ g_e^G:=cases(
    1 & "if " e in E(G),
    0 & "otherwise",
  ), quad y^G:=(1,g^G,0) in D. $
]

#draft[
If $U$ is a $k$-clique of $G$, nature can return $y^G$ on every round
under hypothesis $z^U$: every edge inside $U$ has $g_e^G=1$, and all the
$s_e$ coordinates are zero. For every candidate $T$,
]

#draft[
$ r(x^T,y^G)=abs(E(G[T]))/q. $
]

#draft[
This reward is $1$ exactly when $T$ is a $k$-clique, and is at most
$1-1/q$ otherwise.
]

#draft[
Assume the policy in the theorem exists, and give it the outcome $y^G$
on every round. If $G$ contains a $k$-clique $U$, these outcomes are
compatible with $z^U$, whose optimal value is $1$. If the policy plays
$x^(T_1),dots,x^(T_N)$, the total reward it loses relative to this value is
]

#draft[
$ cal(L)_N:=N-sum_(t=1)^N r(x^(T_t),y^G). $
]

#draft[
This quantity is nonnegative. Let $cal(E)$ be the event that none of
$T_1,dots,T_N$ is a clique. On this event, the learner loses at least
$1/q$ on every round, so $cal(L)_N>=N/q$. Markov's inequality and the
assumed regret bound give
]

#draft[
$ Pr(cal(E))
    <=q E[cal(L)_N]/N
    <=q P(|cM|) N^(-beta). $
]

#draft[
Choose
]

#draft[
$ N:=ceil((4 q P(|cM|))^(1/beta)). $
]

#draft[
The instance description has length polynomial in $n$, so $N$ and the
time needed to simulate the learner are polynomial in the CLIQUE input
length. Check each $k$-set proposed by the learner and accept as soon as
one is a clique in $G$. If $G$ has a $k$-clique, the preceding bound gives
acceptance probability at least $3/4$. If $G$ has none, none of the
proposed sets can pass this check. In that case, the outcomes may be
incompatible with every hypothesis, but the learner must still terminate
in polynomial time on every syntactically valid history. Thus the
simulation also takes polynomial time when $G$ has no $k$-clique.
]

#draft[
This is an RP algorithm for CLIQUE. Since CLIQUE is NP-complete, it implies
$"NP"="RP"$. If the policy is deterministic, the same verified search gives
$"P"="NP"$. $qed$
]

#draft[
This example shows that efficient planning alone does not suffice for
efficient learning. It uses exponentially large finite sets $X$ and $Z$
represented by $k$-subsets, a polytope $D$, and the bilinear reward
$r(x,y)=sum_e x_e g_e$. It therefore falls outside our setting of Euclidean
balls and jointly affine rewards.
]

#bibliography(
  "imprecise_bandits_T8_9_upper_bound_clean.bib",
  title: [#draft[References]],
  style: "ieee",
)

#pagebreak()
#heading(level: 1, numbering: none)[#draft[Appendix]]
#counter(heading).update(0)
#set heading(numbering: "A.")

#draft[
= Quadratically constrained quadratic programming <app:qcqp>
]

#draft[
For symmetric matrices $Q_i in RR^(d times d)$, a *quadratically constrained
quadratic program* (QCQP) in $z in RR^d$ has the form
]

#draft[
$ min_(z in RR^d) g_0 (z) quad "subject to" quad
  g_i (z)<=0, quad i=1,dots,m, $
]

#draft[
where $g_i (z):=z^T Q_i z+2p_i^T z+r_i$; for complexity statements, all
entries are rational. A quadratic equality $h(z)=0$ is exactly the pair
$h(z)<=0$ and $-h(z)<=0$ @bienstock2016cdt.
]

#draft[
QCQP describes algebraic form, whereas convex programming describes geometry.
The displayed minimization problem is a convex program when every $Q_i$,
$i=0,dots,m$, is positive semidefinite and all equalities are affine
@boyd2004convex. Without those restrictions it can be nonconvex: general QCQP
is NP-hard even when only the objective is quadratic and its Hessian has one
negative eigenvalue @pardalos1991negative.
]

#draft[
The polynomial-time conclusion for our nonconvex instance has two steps.
]

+ #draft[
  First, fix the number $m$ of constraints. Bienstock's theorem states that,
  for rational quadratics $g_0,dots,g_m$, if at least one constraint
  $g_i (z)<=0$ has a positive-definite quadratic part, then for every
  $epsilon in (0,1)$ an algorithm runs in time
  $poly(L,log(1/epsilon))$, where $L$ is the input bit length, and either
  proves infeasibility or returns $hat(z)$ such that
  ]

  #draft[
  $ g_i (hat(z))<=epsilon, quad i=1,dots,m, $
  ]

  #draft[
  and $g_0 (hat(z))<=g_0 (z)+epsilon$ for every feasible $z$
  @bienstock2016cdt. The underlying weak-feasibility step reduces to a fixed
  number of homogeneous quadratic equations on a sphere, handled by
  Barvinok's method; binary search then gives the objective guarantee
  @barvinok1993feasibility @bienstock2016cdt.
  ]

+ #draft[
  Second, the planning reduction in @sec:soft-square-root has six
  quadratic inequalities. The redundant ellipsoid constraint on
  $(x,z,s)$ has a positive-definite quadratic part, so the QCQP
  satisfies Bienstock's hypotheses. Applying the theorem to the negative
  objective computes the planning maximum to weak additive accuracy
  $epsilon$ in time $poly(L,log(1/epsilon))$. The same section explains
  how to repair the solver's output to obtain a feasible arm. If either
  radius is zero, the problem first reduces to a lower-dimensional instance.
  ]

#draft[
= MAX-CUT <app:max-cut>
]

#draft[
Let $G=(V,E)$ be a finite undirected simple graph. For $S subset.eq V$, the
edge boundary of $S$ is
]

#draft[
$ delta_G (S):={{u,v} in E:abs({u,v} inter S)=1}. $
]

#draft[
The decision problem MAX-CUT takes as input $G$ and an integer
$k in {0,dots,abs(E)}$, and asks whether
]

#draft[
$ exists S subset.eq V quad "such that" quad abs(delta_G (S))>=k. $
]

#draft[
A set $S$ satisfying this inequality is a polynomial-size certificate, so
MAX-CUT belongs to NP. Karp proved that weighted MAX-CUT is NP-complete
@karp1972reducibility. Garey, Johnson, and Stockmeyer subsequently proved
that the unweighted problem defined above remains NP-complete even when $G$
is cubic @garey1976simplified.
]

#draft[
The associated optimization problem computes
]

#draft[
$ M_G:=max_(S subset.eq V) abs(delta_G (S)). $
]

#draft[
Since the decision problem asks whether $M_G>=k$, computing $M_G$ is NP-hard.
]

#draft[
= Regret analysis of the $T^(2/3)$ learner <app:hard-ellipsoid-analysis>

We give the precise statement and proof of @thm:hard-ellipsoid-warmup.
We use the coordinates and notation from @sec:hard-ellipsoid-warmup,
and assume that the planning steps in @alg:hard-ellipsoid-warmup are
solved exactly. A full block is _informative_ if it causes an update,
and _uninformative_ otherwise.

#block(breakable: false)[
For the analysis, fix $delta in (0,1)$ and define

$ J_("max") &:=ceil(q log_2 (1+3T/q)), \
  h_T^2 &:=8d_D log((2d_D T^2)/delta), \
  B_T^2 &:=1+J_("max") h_T^2, \
  G &:=sqrt(3)(1+S^(-1))norm(b)_2, \
  C_r &:=max_(X times D) r-min_(X times D) r. $
]

We write $J$ for the number of updates actually made. We will show
that $J<=J_("max")$.

If $w(x,y)$ is close to $cal(L)$, then $r(x,y)$ cannot be much smaller
than the worst feasible reward $v^star (x)$. We first prove this.

#lemma[
  For every $x in X$ and $y in D$,

  $ v^star (x)<=r(x,y)+G opdist(w(x,y),cal(L)). $
] <lem:subspace-reward-bound>

*Proof.* Let $N:=opker C_(z^star)$ and let $Q$ be the orthogonal projector
onto $N^perp$. Every arm has a feasible outcome, so we can write the
minimum-norm solution of the affine constraints as
$f(x)=A x+e in N^perp$. Thus

$ K^star (x)=(A x+e+N) inter D. $

Since there is a feasible outcome in the unit ball for every arm,
$norm(A x+e)_2<=1$ on $X$. Taking $x=0$ gives $norm(e)_2<=1$, and
comparing opposite unit vectors gives $norm(A)_("op")<=1$. Now define

$ Phi(s,x,y):=Q y-A x-s e. $

This map has operator norm at most $sqrt(3)$ and kernel $cal(L)$: the
original constraints are equivalent to $Q y=A x+e$, and homogenizing
either equation gives the same subspace. Therefore

$ opdist(y,A x+e+N)=norm(Phi(1,x,y))_2
    <=sqrt(3)opdist(w(x,y),cal(L)). $

Let $p$ be the point in $A x+e+N$ closest to $y$. Since $y in D$,
the non-tangency condition gives

$ opdist(p,K^star (x))<=S^(-1)opdist(p,D)
    <=S^(-1)norm(p-y)_2, $

where the first inequality is immediate if $p in D$, since then
$p in K^star (x)$. The triangle inequality now gives

$ opdist(y,K^star (x))
    <=(1+S^(-1))opdist(y,A x+e+N). $

Moving $y$ to the nearest point in $K^star (x)$ changes the reward by
at most $norm(b)_2$ times this distance, which proves the claim. $qed$

We also need to know how close a block average is to the average of the
true conditional means.

#lemma[
  Let $m_t$ be the conditional mean of $y_t$ given the history and the
  chosen arm on round $t$. For each interval in the first $T$ rounds,
  write $n$ for its length and $overline(y)$ and $overline(m)$ for the
  averages of $y_t$ and $m_t$ over that interval. With probability at
  least $1-delta$, the bound

  #set math.equation(numbering: "(1)")
  $ n norm(overline(y)-overline(m))_2^2<=h_T^2 $
    <eq:soft-interval-noise>
  #set math.equation(numbering: none)

  holds simultaneously on all these intervals.
] <lem:interval-noise>

*Proof.* Each coordinate of $y_t-m_t$ is a martingale difference
bounded in absolute value by two. For any fixed interval of length
$n$ and coordinate $i$, Azuma--Hoeffding gives

$ Pr(abs(overline(y)_i-overline(m)_i)>h_T/sqrt(n d_D))
    <=2 exp(-h_T^2/(8d_D))=delta/(d_D T^2). $

There are $d_D$ coordinates and at most $T^2$ intervals. A union bound
and summing the squared coordinate bounds give the claim. $qed$

We need to know how far a point in $E_V$ can be from $cal(L)$.
The next lemma bounds this distance using the noise bound we just
proved. We can then apply @lem:subspace-reward-bound to the outcomes
the learner treats as feasible.

#lemma[
  With probability at least $1-delta$, after any number $J$ of updates
  in @alg:hard-ellipsoid-warmup, the matrix $V$ satisfies, for every
  $w in RR^q$,

  $ opdist(w,cal(L))
      <=sqrt((1+J h_T^2)/n) norm(w)_(V^(-1)). $
] <lem:subspace-distance-bound>

*Proof.* Number the informative blocks $j=1,dots,J$. Write $x_j$ for
the arm played in block $j$, and $overline(y)_j$ and $overline(m)_j$
for its average observation and average conditional mean. With
$overline(w)_j:=w(x_j,overline(y)_j)$, the update rule gives

$ V=n^(-1)I_q+sum_(j=1)^J overline(w)_j overline(w)_j^T. $

Fix $u in cal(L)^perp$ with $norm(u)_2<=1$. Since the arm is held
fixed within each block, $w(x_j,overline(m)_j) in cal(L)$. Each
informative block has length $n$. By @lem:interval-noise, with
probability at least $1-delta$, the bound

$ (u^T overline(w)_j)^2
    =(u^T (0,0,overline(y)_j-overline(m)_j))^2<=h_T^2/n $

holds simultaneously for all informative blocks and all such $u$.
On this event, $u^T V u<=(1+J h_T^2)/n$. For any $w$,
Cauchy--Schwarz gives $u^T w<=sqrt(u^T V u)norm(w)_(V^(-1))$.
Taking the supremum over the unit ball of $cal(L)^perp$ proves the
claim. $qed$

#theorem[
  Suppose nature follows any compatible adaptive policy. Then
  @alg:hard-ellipsoid-warmup satisfies, with probability at least $1-delta$,

  $ T V^star-sum_(t=1)^T r(x_t,y_t)
      <=C_r n(J_("max")+1)+(G B_T T)/sqrt(n). $

  Its expected regret is at most the same expression plus
  $C_r T delta$. Taking $n=ceil(T^(2/3))$ and
  $delta=(T+1)^(-2)$ give $R_T<=tilde(O)(T^(2/3))$ for fixed problem
  parameters.
] <thm:hard-ellipsoid-regret>

*Proof.* First, there cannot be very many informative blocks. Each one
more than doubles the determinant:

$ opdet(V+overline(w)overline(w)^T)
    =opdet(V)(1+p_V (x,overline(y)))>2opdet(V). $

If there are $J$ updates, then $J<=T/n$. Each update adds at most three
to the trace, so $optr V<=q/n+3J<=(q+3T)/n$. The initial determinant
is $n^(-q)$. Using the arithmetic--geometric mean inequality on the
eigenvalues, we get

$ 2^J<=(opdet V)/(opdet(n^(-1)I_q))<=(1+3T/q)^q, quad J<=J_("max"). $

Since $J<=J_("max")$, @lem:subspace-distance-bound gives, with probability
at least $1-delta$, simultaneously for every matrix $V$ that the
learner maintains and every $(x,y) in X times D$,

#set math.equation(numbering: "(1)")
$ opdist(w(x,y),cal(L))<=(B_T/sqrt(n))sqrt(p_V (x,y)). $
  <eq:hard-subspace-certificate>
#set math.equation(numbering: none)

On this event, if $y in hat(K)_V (x)$, then $p_V (x,y)<=1$, so
@lem:subspace-reward-bound gives
$r(x,y)>=v^star (x)-G B_T/sqrt(n)$. Taking the minimum over
$hat(K)_V (x)$, whenever this set is nonempty, gives

#set math.equation(numbering: "(1)")
$ H_V (x)>=v^star (x)-G B_T/sqrt(n). $
  <eq:hard-optimism>
#set math.equation(numbering: none)

Consider a full block in which we do not update the ellipsoid. Its
empirical mean belongs to $hat(K)_V (x)$. Such a block could not have
used the empty-set rule, since that would force the mean outside the
ellipsoid. Thus all the sets $hat(K)_V (x')$ were nonempty, and we
chose $x$ by maximizing $H_V$. It follows that

$ r(x,overline(y))>=H_V (x)=max_(x' in X) H_V (x')
    >=V^star-G B_T/sqrt(n). $

Since the reward is affine, $r(x,overline(y))$ is the average reward
in the block. The block's regret is therefore at most $G B_T sqrt(n)$.
There are at most $T/n$ such blocks, for a total of $G B_T T/sqrt(n)$.
An informative block may cost as much as $C_r n$, but there are at most
$J_("max")$ of them. A final incomplete block also costs at most $C_r n$.
Adding these bounds proves the high-probability claim. Outside this
event, regret is still at most $C_r T$, so taking expectations
adds at most $C_r T delta$. $qed$

== Finite-precision implementation <app:hard-computation>

We justify the implementation in @sec:hard-computation. The matrix
always satisfies

$ n^(-1)I_q prec.eq V prec.eq (n^(-1)+3T)I_q, $

since each update adds a positive semidefinite matrix of operator norm
at most three. In particular, $E_V$ contains the Euclidean ball of
radius $1/sqrt(n)$.

The distance formula follows by writing distance to $2E_V$ as

$ opdist(w,2E_V)=max_(norm(z)_2<=1)
    [z^T w-2sqrt(z^T V z)]. $

Minimizing over $w=(1,x,y)$ with $y in D$ and exchanging the minimum
and maximum gives the claimed expression for $d_V (x)$. The exchange
is valid because the domains are compact and convex, and the
objective is affine in $y$ and concave in $z$.

Suppose the empty-set test has not returned an arm. Its additive
guarantee gives $d_V (x)<=2eta$ for every $x$. Thus, for every arm,
there is a $y_0 in D$ such that $w_0:=w(x,y_0)$ satisfies

$ norm(w_0)_(V^(-1))<=2+2eta sqrt(n)<=11/5. $

This point lies strictly inside $3E_V$. We may therefore apply convex
duality to the constraint $w(x,y) in 3E_V$, whose indicator has the
representation

$ iota_(3E_V) (w)=sup_z [z^T w-3sqrt(z^T V z)], $

where the indicator is zero on the set and $+infinity$ outside it.
Strong duality holds because $y_0 in D$ and $w_0$ is in the interior
of $3E_V$ @boyd2004convex. Minimizing the resulting affine expression
over the unit ball $D$ gives the formula for $H_V^("out")$, initially
with a supremum over all $z$.

To bound $z$, write the expression inside that supremum as $F_x (z)$.
Using $norm(y_0)_2<=1$ and Cauchy--Schwarz in the $V$ norm gives

$ F_x (z)
    &<=b^T y_0+z^T w_0-3sqrt(z^T V z) \
    &<=norm(b)_2-4/5 sqrt(z^T V z) \
    &<=norm(b)_2-4/(5sqrt(n)) norm(z)_2. $

Since $F_x (0)=-norm(b)_2$, the supremum is attained at a point with
$norm(z)_2<=(5/2)sqrt(n)norm(b)_2$. This is smaller than the bound
$M$ used in the implementation.

We next give the quadratic programs explicitly. For the distance
problem take $(alpha,g,R)=(2,0,1)$, and for the planning problem take
$(alpha,g,R)=(3,b,M)$. Replace
$alpha sqrt(z^T V z)+norm(g+z_D)_2$ by $alpha t+s$ and impose

$ norm(x)_2^2<=1, quad norm(z)_2^2<=R^2, quad
  z^T V z<=t^2, quad norm(g+z_D)_2^2<=s^2, $

$ 0<=t<=1+(1+3T)R, quad 0<=s<=1+norm(g)_1+R. $

The remaining objective is $z_0+z_X^T x-alpha t-s$, with the additional
term $a^T x+c$ for planning. The upper bounds leave room beyond the
largest possible values of the two norms. Adding a redundant ball
containing all these bounded variables gives nine quadratic
inequalities, one with a positive-definite quadratic part.
The result in @app:qcqp[Appendix] therefore applies.

A weak solution may slightly violate these constraints. Project its
$x$ and $z$ components onto their balls and round inward to rational
grids. Replace $t$ and $s$ by rational upper approximations to the
corresponding norms. The resulting objective is a valid lower bound
on $d_V (x)$ or $H_V^("out") (x)$ at the returned arm. If the weak
constraint error is $tau$, projection moves each vector by at most
$sqrt(tau)$; the changes in the two norms and the quadratic objective
are bounded by a polynomial in the numerical data and $T$ times
$sqrt(tau)$. Thus both the required objective accuracy and a certified
lower bound can be obtained with polynomially many precision bits.
For the distance test, include all these errors in its additive
budget $eta$: a returned lower bound above $eta$ then certifies
emptiness, and a lower bound at most $eta$ implies
$max_(x in X) d_V (x)<=2eta$.

Finally, round each observed outcome inward to a common rational grid,
with Euclidean error at most
$tau_y:=(T+1)^(-4)/(1+norm(b)_1)$. Use these rounded observations in
the block averages and updates. The interval bound in
@lem:interval-noise remains valid with $h_T^2$ replaced by
$2h_T^2+2T tau_y^2$. The matrix-distance proof and the determinant
argument therefore still apply. An uninformative rounded mean belongs
to $E_V$, and hence to both the inner and outer sets. Consequently
such a block must have used the planning rule. Applying
@lem:subspace-reward-bound and the matrix-distance bound on $3E_V$
gives the same regret estimate with the geometric term multiplied
by three, an additional $T epsilon$ for planning error, and at most
$norm(b)_2 T tau_y$ for replacing the actual rewards by rounded ones.

The common grids keep all stored matrices rational with polynomial
bit length. Matrix inversion and the comparison $p_V>1$ can then be
performed exactly in polynomial time. There are at most
$ceil(T/n)$ planning calls, each taking time polynomial in the input
bit length, $T$, and $log(1/epsilon)$. This proves the claimed
implementation and regret bound. $qed$
]
