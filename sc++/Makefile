DATE := $(shell git log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=callout.lua
PANDOC_OPTS := $(FILTER) --pdf-engine=latexmk -M subtitle="$(DATE)" -V geometry:margin=1in

PDFS := sc++.pdf sc++-answers.pdf

CHAPTERS := frontmatter.yaml author-intro.md \
	ch00.md ch01.md ch02.md ch03.md ch04.md ch05.md ch06.md \
	ch07.md ch08.md ch09.md ch10.md ch11.md ch12.md ch13.md ch14.md

CH_SRCS := $(filter ch%.md,$(CHAPTERS))
CH_PDFS := $(CH_SRCS:.md=.pdf)

all: $(PDFS)

chapters: $(CH_PDFS)

sc++.pdf: $(CHAPTERS) callout.lua
	pandoc $(CHAPTERS) -o $@ $(PANDOC_OPTS)

sc++-answers.pdf: sc++-answers.md callout.lua
	pandoc $< -o $@ $(PANDOC_OPTS)

ch%.pdf: frontmatter.yaml ch%.md callout.lua
	pandoc frontmatter.yaml ch$*.md -o $@ $(PANDOC_OPTS)

clean:
	rm -f $(PDFS) $(CH_PDFS) *.idx *.ilg *.ind

.PHONY: all chapters clean
