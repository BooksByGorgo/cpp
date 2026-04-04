local tcb = "colback=black!5, colframe=black!20, " ..
  "boxrule=0.4pt, arc=2pt, left=5pt, right=5pt, " ..
  "top=4pt, bottom=4pt, fontupper=\\small"

local html_style = "background-color: #f5f5f5; border: 1px solid #ccc; " ..
  "border-radius: 4px; padding: 12px 16px; margin: 1em 0; font-size: 0.95em;"

function Div(el)
  if el.classes:includes("tip") then
    local fmt = FORMAT
    if fmt:match("latex") then
      local blocks = pandoc.List({})
      blocks:insert(pandoc.RawBlock("latex",
        "\\begin{tcolorbox}[" .. tcb .. "]"))
      for _, cb in ipairs(el.content) do
        blocks:insert(cb)
      end
      blocks:insert(pandoc.RawBlock("latex", "\\end{tcolorbox}"))
      return blocks
    elseif fmt:match("html") then
      local blocks = pandoc.List({})
      blocks:insert(pandoc.RawBlock("html",
        '<div style="' .. html_style .. '">'))
      for _, cb in ipairs(el.content) do
        blocks:insert(cb)
      end
      blocks:insert(pandoc.RawBlock("html", '</div>'))
      return blocks
    end
  end
end
