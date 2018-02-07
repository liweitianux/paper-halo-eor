#
# Weitian LI, et al.
# 2017-07-18
# Updated: 2018-02-01
#
# Credit:
# [1] How to get current relative directory of your Makefile?
#     https://stackoverflow.com/a/23324703
#

# Whether CJK support required (will use `xelatex`)
# Comment out this to disable CJK support.
CJK:= ON

# Name to identify the reported manuscript
ID:= lwt

DATE:=		$(shell date +'%Y%m%d')
ROOT_DIR:=	$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJNAME:=	$(shell basename $(ROOT_DIR))

# Environment variables
TEXINPUTS:= .:aastex:revtex:texmf:$(TEXINPUTS)
BSTINPUTS:= .:aastex:revtex:texmf:$(BSTINPUTS)

# EPS figures
EPS_FIG:= $(wildcard figures/*.eps)
PDF_FIG:= $(EPS_FIG:.eps=.pdf)

default: main.pdf

eps2pdf: $(PDF_FIG)

report: main.pdf main.tex references.bib
	mkdir reports/v$(DATE)
	cp main.pdf reports/v$(DATE)/manuscript-$(ID)-$(DATE).pdf
	cp main.tex reports/v$(DATE)/manuscript-$(ID)-$(DATE).tex
	cp references.bib reports/v$(DATE)/references-$(ID)-$(DATE).bib

main.pdf: main.tex references.bib
ifeq ($(CJK),ON)
	# XeLaTeX with CJK support
	env TEXINPUTS=$(TEXINPUTS) BSTINPUTS=$(BSTINPUTS) latexmk -xelatex $<
else
	# pdfLaTeX
	env TEXINPUTS=$(TEXINPUTS) BSTINPUTS=$(BSTINPUTS) latexmk -pdf $<
endif

%.pdf: %.eps
	epstopdf $^ $@

clean:
	latexmk -c main.tex
	touch main.tex

cleanall:
	latexmk -C main.tex

.PHONY: report clean cleanall


# One liner to get the value of any makefile variable
# Credit: http://blog.jgc.org/2015/04/the-one-line-you-should-add-to-every.html
print-%: ; @echo $*=$($*)
