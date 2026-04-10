DATE := $(shell git -C .. log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=../sc++/callout.lua

FRONTMATTER := frontmatter-lulu.yaml

SC_PART := lulu-part-sc.md
SC_AUTHOR := .lulu-sc-author.md
SC_CHAPTERS_PRE15 := ../sc++/ch00.md ../sc++/ch01.md ../sc++/ch02.md ../sc++/ch03.md \
                     ../sc++/ch04.md ../sc++/ch05.md ../sc++/ch06.md ../sc++/ch07.md \
                     ../sc++/ch08.md ../sc++/ch09.md ../sc++/ch10.md ../sc++/ch11.md \
                     ../sc++/ch12.md ../sc++/ch13.md ../sc++/ch14.md
SC_CH15 := .lulu-ch15.md

C4_PART := lulu-part-c4.md
C4_AUTHOR := .lulu-c4-author.md
C4_CHAPTERS := ../c4c++/ch00.md ../c4c++/ch01.md ../c4c++/ch02.md ../c4c++/ch03.md \
               ../c4c++/ch04.md ../c4c++/ch05.md ../c4c++/ch06.md ../c4c++/ch07.md \
               ../c4c++/ch08.md ../c4c++/ch09.md ../c4c++/ch10.md ../c4c++/ch11.md \
               ../c4c++/ch12.md
C4_BIBL := ../c4c++/bibliography.md

# PNGs that get embedded in the lulu PDF. Lulu rejects transparent PNGs,
# so we composite them onto white into .lulu-img/images/. The .lulu-img/sub/
# stub directory exists so the \graphicspath trick in frontmatter-lulu.yaml
# can resolve the callout's raw \includegraphics{../images/foo.png} paths
# (.lulu-img/sub/../images/foo.png -> .lulu-img/images/foo.png).
LULU_IMG_DIR := .lulu-img/images
LULU_IMG_STUB := .lulu-img/sub
LULU_IMG_PNGS := $(LULU_IMG_DIR)/c++c-gorgo.png \
                 $(LULU_IMG_DIR)/c++-gorgo.png \
                 $(LULU_IMG_DIR)/c-gorgo.png \
                 $(LULU_IMG_DIR)/tip-callout.png \
                 $(LULU_IMG_DIR)/trap-callout.png \
                 $(LULU_IMG_DIR)/wut-callout.png

SRCS := $(FRONTMATTER) \
        $(SC_PART) $(SC_AUTHOR) $(SC_CHAPTERS_PRE15) $(SC_CH15) \
        $(C4_PART) $(C4_AUTHOR) $(C4_CHAPTERS) $(C4_BIBL)

PANDOC_OPTS := $(FILTER) \
               --pdf-engine=latexmk --pdf-engine-opt=-lualatex \
               --citeproc --bibliography=../c4c++/references.bib --csl=../c4c++/ieee.csl \
               --resource-path=.:../sc++:../c4c++ \
               -M subtitle="$(DATE)" \
               -V geometry:"paperwidth=7in" \
               -V geometry:"paperheight=10in" \
               -V geometry:"top=0.75in" \
               -V geometry:"bottom=0.75in" \
               -V geometry:"inner=0.8in" \
               -V geometry:"outer=0.7in" \
               -V fontsize=11pt

# Lulu Executive wraparound cover (15.123in x 10.25in with bleed).
COVER_IMG := ../images/c++c-gorgo-cover.png
COVER_BADGE := ../images/c++c-gorgo-with-badge.png
COVER_BG := \#152844

all: lulu-sc++c.pdf lulu-cover.pdf

# --- Interior ---

.lulu-ch15.md: ../sc++/ch15.md
	sed '/\\printindex/d' $< > $@

.lulu-sc-author.md: ../sc++/author-intro.md
	sed '1{/^\\newpage$$/d;}' $< > $@

.lulu-c4-author.md: ../c4c++/author-intro.md
	sed '1{/^\\newpage$$/d;}' $< > $@

$(LULU_IMG_DIR) $(LULU_IMG_STUB):
	mkdir -p $@

$(LULU_IMG_DIR)/%.png: ../images/%.png | $(LULU_IMG_DIR) $(LULU_IMG_STUB)
	convert "$<" -background white -alpha remove -alpha off "$@"

lulu-sc++c.pdf: $(SRCS) ../sc++/callout.lua ../c4c++/references.bib ../c4c++/ieee.csl $(LULU_IMG_PNGS)
	pandoc $(SRCS) -o $@ $(PANDOC_OPTS)

# --- Cover ---

$(COVER_IMG): $(COVER_BADGE)
	convert "$<" -background '$(COVER_BG)' -alpha remove -alpha off "$@"

.commit-date.tex: FORCE
	@printf '\\def\\CommitDate{%s}\n' '$(DATE)' > $@

lulu-cover.pdf: lulu-cover.tex .commit-date.tex $(COVER_IMG)
	latexmk -lualatex -interaction=nonstopmode lulu-cover.tex
	latexmk -c lulu-cover.tex

# --- Clean ---

clean:
	rm -f lulu-sc++c.pdf .lulu-ch15.md .lulu-sc-author.md .lulu-c4-author.md *.idx *.ilg *.ind
	rm -rf .lulu-img
	-latexmk -C lulu-cover.tex
	rm -f .commit-date.tex lulu-cover.aux lulu-cover.log lulu-cover.fls lulu-cover.fdb_latexmk

.PHONY: all clean FORCE
FORCE:
