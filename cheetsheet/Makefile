SRC = cheetsheet.md
FULL = cheetsheet.pdf
BOOKLET = cheetsheet-booklet.pdf

all: $(FULL) $(BOOKLET)

$(FULL): $(SRC)
	pandoc $< -o $@

$(BOOKLET): $(FULL)
	pdfbook2 --paper=letterpaper $(FULL)
	mv cheetsheet-book.pdf $(BOOKLET)

clean:
	rm -f $(FULL) $(BOOKLET)

.PHONY: all clean
