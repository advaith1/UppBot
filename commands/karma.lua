local file = require("../libs/file.lua")
local clickbot = require("../clickbot.lua")

local files = {
  memberInfo = file.load("./UppBot/data/memberInfo.txt")
}

--File Tables
local memberInfo = files.memberInfo:toTable()

function doublecheckmemberinfo(user)
  files.memberInfo = file.load("./UppBot/data/memberInfo.txt")
  memberInfo = files.memberInfo:toTable()
  local oldInfo = memberInfo[user.id]

  if memberInfo[user.id] == nil then
    memberInfo[user.id] = {}
  end

  if memberInfo[user.id]["roles"] == nil then
    memberInfo[user.id]["roles"] = {}
  end

  if memberInfo[user.id]["karma"] == nil then
    memberInfo[user.id]["karma"] = 0
  end

  if oldInfo ~= memberInfo[user.id] then
    files.memberInfo:saveFromTable(memberInfo)
  end
end

function karma(message, args)
  files.memberInfo = file.load("./UppBot/data/memberInfo.txt")
  memberInfo = files.memberInfo:toTable()
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
    doublecheckmemberinfo(users[1])
    name = users[1].name
    karma = memberInfo[users[1].id]["karma"]
  end
  message.channel:sendMessage(string.format("**%s** has **%d** karma.", name, karma))
end

return karma
