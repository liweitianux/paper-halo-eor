#
# Weitian LI
# 2017-07-18
#

# Comment out to disable CJK support (use `pdflatex' instead of `xelatex')
#CJK:= ON

# Name to identify the reported manuscript
ID:= lwt

DATE:=		$(shell date +'%Y%m%d')

# Get current relative directory
# Credit: https://stackoverflow.com/a/23324703
ROOT_DIR:=	$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJNAME:=	$(shell basename $(ROOT_DIR))

# Environment variables
TEXINPUTS:=	.:aastex:revtex:texmf:$(TEXINPUTS)
BSTINPUTS:=	.:aastex:revtex:texmf:$(BSTINPUTS)

# EPS figures
EPS_FIG:=	$(wildcard figures/*.eps)
PDF_FIG:=	$(EPS_FIG:.eps=.pdf)

# Files to pack for AAS submission
SRCS:=		main.tex references.bib
FIGURES:=	$(wildcard figures/*.pdf)
TEMPLATE:=	aastex/aastex62.cls aastex/aasjournal-links.bst

default: main.pdf

eps2pdf: $(PDF_FIG)

report: main.pdf $(SRCS)
	mkdir reports/v$(DATE)
	cp main.pdf reports/v$(DATE)/manuscript-$(ID)-$(DATE).pdf
	cp main.tex reports/v$(DATE)/manuscript-$(ID)-$(DATE).tex
	cp references.bib reports/v$(DATE)/references-$(ID)-$(DATE).bib

main.pdf: $(SRCS) $(TEMPLATE) $(FIGURES) eps2pdf
ifeq ($(CJK),ON)
	# use XeLaTeX (support CJK)
	env TEXINPUTS=$(TEXINPUTS) BSTINPUTS=$(BSTINPUTS) latexmk -xelatex $<
else
	# pdfLaTeX
	env TEXINPUTS=$(TEXINPUTS) BSTINPUTS=$(BSTINPUTS) latexmk -pdf $<
endif

aaspack: $(SRCS) $(TEMPLATE) $(FIGURES)
	mkdir $@.$(DATE)
	@for f in $(SRCS) $(TEMPLATE) $(FIGURES); do \
		cp -v $$f $@.$(DATE)/; \
	done
	tar -cjf $@.$(DATE).tar.bz2 -C $@.$(DATE)/ .
	rm -r $@.$(DATE)

%.pdf: %.eps
	epstopdf $^ $@

clean:
	latexmk -c main.tex
	touch main.tex

cleanall:
	latexmk -C main.tex

help:
	@echo "default - compile the paper PDF file (main.pdf)"
	@echo "eps2pdf - convert figures from EPS to PDF"
	@echo "aaspack - pack the necessary files and figures for AAS submission"
	@echo "clean - clean the temporary files"
	@echo "cleanall - clean temporary files and the output PDF file"

.PHONY: report clean cleanall help


# One liner to get the value of any makefile variable
# Credit: http://blog.jgc.org/2015/04/the-one-line-you-should-add-to-every.html
print-%: ; @echo $*=$($*)
