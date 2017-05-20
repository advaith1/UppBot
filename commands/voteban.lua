local file = require("../libs/file.lua")

--[[
  presumed defaults for stuff:
    minVoteMemeCount is the amount of votes required to ban someone, defaults to 5
    voteBanExpireTime is the time in seconds that a vote will take to expire, defaults to 900 (15 minutes)
]]--

--Files
local files = {
  config = file.load("./UppBot/data/config.txt"),
  votes = file.load("./UppBot/data/votes.txt")
}

--File Tables
local config = files.config:toTable()
local votes = files.votes:toTable()


--[[
  structure:
    key is id of voted user
    value is a table of the IDs of users who have voted to ban said user, although it should be noted value[1] will always be the seconds since the epoch at which the vote was started
]]--

function main(message, args)
  --Detecting Mentioned Users and turning them into members
  local members = {}
  for users in message.mentionedUsers do
    table.insert(members, users:getMembership(message.guild))
  end
  --Limiting members voted for
  if #members == 0 then print("No users to vote ban to...") return end
  if #members > 1 then print("Too much users voted for") return end

  --Meeting author requirements
  local allowed = false
  for role in message.member.roles do
    if role.name == "Clickers" then
      allowed = true
      break
    end
  end
  if not allowed then
    message.channel:sendMessage("You need to have the Clicker role to voteban users!")
    return
  end

  for _, member in pairs(members) do
    --Meeting target requirements
    if member.roleCount > 0 then message.channel:sendMessage("You can not voteban members with roles!") break end
    --Starting main
    if votes[member.id] == nil then votes[member.id] = {} end
    local entry = votes[member.id]
    if entry.ban == nil then entry.ban = {} end
    if entry.ban[message.member.id] == nil then
      print("Making new entry...")
      entry.ban[message.member.id] = os.time()
      local vote = entry.ban[message.member.id]
      message.channel:sendMessage(message.member.username.." has voted to ban "..member.username)
    end
  end
end

return main
