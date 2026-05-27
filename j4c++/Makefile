CHAPTERS := ch00.md ch01.md ch02.md ch03.md ch04.md ch05.md ch06.md ch07.md \
            ch08.md ch09.md ch10.md ch11.md ch12.md ch13.md ch14.md ch15.md \
            ch16.md ch17.md ch18.md ch19.md ch20.md ch21.md ch22.md ch23.md \
            ch24.md appA.md appB.md

SRCS := frontmatter.yaml $(CHAPTERS)

PANDOC_OPTS := --lua-filter=callout.lua \
               --pdf-engine=latexmk \
               --pdf-engine-opt=-lualatex \
               --top-level-division=chapter \
               -V documentclass=book \
               -V geometry:"paperwidth=7in" \
               -V geometry:"paperheight=10in" \
               -V geometry:"top=0.75in" \
               -V geometry:"bottom=0.75in" \
               -V geometry:"inner=0.8in" \
               -V geometry:"outer=0.7in" \
               -V fontsize=11pt

OUT := j4c++.pdf

all: $(OUT)

$(OUT): $(SRCS) callout.lua
	pandoc $(SRCS) -o $@ $(PANDOC_OPTS)

clean:
	rm -f $(OUT)

.PHONY: all clean
