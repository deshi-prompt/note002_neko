# Makefile for *.dot --> *.png

CONVERT:=convert -density 300 -resize 960

BUILD_DIR= build
SRC_DIR= src
TEMPLATE_DIR=`pwd`/template

SRCS= $(wildcard src/*.md)
TEX_TGTS= $(SRCS:.md=.tex)

TEX_SRC= ./book.tex
PDF_TGT= $(TEX_SRC:.tex=.pdf)

EPS_SRCS= $(wildcard fig/*.eps)
PNG_TGTS= $(EPS_SRCS:.eps=.PNG)
HTML_TGT= ./index.html

.SUFFIXES:
.SUFFIXES: .md .tex .pdf .eps .PNG

.eps.PNG:
	@$(CONVERT) $< $@

.md.tex:
	@pandoc -f markdown -t latex $< -o$@

.tex.pdf:
	@platex -kanji=utf8 $<
	@dvipdf $(basename $<).dvi $@

${HTML_TGT}:${TEX_SRC}
	@pandoc -f latex -t html5 -c style/markdown.css $< -o$@.tmp
	@./image2eps.sh $@.tmp $@ PNG
	@cat template/cc_lisence.md >> $@

png: ${PNG_TGTS}
tex: ${TEX_TGTS}
pdf: tex ${PDF_TGT}
all: pdf
html: png tex ${HTML_TGT}

.PHONY: list
list:
	@echo sources : ${SRCS}
	@echo targets tex : ${TEX_TGTS}
	@echo \n
	@echo sources tex : ${TEX_SRC}
	@echo targets pdf : ${PDF_TGT}
	@echo targets png : ${PNG_TGTS}
	@echo targets html: ${HTML_TGT}

.PHONY: clean
clean:
	@rm -f ${TEX_TGTS} ${PDF_TGT} ${PNG_TGTS} ${HTML_TGT}

