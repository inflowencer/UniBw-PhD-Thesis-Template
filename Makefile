.RECIPEPREFIX = >

# Directory variables
export BUILD_DIR   ?= build
export EXPORT_DIR  ?= export
export BIB_PATH    ?= ref/ref.bib


# Compilation options
export PANDOC_COMMON_OPTS = ${PANDOC_OPTIONS} --verbose -F pandoc-include -F pandoc-crossref --citeproc --bibliography ref/ref.bib --metadata-file meta.yml
export PANDOC_LATEX_OPTS  = ${PANDOC_COMMON_OPTS} --biblatex --pdf-engine lualatex --template Oxford_Thesis.latex --number-sections -M link-citations=true -M documentclass=ociamthesis --top-level-division=chapter

dirs:
> mkdir -p ${BUILD_DIR} ${EXPORT_DIR}

pandoc:
> echo -e "     -----    Running 'pandoc'    ------     "
> pandoc ${PANDOC_LATEX_OPTS} -s -t latex -o main.tex main.md
> mv main.tex *.cls *.latex *.py ${BUILD_DIR}/.
> mkdir -p ${BUILD_DIR}/ref ${BUILD_DIR}/custom
> cp -uR ${BIB_PATH} ${BUILD_DIR}/${BIB_PATH}
> cp -uR custom/author-includes.tex ${BUILD_DIR}/custom/author-includes.tex
> cp -uR fig ${BUILD_DIR}/fig

lualatex:
> echo -e "     -----    Building PDF using 'lualatex'    ------     "
> cd ${BUILD_DIR}; lualatex main.tex

latexmk:
> echo -e "     -----    Building PDF using 'latexmk'    ------     "
> latexmk -pdf -pdflatex=lualatex -cd ${BUILD_DIR}/main.tex


scale:
> gs -sDEVICE=pdfwrite -dPDFSETTINGS=/printer -dNOPAUSE -dBATCH -sOutputFile=${EXPORT_DIR}/body.pdf ${BUILD_DIR}/main.pdf
> gs -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -dNOPAUSE -dBATCH -sOutputFile=${EXPORT_DIR}/draft.pdf ${EXPORT_DIR}/body.pdf
# > rm -f build/body.pdf

# post:
# > mv $BUILD_DIR/main.tex $BUILD_DIRmain.pdf ${BUILD_DIR}/.
# > mv ${BUILD_DIR}/main.pdf ${BUILD_DIR}/body.pdf

# all: clear-build references document post scale
doc: dirs pandoc lualatex scale

all: dirs pandoc latexmk scale