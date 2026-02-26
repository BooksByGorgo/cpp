SRC = cheetsheet.md
FULL = cheetsheet.pdf
BOOKLET = cheetsheet-booklet.pdf

all: $(FULL) $(BOOKLET)

$(FULL): $(SRC)
	pandoc $< -o $@

$(BOOKLET): $(FULL)
	pdfbook2 --paper=letterpaper --top-margin=0 --bottom-margin=0 --outer-margin=10 --inner-margin=10 $(FULL)
	mv cheetsheet-book.pdf $(BOOKLET)

clean:
	rm -f $(FULL) $(BOOKLET)

.PHONY: all clean
