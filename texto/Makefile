# 
# makefile para a compilação do documento
#
# Sáb Jun 23 21:13:37 BRT 2007
#

BASE_NAME = dissertacao

LATEX     = latex
PDFLATEX  = pdflatex
BIBTEX    = bibtex
MAKEINDEX = makeindex
CHAPTERS=cap-agile-to-open.tex cap-conclusoes.tex cap-escopo.tex cap-introducao.tex cap-open-to-agile.tex cap-omm.tex cap-pesquisas.tex
APENDIXES=ape-pesquisaEA.tex ape-pesquisaOS.tex ape-pesquisaMA.tex

open: pdf
	open $(BASE_NAME).pdf

pdf: $(BASE_NAME).pdf
ps: $(BASE_NAME).ps

$(BASE_NAME).pdf: $(BASE_NAME).tex ${CHAPTERS} ${APENDIXES}
	$(PDFLATEX) $<
	$(BIBTEX) $(BASE_NAME) 
	$(MAKEINDEX) $(BASE_NAME) 
	$(PDFLATEX) $< 
	$(PDFLATEX) $<

$(BASE_NAME).ps: $(BASE_NAME).tex ${CHAPTERS} ${APENDIXES}
	$(LATEX) $<
	$(BIBTEX) $(BASE_NAME) 
	$(MAKEINDEX) $(BASE_NAME) 
	$(LATEX) $< 
	$(LATEX) $<

clean:
	rm -f $(BASE_NAME)*.ps $(BASE_NAME)*.dvi *.log \
	      *.aux *.blg *.toc \
	      missfont.log $(BASE_NAME)*.bbl $(BASE_NAME)*.pdf $(BASE_NAME)*.out \
		  $(BASE_NAME)*.lof $(BASE_NAME)*.lot $(BASE_NAME).idx $(BASE_NAME).brf $(BASE_NAME).ilg $(BASE_NAME).ind
