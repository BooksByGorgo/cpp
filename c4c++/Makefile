DATE := $(shell git log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=callout.lua
PANDOC_OPTS := $(FILTER) --pdf-engine=latexmk --pdf-engine-opt=-lualatex --citeproc --bibliography=references.bib -M subtitle="$(DATE)" -V geometry:margin=1in

PDFS := c4c++.pdf c4c++-answers.pdf

CHAPTERS := frontmatter.yaml author-intro.md \
	ch00.md ch01.md ch02.md ch03.md ch04.md ch05.md ch06.md \
	ch07.md ch08.md ch09.md ch10.md ch11.md ch12.md \
	bibliography.md

CH_SRCS := $(filter ch%.md,$(CHAPTERS))
CH_PDFS := $(CH_SRCS:.md=.pdf)

all: $(PDFS) $(CH_PDFS)

chapters: $(CH_PDFS)

c4c++.pdf: $(CHAPTERS) callout.lua
	pandoc $(CHAPTERS) -o $@ $(PANDOC_OPTS)

c4c++-answers.pdf: c4c++-answers.md callout.lua
	pandoc $< -o $@ $(PANDOC_OPTS)

ch%.pdf: ch%.md callout.lua
	pandoc chapfront.yaml ch$*.md -o $@ $(PANDOC_OPTS) 

clean:
	rm -f $(PDFS) $(CH_PDFS) *.idx *.ilg *.ind

.PHONY: all chapters clean
