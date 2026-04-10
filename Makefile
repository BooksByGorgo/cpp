DATE := $(shell git log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=sc++/callout.lua

FRONTMATTER := frontmatter-lulu.yaml

SC_PART := lulu-part-sc.md
SC_AUTHOR := sc++/author-intro.md
SC_CHAPTERS_PRE15 := sc++/ch00.md sc++/ch01.md sc++/ch02.md sc++/ch03.md \
                     sc++/ch04.md sc++/ch05.md sc++/ch06.md sc++/ch07.md \
                     sc++/ch08.md sc++/ch09.md sc++/ch10.md sc++/ch11.md \
                     sc++/ch12.md sc++/ch13.md sc++/ch14.md
SC_CH15 := .lulu-ch15.md

C4_PART := lulu-part-c4.md
C4_AUTHOR := c4c++/author-intro.md
C4_CHAPTERS := c4c++/ch00.md c4c++/ch01.md c4c++/ch02.md c4c++/ch03.md \
               c4c++/ch04.md c4c++/ch05.md c4c++/ch06.md c4c++/ch07.md \
               c4c++/ch08.md c4c++/ch09.md c4c++/ch10.md c4c++/ch11.md \
               c4c++/ch12.md
C4_BIBL := c4c++/bibliography.md

SRCS := $(FRONTMATTER) \
        $(SC_PART) $(SC_AUTHOR) $(SC_CHAPTERS_PRE15) $(SC_CH15) \
        $(C4_PART) $(C4_AUTHOR) $(C4_CHAPTERS) $(C4_BIBL)

PANDOC_OPTS := $(FILTER) \
               --pdf-engine=latexmk --pdf-engine-opt=-lualatex \
               --citeproc --bibliography=c4c++/references.bib --csl=c4c++/ieee.csl \
               --resource-path=.:sc++:c4c++ \
               -M subtitle="$(DATE)" \
               -V geometry:"paperwidth=7in" \
               -V geometry:"paperheight=10in" \
               -V geometry:"top=0.75in" \
               -V geometry:"bottom=0.75in" \
               -V geometry:"inner=0.8in" \
               -V geometry:"outer=0.7in" \
               -V fontsize=11pt

all: lulu-sc++c.pdf

.lulu-ch15.md: sc++/ch15.md
	sed '/\\printindex/d' $< > $@

lulu-sc++c.pdf: $(SRCS) sc++/callout.lua c4c++/references.bib c4c++/ieee.csl
	pandoc $(SRCS) -o $@ $(PANDOC_OPTS)

clean:
	rm -f lulu-sc++c.pdf .lulu-ch15.md *.idx *.ilg *.ind

.PHONY: all clean
