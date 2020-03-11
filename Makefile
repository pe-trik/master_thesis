export TEXINPUTS=../tex//:

all: main.pdf abstract.pdf

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
