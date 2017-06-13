local basic = {}
basic.name = "botLog"
basic.desc = "Logs edited and removed messages."

function basic.event_messageUpdate(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if message.member == nil then return end
  message.guild:getChannel("name", "bot_log"):sendMessage(message.member.mentionString .. ": " .. message.oldContent .. " - > TO - > "..message.content)
end

function basic.event_messageDelete(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if message.member == nil then return end
  message.guild:getChannel("name", "bot_log"):sendMessage(message.member.mentionString .. ": " .. message.content .. " - > TO - > REMOVED ")
end

return basic
