DATE := $(shell git log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=callout.lua
PANDOC_OPTS_BASE := $(FILTER) --citeproc --pdf-engine=latexmk --pdf-engine-opt=-lualatex -M subtitle="$(DATE)" -V geometry:margin=1in
PANDOC_OPTS := $(PANDOC_OPTS_BASE) --top-level-division=chapter -V documentclass=book

PDFS := g4j.pdf g4j-answers.pdf

CHAPTERS := frontmatter.yaml author-intro.md \
	ch00.md ch01.md ch02.md ch03.md ch04.md

CH_SRCS := $(filter ch%.md,$(CHAPTERS))
CH_PDFS := $(CH_SRCS:.md=.pdf)

all: $(PDFS) $(CH_PDFS)

chapters: $(CH_PDFS)

g4j.pdf: $(CHAPTERS) callout.lua
	pandoc $(CHAPTERS) -o $@ $(PANDOC_OPTS)

g4j-answers.pdf: g4j-answers.md callout.lua
	pandoc $< -o $@ $(PANDOC_OPTS_BASE)

ch%.pdf: frontmatter.yaml ch%.md callout.lua
	@NUM=$$(echo $* | sed 's/^0*//'); [ -z "$$NUM" ] && NUM=0; \
	OFFSET=$$((NUM - 1)); \
	{ printf '\\setcounter{chapter}{%d}\n\n' $$OFFSET; cat ch$*.md; } \
	  | pandoc frontmatter.yaml - -o $@ $(PANDOC_OPTS)

clean:
	rm -f $(PDFS) $(CH_PDFS) *.idx *.ilg *.ind

.PHONY: all chapters clean
