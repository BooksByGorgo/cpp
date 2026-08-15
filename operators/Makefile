DATE := $(shell git log -1 --format="%ad" --date=format:"%B %d, %Y")
FILTER := --lua-filter=../callout.lua

PDFS := operators.pdf

all: $(PDFS)

%.pdf: %.md ../callout.lua
	pandoc $< -o $@ $(FILTER) -M subtitle="$(DATE)"

clean:
	rm -f $(PDFS)

.PHONY: all clean
