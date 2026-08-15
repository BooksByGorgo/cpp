#!/bin/bash
set -euo pipefail
shopt -s nullglob

DOCS=docs
INCLUDES=$DOCS/_includes
PANDOC_OPTS="-f markdown -t html5 --highlight-style=pygments --wrap=none --email-obfuscation=none"

# Inline SVG used as a PDF icon. Kept as a single line so it drops cleanly
# into generated HTML includes.
PDF_ICON_SVG='<svg class="pdf-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="9" y1="13" x2="15" y2="13"/><line x1="9" y1="17" x2="15" y2="17"/></svg>'

get_heading() {
    grep -m1 '^#\+ ' "$1" | sed -e 's/^#\+ //' -e 's/[[:space:]]*{[^}]*}[[:space:]]*$//'
}

convert_chapter() {
    local src_dir="$1" md_base="$2" dest="$3" title="$4" parent="$5" nav_order="$6"
    local extra_opts="${7:-}"

    mkdir -p "$(dirname "$dest")"

    # The shared callout filter lives at the repo root; pandoc runs from
    # the book directory, so it is one level up.
    local filter_opt="--lua-filter=../callout.lua"

    {
        printf '%s\n' "---"
        printf 'layout: default\n'
        printf 'title: "%s"\n' "$title"
        printf 'parent: "%s"\n' "$parent"
        printf 'nav_order: %s\n' "$nav_order"
        printf '%s\n\n' "---"
        printf '{%% raw %%}\n'
        (cd "$src_dir" && pandoc "$md_base" $PANDOC_OPTS $filter_opt $extra_opts)
        printf '\n{%% endraw %%}\n'
    } > "$dest"
}

# Render bibliography.md as a standalone HTML page. Citeproc alone would leave
# the #refs div empty because bibliography.md has no explicit citations, so we
# prepend a nocite="@*" YAML metadata block to pull every .bib entry in. The
# raw LaTeX (\newpage, \printindex) in the source drops out naturally on HTML
# output.
convert_bibliography() {
    local src_dir="$1" dest="$2" title="$3" parent="$4" nav_order="$5"

    mkdir -p "$(dirname "$dest")"

    local filter_opt="--lua-filter=../callout.lua"

    local -a cite_opts=()
    if [ -f "$src_dir/references.bib" ]; then
        cite_opts+=(--citeproc --bibliography=references.bib)
        [ -f "$src_dir/ieee.csl" ] && cite_opts+=(--csl=ieee.csl)
    fi

    {
        printf '%s\n' "---"
        printf 'layout: default\n'
        printf 'title: "%s"\n' "$title"
        printf 'parent: "%s"\n' "$parent"
        printf 'nav_order: %s\n' "$nav_order"
        printf '%s\n\n' "---"
        printf '{%% raw %%}\n'
        (
            cd "$src_dir"
            {
                printf -- '---\nnocite: "@*"\n---\n\n'
                cat bibliography.md
            } | pandoc $PANDOC_OPTS $filter_opt "${cite_opts[@]}"
        )
        printf '\n{%% endraw %%}\n'
    } > "$dest"
}

# Run the book's Makefile to build its PDFs. Does not fail the whole site
# build if a book's PDFs can't be built; the pipeline still produces HTML.
build_book_pdfs() {
    local src_dir="$1"
    if [ ! -f "$src_dir/Makefile" ]; then
        return
    fi
    echo "building PDFs in $src_dir"
    # -k: keep going after an error so one bad target (e.g. a chapter with
    # a LaTeX-incompatible Unicode char) doesn't block the other PDFs.
    # -j4: build up to four PDF targets in parallel within this book.
    if ! (cd "$src_dir" && make -k -j4 all chapters); then
        echo "warning: one or more PDF targets failed for $src_dir — site will use whatever PDFs were produced" >&2
    fi
}

# Copy a PDF into the docs tree if it exists.
copy_pdf() {
    local src="$1" dst="$2"
    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
    fi
}

# Emit an entry for the chapter list include: chapter title link + optional PDF icon.
emit_chapter_entry() {
    local dest_subdir="$1" base_noext="$2" title="$3" include_pdf="$4"
    printf '  <li>\n'
    printf "    <a href=\"{{ '/%s/%s.html' | relative_url }}\">%s</a>\n" \
        "$dest_subdir" "$base_noext" "$title"
    if [ "$include_pdf" = "yes" ]; then
        printf "    <a class=\"chapter-pdf-link\" href=\"{{ '/%s/%s.pdf' | relative_url }}\" title=\"Download chapter PDF\" aria-label=\"Download %s PDF\">%s</a>\n" \
            "$dest_subdir" "$base_noext" "$title" "$PDF_ICON_SVG"
    fi
    printf '  </li>\n'
}

build_book() {
    local src_dir="$1" dest_subdir="$2" parent="$3" book_slug="$4"

    build_book_pdfs "$src_dir"

    local include_file="$INCLUDES/${dest_subdir}-chapters.html"
    mkdir -p "$INCLUDES" "$DOCS/$dest_subdir"

    # Full book and answer key PDFs get copied next to the chapter PDFs.
    local full_pdf_src="$src_dir/${book_slug}.pdf"
    local full_pdf_dst="$DOCS/$dest_subdir/${dest_subdir}.pdf"
    local answers_pdf_src="$src_dir/${book_slug}-answers.pdf"
    local answers_pdf_dst="$DOCS/$dest_subdir/${dest_subdir}-answers.pdf"
    copy_pdf "$full_pdf_src" "$full_pdf_dst"
    copy_pdf "$answers_pdf_src" "$answers_pdf_dst"

    # Lecture slides are static artifacts committed under docs/ (published
    # from the private cpp-instructor repo), not generated from this repo.
    local has_lectures=no
    [ -d "$DOCS/$dest_subdir/lectures" ] && has_lectures=yes

    {
        printf '<!-- generated by build-site.sh; do not edit -->\n'

        # Top-of-page book PDF + lectures links.
        if [ -f "$full_pdf_dst" ] || [ -f "$answers_pdf_dst" ] || [ "$has_lectures" = yes ]; then
            printf '<p class="book-pdf-links">\n'
            if [ -f "$full_pdf_dst" ]; then
                printf "  <a class=\"book-pdf-link\" href=\"{{ '/%s/%s.pdf' | relative_url }}\">%s Full book PDF</a>\n" \
                    "$dest_subdir" "$dest_subdir" "$PDF_ICON_SVG"
            fi
            if [ -f "$answers_pdf_dst" ]; then
                printf "  <a class=\"book-pdf-link\" href=\"{{ '/%s/%s-answers.pdf' | relative_url }}\">%s Answer key PDF</a>\n" \
                    "$dest_subdir" "$dest_subdir" "$PDF_ICON_SVG"
            fi
            if [ "$has_lectures" = yes ]; then
                printf "  <a class=\"book-pdf-link\" href=\"{{ '/%s/lectures/' | relative_url }}\">Lectures</a>\n" \
                    "$dest_subdir"
            fi
            printf '</p>\n'
        fi

        printf '<ul class="chapter-list">\n'

        # Author intro (if present) renders before chapter 0.
        if [ -f "$src_dir/author-intro.md" ]; then
            local author_title author_dest
            author_title=$(get_heading "$src_dir/author-intro.md")
            author_dest="$DOCS/$dest_subdir/author-intro.html"
            convert_chapter "$src_dir" "author-intro.md" "$author_dest" \
                "$author_title" "$parent" "-1"
            emit_chapter_entry "$dest_subdir" "author-intro" "$author_title" "no"
        fi

        for md in "$src_dir"/ch*.md; do
            local base num chapnum title html_dest pdf_src pdf_dst include_pdf number_opts
            base=$(basename "$md")
            num=${base%.md}
            num=${num#ch}
            chapnum=$((10#$num))
            # Prefix the chapter number on the Jekyll title so the sidebar,
            # browser tab, and breadcrumb all show "N. Chapter Name". The h1 in
            # the rendered content is numbered separately by pandoc below.
            title="${chapnum}. $(get_heading "$md")"
            html_dest="$DOCS/$dest_subdir/${base%.md}.html"

            # Auto-number chapter headings to match the PDF: offset N-1 so pandoc
            # renders the first h1 as N (ch00 gets "0", ch12 gets "12"). h2 and
            # below also pick up "N.x" subsection numbers --- custom.scss hides
            # those so only the top-level chapter number renders.
            number_opts="--number-sections --number-offset=$((chapnum - 1))"

            convert_chapter "$src_dir" "$base" "$html_dest" "$title" "$parent" "$chapnum" "$number_opts"

            pdf_src="$src_dir/${base%.md}.pdf"
            pdf_dst="$DOCS/$dest_subdir/${base%.md}.pdf"
            copy_pdf "$pdf_src" "$pdf_dst"
            if [ -f "$pdf_dst" ]; then include_pdf=yes; else include_pdf=no; fi

            emit_chapter_entry "$dest_subdir" "${base%.md}" "$title" "$include_pdf"
        done

        # Conclusion (if present) renders after the numbered chapters,
        # unnumbered like the author intro and bibliography.
        if [ -f "$src_dir/conclusion.md" ]; then
            local concl_title concl_dest
            concl_title=$(get_heading "$src_dir/conclusion.md")
            concl_dest="$DOCS/$dest_subdir/conclusion.html"
            convert_chapter "$src_dir" "conclusion.md" "$concl_dest" \
                "$concl_title" "$parent" "99"
            emit_chapter_entry "$dest_subdir" "conclusion" "$concl_title" "no"
        fi

        for md in "$src_dir"/app*.md; do
            local base letter order title html_dest pdf_src pdf_dst include_pdf
            base=$(basename "$md")
            letter=${base%.md}
            letter=${letter#app}
            order=$((100 + $(printf '%d' "'$letter") - $(printf '%d' "'A")))
            title="Appendix ${letter}: $(get_heading "$md")"
            html_dest="$DOCS/$dest_subdir/${base%.md}.html"

            # Appendices don't use --number-sections (pandoc numbers with digits,
            # not letters); the "Appendix X: " prefix is baked into the title.
            convert_chapter "$src_dir" "$base" "$html_dest" "$title" "$parent" "$order"

            pdf_src="$src_dir/${base%.md}.pdf"
            pdf_dst="$DOCS/$dest_subdir/${base%.md}.pdf"
            copy_pdf "$pdf_src" "$pdf_dst"
            if [ -f "$pdf_dst" ]; then include_pdf=yes; else include_pdf=no; fi

            emit_chapter_entry "$dest_subdir" "${base%.md}" "$title" "$include_pdf"
        done

        if [ -f "$src_dir/bibliography.md" ]; then
            local biblio_title biblio_dest
            biblio_title=$(get_heading "$src_dir/bibliography.md")
            biblio_dest="$DOCS/$dest_subdir/bibliography.html"
            convert_bibliography "$src_dir" "$biblio_dest" \
                "$biblio_title" "$parent" "150"
            emit_chapter_entry "$dest_subdir" "bibliography" "$biblio_title" "no"
        fi

        printf '</ul>\n'

        for md in "$src_dir"/*-answers.md; do
            local base
            base=$(basename "$md")
            convert_chapter "$src_dir" "$base" \
                "$DOCS/$dest_subdir/answers.html" "Answer Key" "$parent" 200
        done
    } > "$include_file"
}

# Build the three books and the extras in parallel so
# at least four top-level jobs are running at any given time. Combined with
# make -j4 inside each book's PDF build, peak parallelism is ~12 concurrent
# pandoc+lualatex runs during the PDF phase.
build_book sc++  starting-cpp   "Gorgo Starting C++"          "sc++" &
build_book cc++  continuing-cpp "Gorgo Continuing C++"        "cc++" &
build_book c4c++ c-for-cpp      "Gorgo C for C++ Programmers" "c4c++" &

# extras --- run in parallel with the book builds.
(
    for name in operators numbers; do
        md="$name.md"
        title=$(sed -n 's/^title: *"\(.*\)"/\1/p' "$name/$md")
        [ -z "$title" ] && title=$(get_heading "$name/$md")
        case "$name" in
            operators) order=1 ;;
            *)         order=2 ;;
        esac
        convert_chapter "$name" "$md" "$DOCS/extras/${name}.html" "$title" "Extras" "$order"
    done
) &

wait

echo "site built successfully"
