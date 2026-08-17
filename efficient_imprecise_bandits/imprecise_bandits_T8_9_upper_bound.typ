#set page(
  paper: "us-letter",
  margin: (left: 0.9in, right: 0.9in, top: 0.8in, bottom: 0.85in),
  numbering: "1",
)
#set text(size: 10.5pt)
#set par(justify: true, leading: 0.68em)
#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")
#set list(indent: 1.2em, body-indent: 0.55em)
#set enum(indent: 1.2em, body-indent: 0.55em)

#let thm(body) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: rgb("#f5f8fc"),
  stroke: 0.6pt + rgb("#9aa9bb"),
  body,
)

#let note(body) = block(
  width: 100%,
  inset: 9pt,
  radius: 4pt,
  fill: rgb("#fff8e8"),
  stroke: 0.6pt + rgb("#c9ad65"),
  body,
)

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

#align(center)[
  #text(size: 18pt, weight: "bold")[A Computationally Efficient $T^(8/9)$ Upper Bound]
  #v(3pt)
  #text(size: 15pt, weight: "bold")[for Additive Linear Imprecise Bandits with Euclidean Balls]
  #v(8pt)
  #text(size: 10pt)[A self-contained proof for the fixed-block residual-subspace algorithm]
]

#v(12pt)

#thm[
  *Abstract.* We study the sampled-outcome linear imprecise-bandit problem under the following restrictions: the arm set and outcome set are Euclidean balls in their affine hulls, the reward is affine in the arm and outcome, and after fixing the unknown hypothesis the mean constraints decompose additively into a term depending on the arm and a term depending on the outcome. The additive structure implies that the compatible mean sets are intersections of a Euclidean ball with a family of parallel affine subspaces. We give a polynomial-time block algorithm that estimates one affine feasible selection and incrementally learns only the residual directions that nature actually uses. A leverage-score rule limits the number of stored residuals; thresholded singular-value decomposition prevents sampling noise from creating large spurious directions; and a geometric lemma controls intersections with the outcome ball even at tangency. With block length $n = ceil(T^(8/9))$, the resulting expected regret is $tilde(O)(poly("input") T^(8/9))$.
]

#v(8pt)

#note[
  *Status and scope.* This is a new proof for the restricted Euclidean-ball subclass. It is not the proof of the original IUCB theorem. Kosoy's IUCB analysis gives a statistical $tilde(O)(sqrt(T))$ bound for the broader linear-imprecise-bandit model, but explicitly leaves computational complexity open. The present argument uses a different residual-subspace algorithm. The proof below is complete in the standard weak/additive-approximation model for continuous optimization; finite-precision tolerances are discussed in Section 12.
]

#outline(title: [Contents])
#pagebreak()

= Model and theorem

== Intrinsic affine coordinates

The outcome set in the linear imprecise-bandit model lies in an affine hyperplane $mu^(-1)(1)$. We work in intrinsic Euclidean coordinates on that hyperplane. After translating the centers of the arm and outcome balls, we may write

$ A = {x in RR^(d_A) : norm(x)_2 <= R_A}, quad D = {y in RR^(d_D) : norm(y)_2 <= R_D} $ <eq:balls>.

Translations only change constant terms in the affine constraint and reward. The reward is

$ r(x,y) = a^T x + b^T y + c $ <eq:reward>.

Fix the unknown true hypothesis $z^star$. To see exactly how the additive restriction enters, write the ambient constraint on the outcome hyperplane as

$ F_0(x,z^star)+F_1(y,z^star)=0 $.

Choose affine coordinates $x=c_A+U_A xi$ on the arm ball and $y=c_D+U_D upsilon$ on the outcome ball. Because the first term is linear in $x$ at fixed $z^star$ and the second is linear in $y$ at fixed $z^star$, substitution gives

$ F_0(U_A xi,z^star)+F_1(U_D upsilon,z^star)+F_0(c_A,z^star)+F_1(c_D,z^star)=0 $.

After choosing bases in the constraint space and renaming $xi,upsilon$ as $x,y$, this is

$ C y + B x + d = 0, $ <eq:constraint>

where $B$, $C$, and $d$ are fixed but unknown. Crucially, the matrix $C$ does not depend on the arm. In the homogeneous ambient formulation one can equivalently absorb $d$ into the fixed coordinate $mu(y)=1$; the constant appears here only because we use intrinsic affine coordinates. Define

$ L(x) := {y in RR^(d_D) : C y = - B x - d}, quad N := opker C $ <eq:slices>.

The true set of compatible conditional means at arm $x$ is

$ K^star(x) := L(x) ∩ D $ <eq:true-fiber>.

The standing validity assumption is

$ K^star(x) != emptyset quad "for every" x in A $ <eq:nonempty>.

On round $t$, after the learner chooses $x_t$, nature chooses an outcome distribution supported on $D$ whose conditional mean

$ m_t := E[y_t | cal(F)_(t-1)] $ <eq:conditional-mean>

belongs to $K^star(x_t)$. Nature may choose this distribution adaptively as a function of the entire past.

Define the true robust value

$ v^star(x) := min_(y in K^star(x)) r(x,y), quad V^star := max_(x in A) v^star(x) $ <eq:true-value>.

For a horizon $T$, the realized regret against a compatible nature policy is

$ R_T := T V^star - sum_(t=1)^T r(x_t,y_t) $ <eq:regret>.

The regret can be negative. We only need an upper bound.

== Precise theorem

Let

$ C_r := max_(x in A, y in D) r(x,y) - min_(x in A, y in D) r(x,y) $ <eq:reward-range>

be the reward range.

#thm[
  *Theorem 1 (efficient $T^(8/9)$ learning).* Assume the model above is specified by rational data and that the original mean constraints arise from an additive decomposition $F_0(x,z)+F_1(y,z)=0$, with $F_0$ bilinear in $(x,z)$ and $F_1$ bilinear in $(y,z)$. For every known horizon $T$, there is a policy whose arithmetic and weak-optimization running time is polynomial in $T$ and the input bit length and which, for every true hypothesis and every compatible adaptive nature policy, satisfies

  $ E[R_T] <= tilde(O)(P(d_A,d_D,R_A,R_D,norm(b)_2,C_r) T^(8/9)) $ <eq:main-bound>

  for a fixed polynomial $P$. The hypothesis set being an $ell_2$-ball is not used by the algorithm; the conclusion therefore remains valid for any hypothesis set that induces a valid family of slices of the form @eq:constraint.
]

The proof gives a more explicit high-probability intermediate bound. Up to fixed numerical constants, it is

$ R_T <= C_r (d_A + M_T + 3)n + C_b T sqrt(lambda) + 1, $ <eq:master-bound>

where $M_T = O(d_D log T)$, the block length is $n$, the residual threshold obeys $lambda = tilde(O)(poly("input") n^(-1/4))$, and $C_b$ is polynomial in $R_D$ and $norm(b)_2$. Choosing $n = ceil(T^(8/9))$ yields @eq:main-bound.

= Intuition

The additive constraint makes the problem geometrically special.

- Every arm $x$ has an affine constraint slice $L(x)$.
- All slices have the same direction space $N = opker C$.
- The arm only changes the offset of the slice.
- The actual feasible mean set is the bounded section $L(x) ∩ D$.

The learner first estimates one affine point $f(x)$ on every slice. It then maintains a subspace $hat(U)$ containing only directions revealed by nature. The provisional set

$ hat(K)(x) = (hat(f)(x) + hat(U)) ∩ D_rho $ <eq:provisional-intuition>

is usually smaller than the true feasible set and is therefore optimistic. There are two possibilities in a block.

+ The block average lies close to $hat(f)(x)+hat(U)$. Then the reward obtained in the block is close to the provisional robust value, and optimism implies small regret.
+ The block average has a substantial component outside the current model. Then the residual is informative and is stored. A determinant argument shows that this can happen only $O(d_D log T)$ times.

Noise causes two geometric errors. First, $hat(f)$ is displaced from $f$. Second, the learned singular subspace is slightly tilted away from $N$. These produce an affine-slice error of order $n^(-1/4)$. A nearly tangent slice of a ball can turn a displacement $e$ into endpoint movement of order $sqrt(e)$, so the worst-case value error is only $n^(-1/8)$. Balancing $n$ costly exploration rounds against $T n^(-1/8)$ exploitation error gives $n = T^(8/9)$.

= Parallel affine slices and anchor interpolation

== Parallel-slice lemma

#thm[
  *Lemma 2 (parallel slices).* If $L(x)$ is nonempty, then for every choice $f(x) in L(x)$,

  $ L(x) = f(x) + N, quad N = opker C $ <eq:parallel>.
]

*Proof.* If $y,y' in L(x)$, then $C(y-y')=0$, so $y-y' in N$. Conversely, if $y in L(x)$ and $u in N$, then $C(y+u)=C y=-B x-d$, so $y+u in L(x)$. Therefore $L(x)=f(x)+N$. #h(1fr) $qed$

== Well-conditioned anchors

Choose the $d_A+1$ anchors

$ x^(0)=0, quad x^(i)=R_A e_i quad (1 <= i <= d_A), $ <eq:anchors>

where $e_i$ are the standard basis vectors. For $x=R_A u$ with $norm(u)_2<=1$, define

$ alpha_i(x)=u_i quad (i>=1), quad alpha_0(x)=1-sum_(i=1)^(d_A) u_i $ <eq:alpha>.

Then

$ x = sum_(i=0)^(d_A) alpha_i(x) x^(i), quad sum_(i=0)^(d_A) alpha_i(x)=1 $ <eq:affine-coefficients>.

Moreover,

$ sum_(i=0)^(d_A) abs(alpha_i(x)) <= 1 + 2 sqrt(d_A) =: L_A $ <eq:coefficient-bound>.

Indeed,

$ abs(1-sum_i u_i)+sum_i abs(u_i) <= 1+2sum_i abs(u_i) <= 1+2sqrt(d_A) norm(u)_2 $.

#thm[
  *Lemma 3 (anchor interpolation).* Let $m_i in L(x^(i))$ be arbitrary points. Define

  $ f(x):=sum_(i=0)^(d_A) alpha_i(x)m_i $ <eq:true-selection>.

  Then $f(x) in L(x)$ for every $x in A$, and hence $L(x)=f(x)+N$.
]

*Proof.* Since $C m_i+B x^(i)+d=0$,

$ C f(x)+B x+d = sum_i alpha_i(x)(C m_i+B x^(i)+d)=0 $.

Thus $f(x) in L(x)$, and Lemma 2 gives the second claim. #h(1fr) $qed$

The points $m_i$ need not be canonical, and they need not be chosen by the learner. In the noisy algorithm they are the latent average conditional means in the anchor blocks. Any such choice defines a valid affine selection.

= Algorithm

Fix a horizon $T$ and a block length $n$. The final choice will be $n=ceil(T^(8/9))$. All numerical parameters below are computed from $T$ before play begins. If the parameter guard in Section 11 detects that the prescribed anchor and informative blocks cannot fit inside the horizon, or that the resulting threshold exceeds one, the policy uses the fallback action described there. Otherwise the algorithm uses fixed-length blocks after an initial anchor phase.

== Anchor phase

Play each anchor $x^(i)$ for $n$ consecutive rounds and let $bar(y)_i$ be the observed block average. Define

$ hat(f)(x) := sum_(i=0)^(d_A) alpha_i(x) bar(y)_i $ <eq:estimated-selection>.

== Residual data and learned subspace

The algorithm stores only residuals declared informative. If $M$ residuals have been stored, put them into the matrix

$ hat(R)_M := [hat(r)_1, ..., hat(r)_M] in RR^(d_D times M) $ <eq:residual-matrix>.

Initially $M=0$ and $hat(R)_0$ is empty. Given a threshold $lambda>0$, define $hat(U)_M$ to be the span of the left singular vectors of $hat(R)_M$ whose singular values are at least $lambda$. Initially $hat(U)_0={0}$.

Let

$ D_rho := {y : norm(y)_2 <= R_D+rho}, quad rho:=2lambda $ <eq:expanded-ball>.

At the beginning of a post-anchor block, abbreviate $hat(U)=hat(U)_M$ and define

$ hat(K)(x):=(hat(f)(x)+hat(U)) ∩ D_rho $ <eq:estimated-fiber>.

== Arm choice

- If there exists an arm with $hat(K)(x)=emptyset$, choose such an arm.
- Otherwise define

  $ hat(v)(x):=min_(y in hat(K)(x)) r(x,y) $ <eq:estimated-value>

  and choose an arm $x$ satisfying

  $ hat(v)(x) >= max_(x' in A) hat(v)(x')-xi_T, quad xi_T:=T^(-2) $ <eq:approx-plan>.

Play the selected arm for $n$ rounds, except that the last block may be truncated at the horizon. For a complete block, let $bar(y)$ be its average and form the observed residual

$ hat(r):=bar(y)-hat(f)(x) $ <eq:observed-residual>.

Define

$ V_M:=lambda^2 I+hat(R)_M hat(R)_M^T $ <eq:leverage-matrix>.

The block is *informative* if

$ hat(r)^T V_M^(-1) hat(r)>1 $ <eq:leverage-test>.

In that case append $hat(r)$ to $hat(R)_M$, increase $M$ by one, recompute the thresholded singular subspace, and replan. If the block is noninformative, leave the model unchanged. The same arm remains an admissible approximate maximizer, so it may simply be repeated.

#thm[
  *Algorithm 1 (fixed-block residual-subspace learner).*

  + Play $d_A+1$ anchor blocks and construct $hat(f)$ by @eq:estimated-selection.
  + Set $M=0$, $hat(R)_0=[]$, and $hat(U)_0={0}$.
  + In each later block, form $hat(K)(x)$ by @eq:estimated-fiber.
  + If some estimated fiber is empty, play such an arm. Otherwise solve @eq:approx-plan.
  + After the block, compute $hat(r)$ and apply @eq:leverage-test.
  + Store an informative residual, update the SVD, and continue until time $T$.
]

= Uniform concentration and residual accuracy

We first condition on a high-probability event under which every block average is close to its average conditional mean.

== Block concentration

Consider any complete block of length $n$ in which one arm $x$ is fixed. Let

$ m := 1/n sum_(t " in the block") E[y_t | cal(F)_(t-1)] $ <eq:block-mean>.

Every conditional mean belongs to the convex set $K^star(x)$, so

$ m in K^star(x) $ <eq:block-mean-feasible>.

Also, $bar(y)-m$ is an average of bounded martingale differences.

#thm[
  *Lemma 4 (simultaneous block concentration).* Let $delta in (0,1)$. With probability at least $1-delta$, simultaneously for every complete block used by the algorithm,

  $ norm(bar(y)-m)_2 <= epsilon_n, $ <eq:epsilon-event>

  where one may take

  $ epsilon_n := 2sqrt(2) R_D sqrt((d_D log(2d_D T/delta))/n) $ <eq:epsilon-definition>.
]

*Proof.* The beginning of a block is a stopping time. Condition on the complete history at that stopping time. For a fixed coordinate $j$, the within-block variables $(y_t-m_t)_j$ are still martingale differences and have absolute value at most $2R_D$. Azuma-Hoeffding therefore gives, conditionally on the past and hence also unconditionally,

$ Pr(abs((bar(y)-m)_j)>=s) <= 2 exp(-n s^2/(8R_D^2)) $.

If $norm(bar(y)-m)_2>=epsilon$, then some coordinate has magnitude at least $epsilon/sqrt(d_D)$. Hence

$ Pr(norm(bar(y)-m)_2>=epsilon) <= 2d_D exp(-n epsilon^2/(8d_D R_D^2)) $.

There are at most $T$ complete blocks, including anchors. The conditional estimate is uniform in the adaptively selected arm and block-start history, so it can be union-bounded over the realized sequence of blocks. Substitute $epsilon=epsilon_n$ and take a union bound. #h(1fr) $qed$

For the remainder of the high-probability proof, fix the event in Lemma 4.

== Accuracy of $hat(f)$

Let $m_i$ be the latent average conditional mean in anchor block $i$. By Lemma 3 these means define the exact affine selection

$ f(x)=sum_i alpha_i(x)m_i $.

By @eq:coefficient-bound and @eq:epsilon-event,

$ sup_(x in A) norm(hat(f)(x)-f(x))_2 <= L_A epsilon_n $ <eq:f-error>.

== Accuracy of residuals

In a post-anchor complete block, let $m$ be the latent average conditional mean and define the true residual

$ r:=m-f(x) $ <eq:true-residual>.

Since $m in L(x)=f(x)+N$,

$ r in N $ <eq:true-residual-in-N>.

The observed residual decomposes as

$ hat(r)=r+e, quad e=(bar(y)-m)+(f(x)-hat(f)(x)) $ <eq:residual-decomposition>.

Therefore

$ norm(e)_2 <= (L_A+1)epsilon_n =: eta_n $ <eq:eta-definition>.

Every stored residual is thus within $eta_n$ of a true vector in $N$.

Finally, because every observed block average lies in $D$ and $norm(hat(f)(x))_2<=L_A R_D$,

$ norm(hat(r))_2 <= (L_A+1)R_D =: R_0 $ <eq:residual-bound>.

= The number of informative residuals

#thm[
  *Lemma 5 (elliptical-potential bound).* Suppose $M$ residuals have passed @eq:leverage-test. Then

  $ M <= d_D log_2(1+(T R_0^2)/(d_D lambda^2)) $ <eq:M-bound>.
]

*Proof.* Let $V_j=lambda^2 I+sum_(i=1)^j hat(r)_i hat(r)_i^T$. Whenever residual $j$ is stored, the matrix determinant lemma gives

$ opdet(V_j)=opdet(V_(j-1))(1+hat(r)_j^T V_(j-1)^(-1)hat(r)_j)>2opdet(V_(j-1)) $.

Thus

$ opdet(V_M)>2^M lambda^(2d_D) $ <eq:det-lower>.

On the other hand,

$ optr(V_M)<=d_D lambda^2+M R_0^2<=d_D lambda^2+T R_0^2 $.

The arithmetic-geometric mean inequality for the eigenvalues gives

$ opdet(V_M)<=((optr(V_M))/d_D)^(d_D)<= (lambda^2+(T R_0^2)/d_D)^(d_D) $ <eq:det-upper>.

Combine @eq:det-lower and @eq:det-upper and take base-two logarithms. #h(1fr) $qed$

To remove any circular dependence between $M$ and $lambda$, define the deterministic upper bound

$ M_T:=ceil(d_D log_2(1+(T^3 R_0^2)/d_D)) $ <eq:MT>.

We will choose $lambda>=T^(-1)$. Then Lemma 5 implies $M<=M_T$.

= SVD stability: learned directions stay near the true space

This is the central invariant. Exact containment $hat(U) subset.eq N$ is false under noise; the correct statement is one-sided closeness.

#thm[
  *Lemma 6 (one-sided SVD perturbation).* Suppose $M$ residuals have been stored and write

  $ hat(R)_M=R_M+E_M, $ <eq:R-plus-E>

  where every column of $R_M$ lies in $N$ and every column of $E_M$ has norm at most $eta_n$. Let $hat(U)$ be the singular subspace of $hat(R)_M$ corresponding to singular values at least $lambda$. Then every unit vector $u in hat(U)$ satisfies

  $ opdist(u,N) <= (sqrt(M) eta_n)/lambda $ <eq:subspace-error>.
]

*Proof.* Since every column error has norm at most $eta_n$,

$ norm(E_M)_(op) <= norm(E_M)_F <= sqrt(M)eta_n $ <eq:E-bound>.

Take a unit vector $u in hat(U)$. Expanding in retained left singular vectors shows that there exists a coefficient vector $alpha$ such that

$ u=hat(R)_M alpha, quad norm(alpha)_2<=1/lambda $ <eq:alpha-svd>.

Using @eq:R-plus-E,

$ u=R_M alpha+E_M alpha $.

The first term belongs to $N$, because $opcol(R_M) subset.eq N$. Therefore

$ opdist(u,N)<=norm(E_M alpha)_2<=norm(E_M)_(op)norm(alpha)_2<= (sqrt(M)eta_n)/lambda $.

#h(1fr) $qed$

The reverse inclusion need not hold. Nature may never use some directions of $N$, and the learner need not discover them.

== What a noninformative test guarantees

#thm[
  *Lemma 7 (noninformative residuals are close to the learned space).* If a residual fails @eq:leverage-test, then

  $ opdist(hat(r),hat(U)) <= sqrt(2)lambda $ <eq:noninformative-distance>.
]

*Proof.* The matrix $hat(R)_M hat(R)_M^T$ and $V_M$ have the same eigenvectors. On $hat(U)^perp$, every eigenvalue of $hat(R)_M hat(R)_M^T$ is strictly below $lambda^2$, so every eigenvalue of $V_M$ there is below $2lambda^2$. Hence

$ hat(r)^T V_M^(-1)hat(r) >= norm(P_(hat(U)^perp)hat(r))_2^2/(2lambda^2) $.

If the left side is at most one, @eq:noninformative-distance follows. #h(1fr) $qed$

= Stability of affine slices intersected with a ball

The next lemma is deliberately uniform over tangent and nontangent slices.

#thm[
  *Lemma 8 (ball-slice stability).* Let $L$ be an affine subspace of $RR^d$ satisfying $L ∩ B_2(0,R) != emptyset$. Suppose

  $ y in B_2(0,R+rho), quad opdist(y,L)<=delta $.

  Put $e:=rho+delta$. Then

  $ opdist(y,L ∩ B_2(0,R)) <= 2e+sqrt(2Re+e^2) $ <eq:ball-stability>.
]

*Intuition.* If the slice is transverse to the sphere, the right side can be improved to $O(e)$. At tangency, a normal displacement $e$ creates a chord of radius $Theta(sqrt(Re))$, so a square root is unavoidable.

*Proof.* Radially project $y$ into $B_2(0,R)$ and call the result $y_0$. Then

$ norm(y-y_0)_2<=rho, quad opdist(y_0,L)<=rho+delta=e $.

Let $q$ be the orthogonal projection of $y_0$ onto $L$. Then $norm(q)_2<=R+e$. Let $p$ be the minimum-norm point in $L$. Writing $L=p+V$, we have $p perp V$. Write $q=p+v$ with $v in V$. The intersection $L ∩ B_2(0,R)$ is the ball in $L$ centered at $p$ with radius

$ r_L=sqrt(R^2-norm(p)_2^2) $.

Since

$ norm(p)_2^2+norm(v)_2^2=norm(q)_2^2<=(R+e)^2, $

we obtain

$ norm(v)_2^2<=r_L^2+2Re+e^2 $.

Thus the distance from $q$ to the radius-$r_L$ ball in $L$ is at most $sqrt(2Re+e^2)$. Adding the radial-projection error and the projection-to-$L$ error gives at most

$ rho+e+sqrt(2Re+e^2)<=2e+sqrt(2Re+e^2) $.

#h(1fr) $qed$

= Comparing estimated and true fibers

We now choose the threshold. Define

$ R_U:=(L_A+3)max(R_D,1) $ <eq:RU>.

For the substantive regime of the proof, choose

$ lambda := max(T^(-1), 2eta_n, sqrt(R_U sqrt(M_T) eta_n)), quad rho:=2lambda $ <eq:lambda-choice>.

If this value exceeds one, the final theorem follows from the trivial bound $R_T<=C_r T$ after increasing the polynomial prefactor; see Section 11. Hence assume $lambda<=1$ below.

#thm[
  *Lemma 9 (estimated affine fibers are close to true affine fibers).* For every arm $x$ and every

  $ hat(y) in hat(L)(x) ∩ D_rho, quad hat(L)(x):=hat(f)(x)+hat(U), $

  we have

  $ opdist(hat(y),L(x)) <= 3lambda/2 $ <eq:affine-fiber-error>.
]

*Proof.* Write $hat(y)=hat(f)(x)+u$ with $u in hat(U)$. Since $norm(hat(y))_2<=R_D+rho$, $norm(hat(f)(x))_2<=L_A R_D$, and $rho<=2$, the definition @eq:RU gives $norm(u)_2<=R_U$.

By Lemma 6 and $M<=M_T$,

$ opdist(u,N)<=norm(u)_2 (sqrt(M_T)eta_n)/lambda <= R_U (sqrt(M_T)eta_n)/lambda $.

The choice @eq:lambda-choice implies $lambda^2>=R_U sqrt(M_T)eta_n$, hence the last display is at most $lambda$. Also, by @eq:f-error and @eq:eta-definition,

$ norm(hat(f)(x)-f(x))_2<=L_A epsilon_n<=eta_n<=lambda/2 $.

Since $L(x)=f(x)+N$, the triangle inequality gives @eq:affine-fiber-error. #h(1fr) $qed$

Define

$ G_D(lambda):=8lambda+sqrt(8R_D lambda+16lambda^2) $ <eq:GD-lambda>.

Applying Lemma 8 with $rho=2lambda$ and $delta=3lambda/2$, and loosening $e<=4lambda$, yields the following.

#thm[
  *Corollary 10 (estimated feasible points are near true feasible points).* For every arm $x$ and every $hat(y) in hat(K)(x)$, there exists $y in K^star(x)$ such that

  $ norm(hat(y)-y)_2<=G_D(lambda) $ <eq:point-correspondence>.
]

When $lambda<=1$,

$ G_D(lambda)<=C_D sqrt(lambda), quad C_D:=8+sqrt(8R_D+16) $ <eq:GD-sqrt>.

== Approximate optimism

#thm[
  *Lemma 11 (estimated values are approximately optimistic).* Whenever $hat(K)(x)$ is nonempty,

  $ hat(v)(x)>=v^star(x)-norm(b)_2 G_D(lambda) $ <eq:approx-optimism>.
]

*Proof.* For each $hat(y) in hat(K)(x)$, choose the corresponding $y in K^star(x)$ from Corollary 10. By linearity of the reward in $y$,

$ r(x,hat(y))>=r(x,y)-norm(b)_2 norm(hat(y)-y)_2>=v^star(x)-norm(b)_2 G_D(lambda) $.

Take the minimum over $hat(y)$. #h(1fr) $qed$

= Regret of noninformative blocks

#thm[
  *Lemma 12 (one noninformative block).* Suppose all estimated fibers are nonempty, the learner chooses an arm satisfying @eq:approx-plan, and the resulting complete block is noninformative. Then its average realized reward satisfies

  $ r(x,bar(y))>=V^star-norm(b)_2(G_D(lambda)+sqrt(2)lambda)-xi_T $ <eq:block-reward>.
]

Consequently, its average regret is at most

$ norm(b)_2(G_D(lambda)+sqrt(2)lambda)+xi_T $ <eq:block-regret>.

*Proof.* By Lemma 7, choose $u in hat(U)$ such that

$ norm(hat(r)-u)_2<=sqrt(2)lambda $.

Put $tilde(y):=hat(f)(x)+u$. Since $hat(r)=bar(y)-hat(f)(x)$,

$ norm(tilde(y)-bar(y))_2<=sqrt(2)lambda $.

The average $bar(y)$ lies in $D$ because $D$ is convex. Since $rho=2lambda>=sqrt(2)lambda$, we have $tilde(y) in D_rho$, and therefore $tilde(y) in hat(K)(x)$. Hence

$ r(x,bar(y))>=r(x,tilde(y))-norm(b)_2 sqrt(2)lambda>=hat(v)(x)-norm(b)_2 sqrt(2)lambda $.

Let $x^star$ maximize $v^star$. Approximate planning and Lemma 11 imply

$ hat(v)(x)>=hat(v)(x^star)-xi_T>=V^star-norm(b)_2G_D(lambda)-xi_T $.

Combining the two inequalities proves @eq:block-reward. #h(1fr) $qed$

Because the arm is fixed within the block and the reward is affine,

$ r(x,bar(y))=1/n sum_(t " in the block") r(x,y_t) $ <eq:average-reward-linearity>.

Thus Lemma 12 is a bound on actual cumulative block regret, not merely on the reward of an unobserved conditional mean.

= Empty estimated fibers force information

#thm[
  *Lemma 13 (empty-fiber blocks are informative).* Suppose the learner selects an arm $x$ for which $hat(K)(x)=emptyset$. Then the resulting complete block must pass @eq:leverage-test.
]

*Proof.* If the block were noninformative, Lemma 7 would give $u in hat(U)$ with

$ norm(bar(y)-(hat(f)(x)+u))_2<=sqrt(2)lambda $.

Since $bar(y) in D$ and $rho=2lambda$, the point $hat(f)(x)+u$ would belong to $D_rho$. It also belongs to $hat(f)(x)+hat(U)$, so it would be in $hat(K)(x)$, contradicting emptiness. #h(1fr) $qed$

Thus every block used to repair an empty provisional model is counted among the at most $M_T$ informative blocks.

= Total regret and the exponent $8/9$

Fix

$ delta:=T^(-3), quad n:=ceil(T^(8/9)), quad xi_T:=T^(-2), $ <eq:final-parameters>

and define $epsilon_n$, $eta_n$, $M_T$, $lambda$, and $rho$ by @eq:epsilon-definition, @eq:eta-definition, @eq:MT, and @eq:lambda-choice.

== High-probability regret bound

On the event of Lemma 4, partition the rounds into four groups.

+ *Anchor rounds.* There are at most $(d_A+1)n$ of them.
+ *Informative post-anchor blocks.* By Lemma 5 there are at most $M_T$, so they use at most $M_T n$ rounds.
+ *One truncated final block.* It uses at most $n$ rounds.
+ *Complete noninformative blocks.* Lemma 12 applies to every such block.

Each round in the first three groups contributes at most $C_r$ positive regret. Therefore

$ R_T <= C_r(d_A+M_T+2)n + T norm(b)_2(G_D(lambda)+sqrt(2)lambda)+T xi_T $ <eq:good-event-bound>.

Using @eq:GD-sqrt and $lambda<=1$,

$ R_T <= C_r(d_A+M_T+2)n + norm(b)_2(C_D+sqrt(2))T sqrt(lambda)+1 $ <eq:good-event-simplified>.

== Scaling of $lambda$

The definitions give

$ epsilon_n = tilde(O)(R_D sqrt(d_D/n)), $ <eq:eps-scale>

$ eta_n = tilde(O)(L_A R_D sqrt(d_D/n)), $ <eq:eta-scale>

and

$ M_T=O(d_D log(1+T^3R_0^2)) $ <eq:M-scale>.

From @eq:lambda-choice,

$ sqrt(lambda) <= T^(-1/2)+sqrt(2eta_n)+(R_U sqrt(M_T)eta_n)^(1/4) $ <eq:sqrt-lambda>.

The last term is dominant and is

$ tilde(O)(poly(d_A,d_D,R_D) n^(-1/8)) $ <eq:sqrt-lambda-scale>.

Substituting into @eq:good-event-simplified yields

$ R_T <= tilde(O)(poly("input")((d_A+d_D) n+T n^(-1/8))) $ <eq:n-tradeoff>.

The two powers are balanced by

$ n=T^(8/9), quad T n^(-1/8)=T^(8/9) $ <eq:balance>.

Hence, on the concentration event,

$ R_T <= tilde(O)(poly("input")T^(8/9)) $ <eq:high-prob-final>.

== Small-horizon and large-threshold regimes

The proof above assumed that the anchor and informative blocks fit within the horizon and that $lambda<=1$. We now verify that the omitted regimes are absorbed by the polynomial prefactor.

First suppose

$ (d_A+M_T+2)n>T $.

Since $n>=T^(8/9)$, this implies

$ T^(1/9)<d_A+M_T+2 $.

Hence the trivial estimate $R_T<=C_r T$ satisfies

$ R_T<=C_r(d_A+M_T+2)T^(8/9) $.

Next suppose $lambda>1$. Because $T>=2$, the term $T^(-1)$ in @eq:lambda-choice is below one. Thus either $2eta_n>1$ or $R_U sqrt(M_T)eta_n>1$. From @eq:eta-scale there is a fixed polynomial-logarithmic quantity $Q_T=tilde(O)(poly(d_A,d_D,R_D))$ such that

$ eta_n<=Q_T T^(-4/9) $.

In the first case, $T^(4/9)<2Q_T$; in the second case, $T^(4/9)<R_U sqrt(M_T)Q_T$. Taking fourth roots gives

$ T^(1/9)<=tilde(O)(poly(d_A,d_D,R_D)) $.

Therefore $C_r T$ is again at most a polynomial-logarithmic input factor times $T^(8/9)$. These conditions depend only on the known horizon, dimensions, radii, and confidence parameters, so the algorithm checks them before starting the anchor phase. In either exceptional regime it simply plays an arbitrary fixed arm for all $T$ rounds. Enlarging the polynomial prefactor gives a uniform statement for every $T>=2$.

== Expected regret

The event in Lemma 4 fails with probability at most $delta=T^(-3)$. Since $R_T<=C_r T$ always,

$ E[R_T] <= tilde(O)(poly("input")T^(8/9))+delta C_r T $.

The second term is $C_r T^(-2)$. This proves Theorem 1. #h(1fr) $qed$

= Polynomial-time implementation

It remains to justify that every step can be implemented in polynomial time.

== Linear algebra

The anchor interpolation map $hat(f)$ is explicit and affine. Residual formation, regularized leverage scores, singular-value decomposition, orthogonal projections, and the construction of $hat(U)$ are standard polynomial-time linear-algebra operations. Regularization gives

$ V_M - lambda^2 I " is positive semidefinite", $

and $lambda>=T^(-1)$, so the relevant condition numbers are polynomially bounded in $T$ and the input scale.

== Geometry of the provisional fiber

Let $P$ be the orthogonal projector onto $hat(U)^perp$ and define

$ q(x):=P hat(f)(x) $ <eq:q-definition>.

Because $hat(f)$ is affine, so is $q$. The closest point of the affine space $hat(f)(x)+hat(U)$ to the origin is $q(x)$. Therefore

$ hat(K)(x)!=emptyset ⇔ norm(q(x))_2<=R_D+rho $ <eq:fiber-nonempty-test>.

When nonempty,

$ hat(K)(x)=q(x)+{u in hat(U):norm(u)_2<=sqrt((R_D+rho)^2-norm(q(x))_2^2)} $ <eq:fiber-ball-form>.

== Finding an empty fiber

To decide whether some estimated fiber is empty, maximize

$ norm(q(x))_2^2 $ <eq:empty-objective>

subject to $norm(x)_2<=R_A$. This is a quadratic optimization problem over one Euclidean ball, i.e. a trust-region problem, and is polynomial-time solvable to prescribed additive accuracy.

== Robust value formula

Let

$ beta:=norm(P_(hat(U))b)_2 $ <eq:beta>.

Using @eq:fiber-ball-form, the inner minimization is explicit:

$ hat(v)(x)=a^T x+b^T q(x)+c-beta sqrt((R_D+rho)^2-norm(q(x))_2^2) $ <eq:value-formula>.

Indeed, nature moves in the direction $-P_(hat(U))b$ with the largest norm allowed by the residual ball in @eq:fiber-ball-form.

== Outer planning as a fixed-constraint QCQP

Introduce a scalar $s>=0$. Maximizing @eq:value-formula is equivalent to

$ max_(x,s) a^T x+b^T q(x)+c-beta s $ <eq:qcqp-objective>

subject to

$ norm(x)_2^2<=R_A^2, $ <eq:qcqp-arm>

$ s^2+norm(q(x))_2^2=(R_D+rho)^2, $ <eq:qcqp-equality>

$ s>=0 $ <eq:qcqp-sign>.

The equality is represented by two quadratic inequalities. To make the compact ellipsoidal constraint positive definite in all variables, add the redundant inequality

$ norm(x)_2^2/R_A^2+s^2/(R_D+rho)^2<=2 $ <eq:redundant-ellipsoid>.

It is redundant under @eq:qcqp-arm and @eq:qcqp-equality and is a genuine ellipsoid in $(x,s)$. The lifted problem therefore has a fixed number of quadratic constraints, one of which is ellipsoidal. Bienstock's weak-optimization theorem for quadratic programming with a fixed number of quadratic constraints and one ellipsoidal constraint gives a polynomial-time additive-accuracy algorithm in the standard bit model.

Choosing planning accuracy $xi_T=T^(-2)$ makes the cumulative planning loss at most $T xi_T<=T^(-1)$.

== Finite precision

The proof was written with exact SVD thresholds and exact comparisons to one in @eq:leverage-test. With rational input and polynomial-bit feedback, compute all matrix quantities to accuracy $nu=T^(-c)$ for a sufficiently large fixed $c$ and use gray zones of width $nu$ around the thresholds. Retained singular directions then have singular value at least $lambda-nu$, discarded directions have singular value at most $lambda+nu$, and informative determinant growth and Lemma 7 change only by fixed numerical factors. Since $lambda>=T^(-1)$, taking $nu<=lambda/100$ requires only $O(log T)$ additional bits.

For the empty-fiber test, weakly maximize $norm(q(x))_2^2$. If the returned lower bound exceeds $(R_D+rho)^2$ by more than the solver tolerance, the returned arm has an empty provisional fiber. Otherwise every arm has a nonempty fiber after increasing $rho$ by $O(sqrt(nu))$. Use this slightly larger radius in the planning step. Approximate projectors and approximate feasible QCQP points perturb provisional fibers by another $O(sqrt(nu))$; all these errors are absorbed by replacing $rho$ with $rho+O(sqrt(nu))$. Choose $c$ large enough that $sqrt(nu)=o(lambda)$, so every displayed estimate changes only by a fixed factor. The QCQP solver is already formulated in the weak/additive model. Consequently the complete implementation has polynomial arithmetic complexity; under polynomial-bit rational feedback it has running time polynomial in $T$ and the input bit length.

= Why the three error terms appear

For reference, the geometric mismatch used in the proof can be summarized schematically as

$ e_("geom") approx lambda + (R_U sqrt(M)eta_n)/lambda + eta_n $ <eq:three-errors>.

The terms have distinct meanings.

- $lambda$ is the behavior tolerated below the informative-residual threshold.
- $(R_U sqrt(M)eta_n)/lambda$ is the tilt of the retained singular subspace. The numerator is the operator norm of the accumulated residual-noise matrix, and division by $lambda$ comes from retaining only singular directions of strength at least $lambda$.
- $eta_n$ is the direct displacement of the affine baseline $hat(f)$ and of each residual.

The choice $lambda^2 approx R_U sqrt(M)eta_n$ balances the first two terms, giving $e_("geom")=tilde(O)(n^(-1/4))$. Lemma 8 then turns this into a worst-case reward error $O(sqrt(e_("geom")))=tilde(O)(n^(-1/8))$ near tangency.

= Relation to the noiseless case

If outcomes equal their conditional means and the anchor observations are exact, then $eta_n=0$. Every residual lies exactly in $N$, so the learned span is contained in $N$. A residual outside the current span reveals a genuinely new direction. At most $dim(N)$ such events occur. On all other rounds the realized outcome lies in the current optimistic set and the round has nonpositive regret. Thus the noisy proof is a quantitative replacement of the noiseless dichotomy:

$ "either nature stays inside the learned model, or nature reveals a new direction." $

= References

+ Vanessa Kosoy. *Imprecise Multi-Armed Bandits: Representing Irreducible Uncertainty as a Zero-Sum Game.* Journal of Machine Learning Research 26, 2025, 1-75.
+ Daniel Bienstock. *A Note on Polynomial Solvability of the CDT Problem.* Mathematical Programming, 2016; arXiv:1406.6429.
+ Tor Lattimore and Csaba Szepesvari. *Bandit Algorithms.* Cambridge University Press, 2020.
