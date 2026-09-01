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

Here $B_z$, $C_z$, and $d_z$ are matrices and vectors of
appropriate dimensions that are linear in terms of $z$. Now, hypothesis $h_z: X -> credal D$ is given by

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
coefficients, and $H$ by a description of $Z$ together with the linear maps
$z mapsto (B_z,C_z,d_z)$. We restrict attention to succinctly represented
instances, for which $|cM| <= poly(d_X,d_D,d_Z)$.
]

Now we state our main result.

#draft[#theorem(title: [efficient $T^(2/3)$ learning])[
  #[
  There exists a policy for linear imprecise bandits as defined above that, for every time horizon $T$ and every true hypothesis $h^star in H$, runs in polynomial time, and achieves a regret
  ] $R_T <= tilde(O)(
      poly(|cM|) T^(2/3))$.
] <thm:efficient-upper-bound>
]
#draft[
= Warmup: Noiseless Setting
]

#draft[
In this section, playing an arm $x$ reveals an exact feasible response
$y in K^star (x)$; there is no sampling noise. However, there still is the Knightian uncertainty corresponding to the adversary picking an arbitrary outcome inside $K^star (x)$.
]

#draft[
Let $N:=opker C_(z^star)$.
]

#lemma[
  #draft[
  There exists an affine map $f_z: X -> RR^(d_D)$ and a linear subspace $N_z$ independent of $x$ such that
  ]

  #draft[
  $ f_z (x)+N_z
      ={y in RR^(d_D):C_(z)y+B_(z)x+d_(z)=0},
      quad x in X. $
  ]

  #draft[
  Consequently, there exists an $f$ and $N$ such that
  ]

  #draft[
  $ K^star (x)=(f(x)+N) inter D, quad x in X. $
  ]
] <lem:noiseless-affine-spaces>

#draft[
*Proof.* Fix $x$ and let $y_1, y_2 in K_z (x)$. Then $C_z (y_1 - y_2) = 0$, which means $y_1-y_2$ must lie in a subspace determined by $z$. We can pick some $y in K_z (x)$ arbitrarily and set $f_z (x) = y$. This is clearly an affine mapping. $qed$
]

#draft[
Note that as the proof demonstrates, $f_z$ need not be unique. Indeed, for each $z$ there can be multiple $f_z$'s that satisfy the requirement of the lemma. However, each $z$ determines a unique $N_z$.
]


#lemma[
  #draft[
  Suppose that, for every arm $x in X$, we have identified a nonempty set
  $K'(x) subset.eq K^star (x)$, and suppose that whenever the learner plays
  $x$, nature chooses an outcome in $K'(x)$. Define
  ]

  #draft[
  $ v'(x) := min_(y in K'(x)) r(x,y), $
  ]

  #draft[
  and choose
  ]

  #draft[
  $ x' in opargmax_(x in X) v'(x). $
  ]

  #draft[
  Then playing $x'$ on every round incurs nonpositive regret with
  respect to the original robust benchmark, i.e. $R_T <= 0$.
  ]
] <lem:inner-feasible-set>

#lemma[
  #draft[
  There exist $d_X+1$ arms $x^((0)),dots,x^((d_X)) in X$ such that, from any
  possible sequence of responses
  $y^((i)) in K^star (x^((i)))$, we can compute an affine map $hat(f)$ such that
  $ K^star (x) = (hat(f)(x) + N) inter D, quad x in X. $
  ]
] <lem:noiseless-anchor-identification>

#draft[
*Proof.* Let $f$ be any affine map supplied by
@lem:noiseless-affine-spaces. Let $x^((0)), dots, x^((d_X))$ be any affine
basis of $X$. Play them in sequence and let
$y^((0)),dots, y^((d_X))$ be the corresponding outcomes chosen by the
adversary. Let $hat(f)$ be the unique affine interpolator for which
$hat(f)(x^((i))) = y^((i))$ for all $i$. Since
$y^((i)) in K^star (x^((i)))$, we have that
$hat(f)(x^((i)))+N = f(x^((i)))+N$ for all $i$. Since the $x^((i))$ form an
affine basis, $hat(f)(x)+N = f(x)+N$ for all $x in X$.
 $qed$
]

#algorithm(title: [#draft[Noiseless imprecise bandit]])[
  #set enum(numbering: "1.", indent: 1.5em, body-indent: 0.55em)

  + #draft[
    Play the $d_X+1$ arms from @lem:noiseless-anchor-identification and use
    their responses to construct $hat(f)$.
    ]

  + #draft[
    Initialize $N_(d_X+2) := {0}$.
    ]

  + #draft[
    For each round $t=d_X+2,dots,T$:
    ]
    - #draft[
      For every $x in X$, define the provisional feasible set
      $ K'_t (x) := (hat(f)(x)+N_t) inter D. $
      ]

    - #draft[
      If $K'_t (x)=emptyset$ for some $x in X$, choose any such arm as
      $x_t$. Otherwise, choose
      $ x_t in opargmax_(x in X) min_(y in K'_t (x)) r(x,y). $
      ]

    - #draft[
      Play $x_t$ and observe $y_t$.
      ]

    - #draft[
      If $y_t-hat(f)(x_t) in.not N_t$, set
      $ N_(t+1) := opspan(N_t union {y_t-hat(f)(x_t)}). $
      Otherwise, set $N_(t+1):=N_t$.
      ]
] <alg:noiseless-subspace-learning>

#draft[
Every $N_t$ maintained by @alg:noiseless-subspace-learning is a subspace of
$N$. Whenever it is updated, its dimension increases by one. Moreover, if a
provisional feasible set is empty, playing an arm with an empty provisional
set necessarily triggers such an update. There can therefore be at most
$dim(N) <= d_D$ update rounds.
]

#draft[
On every remaining round, all the provisional feasible sets are nonempty and
the observed response belongs to $K'_t (x_t)$. Hence
@lem:inner-feasible-set shows that the reward on that round is at least the
original robust benchmark. Charging at most a constant regret to each of the
$d_X+1$ initial rounds and to each update round gives $R_T <= O(d_X+d_D). $
]

#draft[
== Computational Tractability
]

#draft[
All the steps in @alg:noiseless-subspace-learning can be carried out in
polynomial time. First, affine interpolation can be done via Gaussian elimination.
]

#draft[
The subspace $N_t$ can be stored through an orthonormal basis. Given the new
residual
]

#draft[
$ h_t:=y_t-hat(f)(x_t), $
]

#draft[
project $h_t$ onto $N_t^perp$. If the projection is zero, the span does not
change. Otherwise, normalize the projection and append it to the stored
basis. This is an incremental Gram--Schmidt and takes
polynomial time.
]

#draft[
It remains to compute the arm in the planning step.
]

#lemma[
  #draft[
  Fix a round $t$. Given rational descriptions of $X,D,hat(f)$, and $N_t$,
  one can compute, in polynomially many arithmetic operations, an arm
  $x_("emp") in X$ such that, if $K'_t (x)=emptyset$ for some $x in X$,
  then $K'_t (x_("emp"))=emptyset$.
  ]
] <lem:polynomial-empty-set>

#draft[
*Proof.* Clearly, for a given $x$, the set $K'_t (x)$ is empty if and only if the distance between $c_D$ and $hat(f)(x) + N_t$ is bigger than $R_D$. Thus to decide if there exists an $x in X$ for which $K'_t (x)$ is empty, we need to find the arm that maximizes the distance between $c_D$ and $hat(f)(x) + N_t$. To see why this can be done in polynomial time, let $q_t (x)$ be the point in $hat(f)(x) + N_t$ that is closest to $c_D$. Note that $q_t (x)$ can be written as an affine function.
]

#draft[
$ q_t (x):=c_D+(I-P_t)(hat(f)(x)-c_D). $
]

#draft[
Here $P_t$ is the projection on $N_t$.
]

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
  caption: [#draft[Two-dimensional outcome geometry when $N_t$ is one-dimensional.
    The dashed segment is orthogonal to $hat(f)(x)+N_t$, so its endpoint is
    $q_t (x)$, the point on that line closest to $c_D$.]],
) <fig:q-projection>

#draft[
Now we need to compute
]

#draft[
$ x_("emp") in opargmax_(x in X) norm(q_t (x)-c_D)_2^2. $
]

#draft[
This is a quadratic optimization problem over the Euclidean ball $X$, which is polynomial-time solvable using the result in @more1983computing. $qed$
]

#lemma[
  #draft[
  Fix a round $t$ and suppose that $K'_t (x)$ is nonempty for every $x in X$.
  Let the rational problem data have total bit length $L$. For every
  $epsilon in (0,1)$, one can compute an arm $x_epsilon in X$ in time
  $poly(L,log(1/epsilon))$ such that
  ]

  #draft[
  $ min_(y in K'_t (x_epsilon)) r(x_epsilon,y)
    >= max_(x in X) min_(y in K'_t (x)) r(x,y)-epsilon. $
  ]
] <lem:polynomial-robust-planning>

#draft[
*Proof.* Compute the orthogonal projector $P_t$ onto $N_t$ as in the proof of
@lem:polynomial-empty-set, and define
]

#draft[
$ q_t (x):=c_D+(I-P_t)(hat(f)(x)-c_D). $
]

#draft[
Since every provisional set is nonempty, Pythagoras' theorem gives
]

#draft[
$ K'_t (x)=q_t (x)+
    {u in N_t: norm(u)_2 <=
      sqrt(R_D^2-norm(q_t (x)-c_D)_2^2)}. $
]

#draft[
Put $beta_t:=norm(P_t b)_2$. For a fixed arm $x$, minimizing the linear
reward over the displayed ball moves in direction $-P_t b$, and hence
]

#draft[
$ v'_t (x):=min_(y in K'_t (x)) r(x,y)
  =a^T x+b^T q_t (x)+c
    -beta_t sqrt(R_D^2-norm(q_t (x)-c_D)_2^2). $
]

#draft[
Introduce a scalar $s>=0$. Maximizing $v'_t$ is equivalent to the QCQP
]

#draft[
$ max_(x,s) a^T x+b^T q_t (x)+c-beta_t s $
]

#draft[
subject to
]

#draft[
$ norm(x-c_X)_2^2<=R_X^2, quad
  s^2+norm(q_t (x)-c_D)_2^2=R_D^2, quad s>=0, $
]

#draft[
where $c_X$ is the centre of $X$. Represent the equality by two quadratic
inequalities. If $R_X,R_D>0$, add the redundant constraint
]

#draft[
$ norm(x-c_X)_2^2/R_X^2+s^2/R_D^2<=2. $
]

#draft[
This is an ellipsoid in the joint variable $(x,s)$. Thus the QCQP has a fixed
number of quadratic constraints, one of which is ellipsoidal. Bienstock's
theorem @bienstock2016cdt returns, in time polynomial in $L$ and $log(1/delta)$, a solution $(x^star,s^star)$ such that for each constraint $g_i (x,s)<= 0$, we have that $g_i (x^star, s^star) <= delta$, and the value of the objective function $Phi_t (x,s):=a^T x+b^T q_t (x)+c-beta_t s$ at $(x^star, s^star)$ is $delta$-close to the optimal, i.e., for every feasible $(x,s)$, $Phi_t (x^star,s^star)>=Phi_t (x,s)-delta$.
]

#draft[
The output $x^star$ of Bienstock's algorithm may not be a feasible arm. But to obtain a feasible arm, we can simply project
$x^star$ onto $X$ to obtain $x_epsilon$. It is easy to see that this does not change the value of the objective function too much. Indeed, set $s_epsilon:=sqrt(R_D^2-norm(q_t (x_epsilon)-c_D)_2^2).$
The projection moves
$x^star$ by $O(sqrt(delta))$, and thus moves $s^star$ by at most
$O(delta^(1/4))$. Consequently the linear objective
changes by at most $C delta^(1/4)$, where $C>=1$ is a constant. Choose
$delta<=(epsilon/(2C))^4$. The resulting arm is feasible and its robust value is within
$epsilon$ of the optimum. Since
$log(1/delta)=poly(L)+O(log(1/epsilon))$, the running time is polynomial. $qed$
]

#draft[
Set $epsilon=T^(-2)$ in @lem:polynomial-robust-planning. On each round, the
computed arm then loses at most $T^(-2)$ relative to the exact planning
solution, so approximate planning contributes at most $T^(-1)$ to total
regret.
]

#draft[
= Noisy Setting
]

#draft[
In this section, constants hidden by $O$ and $tilde(O)$ may depend on the
fixed problem parameters. In addition, $tilde(O)$ suppresses logarithmic
factors in $T$ and $1/delta$.
]

#draft[
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
]

#lemma[
  #draft[
  Fix $delta in (0,1)$ and $1<=n<=T$. There exist $d_X+1$ affinely
  independent anchor arms such that, after playing each arm for $n$ rounds
  and interpolating their empirical average outcomes, the resulting affine
  map $hat(f)$ satisfies the following with probability at least $1-delta$.
  There is an affine map $f$ and a linear subspace $N$ such that
  $K^star (x)=(f(x)+N) inter D$ and
  ]

  #draft[
  $ sup_(x in X) norm(hat(f)(x)-f(x))_2
    <= tilde(O)(n^(-1/2)). $
  ]
] <lem:noisy-anchor-interpolation>

#draft[
*Proof.* Let $x^((0)),dots,x^((d_X))$ be any affine basis of $X$. Play each
arm for $n$ rounds. Let $overline(y)^((i))$ be the average observed outcome
for arm $i$, and let $overline(m)^((i))$ be the corresponding average conditional mean. Since
$K^star (x^((i)))$ is convex, $overline(m)^((i)) in K^star (x^((i)))$.
Let $hat(f)$ and $f$ be the unique affine interpolators satisfying
$hat(f) (x^((i)))=overline(y)^((i))$ and
$f(x^((i)))=overline(m)^((i))$ for every $i$. By
@lem:noiseless-anchor-identification,
$K^star (x)=(f(x)+N) inter D$ for every $x in X$.
]

#draft[
Within each block, $y_t-m_t$ is a martingale-difference sequence. Since $D$
is bounded, the Azuma--Hoeffding inequality for bounded martingale
differences (see @hoeffding1963probability @azuma1967weighted), together with
a union bound over the finitely many anchors and outcome coordinates, implies
that, with probability at least $1-delta$,
]

#draft[
$ max_(0 <= i <= d_X)
    norm(overline(y)^((i))-overline(m)^((i)))_2
  <=tilde(O)(n^(-1/2)). $
]

#draft[
Now consider an arbitrary $x in X$, and let
$alpha_0,dots,alpha_(d_X)$ be its affine coordinates with respect to the
chosen basis. Since $X$ is compact, there is a constant $L$, independent of
$x$, such that
]

#draft[
$ sum_(i=0)^(d_X) abs(alpha_i)<=L. $
]

#draft[
Since $hat(f)$ and $f$ are affine and agree with the corresponding values at
the anchors,
]

#draft[
$ norm(hat(f) (x)-f(x))_2
  <=sum_(i=0)^(d_X) abs(alpha_i)
    norm(overline(y)^((i))-overline(m)^((i)))_2
  <=L tilde(O)(n^(-1/2)). $
]

#draft[
Taking the supremum over $x in X$ proves the result. $qed$
]

#draft[
In the noisy setting, taking the span of the observed residuals is unstable:
even a small amount of noise can introduce a spurious direction. We therefore
replace the subspace $N_t$ by a learned residual ellipsoid.
]

#draft[
Fix $delta in (0,1)$ and $1<=n<=T$, and let $hat(f)$ and $f$ be as in
@lem:noisy-anchor-interpolation. One can choose
$lambda=tilde(O)(n^(-1/2))$ with $lambda>=n^(-1/2)$ so that, conditional on
the anchor conclusion, the conclusions of the following two lemmas hold
simultaneously throughout the horizon with probability at least $1-delta$.
]

#algorithm(title: [#draft[Noisy imprecise bandit $(n,lambda)$]])[
  #set enum(numbering: "1.", indent: 1.5em, body-indent: 0.55em)

  #draft[
  *Parameters:* block length $n in NN$ and ridge parameter $lambda>0$.
  ]

  + #draft[
    Choose the $d_X+1$ anchor arms from
    @lem:noisy-anchor-interpolation. Play each anchor for $n$ consecutive
    rounds, compute its empirical average $overline(y)^((i))$, and construct
    the affine interpolant $hat(f)$. If the horizon ends during this phase,
    stop.
    ]

  + #draft[
    Initialize $M:=0$ and let $hat(G)_0$ be the matrix with no columns.
    ]

  + #draft[
    At the beginning of each subsequent block, define
    ]

    #draft[
    $ V_M:=lambda^2 I_(d_D)+hat(G)_M hat(G)_M^T
        in RR^(d_D times d_D), quad
      cal(E)_M:={u in RR^(d_D):u^T V_M^(-1)u<=1}. $
    ]

    #draft[
    For every arm $x in X$, define
    ]

    #draft[
    $ hat(K)_M (x):=(hat(f)(x)+cal(E)_M) inter D. $
    ]

  + #draft[
    If $hat(K)_M (x)=emptyset$ for some $x in X$, choose any such arm.
    Otherwise, choose
    ]

    #draft[
    $ x in opargmax_(x' in X)
        min_(y in hat(K)_M (x')) r(x',y). $
    ]

  + #draft[
    Play the chosen arm for $n$ rounds. If fewer than $n$ rounds remain, play
    until the horizon and stop without updating. Otherwise, let $overline(y)$
    be the block-average outcome and set
    ]

    #draft[
    $ hat(g):=overline(y)-hat(f)(x). $
    ]

  + #draft[
    If $hat(g) in.not cal(E)_M$, declare the block informative, set
    $hat(G)_(M+1):=[hat(G)_M,hat(g)]$, and then increase $M$ by one. Otherwise
    leave $hat(G)_M$ and $M$ unchanged. Return to Step 3 and continue until
    time $T$.
    ]
] <alg:noisy-ridge-learning>

#lemma[
  #draft[
  At most $O(log T)$ blocks of @alg:noisy-ridge-learning are informative.
  ]
] <lem:ridge-informative-blocks>

#draft[
*Proof.* Enumerate the stored residuals as
$hat(g)_1,dots,hat(g)_M$. After $j$ of them have been stored,
]

#draft[
$ V_j:=lambda^2 I_(d_D)
    +sum_(i=1)^j hat(g)_i hat(g)_i^T. $
]

#draft[
Every block average lies in $D$. The anchor averages also lie in $D$, and
affine interpolation from the fixed anchors has uniformly bounded
coefficients on the compact set $X$. Hence
$norm(hat(g)_j)_2=O(1)$ for every block.
]

#draft[
When $hat(g)_j$ is stored, the block is informative, so
]

#draft[
$ hat(g)_j^T V_(j-1)^(-1)hat(g)_j>1. $
]

#draft[
The matrix determinant lemma @bernstein2009matrix therefore gives
]

#draft[
$ opdet(V_j)
    =opdet(V_(j-1))
      (1+hat(g)_j^T V_(j-1)^(-1)hat(g)_j)
    >2opdet(V_(j-1)). $
]

#draft[
Since $V_0=lambda^2 I_(d_D)$, iteration yields
]

#draft[
$ opdet(V_M)>2^M lambda^(2d_D). $
]

#draft[
On the other hand, $M<=T/n$, and therefore
]

#draft[
$ optr(V_M)
    =d_D lambda^2+sum_(j=1)^M norm(hat(g)_j)_2^2
    <=d_D lambda^2+O(T/n). $
]

#draft[
Applying the arithmetic--geometric mean inequality to the eigenvalues of
$V_M$ gives
]

#draft[
$ opdet(V_M)<= (lambda^2+O(T/n))^(d_D). $
]

#draft[
Combining the two determinant bounds,
]

#draft[
$ M<=d_D log_2 (1+O(T/(n lambda^2)))=O(log T), $
]

#draft[
where the last equality uses $lambda>=n^(-1/2)$. $qed$
]

#lemma[
  #draft[
  Let $hat(f)$ be the empirical affine interpolant constructed during the
  anchor phase of @alg:noisy-ridge-learning, and let $f$ be the affine
  interpolant of the corresponding average conditional means, as in
  @lem:noisy-anchor-interpolation. For every current ellipsoid $cal(E)_M$,
  every $x in X$, and every $u in cal(E)_M$,
  ]

  #draft[
  $ opdist(hat(f)(x)+u,f(x)+N) <= tilde(O)(n^(-1/2)). $
  ]
] <lem:ridge-residual-learning>

#draft[
*Proof.* We prove by induction on $M$.
]

#draft[
We first show that this bound holds for the initial matrix
$V_0=lambda^2 I_(d_D)$, and then show that it remains true after every update
from $V_M$ to $V_(M+1)$.
]

#draft[
For the initial matrix $V_0=lambda^2 I_(d_D)$, the ellipsoid $cal(E)_0$ is
the Euclidean ball of radius $lambda$. By @lem:noisy-anchor-interpolation,
there exists some $beta_n<=tilde(O)(n^(-1/2))$ such that
$norm(hat(f)(x)-f(x))_2<=beta_n$ for every $x in X$. Therefore, by the
triangle inequality, for every $x in X$ and $u in cal(E)_0$,
]

#draft[
$ opdist(hat(f)(x)+u,f(x)+N)
    <=norm(hat(f)(x)-f(x))_2+norm(u)_2
    <=beta_n+lambda <= tilde(O)(n^(-1/2)). $
]

#draft[
Thus the claimed bound holds when $M=0$.
]

#draft[
Geometrically, $hat(f)(x)+cal(E)_0$ is a ball of radius $lambda$ centred at
$hat(f)(x)$, while $f(x)+N$ is the affine space that we want this ball to
remain close to. Each informative update adds a new generating direction
$hat(g)$ to the ellipsoid. The component of $hat(g)$ lying in $N$ only moves
the ellipsoid parallel to $f(x)+N$ and therefore does not increase the
distance from that affine space. Only the component orthogonal to $N$ matters.
Thus, if $hat(g)$ is within $eta_n$ of $N$, one update can increase the
distance by at most $eta_n$. An uninformative block does not change the
ellipsoid at all.
]

#draft[
To make this precise, consider a complete block $cal(B)$ at arm $x$ and let
]

#draft[
$ overline(m):=1/n sum_(t in cal(B)) m_t. $
]

#draft[
Since $overline(m) in K^star (x)$, the vector
$g:=overline(m)-f(x)$ belongs to $N$. The empirical residual is
$hat(g):=overline(y)-hat(f)(x)$. Conditionally on the history at the beginning
of any adaptively selected block, the vectors $y_t-m_t$ remain martingale
differences. The same concentration argument as in
@lem:noisy-anchor-interpolation, followed by a union bound over the at most
$T/n$ complete blocks, therefore gives, simultaneously for every block,
]

#draft[
$ norm(overline(y)-overline(m))_2<=tilde(O)(n^(-1/2)). $
]

#draft[
Combining this with the uniform anchor-interpolation bound gives
]

#draft[
$ norm(hat(g)-g)_2<=tilde(O)(n^(-1/2)). $
]

#draft[
We may therefore choose $eta_n=tilde(O)(n^(-1/2))$ so that every stored
residual satisfies $opdist(hat(g),N)<=eta_n$. We prove the following more
explicit form of the induction claim:
]

#draft[
$ opdist(hat(f)(x)+u,f(x)+N)
    <=beta_n+lambda+M eta_n, quad
  x in X, u in cal(E)_M. $
]

#draft[
The base case above establishes this claim when $M=0$.
]

#draft[
Now consider an update from $V_M$ to $V_(M+1)$. Suppose that the bound holds
for $M$ and that the informative block producing the update has residual
$hat(g)$. Let $Q_M:=[hat(G)_M,lambda I_(d_D)]$. Since
$Q_M Q_M^T=V_M$ and $Q_M$ has full row rank,
]

#draft[
$ cal(E)_M={Q_M theta:norm(theta)_2<=1}. $
]

#draft[
After storing $hat(g)$, every $u in cal(E)_(M+1)$ can therefore be written as
]

#draft[
$ u=Q_M theta+a hat(g), quad norm(theta)_2^2+a^2<=1. $
]

#draft[
Set $u_0:=Q_M theta$. Then $u_0 in cal(E)_M$, and since $N$ is a linear
subspace, for every $x in X$,
]

#draft[
$ opdist(hat(f)(x)+u,f(x)+N)
    <=opdist(hat(f)(x)+u_0,f(x)+N)
      +abs(a)opdist(hat(g),N)
    <=beta_n+lambda+(M+1)eta_n. $
]

#draft[
This proves the induction claim. By @lem:ridge-informative-blocks,
$M=O(log T)$, and therefore
]

#draft[
$ beta_n+lambda+M eta_n=tilde(O)(n^(-1/2)). $
]

#draft[
#h(1fr) $qed$
]

#lemma[
  #draft[
  Under the uniform non-tangency condition, for every $x in X$ and every
  $y in RR^(d_D)$,
  ]

  #draft[
  $ opdist(y,K^star (x))
      <=(1+S^(-1))opdist(y,f(x)+N)+S^(-1)opdist(y,D). $
  ]

  #draft[
  In particular, if $y in D$, then
  ]

  #draft[
  $ opdist(y,K^star (x))
      <=(1+S^(-1))opdist(y,f(x)+N). $
  ]
] <lem:noisy-ball-stability>

#draft[
*Proof.* Let $p$ be the Euclidean projection of $y$ onto $f(x)+N$. If
$p in D$, then $p in K^star (x)$ and the result is immediate. Otherwise, the
uniform non-tangency condition and the triangle inequality give
]

#draft[
$ opdist(p,K^star (x))
    <=S^(-1)opdist(p,D)
    <=S^(-1) (norm(y-p)_2+opdist(y,D)). $
]

#draft[
Since $norm(y-p)_2=opdist(y,f(x)+N)$, one more application of the triangle
inequality proves the first claim. The second follows by setting
$opdist(y,D)=0$. $qed$
]

#lemma[
  #draft[
  Suppose that the conclusions of @lem:noisy-anchor-interpolation and
  @lem:ridge-residual-learning hold. Let $cal(B)$ be a complete $n$-round
  block that is declared uninformative, and let $x$ be the arm played in that
  block. Then its realized average regret satisfies
  ]

  #draft[
  $ 1/n sum_(t in cal(B)) (V^star-r(x,y_t))
      <= tilde(O)(n^(-1/2)). $
  ]
] <lem:noisy-uninformative-block>

#draft[
*Proof.* Let $M$ be the state at the start of the block and let
]

#draft[
$ overline(y):=1/n sum_(t in cal(B)) y_t. $
]

#draft[
Since the block is uninformative,
$hat(g):=overline(y)-hat(f)(x)$ belongs to $cal(E)_M$.
]

#draft[
Since $D$ is convex, $overline(y) in D$. Therefore,
]

#draft[
$ overline(y) in (hat(f)(x)+cal(E)_M) inter D=hat(K)_M (x). $
]

#draft[
In particular, this block could not have been selected by the empty-set
branch of Step 4, so its arm was selected by the planning rule. Define
]

#draft[
$ hat(v)_M (x'):=min_(y in hat(K)_M (x')) r(x',y). $
]

#draft[
For every $x' in X$ and $y in hat(K)_M (x')$,
@lem:ridge-residual-learning gives
]

#draft[
$ opdist(y,f(x')+N)<=tilde(O)(n^(-1/2)). $
]

#draft[
Since $y in D$, applying @lem:noisy-ball-stability gives
]

#draft[
$ opdist(y,K^star (x'))
    <=tilde(O)(n^(-1/2)). $
]

#draft[
Since the reward is Lipschitz in its outcome argument,
]

#draft[
$ hat(v)_M (x')
    >=v^star (x')-tilde(O)(n^(-1/2)). $
]

#draft[
Let $x^star$ maximize $v^star$. The planning rule and the fact that
$overline(y) in hat(K)_M (x)$ now give
]

#draft[
$ r(x,overline(y))
    >=hat(v)_M (x)
    >=hat(v)_M (x^star)
    >=V^star-tilde(O)(n^(-1/2)). $
]

#draft[
Finally, the reward is affine in the outcome and the arm is fixed throughout
the block, so
]

#draft[
$ r(x,overline(y))=1/n sum_(t in cal(B)) r(x,y_t). $
]

#draft[
This proves the average-regret bound.  $qed$
]

#draft[
Taking $delta=(T+1)^(-2)$, $n=ceil(T^(2/3))$, and $lambda$ chosen as above
now gives the claimed regret rate. The anchor
phase, the $O(log T)$ informative blocks from
@lem:ridge-informative-blocks, and the final partial block contribute
$tilde(O)(n)$ regret. By
@lem:noisy-uninformative-block, all remaining rounds contribute
$tilde(O)(T n^(-1/2))$. Hence, when the anchor conclusion and the joint
ridge conclusion both hold,
]

#draft[
$ R_T<=tilde(O)(n+T n^(-1/2))=tilde(O)(T^(2/3)). $
]

#draft[
These conclusions fail with probability at most $2(T+1)^(-2)$, and
$R_T<=C_r T$ always, so taking expectations only adds $O(C_r/T)$.
]

#draft[
== Computational Tractability
]

#draft[
The statistical argument above presents @alg:noisy-ridge-learning using
exact emptiness tests and exact maximization over the single provisional set
$hat(K)_M (x)$. We now explain how to implement these operations with weak
finite-precision optimization. The additional sets introduced in this
section provide numerical slack only; they do not change the statistical
idea.
]

#draft[
The matrix updates, leverage calculations, and affine interpolation are
standard polynomial-time linear algebra. Moreover,
$V_M-lambda^2 I_(d_D)$ is positive semidefinite, while
$lambda>=T^(-1/2)$ and the stored residuals have bounded norm. Hence all
inversions can be carried out to the required inverse-polynomial precision in
polynomial time. For this implementation, one may choose the centre
$c_X$ of $X$ and the arms $c_X+R_X e_i$, $i=1,dots,d_X$, as the affine
basis. Their interpolation coefficients and the resulting affine map are
computed by Gaussian elimination and matrix multiplication, with
polynomially controlled bit complexity. This conditioning detail is
irrelevant to the dependence on $n$ and was therefore omitted from the
statistical argument.
]

#draft[
=== Empty-Fiber Certification
]

#draft[
Fix $rho:=lambda$, let $c_D$ be the centre of $D$, and define
]

#draft[
$ D_1:={y:norm(y-c_D)_2<=R_D+rho}, quad
  D_2:={y:norm(y-c_D)_2<=R_D+2rho}, $
]

#draft[
$ hat(K)_M^("in") (x):=(hat(f)(x)+2cal(E)_M) inter D_1, quad
  hat(K)_M^("out") (x):=(hat(f)(x)+3cal(E)_M) inter D_2. $
]

#draft[
The implementation tests the inner sets for emptiness and plans against the
outer sets. The exact set used in the statistical proof satisfies
]

#draft[
$ hat(K)_M (x) subset.eq hat(K)_M^("in") (x)
    subset.eq hat(K)_M^("out") (x). $
]

#draft[
The constants $2$ and $3$ are not important. Their role, together with the
two expanded outcome balls, is to create a strict margin between the set
containing an uninformative empirical outcome and the set used for planning.
]

#draft[
Write $hat(f)(x)=F x+f_0$. For a fixed arm, the distance between
$hat(f)(x)+2cal(E)_M$ and $D_1$ is
]

#draft[
$ d_M (x):=max_(norm(u)_2<=1) (
    u^T (hat(f)(x)-c_D)
    -2sqrt(u^T V_M u)
    -(R_D+rho)norm(u)_2
  ). $
]

#draft[
This is the support-function formula for the distance between two closed
convex sets. In particular, $d_M (x)>0$ exactly when
$hat(K)_M^("in") (x)=emptyset$.
]

#draft[
After introducing nonnegative variables $s_0,s_1$ satisfying
]

#draft[
$ u^T V_M u<=s_0^2, quad norm(u)_2^2<=s_1^2, $
]

#draft[
maximizing $d_M (x)$ jointly over $x in X$ and $norm(u)_2<=1$ becomes a QCQP
with a fixed number of quadratic constraints. The only coupling between the
arm and dual variables is the bilinear expression $u^T F x$. We impose the
explicit bounds $norm(u)_2<=1$, $0<=s_1<=1$, and
$0<=s_0<=sqrt(lambda_(max) (V_M))$, together with the ball constraint on $x$,
and combine them into a redundant positive-definite enclosing ellipsoid.
The weak fixed-constraint result in @app:qcqp then applies.
]

#draft[
A weakly feasible output is corrected before it is used as a certificate:
project its $x$ and $u$ components onto their respective balls, reset
$s_0,s_1$ to the corresponding exact norms, and directly evaluate the
support-function objective. Since all variables are polynomially bounded,
using sufficiently smaller internal accuracy makes the change in objective
at most $zeta$. The corrected point is feasible, so a positive value is a
genuine certificate of emptiness.
]

#draft[
Exact emptiness classification is unnecessary. Let
$zeta<min(rho,lambda)/10$ and solve the preceding maximization to additive
accuracy $zeta$. If an arm has certified distance greater than $2zeta$, its
inner set is genuinely empty. Otherwise every inner pair of constituent sets
is at distance at most $3zeta$. The corresponding outer intersection then
contains a Euclidean ball of radius at least
]

#draft[
$ min(lambda,rho-3zeta). $
]

#draft[
Indeed, the positive semidefiniteness of $V_M-lambda^2 I_(d_D)$ implies that
$cal(E)_M$ contains the Euclidean ball of radius $lambda$. The gap from
$2cal(E)_M$ to $3cal(E)_M$ therefore supplies the ellipsoid margin,
while the gap from $D_1$ to $D_2$ supplies the outcome-ball margin.
]

#draft[
=== Robust Planning
]

#draft[
The preceding strict-feasibility margin also makes robust planning tractable.
Fenchel--Rockafellar duality gives the following dual representation (see
@boyd2004convex):
]

#draft[
$ min_(y in hat(K)_M^("out") (x)) r(x,y)
  =a^T x+c+b^T c_D+max_(u in RR^(d_D)) (
      u^T (hat(f)(x)-c_D)
      -3sqrt(u^T V_M u)
      -(R_D+2rho)norm(b-u)_2
    ). $
]

#draft[
The interior ball bounds the norm of an optimal dual vector by a polynomial
in the bit length of the public and accumulated numerical data, $T$, and
$min(lambda,rho-3zeta)^(-1)$. Introducing epigraph variables for the two
square roots therefore turns the joint maximization over $x$ and $u$ into a
bounded QCQP with a fixed number of quadratic constraints.
@app:qcqp[Appendix] gives an additive-$zeta_v$ optimal arm in polynomial time. As in
the emptiness problem, a weakly feasible solution is projected onto the arm
ball and its epigraph variables are conservatively increased. The resulting
loss is absorbed into $zeta_v$.
]

#draft[
=== Finite-Precision Comparisons
]

#draft[
The remaining comparisons use the same kind of gray zone. Let $tilde(y)$
denote the rounded block average used by the implementation, and choose the
rounding precision $tau$ so that
$norm(tilde(y)-overline(y))_2<=tau<=rho$. Define the residual used in the
leverage test to be $hat(g):=tilde(y)-hat(f)(x)$. Since
$overline(y) in D$, the expanded ball $D_1$ absorbs the rounding error and
$tilde(y) in D_1$.
]

#draft[
Let $ell:=hat(g)^T V_M^(-1)hat(g)$ and compute an approximation
$tilde(ell)$ satisfying $abs(tilde(ell)-ell)<=gamma/2$. Append the residual
only if $tilde(ell)-gamma/2>1$. Such an update has $ell>1$ and therefore
retains the determinant-doubling argument in
@lem:ridge-informative-blocks. Otherwise $ell<=1+gamma$, so, for
$gamma<=1$,
]

#draft[
$ hat(g) in sqrt(1+gamma)cal(E)_M subset.eq 2cal(E)_M. $
]

#draft[
Finally, the proof of @lem:ridge-residual-learning is unchanged when
$cal(E)_M$ is multiplied by any fixed constant. Thus points in the outer
ellipsoid remain $tilde(O)(n^(-1/2))$-close to $f(x)+N$, while points in
$D_2$ are at distance at most $2rho$ from $D$. Applying
@lem:noisy-ball-stability shows that every point in an outer fiber is
$tilde(O)(n^(-1/2))$-close to the corresponding true feasible set.
]

#draft[
It remains to connect this numerical wrapper to the statistical proof. If a
complete block is not appended, its rounded residual lies in
$2cal(E)_M$, and therefore
]

#draft[
$ tilde(y) in hat(K)_M^("in") (x)
    subset.eq hat(K)_M^("out") (x). $
]

#draft[
Consequently, a complete block selected using a certified empty inner fiber
must be appended; otherwise the displayed membership would contradict
emptiness. Every complete block that is not appended is therefore a planning
block. For such a block, define
]

#draft[
$ hat(v)_M^("out") (x')
    :=min_(y in hat(K)_M^("out") (x')) r(x',y). $
]

#draft[
The preceding outer-fiber bound and the Lipschitz property of the reward give,
uniformly in $x'$,
]

#draft[
$ hat(v)_M^("out") (x')
    >=v^star (x')-tilde(O)(n^(-1/2)). $
]

#draft[
If the weak planner returns an additive-$zeta_v$ maximizer and $x^star$
maximizes $v^star$, then
]

#draft[
$ r(x,overline(y))
  >=r(x,tilde(y))-norm(b)_2 tau
  >=hat(v)_M^("out") (x)-norm(b)_2 tau
  >=hat(v)_M^("out") (x^star)-zeta_v-norm(b)_2 tau
  >=V^star-tilde(O)(n^(-1/2))-zeta_v-norm(b)_2 tau. $
]

#draft[
Affineness again identifies $r(x,overline(y))$ with the realized average
reward in the block. Thus certified empty-fiber blocks and leverage updates
are charged to the same $O(log T)$ informative blocks as before, while every
other complete block has average regret at most
$tilde(O)(n^(-1/2))+zeta_v+norm(b)_2 tau$.
]

#draft[
Taking $rho=lambda=tilde(O)(n^(-1/2))$ and choosing, for example,
$zeta=(T+1)^(-8)$, $gamma=(T+1)^(-8)$,
$zeta_v=(T+1)^(-3)$, and $tau=(T+1)^(-12)$ makes every
numerical error negligible or absorbs it into the existing
$tilde(O)(n^(-1/2))$ bound. These choices require only $O(log T)$ additional
precision bits, and the planning error contributes at most $T zeta_v$ to
regret. Hence the weak bit-model implementation remains polynomial in
$L_("pub")$ and $T$ and has the same regret rate.
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
$y_(z,eta) (x_t)$. This nature policy is compatible because
$y_(z,eta) (x_t) in K_z (x_t)$. Put
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
$v_z (hat(x))>=tilde(v)_(hat(t))-eta$, and the maximality of $hat(t)$ gives
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
Since $v_z (hat(x))<=V_z$, this gap equals
$abs(V_z-v_z (hat(x)))$, so Markov's inequality gives the claimed probability.
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

#draft[
*Proof.* We reduce from MAX-CUT, as defined in @app:max-cut[Appendix]. Let $(G,k)$ be an
instance, where $G=(V,E)$ has $n$ vertices and $m>=1$ edges and
$k in {1,dots,m}$. Orient the edges arbitrarily, let
$B_G in RR^(m times n)$ be the resulting edge-vertex incidence matrix, and
put
]

#draft[
$ X:={x in RR^m:norm(x)_2<=1}, quad Z:=[1,2]. $
]

#draft[
Write an outcome as $y=(p,q,s) in RR^n times RR^n times RR$ and take
]

#draft[
$ D:={(p,q,s):p_i>=0, q_i>=0 " for " i=1,dots,n,
      s>=0, sum_(i=1)^n (p_i+q_i)+s=1}. $
]

#draft[
Let $gamma>0$ be a constant to be chosen later. For every $z in Z$, let
]

#draft[
$ K_z (x):={(p,q,s) in D:p-q=gamma B_G^T x}. $
]

#draft[
Since $z!=0$, this is of the form in @eq:setting-compatible-set, where
]

#draft[
$ C_z (p,q,s):=z(p-q), quad
  B_z x:=-gamma z B_G^T x, quad d_z:=0. $
]

#draft[
Let the reward be
]

#draft[
$ r(x,(p,q,s)):=sum_(i=1)^n (p_i+q_i). $
]

#draft[
The maps $z mapsto B_z$, $z mapsto C_z$, and $z mapsto d_z$ are linear, as
required, and the reward lies in $[0,1]$ on $D$.
]

#draft[
In particular, $K_z (x)$ is independent of $z$.
]

#draft[
Next we show that, for every $z in Z$, $(G,k)$ is a yes-instance of MAX-CUT
if and only if the constructed imprecise bandit instance has an arm $x in X$
satisfying
]

#draft[
$ v_z (x)>=2gamma sqrt(k). $
]

#draft[
For the forward implication, suppose $(G,k)$ is a yes-instance. A vector
$sigma in {-1,1}^n$ represents a partition of the vertices of $G$ into the
two sides ${i:sigma_i=1}$ and ${i:sigma_i=-1}$. Let $c_G (sigma)$ denote the
number of edges between these sides. Choose $sigma$ such that
$c_G (sigma)>=k$, and define the arm
]

#draft[
$ x_sigma:=B_G sigma/norm(B_G sigma)_2. $
]

#draft[
This is well-defined because
$norm(B_G sigma)_2>0$. Indeed, for every edge
$e={i,j}$,
]

#draft[
$ (B_G sigma)_e^2=(sigma_i-sigma_j)^2
  =cases(4 & "if " sigma_i!=sigma_j, 0 & "otherwise"). $
]

#draft[
Summing over $e in E$ gives
]

#set math.equation(numbering: "(1)")
#draft[
$ norm(B_G sigma)_2=2sqrt(c_G (sigma)). $ <eq:simplex-cut-norm>
]
#set math.equation(numbering: none)

#draft[
By construction, $x_sigma in X$. Since $K_z (x)$ is independent of $z$, write
]

#draft[
$ K(x):=K_z (x)={(p,q,s) in D:p-q=gamma B_G^T x}. $
]

#draft[
Thus an arm $x$ fixes the signed vector $t=gamma B_G^T x$. A compatible
outcome decomposes $t$ as the difference $p-q$ of two nonnegative vectors,
while $s=1-sum_(i=1)^n (p_i+q_i)$ is the remaining mass needed to obtain a
point in the simplex $D$.
]

#draft[
To evaluate an arm, observe that $norm(B_G)_F=sqrt(2m)$, so every $x in X$
satisfies
]

#draft[
$ norm(B_G^T x)_1
  <=sqrt(n) norm(B_G^T x)_2
  <=sqrt(n) norm(B_G)_F norm(x)_2
  <=sqrt(2m n). $
]

#draft[
For $t:=gamma B_G^T x$, it follows that
$norm(t)_1<=gamma sqrt(2m n)$. Thus, provided that
$gamma sqrt(2m n)<=1$, the choice
]

#draft[
$ p_i:=max(t_i,0), quad q_i:=max(-t_i,0), quad
  s:=1-norm(t)_1 $
]

#draft[
belongs to $D$ and satisfies $p-q=t$, proving that $K(x)$ is nonempty for
every $x in X$. For any compatible $(p,q,s)$, nonnegativity gives
$p_i+q_i>=abs(p_i-q_i)=abs(t_i)$. The preceding positive-negative
decomposition attains equality in every coordinate. Hence, for every
$x in X$,
]

#set math.equation(numbering: "(1)")
#draft[
$ v_z (x):=min_(y in K(x)) r(x,y)
    =gamma norm(B_G^T x)_1. $ <eq:simplex-arm-value>
]
#set math.equation(numbering: none)

#draft[
Applying @eq:simplex-arm-value to $x_sigma$ and using
@eq:simplex-cut-norm gives
]

#draft[
$ v_z (x_sigma)
    =gamma norm(B_G^T x_sigma)_1
    >=gamma sigma^T B_G^T x_sigma
    =gamma norm(B_G sigma)_2
    =2gamma sqrt(c_G (sigma))
    >=2gamma sqrt(k). $
]

#draft[
For the reverse implication, suppose there is an arm $x in X$ satisfying
$v_z (x)>=2gamma sqrt(k)$. By $ell_1$--$ell_oo$ duality, choose
$sigma in {-1,1}^n$ such that
]

#draft[
$ norm(B_G^T x)_1=sigma^T B_G^T x. $
]

#draft[
Using @eq:simplex-arm-value and @eq:simplex-cut-norm,
]

#draft[
$ 2gamma sqrt(k)
    <=v_z (x)
    =gamma norm(B_G^T x)_1
    =gamma x^T B_G sigma
    <=gamma norm(x)_2 norm(B_G sigma)_2
    <=2gamma sqrt(c_G (sigma)). $
]

#draft[
Since $gamma>0$, this implies $c_G (sigma)>=k$, so $(G,k)$ is a yes-instance.
This proves the claimed equivalence.
]

#draft[
If $M_G$ denotes the maximum cut size, the same argument gives
]

#draft[
$ V_z=2gamma sqrt(M_G). $
]

#draft[
The values corresponding to consecutive cut sizes satisfy, for
$j=1,dots,m$,
]

#draft[
$ 2gamma (sqrt(j)-sqrt(j-1))
  =2gamma/(sqrt(j)+sqrt(j-1))
  >=gamma/m. $
]

#draft[
It remains to choose $gamma$. Set $gamma:=1/(2m n)$. This choice has
$O(log m+log n)$-bit representation and satisfies
]

#draft[
$ gamma sqrt(2m n)=1/sqrt(2m n)<=1, $
]

#draft[
so every $K_z (x)$ is nonempty. Moreover, consecutive candidate values are
separated by at least
]

#draft[
$ gamma/m=1/(2m^2 n). $
]

#draft[
Thus the tolerance
]

#draft[
$ epsilon:=gamma/(3m)=1/(6m^2 n) $
]

#draft[
is inverse-polynomial in the encoding length and is less than half the gap.
Approximating the candidate values $2gamma sqrt(j)$, $j=0,dots,m$, to
polynomially many bits, any estimate of $V_z$ within $epsilon$ therefore
identifies $M_G$ and decides whether $(G,k)$ is a yes-instance. This proves
the planning claim.
]

#draft[
The positive-negative decomposition displayed above is an exact rational
minimizing outcome and is computable in polynomial time from every rational
arm. Applying @lem:planning-from-learning with this $epsilon$
therefore supplies, with probability at least $2/3$, the estimate used in the
preceding paragraph. This would place MAX-CUT in $"BPP"$ and hence imply
$"NP" subset.eq "BPP"$. For a deterministic learner, the estimate is
deterministic and gives $"P"="NP"$. $qed$
]

#draft[
== D = ball, X = polytope, F = F0 + F1
]

#draft[
We now keep the Euclidean outcome ball and the additive bilinear constraint,
but allow the arm set to be a polytope given by rational inequalities. Even
the cube, which has only $2n$ such inequalities but $2^n$ vertices, makes
known-hypothesis planning NP-hard.
]

#theorem[
  #draft[
  Consider a variation of the linear imprecise bandits problem where $X$ is allowed to be a polytope. If, for
  some fixed $beta>0$, a randomized polynomial-time learner guarantees $E[R_T]<=P(|cM|) T^(1-beta)$ for every instance $cM$, then $"NP" subset.eq "BPP"$. If a deterministic learner achieves the same regret guarantee, then $"P"="NP"$.
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
and let $r(x,(u,s)):=s$. Both constraint maps are bilinear and the reward is
linear. Since $z!=0$, compatibility is equivalent to
]

#draft[
$ u=epsilon B_G x, $
]

#draft[
and is therefore independent of $z$. Moreover, every $x in X$ satisfies
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
Thus every compatible fiber is nonempty. Minimizing $s$ over that fiber gives
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
The displayed robust value is strictly increasing in $q(x)$. If the maximum
cut has size $k$, the planning value is therefore
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
identifies $k$ after the $m+1$ candidate values are computed to polynomially
many bits. This proves the planning claim.
]

#draft[
We next derive the learning consequence. The exact minimizing outcome
displayed above need not be rational, so we use a rational feasible
approximation rather than invoke @lem:planning-from-learning. Suppose the
claimed learner exists and set
]

#draft[
$ eta:=Delta/6, quad
  T:=ceil((6P(L)/Delta)^(1/beta)). $
]

#draft[
In the weak bit model the learner outputs rationally encoded arms. For each
played arm $x_t$, rational binary search for a square root computes $a_t$ in
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
we therefore have
]

#draft[
$ S_T<=R_T+T eta. $
]

#draft[
Taking expectations under the learner's randomization gives
]

#draft[
$ E[S_T]<=P(L) T^(1-beta)+T eta. $
]

#draft[
If the learner never plays a $Delta$-optimal arm, then $S_T>Delta T$.
Markov's inequality and the choices of $T$ and $eta$ imply
]

#draft[
$ Pr("no " Delta "-optimal arm is played")
  <=P(L)/(Delta T^beta)+eta/Delta
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
The ambient affine solution space and its intersection with $D$ are
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
Indeed, after clearing the positive denominator, subtracting $rho$, and
squaring, the first inequality is equivalent to
$(1-rho^2)(t^2-rho^2)>=0$. Thus the uniform non-tangency condition holds with
$S=sqrt(3)/2$. $qed$
]

#draft[
== D = ball, X = ball, F = trilinear
]

#draft[
In this subsection, we retain the Euclidean arm and outcome balls from but drop the additive restriction and allow a
general trilinear constraint map. It is convenient to use
the homogeneous outcome formulation. Thus, if $Y$ is the ambient outcome
space, $W$ is the constraint space, and
]

#draft[
$ F:RR^(d_X) times RR^(d_Z) times Y -> W $
]

#draft[
is linear in each argument separately, define
]

#draft[
$ L_z (x):=opker F_(x,z), quad
  K_z (x):=L_z (x) inter D, quad
  v_z (x):=min_(y in K_z (x)) r(x,y), quad
  V_z:=max_(x in X) v_z (x). $
]

#draft[
Here $D$ is a Euclidean ball in the affine normalization hyperplane, hence a
Euclidean ball in its affine hull. The construction below shows that allowing
the coefficients of the outcome constraint to depend on the arm makes even
known-hypothesis planning hard.
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
Writing $u=rho s$ with $norm(s)_2=1$ and setting $pi_i:=s_i^2$, the
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
Squaring the product of these two maxima proves the identity. Since $p_G$ is
odd, its maximum, rather than only its maximum absolute value, is the positive
square root of the displayed quantity. $qed$
]

#theorem[
  #draft[
  There is a polynomial-time reduction from CLIQUE to rational
  imprecise-bandit instances for which $X$ is a full-dimensional Euclidean
  ball, $D$ is a Euclidean ball in its affine hull, $Z=[1,2]$ is a
  one-dimensional Euclidean ball, the reward is linear, and $F$ is
  trilinear. Every set $K_z (x)$ is a singleton independent of $z$, and the
  uniform non-tangency condition holds. Even the corresponding distance
  inequality over the full homogeneous kernel holds with a constant
  $S>0.88$.
  ]

  #draft[
  For these instances, approximating $V_z$ to inverse-polynomial additive
  accuracy is NP-hard even when $z$ is known. Consequently, if, for some
  fixed $beta>0$, a randomized polynomial-time learner guaranteed
  ]

  #draft[
  $ E[R_T]<=P(L) T^(1-beta) $
  ]

  #draft[
  on every such instance for a polynomial $P$, then $"NP" subset.eq "BPP"$.
  For a deterministic learner, the same conclusion would be $"P" = "NP"$.
  ]
] <thm:trilinear-balls-np-hardness>

#draft[
*Proof.* We may restrict CLIQUE to instances with $m>=1$ and
$3<=k<=n$, since the excluded cases are polynomial-time decidable. Starting
from $(G,k)$, use the cubic $p_G$ above and write an arm as
$x=(x_0,xi) in RR times RR^d$. Take
]

#draft[
$ X:={(x_0,xi):(x_0-5/3)^2+norm(xi)_2^2<=1}. $
]

#draft[
This is a full-dimensional Euclidean ball and $x_0>=2/3$ throughout $X$.
Moreover, the normalized coordinate $q:=xi/x_0$ ranges over exactly the ball
$norm(q)_2<=3/4$. Indeed,
]

#draft[
$ 1-(x_0-5/3)^2-9/16 x_0^2=-(15x_0-16)^2/144<=0, $
]

#draft[
so every attainable ratio has norm at most $3/4$. Conversely, for any such
$q$, the choice $x_0=16/15$ and $xi=x_0 q$ belongs to $X$.
]

#draft[
Let $Z:=[1,2]$. Introduce the ambient outcome and constraint spaces
]

#draft[
$ Y:=RR times RR^d times RR^(d times d) times RR^(d times d times d), $
]

#draft[
$ W:=RR^d times RR^(d times d) times RR^(d times d times d), $
]

#draft[
and write $y=(y_0,eta,Theta,Xi) in Y$. With the normalization functional
$mu(y):=y_0$, the outcome set is the affine Euclidean unit ball
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
Fix $x in X$ and $z in Z$. Since $z x_0!=0$ and $y_0=1$ on $D$, the equations
$F(x,z,y)=0$ can be solved recursively. They force the unique candidate
]

#draft[
$ eta_i=1/2 q_i, quad
  Theta_(i j)=1/2 q_i q_j, quad
  Xi_(i j ell)=1/2 q_i q_j q_ell. $
]

#draft[
If $t:=norm(q)_2<=3/4$, the squared norm of its nonconstant outcome
coordinates is
]

#draft[
$ 1/4 (t^2+t^4+t^6)<=4329/16384<1. $
]

#draft[
Thus the candidate lies in $D$, proving that $K_z (x)$ is precisely this
singleton. It does not depend on $z$. The operator $F_(x,z):Y->W$ is also
onto: set $y_0=0$ and solve successively for $eta$, $Theta$, and $Xi$ for an
arbitrary right-hand side.
]

#draft[
On the normalization hyperplane, the affine solution space is the singleton
$K_z (x)$, so the intrinsic non-tangency condition in
 is
automatic. In fact, a stronger homogeneous version holds. Surjectivity and
the dimensions of $Y$ and $W$ show that $L_z (x)$ is the line spanned by
$y(x)=(1,g(q))$, where $g(q):=(eta,Theta,Xi)$ is given by the displayed
recursion. If $p=tau y(x) in L_z (x)$ lies outside $D$, then
]

#draft[
$ opdist(p,D)>=abs(tau-1), quad
  opdist(p,K_z (x))=abs(tau-1) sqrt(1+norm(g(q))_2^2). $
]

#draft[
Consequently the ambient homogeneous distance inequality holds uniformly
with
]

#draft[
$ S>=1/sqrt(1+4329/16384)=128/sqrt(20713)>0.88. $
]

#draft[
Because the compatible outcome is unique, evaluating the reward at that
outcome gives
]

#draft[
$ v_z (x)=1/(2m) p_G (q). $
]

#draft[
The ratio $q$ fills the radius-$3/4$ ball, so homogeneity and
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
$V_z<=U_(k-1)$. The two cases have gap
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
Set $epsilon:=1/(500m n^2)$. Using polynomially many bits, one can compute a
rational $tau_k$ such that
]

#draft[
$ abs(tau_k-1/2 (U_k+U_(k-1)))<=epsilon. $
]

#draft[
An $epsilon$-additive estimate of $V_z$ lies above $tau_k$ when
$omega(G)>=k$ and below it when $omega(G)<=k-1$, because
$2epsilon<Delta_k/2$. It therefore decides whether $G$ contains a $k$-clique.
The constructed instance has dimension $O(d^3)$, and all its defining
coefficients are rational with polynomial encoding length. This proves the
planning claim.
]

#draft[
The displayed recursion computes the unique compatible outcome exactly in
polynomial time from every rational arm; in particular, $x_0>=2/3$ keeps the
division $q=xi/x_0$ bounded. Applying @lem:planning-from-learning with the
displayed $epsilon$ therefore supplies, with probability at least $2/3$, an
additive estimate to which the preceding threshold argument applies. This
would place CLIQUE in $"BPP"$ and hence imply $"NP" subset.eq "BPP"$. For a
deterministic learner, the estimate is deterministic and gives
$"P" = "NP"$. $qed$
]


#draft[
== IUCB is NP-hard even when X and D are Euclidean balls
]

#draft[
Given rational descriptions of
$X$, $D$, $Z$, the affine reward $r$, and the maps defining $K_z (x)$, let
]

#draft[
$ v_z (x):=min_(y in K_z (x)) r(x,y). $
]

#draft[
The *exact IUCB optimism problem* asks for the value
]

#draft[
$ V_("IUCB"):=max_(z in Z,x in X) v_z (x). $
]

#draft[
This is the optimization performed on the first round of IUCB, when its
confidence set is all of $Z$. The associated search problem asks for a
globally optimal first arm
]

#draft[
$ x^star in opargmax_(x in X) max_(z in Z) v_z (x). $
]

#theorem[
  #draft[
  Even when $X$, $D$, and $Z$ are Euclidean balls and planning for every
  fixed hypothesis is polynomial-time, computing the exact first optimistic
  value or a globally optimal first arm of IUCB is NP-hard.
  ]
] <thm:iucb-np-hardness>

#draft[
*Proof.* We reduce from the exact tensor spectral-norm problem. Given a
rational order-three tensor $cal(T) in QQ^(m times d times d_X)$, viewed as a
bilinear map $cal(T):RR^d times RR^(d_X) -> RR^m$, this problem asks to
compute
]

#draft[
$ norm(cal(T))_sigma:=max_(norm(u)_2<=1,norm(x)_2<=1)
    norm(cal(T)(u,x))_2. $
]

#draft[
Computing this value is NP-hard @hillar2013most. From $cal(T)$, construct an IUCB
instance as follows. Put
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
For $z=(z_0,u)$, define the data in @eq:setting-compatible-set and the
reward by
]

#draft[
$ B_z x:=-alpha cal(T)(u,x), quad C_z (w,s):=z_0 w, quad d_z:=0,
  quad r(x,(w,s)):=1/2(1+s). $
]

#draft[
, and
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
Also $norm(cal(T)(u,x))_2<=H norm(u)_2 norm(x)_2$, so the fixed $w$ in
$K_z (x)$ has norm at most $3alpha H/4=3/8$. Thus every $K_z (x)$ is
nonempty, and the uniform non-tangency condition holds with
$S>=sqrt(55)/8$. For this instance, nature chooses
$s=-sqrt(1-norm(w)_2^2)$ when evaluating $v_z (x)$, whence
]

#draft[
$ v_z (x)=h(alpha/z_0 norm(cal(T)(u,x))_2), quad
  h(t):=1/2(1-sqrt(1-t^2)). $
]

#draft[
For fixed $z$, a top right singular vector of
$M_u x:=cal(T)(u,x)$ maximizes $v_z (x)$, so fixed-hypothesis planning is
polynomial-time. IUCB instead optimizes jointly over $Z$ and $X$. Since $h$
is strictly increasing and the ratio above attains $3/4$ in every direction,
]

#draft[
$ V_("IUCB")=h(3alpha/4 norm(cal(T))_sigma), $
]

#draft[
Since
]

#draft[
$ norm(cal(T))_sigma=4/(3alpha)
    sqrt(1-(1-2V_("IUCB"))^2), $
]

#draft[
exact IUCB optimism would solve the tensor spectral-norm problem. If IUCB returns
only a globally optimal arm $x^star$, one SVD of
$N_x u:=cal(T)(u,x^star)$ computes
]

#draft[
$ max_(z in Z) v_z (x^star)=h(3alpha/4 sigma_max (N_x))=V_("IUCB"), $
]

#draft[
so the same inverse recovers $norm(cal(T))_sigma$. Producing a globally
optimal first arm is therefore NP-hard as well. $qed$
]

#draft[
== Efficient planning does not imply efficient learning
]

#draft[
The converse of @lem:planning-from-learning fails for succinct nonconvex
model classes. The separation below gives every known hypothesis an exact
polynomial-time planner, but makes learning computationally hard. It is a
variation of the setting above: the reward is allowed to be separately linear
in the arm and outcome, and hence may contain an arm--outcome cross term.
]

#theorem[
  #draft[
  There is a succinctly represented family of rational imprecise-bandit
  instances with finite arm and hypothesis sets, a rational-polytope outcome
  set, additive bilinear constraints $F=F_0+F_1$ with $F_0=0$, and a reward
  in $[0,1]$ that is separately linear in the arm and outcome, such that exact
  known-hypothesis planning takes $O(n^2)$ time. The learning-hardness
  conclusion already holds against a stationary deterministic nature policy.
  ]

  #draft[
  Suppose that, for some fixed $beta>0$ and polynomial $P$, one uniform
  randomized policy runs in time polynomial in the succinct-description
  length $L$ and horizon $N$ and has expected regret at most
  ]

  #draft[
  $ P(L) N^(1-beta) $
  ]

  #draft[
  for every instance in this family, every true hypothesis, and every
  compatible nature policy. Then $"CLIQUE" in "RP"$ and hence
  $"NP"="RP"$. A deterministic policy with the same guarantee would imply
  $"P"="NP"$.
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
and let $H:={h_z:z in Z}$. The learner is given a succinct description of
the entire instance $cM=(X,D,H,r)$, including $Z$, $F_0$, and $F_1$; only the
true $U$ is hidden.
]

#draft[
The maps $F_0$ and $F_1$ are bilinear in their displayed arguments. In these
homogeneous outcome coordinates the constraint is $C_z y=0$: thus $B_z=0$,
$d_z=0$, and $z mapsto C_z$ is linear. For $z=z^U$,
]

#draft[
$ (F_1 (y,z^U))_e=cases(
    g_e-y_0 & "if " e subset.eq U,
    s_e & "otherwise".
  ) $
]

#draft[
Consequently, inside $D$, feasibility forces $g_e=1$ for every
$e subset.eq U$ and $s_e=0$ for every $e subset.eq.not U$, while the graph
coordinates outside $U$ remain free. The feasible set is nonempty: take
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
It lies in $[0,1]$ on $X times D$. For an arm $x^T$, nature minimizes the
reward by setting every graph coordinate not forced by $U$ to zero, so
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
It remains to prove learning hardness directly. Given a CLIQUE instance
$G=([n],E(G))$ and $k$ @garey1979computers, let
]

#draft[
$ g_e^G:=cases(
    1 & "if " e in E(G),
    0 & "otherwise",
  ), quad y^G:=(1,g^G,0) in D. $
]

#draft[
If $U$ is a $k$-clique of $G$, then the stationary deterministic nature
policy that returns $y^G$ on every round is compatible with $z^U$: every
edge inside $U$ has $g_e^G=1$, and every auxiliary coordinate is zero. For
every candidate $T$,
]

#draft[
$ r(x^T,y^G)=abs(E(G[T]))/q. $
]

#draft[
This reward is $1$ exactly when $T$ is a $k$-clique, and is at most
$1-1/q$ otherwise.
]

#draft[
Assume the policy in the theorem exists, and run it against the constant
outcome $y^G$. If $G$ contains a $k$-clique $U$, this is a valid interaction
with true hypothesis $z^U$, whose optimal value is $1$. If the policy plays
$x^(T_1),dots,x^(T_N)$, define its realized shortfall by
]

#draft[
$ cal(L)_N:=N-sum_(t=1)^N r(x^(T_t),y^G). $
]

#draft[
This quantity is nonnegative. On the event $cal(E)$ that none of
$T_1,dots,T_N$ is a clique, the reward gap above gives
$cal(L)_N>=N/q$. Hence Markov's inequality and the assumed regret bound give
]

#draft[
$ Pr(cal(E))
    <=q E[cal(L)_N]/N
    <=q P(L) N^(-beta). $
]

#draft[
Choose
]

#draft[
$ N:=ceil((4 q P(L))^(1/beta)). $
]

#draft[
The family description has length polynomial in $n$, so $N$ and the total
simulation time are polynomial in the CLIQUE input length. Verify each
$k$-set proposed by the policy and accept as soon as it induces a clique in
$G$. If $G$ has a $k$-clique, the preceding bound gives acceptance
probability at least $3/4$. If $G$ has none, verification prevents acceptance,
even though the simulated history need not then be compatible with any
hypothesis. The policy is a polynomial-time algorithm on every syntactically
valid history, so the simulation still terminates in polynomial time.
]

#draft[
This is an RP algorithm for CLIQUE. Since CLIQUE is NP-complete, it implies
$"NP"="RP"$. If the policy is deterministic, the same verified search gives
$"P"="NP"$. $qed$
]

#draft[
The construction deliberately uses exponentially large finite sets $X$ and
$Z$ represented succinctly by $k$-subsets. It also uses a polytope $D$ and the
bilinear reward $r(x,y)=sum_e x_e g_e$, rather than the jointly affine reward. It therefore shows
that efficient planning alone does not suffice for efficient learning; it
does not strengthen the positive result for Euclidean balls and affine
rewards.
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
  Second, our planning problem is a QCQP with a fixed number of constraints,
  one of which is the strictly convex joint-ellipsoid constraint when
  $R_X,R_D>0$. Thus it satisfies Bienstock's hypotheses. Applying the theorem
  to the negative objective computes the planning maximum to weak additive
  accuracy $epsilon$ in time $poly(L,log(1/epsilon))$. If either radius is
  zero, the problem first reduces to a lower-dimensional instance.
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
