local basic = {}
basic.name = "basic commands"
basic.desc = "Example addon - has ping command"

function basic.event_added(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if not dataGuild.commands.ping then
    dataGuild.commands.ping = {addon="basic", name="ping"}
  end
end

function basic.event_removed(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if dataGuild.commands.ping and dataGuild.commands.ping.addon == "basic" then
    dataGuild.commands.ping = nil
  end
end

function basic.cmd_ping(pack)
  local message = pack.message
  message.channel:sendMessage(message.author.mentionString.." pong!")
end

return basic
