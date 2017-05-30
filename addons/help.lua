local help = {}
help.name = "help"
help.desc = "Command to list all addons in a server"

function help.event_added(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if not dataGuild.commands.help then
    dataGuild.commands.help = {addon="help", name="help", desc="Prints out commands available on this server"}
  end
end

function help.event_removed(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if dataGuild.commands.help and dataGuild.commands.help.addon == "help" then
    dataGuild.commands.help = nil
  end
end

function help.cmd_help(pack)
  local message = pack.message
  local addons = pack.addons
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  local guildCommands = dataGuild.commands
  local desc = ""
  for i, v in pairs(guildCommands) do
    desc = desc .. i
    local info = v.desc
    if info then info = ": " .. info .. "\n" else info = "\n" end
    desc = desc .. info
  end
  local msg = {embed={title="Commands: ", description=desc}}
  message.author:sendMessage(msg)
end

return help
