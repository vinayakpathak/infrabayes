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
$z^star in Z$ be the unknown true hypothesis. Each hypothesis $z in Z$
determines matrices $B_z$ and $C_z$ and a vector $d_z$ of compatible
dimensions. For every $z in Z$ and $x in A$, define

#set math.equation(numbering: "(1)")
$ K_z (x) := {y in D : C_z y + B_z x + d_z = 0}. $ <eq:setting-fiber>
#set math.equation(numbering: none)

The true feasible outcome set is $K^star (x) := K_(z^star)(x)$.

We assume throughout that $K^star (x)$ is nonempty for every $x in A$.

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

#theorem(title: [efficient $T^(8/9)$ learning])[
  Suppose that the known problem data in the setting above are rational.
  For every known horizon $T$, there
  is a policy whose arithmetic and weak-optimization running time is
  polynomial in $T$ and the input bit length and which, for every true
  hypothesis and every compatible adaptive nature policy, satisfies

  $ E[R_T] <= tilde(O)(P(d_A,d_D,R_A,R_D,norm(b)_2,C_r) T^(8/9)), $

  where $P$ is a fixed polynomial. No geometric property of $Z$ is used
  beyond its inducing a valid family of compatible sets of the form
  @eq:setting-fiber.
] <thm:efficient-upper-bound>

= Warmup: Noiseless Setting

In this section, playing an arm $x$ reveals an exact feasible response
$y in K^star (x)$; there is no sampling noise. However, there still is the Knightian uncertainty corresponding to the adversary picking an arbitrary outcome inside $K^star (x)$.

#lemma[
  There exist an affine map
  $f: A -> RR^(d_D)$ and a fixed linear subspace
  $N subset.eq RR^(d_D)$ such that

  $ K^star (x) = (f(x) + N) inter D, quad x in A. $

  Equivalently, before intersecting with $D$, the feasible sets form a family
  of parallel affine spaces.
] <lem:noiseless-affine-fibers>

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

*Proof.* Let $x^((0)), dots, x^((d_A))$ be any affine basis of $A$. Play them in sequence and let $y^((0)),dots, y^((d_A))$ be the corresponding outcomes chosen by the adversary. Let $hat(f)$ be the unique affine interpolator for which $hat(f)(x^((i))) = y^((i))$ for all $i$. Since $y^((i)) in K^star (x^((i)))$, we have that $hat(f)(x^((i)))+N = f(x^((i)))+N$ for all $i$. Since $x^((i))$'s form an affine basis, therefore $hat(f)(x)+N = f(x)+N$ for all $x in A$.
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

It remains to compute the arm in the planning step. Let $c_A$ and $c_D$ be
the centres of $A$ and $D$, and let $P_t$ be the orthogonal projector onto
$N_t$. Define

$ q_t(x):=c_D+(I-P_t)(hat(f)(x)-c_D). $

This is the point in $hat(f)(x)+N_t$ closest to $c_D$. Consequently,
$K'_t(x)$ is nonempty exactly when

$ norm(q_t(x)-c_D)_2 <= R_D, $

and, whenever it is nonempty,

$ K'_t(x)=q_t(x)+
    {u in N_t: norm(u)_2 <=
      sqrt(R_D^2-norm(q_t(x)-c_D)_2^2)}. $

Since $q_t$ is affine, an arm with an empty provisional fiber can be found by
maximizing $norm(q_t(x)-c_D)_2^2$ over the ball $A$. This is a trust-region
problem; see @more1983computing.

When every provisional fiber is nonempty, put
$beta_t:=norm(P_t b)_2$. The inner minimization over outcomes is explicit:

$ v'_t(x)=a^T x+b^T q_t(x)+c
    -beta_t sqrt(R_D^2-norm(q_t(x)-c_D)_2^2). $

Introducing a scalar $s >= 0$, maximizing this value over $A$ is equivalent
to the quadratic program

$ max_(x,s) a^T x+b^T q_t(x)+c-beta_t s $

subject to

$ norm(x-c_A)_2^2 <= R_A^2, quad
  s^2+norm(q_t(x)-c_D)_2^2=R_D^2, quad s>=0. $

This problem has a fixed number of quadratic constraints. After adding the
redundant ellipsoidal bound

$ norm(x-c_A)_2^2/R_A^2+s^2/R_D^2 <= 2, $

Bienstock's fixed-constraint QCQP result @bienstock2016cdt computes an
optimizer to any desired additive accuracy in time polynomial in the input
bit length and the number of requested accuracy bits. Taking accuracy
$T^(-2)$ adds at most $T^(-1)$ to the total regret. Since the provisional
model changes only when $N_t$ is updated, the planning problem needs to be
solved at most $d_D+1$ times.

The trust-region and QCQP claims use the standard weak, additive-accuracy
model. With finite-precision data, exact comparisons at the boundary of an
empty fiber require the usual tolerance or gray-zone convention; this issue
will be handled together with the other finite-precision errors in the noisy
analysis.

= Noisy Setting

#lemma[
  Fix $delta in (0,1)$ and an integer $n >= 1$. There exist affinely
  independent arms $x^((0)),dots,x^((d_A)) in A$ with the following
  property. Play each arm for $n$ consecutive rounds, let

  $ bar(y)^((i)) := 1/n sum_(s=1)^n y_s^((i)) $

  be its average observed outcome, and let $hat(f)$ be the unique affine map
  satisfying $hat(f)(x^((i)))=bar(y)^((i))$ for every $i=0,dots,d_A$.
  Then, against every compatible adaptive nature policy, with probability at
  least $1-delta$ there exists an affine map $f:A -> RR^(d_D)$ such that

  $ K^star (x)=(f(x)+N) inter D, quad x in A, $

  and

  $ sup_(x in A) norm(hat(f)(x)-f(x))_2
    <= (1+2sqrt(d_A)) 2sqrt(2) R_D
      sqrt((d_D log((2d_D(d_A+1))/delta))/n). $

  In particular, the uniform interpolation error is
  $tilde(O)(n^(-1/2))$.
] <lem:noisy-anchor-interpolation>

In the noisy setting, taking the span of the observed residuals is unstable:
even a small amount of noise can introduce a spurious direction. We therefore
replace the subspace $N_t$ by a learned residual ellipsoid.

#lemma[
  Fix $delta in (0,1)$ and a block length $n$. Let $hat(f)$ be the empirical
  affine interpolant constructed in @lem:noisy-anchor-interpolation, and put

  $ L_A:=1+2sqrt(d_A), quad
    epsilon_(n,delta):=2sqrt(2)R_D
      sqrt((d_D log((2d_D T)/delta))/n), $

  $ eta_(n,delta):=(1+L_A)epsilon_(n,delta), quad
    R_0:=(1+L_A)R_D, $

  and

  $ M_("max"):=d_D log_2(1+(T R_0^2)/(d_D eta_(n,delta)^2)). $

  The update rule in @alg:noisy-ridge-learning can be implemented in
  polynomial time and maintains an explicitly represented ellipsoid
  $cal(E)_M subset.eq RR^(d_D)$ centred at the origin, where $M$ is the number
  of blocks declared informative. Against every compatible adaptive nature
  policy, with probability at least $1-delta$, there is an affine map
  $f:A -> RR^(d_D)$ satisfying

  $ K^star (x)=(f(x)+N) inter D, quad x in A, $

  such that, simultaneously throughout the horizon:

  - If a block at arm $x$ is not declared informative and $bar(y)$ is its
    empirical average outcome, then
    $ bar(y)-hat(f)(x) in cal(E)_M. $

  - The number of informative blocks satisfies $M <= M_("max")$.

  - For every $gamma >= 0$, every $x in A$, and every
    $u in gamma cal(E)_M$,

    $ opdist(hat(f)(x)+u,f(x)+N)
      <= L_A epsilon_(n,delta)
        +gamma(sqrt(M_("max"))+1)eta_(n,delta). $

  In particular, the learned affine spaces have uniform error
  $tilde(O)(n^(-1/2))$, while only $tilde(O)(d_D)$ blocks are informative.
] <lem:ridge-residual-learning>

#algorithm(title: [Noisy ridge-ellipsoid imprecise bandit])[
  #set enum(numbering: "1.", indent: 1.5em, body-indent: 0.55em)

  + Choose the $d_A+1$ anchor arms from
    @lem:noisy-anchor-interpolation. Play each anchor for $n$ consecutive
    rounds, compute its empirical average $bar(y)^((i))$, and construct the
    affine interpolant $hat(f)$. If the horizon ends during this phase, stop.

  + Set $lambda:=rho:=eta_(n,delta)$, with $eta_(n,delta)$ as defined in
    @lem:ridge-residual-learning. Initialize $M:=0$ and let $hat(G)_0$ be the
    matrix with no columns.

  + At the beginning of each subsequent block, define

    $ V_M:=lambda^2 I+hat(G)_M hat(G)_M^T, quad
      cal(E)_M:={u:u^T V_M^(-1)u<=1}. $

    Let $c_D$ be the centre of $D$, and define the expanded outcome balls

    $ D_1:={y:norm(y-c_D)_2<=R_D+rho}, quad
      D_2:={y:norm(y-c_D)_2<=R_D+2rho}. $

    For every arm $x in A$, define the inner and outer provisional fibers

    $ hat(K)_M^("in")(x):=(hat(f)(x)+2cal(E)_M) inter D_1, $

    $ hat(K)_M^("out")(x):=(hat(f)(x)+3cal(E)_M) inter D_2. $

  + If $hat(K)_M^("in")(x)=emptyset$ for some $x in A$, choose any such arm.
    Otherwise, choose

    $ x in opargmax_(x' in A)
        min_(y in hat(K)_M^("out")(x')) r(x',y). $

  + Play the chosen arm for $n$ rounds. If fewer than $n$ rounds remain,
    play until the horizon and stop without updating. Otherwise, let
    $bar(y)$ be the block-average outcome and set

    $ hat(g):=bar(y)-hat(f)(x). $

  + If

    $ hat(g)^T V_M^(-1)hat(g)>1, $

    declare the block informative, set
    $hat(G)_(M+1):=[hat(G)_M,hat(g)]$, and then increase $M$ by one. Otherwise
    leave $hat(G)_M$ and $M$ unchanged. Return to Step 3 and continue until
    time $T$.
] <alg:noisy-ridge-learning>

#bibliography(
  "imprecise_bandits_T8_9_upper_bound_clean.bib",
  title: [References],
  style: "ieee",
)
