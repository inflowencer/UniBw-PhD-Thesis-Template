.RECIPEPREFIX = >

# Directory variables
export BUILD_DIR             ?= ./build
# export TEMPLATE_DIR          ?= ./template/pandoc


# Compilation options
export PANDOC_COMMON_OPTS      = ${PANDOC_OPTIONS} --verbose -F pandoc-include -F pandoc-crossref --citeproc --bibliography ref/ref.bib --metadata-file meta.yml
export PANDOC_MDPI_LATEX_OPTS  = ${PANDOC_COMMON_OPTS} --biblatex --pdf-engine latexmk --template Oxford_Thesis.latex --number-sections -M link-citations=true -M documentclass=ociamthesis --top-level-division=chapter

clear-cache:
> echo "Cleaning ${BUILD_DIR} from cached values"
> rm -R -f ${BUILD_DIR}/*

# clean:
# > echo "Cleaning dir"
# > rm -f *.out *.log *.bbl *.fls *.blg *.fdb* *.aux *.tex *.latex *.mt* *.cls *.py *.bcf *.toc *.lof *.maf *.xml text/*.aux

# pre: clean
# > echo "Creating directory ${BUILD_DIR}"
# > cp -rf ${TEMPLATE_DIR}/* .

compile:
> pandoc ${PANDOC_MDPI_LATEX_OPTS} -s -t latex -o main.tex main.md
> echo "Generating PDF"
> latexmk -pdf -pdflatex=xelatex main.tex 

post:
> mv main.tex main.pdf ${BUILD_DIR}/.
> mv ${BUILD_DIR}/main.pdf ${BUILD_DIR}/body.pdf
> rm -f *.out *.log *.bbl *.fls *.blg *.fdb* *.aux *.tex *.bst *.pdf *.cls *.xml *.mt* *.bcf *.lof *.maf *.toc text/*.aux
> rm -f *.latex *.py

scale:
> gs -sDEVICE=pdfwrite -dPDFSETTINGS=/printer -dNOPAUSE -dBATCH -sOutputFile=build/phd-thesis.pdf build/body.pdf
> gs -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -dNOPAUSE -dBATCH -sOutputFile=build/draft.pdf build/body.pdf
> rm -f build/body.pdf

all: clear-cache compile post scale