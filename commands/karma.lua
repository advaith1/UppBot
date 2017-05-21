local file = require("../libs/file.lua")
local clickbot = require("../clickbot.lua")
memberInfo = file.load("../UppBot/data/memberInfo.txt"):toTable()

function karma(message, args)
  local users = {}
  for user in message.mentionedUsers do
      table.insert(users, user)
  end

  if (#users == 0 and #args ~= 0) or (#users ~= #args) then
    message.channel:sendMessage("Please either mention nobody or mention another user's karma to see theirs! Other arguments are not acceptable!")
    return
  end

  if #users > 1 then
    message.channel:sendMessage("Please only mention *one* user whose karma you would like to check!")
    return
  end

  local name, karma
  if #users == 0 then
    name = message.author.name
    karma = memberInfo[message.author.id]["karma"]
  elseif #users == 1 then
    doublecheckmemberinfo(users[0])
    name = users[0].name
    karma = memberInfo[users[0].id]["karma"]
  end
  message.channel:sendMessage(string.format("**%s** has **%d** karma.", name, karma))
end

return karma
