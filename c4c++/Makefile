DATE := $(shell git log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=callout.lua

PDFS := c4c++.pdf c4c++-answers.pdf

CHAPTERS := frontmatter.yaml author-intro.md \
	ch00.md ch01.md ch02.md ch03.md ch04.md ch05.md ch06.md \
	ch07.md ch08.md ch09.md ch10.md ch11.md ch12.md

all: $(PDFS)

c4c++.pdf: $(CHAPTERS) callout.lua
	pandoc $(CHAPTERS) -o $@ $(FILTER) --pdf-engine=latexmk -M subtitle="$(DATE)" -V geometry:margin=1in

c4c++-answers.pdf: c4c++-answers.md callout.lua
	pandoc $< -o $@ $(FILTER) --pdf-engine=latexmk -M subtitle="$(DATE)" -V geometry:margin=1in

clean:
	rm -f $(PDFS) *.idx *.ilg *.ind

.PHONY: all clean
