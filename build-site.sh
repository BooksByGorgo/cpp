#!/bin/bash
set -euo pipefail
shopt -s nullglob

DOCS=docs
PANDOC_OPTS="-f markdown -t html5 --highlight-style=pygments --wrap=none --email-obfuscation=none"

get_heading() {
    grep -m1 '^#\+ ' "$1" | sed 's/^#\+ //'
}

convert_chapter() {
    local src_dir="$1" md_base="$2" dest="$3" title="$4" parent="$5" nav_order="$6"

    mkdir -p "$(dirname "$dest")"

    local filter_opt=""
    [ -f "$src_dir/callout.lua" ] && filter_opt="--lua-filter=callout.lua"

    {
        printf '%s\n' "---"
        printf 'layout: default\n'
        printf 'title: "%s"\n' "$title"
        printf 'parent: "%s"\n' "$parent"
        printf 'nav_order: %s\n' "$nav_order"
        printf '%s\n\n' "---"
        printf '{%% raw %%}\n'
        (cd "$src_dir" && pandoc "$md_base" $PANDOC_OPTS $filter_opt)
        printf '\n{%% endraw %%}\n'
    } > "$dest"
}

build_book() {
    local src_dir="$1" dest_subdir="$2" parent="$3"

    for md in "$src_dir"/ch*.md; do
        local base num title
        base=$(basename "$md")
        num=${base%.md}
        num=${num#ch}
        title=$(get_heading "$md")
        convert_chapter "$src_dir" "$base" \
            "$DOCS/$dest_subdir/${base%.md}.html" "$title" "$parent" "$((10#$num))"
    done

    for md in "$src_dir"/app*.md; do
        local base letter order title
        base=$(basename "$md")
        letter=${base%.md}
        letter=${letter#app}
        order=$((100 + $(printf '%d' "'$letter") - $(printf '%d' "'A")))
        title=$(get_heading "$md")
        convert_chapter "$src_dir" "$base" \
            "$DOCS/$dest_subdir/${base%.md}.html" "$title" "$parent" "$order"
    done

    for md in "$src_dir"/*-answers.md; do
        local base
        base=$(basename "$md")
        convert_chapter "$src_dir" "$base" \
            "$DOCS/$dest_subdir/answers.html" "Answer Key" "$parent" 200
    done
}

build_book sc++ starting-cpp "Starting C++"
build_book cc++ continuing-cpp "Continuing C++"
build_book c4c++ c-for-cpp "C for C++ Programmers"

# extras
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

echo "site built successfully"
