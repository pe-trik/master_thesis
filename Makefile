export TEXINPUTS=../tex//:

all: main.pdf abstract.pdf
	cp main.pdf main.PREVIEW.pdf

# LaTeX must be run multiple times to get references right
main.pdf: main.tex $(wildcard *.tex) bibliography.bib main.xmpdata
	pdflatex $<
	bibtex main
	pdflatex $<
	pdflatex $<

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

