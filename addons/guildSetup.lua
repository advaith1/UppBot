local gSetup = {}
gSetup.name = "guildSetup"
gSetup.desc = "Guild setup - Global addon"

function gSetup.main(pack)
  local client = pack.client
  local files = pack.files
  local database = files.database.table
  local guild = pack.guild
  database[guild.id] = database[guild.id] or {name=guild.name, addons={_config={}}, commands={config={addon="_config", name="main", desc="Configures many features on this server"}}, new=true}
  database[guild.id].addons = database[guild.id].addons or {_config={}}
  database[guild.id].commands = database[guild.id].commands or {config={addon="_config", name="main", desc="Configures many features on this server"}}
  if database[guild.id].new then
    print("New Guild: "..guild.name)
    database[guild.id].new = nil
  end
end

return gSetup
