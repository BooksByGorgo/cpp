# project description

lulu executive book build for `Gorgo Starting C++ and C`. produces both the interior PDF (`lulu-sc++c.pdf`) and the wraparound cover PDF (`lulu-cover.pdf`).

## building

run `make` in sc++c/ to build both PDFs. the Makefile automatically injects the last commit date as the subtitle.

- `make lulu-sc++c.pdf` --- interior only
- `make lulu-cover.pdf` --- cover only
- `make clean` --- remove all build artifacts

## interior (`lulu-sc++c.pdf`)

- combines sc++ (Starting C++) and c4c++ (C for C++ Programmers) into one book
- lulu executive trim: 7x10in (paperwidth=7in, paperheight=10in)
- margins: inner=0.8in, outer=0.7in, top/bottom=0.75in
- text width is 5.5in --- code blocks must fit within 77 monospace characters
- pandoc builds a raw PDF, then ghostscript post-processes it to:
    - flatten transparency (PDF 1.3 compatibility)
    - cap image resolution at 600 PPI
    - use lossless FlateEncode (not JPEG) to preserve exact colors
- dedication page after the title page (centered reader message)
- part divider pages with gorgo images for each subbook

## cover (`lulu-cover.pdf`)

### template

the template PDF is `lulu-cover-template.pdf`. descriptions of the parts and measurements are in the template.

### content

- front cover: use the `c++c-gorgo-cover.png` image (background color `#0d1b2a` matched to the full-bleed cover background). title is `Gorgo Starting C++ and C`. subtitle is the date of the last commit. no author name on the front.
- spine: title centered, `Gorgo Book` at the base of the spine
- back cover: a cheetsheet with tables from the sc++ and c4c++ books:
    - printf format specifiers (c4c++ ch01)
    - bitwise operators (c4c++ ch04)
    - std::format specifiers (sc++ ch10)
    - operator precedence (c4c++ ch04)
    - common container methods (sc++ ch03 and ch08)
- back cover bottom left: `https://gorgo.dev/c++`

### cover image

`c++c-gorgo-cover.png` is a make target --- it is generated from `c++c-gorgo-with-badge.png` by flood-filling the white background with `#0d1b2a` (the full-bleed cover background color). total trim with bleed: 15.296in x 10.25in.

## lulu compliance

- no transparency in final PDFs (ghostscript flattens with `-dCompatibilityLevel=1.3`)
- image resolution capped at 600 PPI
- lossless image encoding to avoid color shifts between raster images and vector fills
