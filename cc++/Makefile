DATE := $(shell git log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=../callout.lua
PANDOC_OPTS_BASE := $(FILTER) --pdf-engine=latexmk --pdf-engine-opt=-lualatex --pdf-engine-opt=-e --pdf-engine-opt='$$max_repeat=9' -M subtitle="$(DATE)" -V geometry:margin=1in
PANDOC_OPTS := $(PANDOC_OPTS_BASE) --top-level-division=chapter -V documentclass=book

PDFS := cc++.pdf cc++-answers.pdf

CHAPTERS := frontmatter.yaml author-intro.md \
	ch00.md ch01.md ch02.md ch03.md ch04.md ch05.md ch06.md \
	ch07.md ch08.md ch09.md ch10.md ch11.md ch12.md \
	appA.md appB.md

CH_SRCS := $(filter ch%.md,$(CHAPTERS))
APP_SRCS := $(filter app%.md,$(CHAPTERS))
CH_PDFS := $(CH_SRCS:.md=.pdf)
APP_PDFS := $(APP_SRCS:.md=.pdf)

all: $(PDFS)

chapters: $(CH_PDFS) $(APP_PDFS)

cc++.pdf: $(CHAPTERS) ../callout.lua
	pandoc $(CHAPTERS) -o $@ $(PANDOC_OPTS)

cc++-answers.pdf: cc++-answers.md ../callout.lua
	pandoc $< -o $@ $(PANDOC_OPTS_BASE)

ch%.pdf: frontmatter.yaml ch%.md ../callout.lua
	@NUM=$$(echo $* | sed 's/^0*//'); [ -z "$$NUM" ] && NUM=0; \
	OFFSET=$$((NUM - 1)); \
	{ printf '\\setcounter{chapter}{%d}\n\n' $$OFFSET; cat ch$*.md; } \
	  | pandoc frontmatter.yaml - -o $@ $(PANDOC_OPTS)

app%.pdf: frontmatter.yaml app%.md ../callout.lua
	@OFFSET=$$(( $$(printf '%d' "'$*") - $$(printf '%d' "'A") )); \
	{ printf '\\appendix\n\\setcounter{chapter}{%d}\n\n' $$OFFSET; cat app$*.md; } \
	  | pandoc frontmatter.yaml - -o $@ $(PANDOC_OPTS)

clean:
	rm -f $(PDFS) $(CH_PDFS) $(APP_PDFS) *.idx *.ilg *.ind

.PHONY: all chapters clean
