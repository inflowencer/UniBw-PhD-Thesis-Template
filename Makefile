.RECIPEPREFIX = >

# Directory variables
export BUILD_DIR   ?= build
export EXPORT_DIR  ?= export
export BIB_PATH    ?= ref/ref.bib
export PDFENGINE   ?= lualatex
export META_FILE   ?= .meta.yml

# Compilation options
export PANDOC_COMMON_OPTS = ${PANDOC_OPTIONS} --verbose -F pandoc-include -F pandoc-crossref --citeproc --bibliography ref/ref.bib --metadata-file ${META_FILE}
export PANDOC_LATEX_OPTS  = ${PANDOC_COMMON_OPTS} --biblatex --pdf-engine ${PDFENGINE} --template Oxford_Thesis.latex --number-sections -M link-citations=true -M documentclass=ociamthesis --top-level-division=chapter --listings

dirs:
> mkdir -p ${BUILD_DIR} ${EXPORT_DIR}

pandoc:
> echo -e "     -----    Running 'pandoc'    ------     "
> pandoc ${PANDOC_LATEX_OPTS} -s -t latex -o main.tex main.md
> mv *.tex *.cls *.latex *.py ${BUILD_DIR}/.
> mkdir -p ${BUILD_DIR}/ref ${BUILD_DIR}/custom
> cp -uR ${BIB_PATH} ${BUILD_DIR}/${BIB_PATH}
> cp -uR fig ${BUILD_DIR}/fig
> cp -uR custom ${BUILD_DIR}/.
# > sed -i -e 's/\\phantomsection//g' main.tex

latex:
> echo -e "     -----    Building PDF using 'lualatex'    ------     "
> cd ${BUILD_DIR}; ${PDFENGINE} main.tex

latexmk:
> echo -e "     -----    Building PDF using 'latexmk'    ------     "
> latexmk -pdf -pdflatex=${PDFENGINE} -cd ${BUILD_DIR}/main.tex

scale:
> gs -sDEVICE=pdfwrite -dNumRenderingThreads=8 -dPDFSETTINGS=/prepress -dNOPAUSE -dBATCH -dBufferSpace=2000000000 -sOutputFile=${EXPORT_DIR}/PhD_Thesis_600dpi.pdf ${BUILD_DIR}/main.pdf 
> gs -sDEVICE=pdfwrite -dNumRenderingThreads=8 -dPDFSETTINGS=/printer -dNOPAUSE -dBATCH -dBufferSpace=2000000000 -sOutputFile=${EXPORT_DIR}/PhD_Thesis_300dpi.pdf ${BUILD_DIR}/main.pdf
> gs -sDEVICE=pdfwrite -dNumRenderingThreads=8 -dPDFSETTINGS=/prepress -dNOPAUSE -dBATCH -dBufferSpace=2000000000 -dNOOUTERSAVE -sProcessColorModel=DeviceRGB -dPDFACompatibilityPolicy=1 -sOutputFile=${EXPORT_DIR}/PhD_Thesis_600dpi_PDFA.pdf ${EXPORT_DIR}/PhD_Thesis_600dpi.pdf 

# post:
# > mv $BUILD_DIR/main.tex $BUILD_DIRmain.pdf ${BUILD_DIR}/.
# > mv ${BUILD_DIR}/main.pdf ${BUILD_DIR}/body.pdf

# all: clear-build references document post scale
doc: dirs pandoc latex scale

all: dirs pandoc latexmk scale