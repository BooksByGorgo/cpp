# project description

create lulu executive book cover PDF for `Gorgo Starting C++ and C` called `lulu-cover.pdf`.

## template

the template PDF is `lulu-cover-template.pdf`. descriptions of the parts and measurements are in the template.

## building

run `make` in sc++c/ to build `lulu-cover.pdf`. the Makefile automatically injects the last commit date as the subtitle.

## content

- front cover: use the `c++c-gorgo-cover.png` image (background color matched to the cover panel). title is `Gorgo Starting C++ and C`. subtitle is the date of the last commit. no author name on the front.
- spine: title centered, `Gorgo Book` at the base of the spine
- back cover: a cheat sheet with tables from the sc++ and c4c++ books:
    - printf format specifiers (c4c++ ch01)
    - bitwise operators (c4c++ ch04)
    - std::format specifiers (sc++ ch10)
    - operator precedence (c4c++ ch04)
    - common container methods (sc++ ch03 and ch08)
- back cover bottom left: `https://gorgo.dev/c++`
