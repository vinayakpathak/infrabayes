# Repository instructions for Claude Code

This repository keeps its agent instructions in one file, `AGENTS.md`, so
that Codex and Claude Code follow the same rules. The line below imports
that file; do not copy its contents here.

@AGENTS.md

## Reading AGENTS.md as Claude Code

- Every rule in `AGENTS.md` applies to Claude Code. Where it says "Codex",
  read "the coding agent doing the work", which includes Claude Code. In
  particular, wrap new or substantively rewritten Typst manuscript content
  that you author in `#draft[...]`, exactly as the draft review colour
  section describes.
- When `AGENTS.md` says to record an inferred writing preference "in this
  `AGENTS.md`", edit `AGENTS.md` itself, not this file. That keeps a single
  source of truth for both tools. Limit this file to notes that only
  concern Claude Code.
