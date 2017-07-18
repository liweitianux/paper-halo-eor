#
# Weitian LI, et al.
# 2017-07-18
#

all: main.pdf

main.pdf: main.tex references.bib
	latexmk -pdf $<

clean:
	latexmk -c main.tex

cleanall:
	latexmk -C main.tex

.PHONY: clean cleanall
