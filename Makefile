export TEXINPUTS=../tex//:

all: main.pdf abstract.pdf
	cp main.pdf main.PREVIEW.pdf

# LaTeX must be run multiple times to get references right
main.pdf: $(wildcard *.tex) bibliography.bib main.xmpdata

LATEX=pdflatex
%.pdf: %.tex
	$(LATEX) $<
	bibtex $* || ( echo "Bibtex failed" && exit 1 )
	# change the exit 1 to exit 0 in the line above if you want to ignore it
	lim=4; \
	  while [ $$lim -ge 0 ] \
	      && grep 'Rerun to get\|Citation.*undefined' $*.log >/dev/null 2>/dev/null; do \
	    $(LATEX) $< ; \
	    lim=$$(($$lim - 1)) ; \
	  done

abstract.pdf: abstract.tex abstract.xmpdata
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.toc *.lof *.lot *.out *.bbl *.blg *.xmpi
	rm -f main.pdf abstract.pdf

.PHONY: ci
ci:
	# make sure git will remember my password
	git config credential.helper store
	# git pull push dance with possibly uncommited local modifications
	if git pull; then echo No changes to hide; else git stash; git pull; git stash apply; fi; git commit -am "make ci by $(USER)"; git push

