local tcb = "colback=black!5, colframe=black!20, " ..
  "boxrule=0.4pt, arc=2pt, left=5pt, right=5pt, " ..
  "top=4pt, bottom=4pt, fontupper=\\small"

function Div(el)
  if el.classes:includes("tip") then
    local blocks = pandoc.List({})
    blocks:insert(pandoc.RawBlock("latex",
      "\\begin{tcolorbox}[" .. tcb .. "]"))
    for _, cb in ipairs(el.content) do
      blocks:insert(cb)
    end
    blocks:insert(pandoc.RawBlock("latex", "\\end{tcolorbox}"))
    return blocks
  end
end
