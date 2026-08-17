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

#let thm(body) = block(width: 100%, above: 0.8em, below: 0.8em)[
  #set par(first-line-indent: 0em)
  #set text(style: "italic")
  #show strong: set text(style: "normal")
  #body
]

#let theorem-counter = counter("theorem")
#let theorem(body, title: none) = [
  #theorem-counter.step()
  #thm[
    *Theorem #context theorem-counter.display()#if title != none [ (#title)].* #body
  ]
]

#let lemma-counter = counter("lemma")
#let lemma(body) = [
  #lemma-counter.step()
  #thm[
    *Lemma #context lemma-counter.display().* #body
  ]
]

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
$z^star in Z$ be the unknown true hypothesis. For each arm $x in A$, define
the true feasible outcome set

$ K^star (x) := {y in D : F_0(x,z^star) + F_1(y,z^star) = 0}, $

where $F_0$ and $F_1$ are both bilinear maps.

After fixing $z^star$, the constraint can be written in intrinsic affine
coordinates as

$ C y + B x + d = 0, $

where $B$, $C$, and $d$ are fixed once $z^star$ is fixed. Equivalently,

#set math.equation(numbering: "(1)")
$ K^star (x) = {y in D : C y + B x + d = 0}. $ <eq:setting-fiber>
#set math.equation(numbering: none)

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
  There exist $d_A+1$ arms $x^(0),dots,x^(d_A) in A$ such that, from any
  possible sequence of responses
  $y^(i) in K^star (x^(i))$, we can compute an affine map $hat(f)$ such that
  $ K^star (x) = (hat(f)(x) + N) inter D, quad x in A. $
] <lem:noiseless-anchor-identification>

*Proof.* Let $c_A$ be the centre of $A$, let $e_1,dots,e_(d_A)$ be the
standard basis vectors, and choose

$ x^(0) := c_A, quad
  x^(i) := c_A + R_A e_i, quad i=1,dots,d_A. $

These points form an affine basis. Suppose their observed responses are
$y^(0),dots,y^(d_A)$, and let $hat(f)$ be the unique affine map satisfying

$ hat(f)(x^(i))=y^(i), quad i=0,dots,d_A. $

Thus $hat(f)$ can be computed by affine interpolation from the observed
responses.

Fix an affine map $f$ and a linear subspace $N$ as in Lemma 1, and let $pi$
be the quotient map modulo $N$. Since
$y^(i) in K^star (x^(i)) subset.eq f(x^(i))+N$, we have

$ pi(y^(i))=pi(f(x^(i))), quad i=0,dots,d_A. $

Applying $pi$ to either $hat(f)$ or $f$ gives an affine map into the quotient
space. These two quotient-valued affine maps agree on the affine basis
$x^(0),dots,x^(d_A)$, so they agree everywhere. Consequently,

$ pi(hat(f)(x))=pi(f(x)), quad x in A. $

Equivalently, $hat(f)(x)-f(x) in N$, and hence

$ hat(f)(x)+N=f(x)+N. $

Using Lemma 1 and intersecting with $D$ therefore gives

$ K^star (x)=(hat(f)(x)+N) inter D, quad x in A. $

This proves the claim. #h(1fr) $qed$
