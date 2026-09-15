# Repository instructions

## Default writing voice

- Write in the user's voice by default, including manuscript prose, notes,
  and explanations. Use the user's own writing and passages they have
  explicitly liked as the reference. Their latest edits and feedback take
  precedence over generic preferences for academic style.
- Use plain, direct sentences that explain what we are doing and why.
  Keep the mathematics precise, but let the prose sound like a person
  explaining an argument to another mathematician. Publication quality
  should come from clarity and correctness, not a more formal voice.
- Develop the thought one step at a time. State the task or idea, raise the
  natural objection when it matters, give a concrete example, and explain
  why the objection does or does not cause a problem. Use this sequence
  when it helps the argument; do not force it onto every paragraph.
- Prefer concrete objects and actions: "learn enough about L to get low
  regret" rather than "seek an approximation sufficient to control regret."
  Avoid replacing familiar words with abstract nouns or academic phrases.
  Natural transitions such as "For example" and "But this is fine" are
  welcome when they fit; they are not a checklist of phrases to insert.
- Keep necessary qualifications, but put them where the argument needs
  them. Do not overload an introductory explanation with technical caveats.
  If an intuitive claim needs an assumption to be correct, state the
  assumption plainly or narrow the claim rather than glossing over it.
  When setting an issue aside temporarily, state the assumption directly
  and say that the issue will be addressed later; do not use a label such
  as "warmup" in place of that explanation.
- Preserve the user's wording and rhythm when editing. Do not rewrite
  their prose into a generic conference-paper voice. Match their style,
  not the typos or shorthand in their chat messages. In particular,
  "polish" or "make this publishable" does not override this default.

The user explicitly approved the following passage as matching their voice:

> The learner’s task is to learn enough about \(\mathcal L\) to get low regret.
> Of course, we may never learn all of \(\mathcal L\). For example, if nature
> keeps choosing conditional means in a strictly smaller subspace, then we
> cannot distinguish that subspace from the true \(\mathcal L\). But this is
> fine: we do not need to learn directions that nature never uses.

Use this as a reference for tone and the sequence of the explanation, not
as a template to repeat verbatim in unrelated passages.

### Learn from writing feedback

- Whenever the user asks for a change to our writing, consider why they
  asked and what general preference the correction reveals. This includes
  feedback about tone, wording, structure, explanations, and notation.
- Make the requested revision and update the writing guidelines in this
  `AGENTS.md` during the same task. Record the principle so it applies to
  future writing, rather than just describing the edit to the current
  passage. The user has authorized these updates; do not wait for a
  separate request or confirmation.
- Keep each inferred preference as specific as the feedback supports.
  Distinguish a preference about writing from a correction to the subject
  matter or an instruction that applies only to one passage. Do not invent
  a broader preference when the reason for the change is unclear.
- Before adding a guideline, read the existing writing guidelines in this
  file and judge whether they already express the same principle, even in
  different words. If they do, apply the existing rule without adding or
  rewriting it. If the feedback adds a useful qualification or changes an
  earlier preference, refine that rule. Add a new guideline only when the
  principle is not already covered. Apply the resulting guidance to the
  current revision and future writing.

## Draft review colour

- By default, wrap every new or substantively rewritten piece of
  user-visible Typst manuscript content authored by Codex in `#draft[...]`.
  This includes prose, headings, theorem and lemma statements, proofs,
  captions, list items, and displayed mathematics.
- Do not recolour unchanged text written by the user or mechanically edited
  notation. If a `.typ` file does not yet define the review macros, add:

  ```typst
  #let draft(body) = {
    set text(fill: rgb("#0057d9"))
    body
  }
  ```

- `#draft[...]` renders the enclosed content blue. Once the user accepts a
  passage, convert it to the normal document colour by deleting only the word
  `draft`: `#draft[...]` becomes `#[...]`. Do not alter the accepted wording
  during that conversion.
- If the user explicitly requests normal-coloured text, or explicitly marks a
  passage as accepted, use `#[...]` or leave it unwrapped.

## Document style

- By default, do not give lemmas names or title-like bold prefixes; begin a
  `#lemma[...]` block directly with its mathematical statement. Add a lemma
  name only when the user explicitly requests one. Internal reference labels
  are allowed.
- Write for a mathematically mature reader. Keep the exposition compact but
  explicit, and do not expand routine specializations that the reader can
  immediately derive from a general statement.
- When introducing a learner, give a short description in words of how it
  works, in the order its steps happen, before the formal algorithm.
  Explain what each step does before referring to its outputs by
  shorthand: for example, explain that a block consists of repeated plays
  of one arm before referring to a "block mean." State the algorithm and
  the definitions needed to read it before presenting the lemmas and
  proofs used to analyze it. When a parameter will be chosen later,
  briefly say so at its introduction and explain what the choice is
  meant to achieve.
- When technical jargon is used only once, replace it with its operative
  mathematical definition instead of introducing the term and then defining
  it separately. For outcome sets in this manuscript, do not use "fiber"
  or "fibre": name the set and say what it contains, such as the feasible
  outcomes $K_z(x)$ at arm $x$ or the affine solution space $Ax+e+N$.
- State a general property once rather than enumerating its obvious special
  cases.
- Integrate definitions and explanations into the proof's narrative.
  Define a new function or quantity before the formula or instruction that
  uses it, including within an algorithm step or display. For example,
  define a score before writing the rule that maximizes it. When giving
  formal notation to an idea already explained in words, explicitly connect
  the notation to that earlier explanation. Avoid
  meta-expository detours that interrupt the argument's forward motion.
- Use concrete notation and named mathematical objects instead of vague
  referents such as "the weak solution" or "the scalar changes." For
  constructions introduced in the manuscript, prefer their notation or
  coordinates to repeated technical adjectives. In particular, refer to
  $(1,x,y)$ or $(1,x,m)$ directly and explain what the coordinates mean;
  do not call the space, vectors, or means "lifted."
- Include explanatory material when it is needed for the next step of the
  argument; omit details that merely repeat what was just displayed.

## Typst mathematics

- Use unprimed variables in function definitions unless a distinction is
  needed there. A prime used to distinguish a candidate arm from the chosen
  arm in an optimization rule need not carry into the function's definition.
- In Typst math, always put a space between a symbol carrying a subscript or
  superscript and a following argument or multiplication parenthesis. Write
  `v_t (x)`, `K_M^("in") (x)`, `d_D (d_A+1)`, and `log_2 (z)`; never write
  `v_t(x)` or another attachment immediately followed by `(`.
- Before finishing edits to a `.typ` file, search the whole edited document
  for a subscript or superscript immediately followed by `(` and fix every
  unintended attachment. Parentheses deliberately grouped into the attachment,
  such as `epsilon_(n,delta)` or `x^((i))`, are exceptions.
  A useful audit is
  `rg -n --pcre2 '_(?:[A-Za-z0-9]+|\([^()]*\))\(|\^(?:[A-Za-z0-9]+|\([^()]*\))\(' <file>`.
