local gSetup = {}

local file = require("../libs/file.lua")

-- Files
local files = {
  database = file.load("./UppBot/data/database.txt")
}
-- File Tables
local database = files.database:toTable()

function saveTable(t, name)
  return files[name]:saveFromTable(t)
end

function gSetup.main(args)
  database = files.database.load("./UppBot/data/database.txt"):toTable()
  local client = args[1]
  for guild in client.guilds do
    local new = false
    database[guild.id] = database[guild.id] or {name=guild.name, addons={}, new=true}
    database[guild.id].addons = database[guild.id].addons or {}
    if database[guild.id].new then
      print("New Guild: "..guild.name)
      database[guild.id].new = nil
      database = saveTable(database, "database")
    end
  end
end

gSetup.name = "guildSetup"

return gSetup
