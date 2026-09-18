#!/bin/sh
set -eu
cd "$(dirname "$0")"
if command -v tectonic >/dev/null 2>&1; then
    tectonic efficient_imprecise_bandits.tex
elif [ -x "$HOME/.local/bin/tectonic" ]; then
    "$HOME/.local/bin/tectonic" efficient_imprecise_bandits.tex
elif command -v latexmk >/dev/null 2>&1; then
    latexmk -pdf -interaction=nonstopmode -halt-on-error efficient_imprecise_bandits.tex
elif command -v pdflatex >/dev/null 2>&1; then
    pdflatex -interaction=nonstopmode -halt-on-error efficient_imprecise_bandits.tex
    pdflatex -interaction=nonstopmode -halt-on-error efficient_imprecise_bandits.tex
else
    printf '%s\n' 'Install Tectonic or a LaTeX distribution with latexmk/pdflatex.' >&2
    exit 1
fi
