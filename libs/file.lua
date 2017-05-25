require("./extra_table_functions.lua")

local file = {}

function file.toTable(f)
  local func = loadstring("return "..f.content)
  if func ~= nil then return func() else return {} end
end

function file.load(f, path)
  if type(f) == "table" then
    if f.path then
      local ff = io.open(f.path, "rb")
      if not ff then f.content = "" else f.content = ff:read("*all") ff:close() end
      return f
    else
      local ff = io.open(path, "rb")
      if not ff then f.content = "" else f.content = ff:read("*all") ff:close() end
      f.path = path
      return f
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

function file.loadWithTable(f, path)
  local t = file.load(f, path)
  t.table = t:toTable()
  return t
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
  if type(t) == "string" then -- Defined path, use own table
    f.content = table.tostring(f.table)
    f:save(t)
    return f.table
  elseif type(t) == "table" then -- Defined table, defined path/own path
    f.content = table.tostring(t)
    f:save(path)
    return t
  elseif type(t) == "nil" then -- None, use own table
    f.content = table.tostring(f.table)
    f:save()
    return f.table
  end
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
