# PhD Thesis Template

See an example [here](template/latex/main.pdf). Template for writing a PhD thesis, based on the [Oxford Thesis PhD Template](https://github.com/mcmanigle/OxThesis). 

## Usage

There are **two ways** to use this template, depending on your preference. 

### 1. Pure LaTeX

Use if you prefer a local LaTeX installation without version control. Copy the
example folder `template/latex` to anywhere you want on your computer.
Compile with `latexmk`:

```sh
latexmk -pdf -pdflatex=lualatex main.tex
```

or directly with `lualatex`:

```sh
lualatex main.tex
biber main
lualatex main.tex
lualatex main.tex
```

##### Requirements

* `LuaLaTeX` compiler
* `usepackages`: A list of required packages can be found [here](#default-packages)
* `latexmk` is recommended

### 2. Markdown + `git` + `apptainer`

Use if you prefer version control and a container which includes all the
necessary LaTeX installations.

##### Requirements

* Linux, macOS, or WSL2 terminal
* git
* [Apptainer](https://github.com/apptainer/apptainer)

##### Default packages

```
amsmath amssymb siunitx fouriernc tabularx subcaption footnote lipsum mhchem
float bold-extra abstract
```