ID:=		halo-eor

# Files to pack for AAS submission
SRCS:=		main.tex references.bib
FIGURES:=	$(wildcard figures/*.pdf)
TEMPLATE:=	aastex/aastex62.cls aastex/aasjournal-links.bst

TEXINPUTS:=	.:aastex:revtex:texmf:$(TEXINPUTS)
BSTINPUTS:=	.:aastex:revtex:texmf:$(BSTINPUTS)

DATE:=		$(shell date +'%Y%m%d')

default: main.pdf

report: main.pdf $(SRCS)
	@test -d "reports" || mkdir reports
	cp main.pdf reports/$(ID)-$(DATE).pdf
	cp main.tex reports/$(ID)-$(DATE).tex

main.pdf: $(SRCS) $(TEMPLATE) $(FIGURES)
	env TEXINPUTS=$(TEXINPUTS) BSTINPUTS=$(BSTINPUTS) latexmk -xelatex $<

aaspack: $(SRCS) $(TEMPLATE) $(FIGURES)
	mkdir $@.$(DATE)
	@for f in $(SRCS) $(TEMPLATE) $(FIGURES); do \
		cp -v $$f $@.$(DATE)/; \
	done
	tar -cvf $@.$(DATE).tar -C $@.$(DATE)/ .
	rm -r $@.$(DATE)

clean:
	latexmk -c main.tex
	touch main.tex

cleanall:
	latexmk -C main.tex

help:
	@echo "default - compile the paper PDF file (main.pdf)"
	@echo "aaspack - pack the necessary files and figures for AAS submission"
	@echo "clean - clean the temporary files"
	@echo "cleanall - clean temporary files and the output PDF file"

.PHONY: report clean cleanall help
