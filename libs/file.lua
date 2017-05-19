require("./extra_table_functions.lua")

local file = {}

function file.load(f, path)
  if type(f) == "table" then
    if f.path ~= nil then
      local ff = io.open(f.path, "rb")
      if not ff then f.content = "" else f.content = ff:read("*all") ff:close() end
    else
      local ff = io.open(path, "rb")
      if not ff then f.content = "" else f.content = ff:read("*all") ff:close() end
      f.path = path
    end
  else
    local newf = {}
    local ff = io.open(f, "rb")
    if not ff then newf.content = "" else newf.content = ff:read("*all") ff:close() end
    newf.load = file.load
    newf.save = file.save
    newf.toTable = file.toTable
    newf.saveFromTable = file.saveFromTable
    newf.path = f
    return newf
  end
end

function file.save(f, path)
  if path == nil and f.path ~= nil then
    local file = io.open(f.path, "w")
    file:write(f.content)
    file:close()
  end
  if path ~= nil then
    local file = io.open(path, "w")
    file:write(f.content)
    file:close()
    f.path = path
  end
end

function file.saveFromTable(f, t, path)
  f.content = table.tostring(t)
  f:save(path)
end

function file.toTable(f)
  local func = loadstring("return "..f.content)
  if func ~= nil then return func() else return {} end
end

function file.new()
  local f = {}
  f.content = ""
  f.load = file.load
  f.save = file.save
  f.toTable = file.toTable
  f.saveFromTable = file.saveFromTable
  return f
end

return file
