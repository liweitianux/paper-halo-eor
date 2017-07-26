#
# Weitian LI, et al.
# 2017-07-18
# Updated: 2017-07-27
#
# Credit:
# [1] How to get current relative directory of your Makefile?
#     https://stackoverflow.com/a/23324703
#

DATE:=		$(shell date +'%Y%m%d')
ROOT_DIR:=	$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJNAME:=	$(shell basename $(ROOT_DIR))

# Environment variables
TEXINPUTS:= .:aastex:revtex:$(TEXINPUTS)
BSTINPUTS:= .:aastex:revtex:$(BSTINPUTS)

default: main.pdf

report: main.pdf
	mkdir reports/v$(DATE)
	for f in main.pdf main.tex references.bib; do \
		suffix=`echo $$f | awk -F'.' '{ print $$NF }'`; \
		cp -v $$f reports/v$(DATE)/$${f%.$$suffix}-$(DATE).$$suffix; \
	done

main.pdf: main.tex references.bib
	env TEXINPUTS=$(TEXINPUTS) BSTINPUTS=$(BSTINPUTS) latexmk -pdf $<

clean:
	latexmk -c main.tex

cleanall:
	latexmk -C main.tex

.PHONY: report clean cleanall


# One liner to get the value of any makefile variable
# Credit: http://blog.jgc.org/2015/04/the-one-line-you-should-add-to-every.html
print-%: ; @echo $*=$($*)
