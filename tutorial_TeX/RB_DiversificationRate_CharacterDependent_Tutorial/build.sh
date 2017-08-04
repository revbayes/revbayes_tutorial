#!/bin/bash

tutorial="DiversificationRate_CharacterDependent_Tutorial"

pdflatex RB_${tutorial}.tex
bibtex RB_${tutorial}
pdflatex RB_${tutorial}.tex
pdflatex RB_${tutorial}.tex

rm RB_${tutorial}.aux
rm RB_${tutorial}.bbl
rm RB_${tutorial}.blg
rm RB_${tutorial}.log
rm RB_${tutorial}.out

