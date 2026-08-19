# Repository instructions

## Document style

- By default, do not give lemmas names or title-like bold prefixes; begin a
  `#lemma[...]` block directly with its mathematical statement. Add a lemma
  name only when the user explicitly requests one. Internal reference labels
  are allowed.

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
