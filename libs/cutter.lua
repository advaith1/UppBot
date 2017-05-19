local cutter = {}

function cutter.cut(content, delimiter)
  local cut = content
  local index = 1
  local occurence = content:find(delimiter, index)
  local found = cut:match(delimiter)
  local results = {}
  while occurence ~= nil and occurence > -1 do
    if found == nil then break end
    table.insert(results, content:sub(index, occurence - 1))
    cut = cut:sub(index+#found)
    index = occurence + #found
    occurence = content:find(delimiter, index)
    found = cut:match(delimiter)
  end
  table.insert(results, content:sub(index, #content))
  return results
end

return cutter
