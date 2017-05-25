local gSetup = {}

function gSetup.main(pack)
  local client = pack.client
  local files = pack.files
  local database = files.database.table
  local guild = pack.guild
  database[guild.id] = database[guild.id] or {name=guild.name, addons={config={}}, commands={config={addon="config", name="main"}}, new=true}
  database[guild.id].addons = database[guild.id].addons or {config={}}
  database[guild.id].commands = database[guild.id].commands or {config={addon="config", name="main"}}
  if database[guild.id].new then
    print("New Guild: "..guild.name)
    database[guild.id].new = nil
  end
end

gSetup.name = "guildSetup"

return gSetup
