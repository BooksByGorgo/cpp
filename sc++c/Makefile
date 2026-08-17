DATE := $(shell git -C .. log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=../callout.lua

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
               ../c4c++/ch12.md ../c4c++/conclusion.md ../c4c++/appA.md
C4_BIBL := ../c4c++/bibliography.md

# Ghostscript flags to flatten transparency and cap image resolution at 600 PPI.
# LuaTeX embeds the original transparent PNGs despite \graphicspath, so we
# post-process the PDF instead.
GS_LULU := gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
           -dCompatibilityLevel=1.3 \
           -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode \
           -dAutoFilterGrayImages=false -dGrayImageFilter=/FlateEncode \
           -dDownsampleColorImages=true -dColorImageResolution=600 \
           -dDownsampleGrayImages=true -dGrayImageResolution=600 \
           -dDownsampleMonoImages=true -dMonoImageResolution=600

SRCS := $(FRONTMATTER) \
        $(SC_PART) $(SC_AUTHOR) $(SC_CHAPTERS_PRE15) $(SC_CH15) \
        $(C4_PART) $(C4_AUTHOR) $(C4_CHAPTERS) $(C4_BIBL)

# Lulu executive trim and format shared by every interior build.
LULU_FMT := --top-level-division=chapter \
            -V documentclass=book \
            -M subtitle="$(DATE)" \
            -V geometry:"paperwidth=7in" \
            -V geometry:"paperheight=10in" \
            -V geometry:"top=0.6in" \
            -V geometry:"bottom=0.9in" \
            -V geometry:"footskip=0.3in" \
            -V geometry:"inner=0.8in" \
            -V geometry:"outer=0.7in" \
            -V fontsize=11pt

# both bibliographies: the sc++ part cites from sc++/references.bib, the
# c4c++ part from c4c++/references.bib (KernighanRitchie1988 appears in
# both; pandoc keeps the first definition)
PANDOC_OPTS := $(FILTER) \
               --pdf-engine=latexmk --pdf-engine-opt=-lualatex \
               --citeproc --bibliography=../sc++/references.bib \
               --bibliography=../c4c++/references.bib --csl=../c4c++/ieee.csl \
               --resource-path=.:../sc++:../c4c++ \
               $(LULU_FMT)

# sc++-only interior: same trim, sc++ bibliography, index.md supplies \printindex.
SC_LULU_BIBL := .lulu-sc-bib.md
SC_LULU_SRCS := ../sc++/frontmatter.yaml ../sc++/author-intro.md \
                $(SC_CHAPTERS_PRE15) ../sc++/ch15.md \
                $(SC_LULU_BIBL) index.md
SC_LULU_OPTS := $(FILTER) \
                --pdf-engine=latexmk --pdf-engine-opt=-lualatex \
                --citeproc --bibliography=../sc++/references.bib --csl=../sc++/ieee.csl \
                --resource-path=.:../sc++ \
                $(LULU_FMT)

# c4c++-only interior: same trim, full c4c++ book (conclusion and appendix
# included), c4c++ bibliography, index.md supplies \printindex.
C4_LULU_BIBL := .lulu-c4-bib.md
C4_LULU_SRCS := ../c4c++/frontmatter.yaml ../c4c++/author-intro.md \
                $(C4_CHAPTERS) \
                $(C4_LULU_BIBL) index.md
C4_LULU_OPTS := $(FILTER) \
                --pdf-engine=latexmk --pdf-engine-opt=-lualatex \
                --citeproc --bibliography=../c4c++/references.bib --csl=../c4c++/ieee.csl \
                --resource-path=.:../c4c++ \
                $(LULU_FMT)

# Lulu Executive wraparound cover (15.296in x 10.25in with bleed).
COVER_IMG := ../images/c++c-gorgo-cover.png
COVER_BADGE := ../images/c++c-gorgo-with-badge.png
COVER_BG := \#0d1b2a

all: lulu-sc++c.pdf lulu-cover.pdf

# --- Interior ---

.lulu-ch15.md: ../sc++/ch15.md
	sed '/\\printindex/d' $< > $@

.lulu-sc-author.md: ../sc++/author-intro.md
	sed '1{/^\\newpage$$/d;}' $< > $@

.lulu-c4-author.md: ../c4c++/author-intro.md
	sed '1{/^\\newpage$$/d;}' $< > $@

# sc++/bibliography.md already ends with \printindex; strip it so index.md
# is the only source of the index in the sc++-only build.
.lulu-sc-bib.md: ../sc++/bibliography.md
	sed '/\\printindex/d' $< > $@

# c4c++/bibliography.md also ends with \printindex; same treatment for the
# c4c++-only build.
.lulu-c4-bib.md: ../c4c++/bibliography.md
	sed '/\\printindex/d' $< > $@

lulu-sc++c.pdf: $(SRCS) ../callout.lua ../sc++/references.bib ../c4c++/references.bib ../c4c++/ieee.csl Makefile
	pandoc $(SRCS) -o $@ $(PANDOC_OPTS)

sc++-lulu.pdf: $(SC_LULU_SRCS) ../callout.lua ../sc++/references.bib ../sc++/ieee.csl Makefile
	pandoc $(SC_LULU_SRCS) -o $@ $(SC_LULU_OPTS)

c4c++-lulu.pdf: $(C4_LULU_SRCS) ../callout.lua ../c4c++/references.bib ../c4c++/ieee.csl Makefile
	pandoc $(C4_LULU_SRCS) -o $@ $(C4_LULU_OPTS)

# --- Cover ---

$(COVER_IMG): $(COVER_BADGE)
	convert "$<" -fuzz 15% -fill '$(COVER_BG)' -opaque white "$@"

.commit-date.tex: FORCE
	@printf '\\def\\CommitDate{%s}\n' '$(DATE)' > $@

lulu-cover.pdf: lulu-cover-raw.pdf
	$(GS_LULU) -sOutputFile=$@ $<

lulu-cover-raw.pdf: lulu-cover.tex .commit-date.tex $(COVER_IMG)
	latexmk -lualatex -interaction=nonstopmode -jobname=lulu-cover-raw lulu-cover.tex
	latexmk -c -jobname=lulu-cover-raw lulu-cover.tex

# Cover for the standalone sc++ book (sc++-lulu.pdf). The front image is
# c++-gorgo.png pre-flattened onto the navy background: leaving the alpha
# channel in makes ghostscript rasterize the whole page (text included)
# when flattening for PDF 1.3.
SC_COVER_IMG := ../images/c++-gorgo-sc-cover.png

$(SC_COVER_IMG): ../images/c++-gorgo.png
	convert "$<" -background '$(COVER_BG)' -alpha remove -alpha off "$@"

lulu-cover-sc++.pdf: lulu-cover-sc++-raw.pdf
	$(GS_LULU) -sOutputFile=$@ $<

lulu-cover-sc++-raw.pdf: lulu-cover-sc++.tex .commit-date.tex $(SC_COVER_IMG)
	latexmk -lualatex -interaction=nonstopmode -jobname=lulu-cover-sc++-raw lulu-cover-sc++.tex
	latexmk -c -jobname=lulu-cover-sc++-raw lulu-cover-sc++.tex

# Cover for the standalone c4c++ book (c4c++-lulu.pdf). Front image is
# c-gorgo.png pre-flattened onto the navy background for the same reason
# as the sc++ cover: keeping the alpha channel makes ghostscript rasterize
# the whole page when flattening for PDF 1.3.
C4_COVER_IMG := ../images/c-gorgo-c4-cover.png

$(C4_COVER_IMG): ../images/c-gorgo.png
	convert "$<" -background '$(COVER_BG)' -alpha remove -alpha off "$@"

lulu-cover-c4c++.pdf: lulu-cover-c4c++-raw.pdf
	$(GS_LULU) -sOutputFile=$@ $<

lulu-cover-c4c++-raw.pdf: lulu-cover-c4c++.tex .commit-date.tex $(C4_COVER_IMG)
	latexmk -lualatex -interaction=nonstopmode -jobname=lulu-cover-c4c++-raw lulu-cover-c4c++.tex
	latexmk -c -jobname=lulu-cover-c4c++-raw lulu-cover-c4c++.tex

# --- Bowker front-cover JPGs ---

# Front cover only, trimmed to 7x10in (no bleed), 300 DPI, for ISBN
# registration. The front trim is the rightmost 7in of the wraparound
# minus the 0.125in right bleed, so the crop offset is computed from the
# cover's width and stays correct when a spine width changes.
define FRONT_CROP
	X=$$(pdfinfo $< | awk '/^Page size/{printf "%d", ($$3/72 - 7.125)*300}'); \
	pdftoppm -png -r 300 -f 1 -l 1 $< .bowker-tmp; \
	convert .bowker-tmp-1.png -crop 2100x3000+$$X+38 +repage -quality 92 $@; \
	rm -f .bowker-tmp-1.png
endef

bowker: bowker-front-sc++c.jpg bowker-front-sc++.jpg bowker-front-c4c++.jpg

bowker-front-sc++c.jpg: lulu-cover.pdf
	$(FRONT_CROP)

bowker-front-sc++.jpg: lulu-cover-sc++.pdf
	$(FRONT_CROP)

bowker-front-c4c++.jpg: lulu-cover-c4c++.pdf
	$(FRONT_CROP)

# --- Clean ---

clean:
	rm -f lulu-sc++c.pdf .lulu-sc++c-raw.pdf .lulu-ch15.md .lulu-sc-author.md .lulu-c4-author.md *.idx *.ilg *.ind
	rm -f sc++-lulu.pdf .lulu-sc-bib.md
	rm -f c4c++-lulu.pdf .lulu-c4-bib.md
	rm -f lulu-cover-sc++.pdf lulu-cover-sc++-raw.pdf
	rm -f lulu-cover-sc++-raw.aux lulu-cover-sc++-raw.log lulu-cover-sc++-raw.fls lulu-cover-sc++-raw.fdb_latexmk
	rm -f lulu-cover-c4c++.pdf lulu-cover-c4c++-raw.pdf
	rm -f lulu-cover-c4c++-raw.aux lulu-cover-c4c++-raw.log lulu-cover-c4c++-raw.fls lulu-cover-c4c++-raw.fdb_latexmk
	rm -f bowker-front-*.jpg .bowker-tmp-1.png
	rm -f lulu-cover.pdf lulu-cover-raw.pdf
	rm -f .commit-date.tex lulu-cover-raw.aux lulu-cover-raw.log lulu-cover-raw.fls lulu-cover-raw.fdb_latexmk

.PHONY: all bowker clean FORCE
FORCE:
