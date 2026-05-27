-- Callout filter: handles ::: {.tip} divs and differentiates Tip / Trap /
-- Wut by inspecting the bold label on the first line of the content. The
-- box is split into two columns: the icon sits in a narrow left column
-- and the text fills the right column, so the text does not wrap around
-- the icon. We point at the -callout.png downsized variants (256x256,
-- ~100KB each) so chapter PDFs do not bloat the way they would if we
-- embedded the 1024x1024 source PNGs. The path ../images/<kind>-callout
-- .png works for both LaTeX (from the book dir, pointing at the top-
-- level images/) and HTML (from a Jekyll chapter page at
-- /<book>/chNN.html, pointing at /images/ under docs/).

local tcb = "colback=black!5, colframe=black!20, " ..
  "boxrule=0.4pt, arc=2pt, left=5pt, right=5pt, " ..
  "top=4pt, bottom=4pt, fontupper=\\small"

-- sidebyside splits the box into two columns. lefthand width sets the
-- width of the icon column; the rest goes to the text column. The
-- lower separated=false option suppresses tcolorbox's default thin
-- rule between the upper (icon) and lower (text) segments.
local tcb_icon = tcb ..
  ", sidebyside, sidebyside align=top, sidebyside gap=8pt, " ..
  "lefthand width=0.45in, lower separated=false"

local html_style = "background-color: #f5f5f5; border: 1px solid #ccc; " ..
  "border-radius: 4px; padding: 12px 16px; margin: 1em 0; font-size: 0.95em;"

-- Map the bold label text at the start of a callout to its icon basename.
local function callout_kind(el)
  local first = el.content[1]
  if not first or first.t ~= "Para" then return nil end
  local first_inline = first.content[1]
  if not first_inline or first_inline.t ~= "Strong" then return nil end
  local label = pandoc.utils.stringify(first_inline)
  if label == "Tip:"  then return "tip"  end
  if label == "Trap:" then return "trap" end
  if label == "Wut:"  then return "wut"  end
  return nil
end

function Div(el)
  if not el.classes:includes("tip") then return nil end

  local kind = callout_kind(el)
  local fmt = FORMAT

  if fmt:match("latex") then
    local blocks = pandoc.List({})
    if kind then
      -- Two-column box: icon in the left column, pandoc-emitted content
      -- (everything between \tcblower and \end{tcolorbox}) in the right.
      blocks:insert(pandoc.RawBlock("latex",
        "\\begin{tcolorbox}[" .. tcb_icon .. "]"))
      blocks:insert(pandoc.RawBlock("latex",
        "\\includegraphics[width=\\linewidth]{../images/"
        .. kind .. "-callout.png}"))
      blocks:insert(pandoc.RawBlock("latex", "\\tcblower"))
      for _, cb in ipairs(el.content) do
        blocks:insert(cb)
      end
      blocks:insert(pandoc.RawBlock("latex", "\\end{tcolorbox}"))
    else
      -- No recognized label --- fall back to the plain single-column box.
      blocks:insert(pandoc.RawBlock("latex",
        "\\begin{tcolorbox}[" .. tcb .. "]"))
      for _, cb in ipairs(el.content) do
        blocks:insert(cb)
      end
      blocks:insert(pandoc.RawBlock("latex", "\\end{tcolorbox}"))
    end
    return blocks

  elseif fmt:match("html") then
    local blocks = pandoc.List({})
    if kind then
      -- Flexbox: fixed-width icon column, text fills the rest.
      -- align-items: center vertically centers the icon relative to the
      -- text column so it sits at the middle of the callout.
      blocks:insert(pandoc.RawBlock("html",
        '<div style="' .. html_style ..
        ' display: flex; gap: 12px; align-items: center;">'))
      blocks:insert(pandoc.RawBlock("html",
        '<img src="../images/' .. kind .. '-callout.png" ' ..
        'style="width: 48px; flex-shrink: 0;">'))
      blocks:insert(pandoc.RawBlock("html",
        '<div style="flex: 1; min-width: 0;">'))
      for _, cb in ipairs(el.content) do
        blocks:insert(cb)
      end
      blocks:insert(pandoc.RawBlock("html", '</div></div>'))
    else
      blocks:insert(pandoc.RawBlock("html",
        '<div style="' .. html_style .. '">'))
      for _, cb in ipairs(el.content) do
        blocks:insert(cb)
      end
      blocks:insert(pandoc.RawBlock("html", '</div>'))
    end
    return blocks
  end
end
