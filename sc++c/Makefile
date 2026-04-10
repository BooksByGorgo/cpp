# Builds lulu-cover.pdf, the Lulu Executive wraparound cover for "Gorgo C++ and C".
# Total trim with bleed: 15.123in x 10.25in (matches lulu-cover-template.pdf).

DATE := $(shell git -C .. log -1 --format="%ad" --date=format:"%B %d, %Y")

COVER_IMG := ../images/c++c-gorgo-cover.png

.PHONY: all clean

all: lulu-cover.pdf

lulu-cover.pdf: lulu-cover.tex .commit-date.tex $(COVER_IMG)
	latexmk -lualatex -interaction=nonstopmode lulu-cover.tex
	latexmk -c lulu-cover.tex

# Regenerated every build so the subtitle stays in sync with the latest commit.
.commit-date.tex: FORCE
	@printf '\\def\\CommitDate{%s}\n' '$(DATE)' > $@

FORCE:

clean:
	-latexmk -C lulu-cover.tex
	rm -f .commit-date.tex lulu-cover.aux lulu-cover.log lulu-cover.fls lulu-cover.fdb_latexmk
