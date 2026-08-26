# Repository instructions

## Document style

- By default, do not give lemmas names or title-like bold prefixes; begin a
  `#lemma[...]` block directly with its mathematical statement. Add a lemma
  name only when the user explicitly requests one. Internal reference labels
  are allowed.
- Write for a mathematically mature reader. Keep the exposition compact but
  explicit, and do not expand routine specializations that the reader can
  immediately derive from a general statement.
- When technical jargon is used only once, replace it with its operative
  mathematical definition instead of introducing the term and then defining
  it separately.
- State a general property once rather than enumerating its obvious special
  cases.
- Integrate definitions and explanations into the proof's narrative. Avoid
  meta-expository detours that interrupt the argument's forward motion.
- Use concrete notation and named mathematical objects instead of vague
  referents such as "the weak solution" or "the scalar changes."
- Include explanatory material when it is needed for the next step of the
  argument; omit details that merely repeat what was just displayed.

## Typst mathematics

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
