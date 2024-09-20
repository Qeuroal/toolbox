clean_object = *.aux \
	*.bbl \
	*.blg \
	*.idx \
	*.ind \
	*.lof \
	*.lot \
	*.out \
	*.toc \
	*.acn \
	*.acr \
	*.alg \
	*.glg \
	*.glo \
	*.gls \
	*.ist \
	*.fls \
	*.log \
	*.fdb_latexmk \
	*.pdfsyn \

TEX_OBJ := $(wildcard *.tex)

.PHONY: pdflatex xelatex bibtex latexmk \
	pbpp xbxx xx \
	clean cleanall lib
pdflatex: ${TEX_OBJ}
	@echo "runing pdflatex; ${MAKECMGGOALS}"
	pdflatex -synctex=1 -interaction=nonstopmode -file-line-error ${TEX_OBJ}

xelatex: ${TEX_OBJ}
	@echo "runing xelatex; ${MAKECMGGOALS}"
	xelatex ${TEX_OBJ} -synctex=1 -interaction=nonstopmode -file-line-error -pdf

bibtex: ${TEX_OBJ}
	@echo "runing bibtex; ${MAKECMGGOALS}"
	bibtex ${TEX_OBJ}

latexmk: ${TEX_OBJ}
	@echo "runing latexmk; ${MAKECMGGOALS}"
	latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf ${TEX_OBJ}

pbpp:
	@echo "pdflatex->bibtex->pdflatex->pdflatex; ${MAKECMGGOALS}"
	pdflatex -synctex=1 -interaction=nonstopmode -file-line-error ${TEX_OBJ}
	object_aux := $(wildcard *.aux)
	bibtex $(wildcard *.aux)
	pdflatex -synctex=1 -interaction=nonstopmode -file-line-error ${TEX_OBJ}
	pdflatex -synctex=1 -interaction=nonstopmode -file-line-error ${TEX_OBJ}

xbxx:
	@echo "xelatex->bibte->xelatex->xelatex; ${MAKECMGGOALS}"
	xelatex ${TEX_OBJ} -synctex=1 -interaction=nonstopmode -file-line-error -pdf
	bibtex $(wildcard *.aux)
	xelatex ${TEX_OBJ} -synctex=1 -interaction=nonstopmode -file-line-error -pdf
	xelatex ${TEX_OBJ} -synctex=1 -interaction=nonstopmode -file-line-error -pdf

xx:
	@echo "xelatex->xelatex; ${MAKECMGGOALS}"
	xelatex ${TEX_OBJ} -synctex=1 -interaction=nonstopmode -file-line-error -pdf
	xelatex ${TEX_OBJ} -synctex=1 -interaction=nonstopmode -file-line-error -pdf

clean:
	@rm -rf ${clean_object}

cleanall: clean
	@rm -rf $(wildcard *.pdf)

lib: ${object} ${object_aux}
	@echo "$$\@: $@"
	@echo "$$\%: $%"
	@echo "$$\<: $<"
	@echo "$$\?: $?"
	@echo "$$\^: $^"
	@echo "$$\+: $+"
	@echo "$$\*: $*"


