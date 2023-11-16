.RECIPEPREFIX = >

# Directory variables
export BUILD_DIR             ?= ./build
export TEMPLATE_DIR          ?= ./template/pandoc


# Compilation options
export PANDOC_COMMON_OPTS      = ${PANDOC_OPTIONS} --verbose -F pandoc-include -F pandoc-crossref --citeproc --bibliography ref/ref.bib --metadata-file meta.yaml
export PANDOC_MDPI_LATEX_OPTS  = ${PANDOC_COMMON_OPTS} --natbib -M biblio-style=Definitions/chicago2.bst --pdf-engine latexmk --template mdpi2.latex --number-sections -M link-citations=true -M documentclass=mdpi --top-level-division=section

clear-cache:
> echo "Cleaning ${BUILD_DIR} from cached values"
> rm -R -f ${BUILD_DIR}/*

clean:
> echo "Cleaning dir"
> rm -f *.out *.log *.bbl *.fls *.blg *.fdb* *.aux *.tex *.latex

pre: clean
> echo "Creating directory ${BUILD_DIR}"
> mkdir -p ${BUILD_DIR} Definitions
> cp -rf ${TEMPLATE_DIR}/* .
> echo "Generating LaTeX"
> python3 pandoc.py MDPI

compile:
> pandoc ${PANDOC_MDPI_LATEX_OPTS} -s -t latex -o body.tex body.md
> echo "Generating PDF"
> latexmk -pdf

post:
> mv body.tex body.pdf ${BUILD_DIR}/.
> mv ${BUILD_DIR}/body.pdf ${BUILD_DIR}/body_original.pdf
> rm -f *.out *.log *.bbl *.fls *.blg *.fdb* *.aux *.tex *.bst *.pdf
> rm -f *.latex *.py

scale:
> gs -sDEVICE=pdfwrite -dPDFSETTINGS=/printer -dNOPAUSE -dBATCH -sOutputFile=build/phd-thesis.pdf build/body.pdf
> gs -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -dNOPAUSE -dBATCH -sOutputFile=build/draft.pdf build/body.pdf

all: pre compile post scale