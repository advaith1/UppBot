local basic = {}
basic.name = "message"
basic.desc = "A new command to send messages as the bot."

function basic.event_added(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  local cmdName = "msg"
  if not dataGuild.commands[cmdName] then
    dataGuild.commands[cmdName] = {addon=basic.name, name="main"}
  end
  dataGuild.permissions.msg_sendAsBot = {roleIDs = {}, memberIDs = {}, channelIDs = {}, desc = "If the user can send messages as bot."}
end

function basic.event_removed(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  local cmdName = "msg"
  if dataGuild.commands[cmdName] and dataGuild.commands[cmdName].addon == basic.name then
    dataGuild.commands[cmdName] = nil
  end
  dataGuild.permissions.msg_sendAsBot = nil
end

function basic.cmd_main(pack)
  local message = pack.message
  local perms = pack.permissions
  if perms.msg_sendAsBot then
    local CONTENT = message.content:sub(".msg":len()+1)
    CONTENT = "return" .. CONTENT
    local func = loadstring(CONTENT)
    message.channel:sendMessage(func())
  end
end

return basic
