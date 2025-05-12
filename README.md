# Final Paper – Greenland Trade and Annexation

This repository contains the LaTeX source files, figures, and data used to produce my final economics paper on Greenland, trade diversion, and U.S. annexation interests.

## Files

- `docs.tex` – Main LaTeX file  
- `docs.pdf` – Final compiled paper  
- `adonis.cls` – Custom class file for formatting  
- `bibliography.bib` – Bibliography and citation data  
- `images/` – Folder with all figures and maps  
- `graph.R` – R script for seafood import visualizations  
- `FoodImports.csv` – Data for U.S. seafood imports  
- `.gitignore` – LaTeX build and temp file exclusions  
- `LICENSE` – MIT license  
- `README.md` – This file

## To Compile

Run:

```bash
pdflatex docs.tex
biber docs
pdflatex docs.tex
pdflatex docs.tex
