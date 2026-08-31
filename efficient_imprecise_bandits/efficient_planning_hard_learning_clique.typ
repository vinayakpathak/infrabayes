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
  set par(justify: true, leading: 0.66em)
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
  title: [
    Efficient Planning Does Not Imply Efficient Learning in Linear Imprecise Bandits
    #linebreak()
    #text(size: 0.66em, weight: "regular", fill: rgb("#555555"))[
      A CLIQUE-based separation under additive bilinear constraints
    ]
  ],
  abstract: [
    We construct a family of linear imprecise-bandit instances for which exact
    maximin planning is trivial once the hypothesis is known, but every
    polynomial-time learner with a polynomially controlled sublinear-regret
    guarantee would yield an RP algorithm for CLIQUE. The constraints have the
    additive form $F_0(x,z) + F_1(y,z)$, with $F_0$ identically zero and $F_1$
    bilinear in the outcome and hypothesis. The reward is separately linear in
    the arm and outcome. Nature may be stationary and deterministic. The
    separation therefore comes entirely from computationally hard inference of
    which constraints are active, rather than from planning, statistical noise,
    or adaptive adversarial behavior.
  ],
  cols: 1,
  margin: (x: 1in, y: 0.85in),
  fontsize: 10.5pt,
  sectionnumbering: "1.",
  doc,
)


= Statement, model, and scope
<statement-model-and-scope>
== Linear imprecise-bandit model used in the proof
<linear-imprecise-bandit-model-used-in-the-proof>
Let $A$ be an arm set, $D$ an outcome set, and $H$ a hypothesis set. For
a hypothesis $z in H$ and arm $x in A$, the admissible conditional mean
outcomes are

$ K_z (x) = { y in D : F_0 (x , z) + F_1 (y , z) = 0 } . $

A compatible nature policy may, on every round and after every history,
select any distribution on $D$ whose conditional mean belongs to
$K_z (x)$. Deterministic outcomes are therefore allowed. Because the
reward in the construction is linear in the outcome, the lower value of
an arm is

$ v_z (x) := min_(y in K_z (x)) r (x , y) , $

and the known-hypothesis planning problem is

$ V_z := max_(x in A) v_z (x) . $

For a learner that selects $x_1 , dots.h , x_N$ and observes
$y_1 , dots.h , y_N$, its regret against a fixed compatible nature
policy is

$ L_N := N V_z - sum_(t = 1)^N r (x_t , y_t) . $

The standard expected-regret definition for imprecise bandits takes the
worst compatible nature policy. Consequently, a uniform expected-regret
upper bound also upper-bounds $bb(E) [L_N]$ for each particular
compatible nature policy used below.

== Standing interpretation of linear reward
<standing-interpretation-of-linear-reward>
The reward in this proof is #emph[separately linear] in the arm and
outcome:

$ r (x , y) = angle.l x , g angle.r . $

Equivalently, it is bilinear in $(x , y)$. This is the usual meaning of
being linear in each argument separately. The proof does #strong[not]
establish the same separation under the stricter additively separable
requirement

$ r (x , y) = a^upright(T) x + b^upright(T) y + c , $

which forbids an $x$–$y$ cross term.

The computational model is also important. The finite arm and hypothesis
sets below are represented #emph[succinctly] by polynomial-time
membership and encoding rules. They are not listed explicitly; each
contains $binom(n, k)$ elements.

== Main theorem
<main-theorem>
#quote(block: true)[
#strong[Theorem 1 \(planning–learning separation).] Fix a constant
$alpha < 1$. Consider the succinct family of linear imprecise-bandit
instances constructed below, indexed by integers $n$ and $k$ with
$2 lt.eq k lt.eq n$. Suppose there is a randomized learner and a
polynomial $p$ such that:

+ on horizon $N$, the learner runs in time polynomial in $n$ and $N$;
+ for every true hypothesis and every compatible nature policy,
  $ bb(E) [L_N] lt.eq p (n) N^alpha ; $
+ the guarantee holds uniformly over all members of the family.

Then CLIQUE belongs to $sans(R P)$. Hence, unless
$sans(N P) = sans(R P)$, no such learner exists.

Nevertheless, for every known hypothesis in the same family, exact
maximin planning is solvable in $O (n^2)$ time.
]

For a deterministic learner, the same reduction would imply
$sans(P) = sans(N P)$.

= Intuition
<intuition>
The unknown hypothesis is a hidden $k$-vertex set $S subset.eq [n]$. Its
constraints say:

#quote(block: true)[
Every edge with both endpoints in $S$ is guaranteed to be present. Every
other graph edge is unconstrained.
]

If $S$ is known, the optimal plan is immediate: choose the arm
corresponding to $S$. Every edge tested by that arm is guaranteed, so
its worst-case reward is $1$.

The learner can instead be shown the adjacency vector of an arbitrary
graph $G$ that contains $S$ as a clique. The learner sees all edges
present in $G$, but it cannot tell which present edges are guaranteed by
the hidden hypothesis and which are merely chosen by nature. An arm
receives reward $1$ exactly when it names a $k$-clique of the observed
graph. Therefore, sufficiently small regret forces the learner to output
a $k$-clique.

For the smallest illustrative case, take $k = 3$. The hidden hypothesis
is a triangle $S$. It guarantees the three edges of that triangle.
Nature may reveal a much larger graph containing many additional edges.
Planning with $S$ in hand means playing that triangle. Learning from the
revealed graph means finding some triangle in it, which is the search
version of CLIQUE for $k = 3$; with variable $k$, this becomes NP-hard.

The logical structure is

$ upright("known ") S quad arrow.r.double quad upright("planning is trivial") , $

whereas

$ upright("unknown ") S + upright("a compatible observed graph ") G quad arrow.r.double quad upright("find a ") k upright("-clique in ") G . $

= Construction
<construction>
Fix integers $n$ and $k$ satisfying $2 lt.eq k lt.eq n$. Let

$ E_n := #scale(x: 120%, y: 120%)[{] { i , j } : 1 lt.eq i < j lt.eq n #scale(x: 120%, y: 120%)[}] , #h(2em) m := binom(n, 2) , #h(2em) M := binom(k, 2) . $

Vectors indexed by $E_n$ are regarded as vectors in $bb(R)^m$.

== Arm space
<arm-space>
For every $k$-vertex subset $T subset.eq [n]$, define $x^T in bb(R)^m$
by

$ x_e^T := 1 / M bold(1) { e subset.eq T } , #h(2em) e in E_n . $

Thus $x^T$ is the uniform distribution over the $M$ edges induced by
$T$. Set

$ A := #scale(x: 120%, y: 120%)[{] x^T : T subset.eq [n] , med lr(|T|) = k #scale(x: 120%, y: 120%)[}] . $

An arm is encoded by listing the vertices of $T$, using polynomially
many bits.

== Hypothesis space
<hypothesis-space>
For every $k$-vertex subset $S subset.eq [n]$, define
$z^S in bb(R)^(1 + m)$ by

$ z_0^S := 1 , #h(2em) z_e^S := bold(1) { e subset.eq S } , #h(2em) e in E_n . $

Set

$ H := #scale(x: 120%, y: 120%)[{] z^S : S subset.eq [n] , med lr(|S|) = k #scale(x: 120%, y: 120%)[}] . $

The coordinate $z_e^S$ records whether edge $e$ lies completely inside
the hidden set $S$.

== Outcome space
<outcome-space>
Let

$ Y := bb(R)^(1 + 2 m) . $

Write an outcome as

$ y = (y_0 , g , h) , #h(2em) g , h in bb(R)^m , $

and define the normalization functional $mu (y) := y_0$. Let

$ D := #scale(x: 120%, y: 120%)[{] (1 , g , h) : g in [0 , 1]^m , med h in [- 1 , 1]^m #scale(x: 120%, y: 120%)[}] . $

The vector $g$ will encode graph edges. The vector $h$ is auxiliary
slack used to make the constraint operator surjective.

== Additive bilinear constraints
<additive-bilinear-constraints>
Let $W := bb(R)^m$. Set

$ F_0 (x , z) := 0 . $

For every edge $e in E_n$, define

$ #scale(x: 120%, y: 120%)[\[] F_1 (y , z) #scale(x: 120%, y: 120%)[\]]_e := z_e (g_e - y_0 - h_e) + z_0 h_e . $

This is bilinear in $(y , z)$, and therefore

$ F (x , z , y) = F_0 (x , z) + F_1 (y , z) $

has exactly the required additive form. In fact, the constraints do not
depend on the arm at all.

For $z = z^S$, since $z_0^S = 1$ and $z_e^S in { 0 , 1 }$,

$ #scale(x: 120%, y: 120%)[\[] F_1 (y , z^S) #scale(x: 120%, y: 120%)[\]]_e = cases(delim: "{", g_e - y_0 , & e subset.eq S ,, h_e , & e subset.eq.not S .) $

Inside $D$, where $y_0 = 1$, feasibility is therefore equivalent to

$ g_e = 1 quad upright("for every ") e subset.eq S , $

and

$ h_e = 0 quad upright("for every ") e subset.eq.not S . $

The graph coordinates $g_e$ outside $S$ remain completely unconstrained.

== Reward
<reward>
Define

$ r (x , y) := sum_(e in E_n) x_e g_e . $

For the arm $x^T$, this becomes

$ r (x^T , y) = 1 / M sum_(e subset.eq T) g_e . $

Thus the reward is the fraction of edges induced by $T$ that are present
in the graph vector $g$. It lies in $[0 , 1]$ and is linear in each
argument separately.

= Validity of the bandit construction
<validity-of-the-bandit-construction>
#quote(block: true)[
#strong[Lemma 2 \(model validity).] The construction above satisfies the
relevant linear imprecise-bandit conditions:

+ $A$ and $H$ are compact finite sets and $D$ is a compact rational
  polytope in the affine hyperplane $mu^(- 1) (1)$;
+ $F_0$ is bilinear, $F_1$ is bilinear in $(y , z)$, and
  $F = F_0 + F_1$;
+ for every $S$ and every arm, the feasible set $K_(z^S) (x)$ is
  nonempty;
+ for every $S$, the ambient linear map $y arrow.r.bar F_1 (y , z^S)$
  from $Y$ to $W$ is onto;
+ the reward is bounded, convex in the outcome, and $1$-Lipschitz in the
  outcome norm induced by $D$.
]

== Why the lemma is true
<why-the-lemma-is-true>
The only non-obvious device is $h$. On an edge inside $S$, the
constraint uses $g_e$; on an edge outside $S$, it uses $h_e$. Thus every
output coordinate of $W$ has its own freely adjustable input coordinate,
which gives surjectivity without constraining the graph bit $g_e$
outside $S$.

== Proof
<proof>
Compactness and rationality are immediate from the definitions.
Bilinearity follows because every term in $F_1$ is a product of one
coordinate of $z$ and one coordinate of $y$.

For nonemptiness, fix $S$ and choose

$ y_0 = 1 , #h(2em) g_e = bold(1) { e subset.eq S } , #h(2em) h_e = 0 . $

This point lies in $D$ and satisfies every constraint.

For surjectivity, fix any $w in W$. It is enough to construct
$y in Y$—not necessarily $y in D$—such that $F_1 (y , z^S) = w$. Set
$y_0 = 0$ and choose

$ g_e = cases(delim: "{", w_e , & e subset.eq S ,, 0 , & e subset.eq.not S ,) #h(2em) h_e = cases(delim: "{", 0 , & e subset.eq S ,, w_e , & e subset.eq.not S .) $

Then $[F_1 (y , z^S)]_e = w_e$ for every edge $e$, proving surjectivity.

Finally, for each fixed arm $x^T$, the map $y arrow.r.bar r (x^T , y)$
is linear. Since the coefficients $x_e^T$ are nonnegative and sum to
$1$,

$ 0 lt.eq r (x^T , y) lt.eq 1 #h(2em) upright("for every ") y in D . $

The dual norm of this linear functional with respect to the norm whose
unit ball is the absolute convex hull of $D$ is therefore at most $1$.
Hence the reward is $1$-Lipschitz in the outcome argument. This
completes the proof. $square.stroked.tiny$

= Known-hypothesis planning is easy
<known-hypothesis-planning-is-easy>
#quote(block: true)[
#strong[Lemma 3 \(exact lower value).] Fix a hidden set
$S subset.eq [n]$ of size $k$. For every arm $x^T$,
$ v_S (T) := min_(y in D : F_1 (y , z^S) = 0) r (x^T , y) = binom(lr(|S sect T|), 2) / binom(k, 2) . $
Consequently, $x^S$ is the unique optimal arm and has lower value $1$.
]

== Intuition
<intuition-1>
Every edge inside $S$ is forced to have graph coordinate $g_e = 1$.
Nature minimizes the reward by setting every unforced graph coordinate
used by the candidate arm to zero. The only edges tested by $T$ that
nature cannot erase are the edges lying inside both $S$ and $T$, namely
the edges induced by $S sect T$.

== Proof
<proof-1>
For the arm $x^T$,

$ r (x^T , y) = 1 / M sum_(e subset.eq T) g_e . $

Under hypothesis $z^S$, every edge $e subset.eq S$ must satisfy
$g_e = 1$. Every other graph coordinate is unconstrained within
$[0 , 1]$ and may therefore be set to zero by nature. Hence

$ v_S (T) = lr(|E (T) sect E (S)|) / M . $

An edge lies in both $E (T)$ and $E (S)$ exactly when both of its
endpoints lie in $S sect T$. Therefore

$ E (T) sect E (S) = E (S sect T) , $

and

$ v_S (T) = binom(lr(|S sect T|), 2) / M = binom(lr(|S sect T|), 2) / binom(k, 2) . $

If $T = S$, this value is $1$. If $T eq.not S$, then
$lr(|S sect T|) lt.eq k - 1$, so the value is strictly less than $1$.
Thus $x^S$ is the unique optimal arm.

Given $z^S$, the planner can output $x^S$ directly by setting

$ x_e^S = z_e^S / M . $

Scanning the $m = binom(n, 2)$ edge coordinates takes $O (n^2)$ time.
$square.stroked.tiny$

= A compatible graph outcome turns optimal play into CLIQUE
<a-compatible-graph-outcome-turns-optimal-play-into-clique>
Fix an arbitrary graph

$ G = ([n] , E (G)) . $

Let its adjacency vector $g^G in { 0 , 1 }^m$ be

$ g_e^G := bold(1) { e in E (G) } , $

and define the deterministic outcome

$ y^G := (1 , g^G , 0) in D . $

#quote(block: true)[
#strong[Lemma 4 \(compatibility).] If $S$ is a $k$-clique of $G$, then
the stationary deterministic nature policy that returns $y^G$ on every
round is compatible with hypothesis $z^S$.
]

== Proof
<proof-2>
For every edge $e subset.eq S$, cliquehood gives $g_e^G = 1$, so the
constraint $g_e - y_0 = 0$ is satisfied. For every edge
$e subset.eq.not S$, the relevant constraint is $h_e = 0$, which is also
satisfied. Hence

$ F_1 (y^G , z^S) = 0 . $

The point mass at $y^G$ is therefore an admissible outcome distribution
after every history and every arm. $square.stroked.tiny$

#quote(block: true)[
#strong[Lemma 5 \(reward gap).] For every $k$-vertex set $T$,
$ r (x^T , y^G) = lr(|E (G [T])|) / M . $ In particular,
$ r (x^T , y^G) = 1 quad arrow.l.r.double quad T upright(" is a ") k upright("-clique in ") G . $
If $T$ is not a clique, then $ r (x^T , y^G) lt.eq 1 - 1 / M . $
]

== Proof
<proof-3>
Substituting the adjacency vector into the reward gives

$ r (x^T , y^G) = 1 / M sum_(e subset.eq T) bold(1) { e in E (G) } = lr(|E (G [T])|) / M . $

The induced subgraph $G [T]$ contains all $M$ possible edges exactly
when $T$ is a clique. Otherwise at least one edge is absent, so it
contains at most $M - 1$ edges. $square.stroked.tiny$

= Low regret forces the learner to find a clique
<low-regret-forces-the-learner-to-find-a-clique>
#quote(block: true)[
#strong[Lemma 6 \(regret-to-search conversion).] Suppose $G$ contains a
$k$-clique and the learner is run against the stationary outcome $y^G$.
If $ bb(E) [L_N] lt.eq p (n) N^alpha , $ then, for
$ N gt.eq (4 M p (n))^(1 \/ (1 - alpha)) , $ the learner plays a
$k$-clique of $G$ with probability at least $3 \/ 4$.
]

== Why the lemma is true
<why-the-lemma-is-true-1>
The true maximin value is $1$. Every nonclique arm loses at least
$1 \/ M$ relative to this value. If no clique is ever played, regret
accumulates at rate at least $1 \/ M$ on every round, giving total
regret at least $N \/ M$. A sublinear expected-regret bound makes that
event unlikely.

== Proof
<proof-4>
Let the learner play the vertex sets $T_1 , dots.h , T_N$. Since the
optimal lower value under the hidden clique hypothesis is $1$, the
realized regret under the deterministic nature policy is

$ L_N = N - sum_(t = 1)^N r (x^(T_t) , y^G) . $

Let $cal(E)$ be the event that none of $T_1 , dots.h , T_N$ is a
$k$-clique of $G$. By Lemma 5, on $cal(E)$ every round has reward at
most $1 - 1 \/ M$. Therefore

$ cal(E) quad arrow.r.double quad L_N gt.eq N / M . $

Markov’s inequality gives

$ Pr (cal(E)) & lt.eq Pr #h(-1em) (L_N gt.eq N / M)\
 & lt.eq frac(M thin bb(E) [L_N], N)\
 & lt.eq M p (n) N^(alpha - 1) . $

When

$ N^(1 - alpha) gt.eq 4 M p (n) , $

this probability is at most $1 \/ 4$. Hence the learner plays a
$k$-clique with probability at least $3 \/ 4$. $square.stroked.tiny$

Because $alpha < 1$ is fixed, the exponent $1 \/ (1 - alpha)$ is a
constant. Since $M lt.eq n^2$ and $p$ is polynomial, the required
horizon is polynomial in the CLIQUE instance size.

= Proof of the main theorem
<proof-of-the-main-theorem>
We now give the randomized reduction from CLIQUE.

Given an instance $(G , k)$ with vertex set $[n]$:

+ Construct the succinct bandit instance above using only $(n , k)$.
+ Form the deterministic outcome $y^G = (1 , g^G , 0)$.
+ Run the alleged learner for $ N = ⌈(4 M p (n))^(1 \/ (1 - alpha))⌉ $
  rounds, returning $y^G$ after every selected arm.
+ Whenever the learner selects an arm encoded by a $k$-vertex set $T$,
  check directly whether $G [T]$ is complete.
+ Accept if any selected $T$ is a clique; otherwise reject.

The procedure runs in randomized polynomial time. Each arm can be
decoded and checked in polynomial time, and the horizon $N$ is
polynomial.

If $G$ has no $k$-clique, the procedure never accepts: every candidate
is explicitly verified. Notice that in this case the simulated feedback
need not be compatible with any hypothesis. No correctness guarantee for
the learner is needed on no-instances, because verification gives
one-sided error.

If $G$ has a $k$-clique $S$, then by Lemma 4 the repeated outcome $y^G$
is compatible with the true hypothesis $z^S$. The learner’s regret
guarantee therefore applies. By Lemma 6, with probability at least
$3 \/ 4$ the learner selects some $k$-clique, which the reduction
detects and accepts.

Thus CLIQUE has a randomized polynomial-time algorithm with one-sided
error, so

$ sans(C L I Q U E) in sans(R P) . $

Since CLIQUE is NP-complete, this implies
$sans(N P) subset.eq sans(R P)$. The standard inclusion
$sans(R P) subset.eq sans(N P)$ then gives

$ sans(N P) = sans(R P) . $

Contrapositively, unless $sans(N P) = sans(R P)$, no polynomial-time
learner with a bound $p (n) N^alpha$ for any fixed $alpha < 1$ can work
uniformly on this family. Lemma 3 simultaneously gives an $O (n^2)$
exact planner for every known hypothesis. This proves Theorem 1.
$square.stroked.tiny$

= What the separation establishes
<what-the-separation-establishes>
The construction yields

$ #box(stroke: black, inset: 3pt, [$  & upright("known-hypothesis maximin planning: ") O (n^2) ,\
 & upright("polynomial-rate no-regret learning: computationally hard") . $]) $

Several features sharpen the interpretation.

+ #strong[The hardness is for every learner, not merely IUCB.] The
  reduction uses only the assumed regret guarantee, not any particular
  algorithmic form.
+ #strong[Nature is stationary and deterministic.] There is no sampling
  noise, temporal dependence, or adaptive adversarial strategy.
+ #strong[The constraints are especially simple.] We have $F_0 equiv 0$,
  so the feasible mean set does not depend on the arm.
+ #strong[The obstruction is computational inference.] The learner sees
  a graph containing a hidden clique but must identify an optimal arm
  without being told which present edges are guaranteed.
+ #strong[The problem is information-theoretically easy.] After the
  first observation, exhaustive search over all $k$-subsets finds a
  clique whenever one exists. The difficulty is solely polynomial-time
  computation.
+ #strong[Rewards and outcomes are bounded.] The reward always lies in
  $[0 , 1]$, and $D$ is a rational polytope.

= Limitations and scope qualifications
<limitations-and-scope-qualifications>
The theorem should not be read as saying that efficient planning never
implies efficient learning under additional geometric assumptions. Two
qualifications are essential.

== Succinct nonconvex arm and hypothesis classes
<succinct-nonconvex-arm-and-hypothesis-classes>
Both

$ A = { x^T : lr(|T|) = k } #h(2em) upright("and") #h(2em) H = { z^S : lr(|S|) = k } $

are finite but exponentially large and nonconvex. Their elements are
represented succinctly. If all arms and hypotheses were listed
explicitly, then the input itself would already have exponential length
relative to $n$, and the complexity conclusion would no longer have the
same force.

Accordingly, the construction does not contradict positive results for
settings in which $A$ and $H$ are tractably represented convex bodies,
such as Euclidean balls, and the induced optimization problems have
additional structure.

== The reward contains an arm–outcome cross term
<the-reward-contains-an-armoutcome-cross-term>
The reward

$ r (x , y) = angle.l x , g angle.r $

is linear in $x$ with $y$ fixed and linear in $y$ with $x$ fixed. The
cross term is crucial: it lets an arm test precisely the edges of its
candidate vertex set. The proof does not apply to a reward constrained
to the form

$ a^upright(T) x + b^upright(T) y + c . $

A separate argument would be required for that stricter model.

= References
<references>
+ Vanessa Kosoy. #emph[Imprecise Multi-Armed Bandits: Representing
  Irreducible Uncertainty as a Zero-Sum Game]. Journal of Machine
  Learning Research 26, 2025, 1–75.
+ Richard M. Karp. #emph[Reducibility Among Combinatorial Problems]. In
  #emph[Complexity of Computer Computations], 1972, 85–103.
