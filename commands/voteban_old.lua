--[[
  presumed defaults for stuff:
    minVoteMemeCount is the amount of votes required to ban someone, defaults to 5
    voteBanExpireTime is the time in seconds that a vote will take to expire, defaults to 900 (15 minutes)
]]--

local file = require("../libs/file.lua")
config = file.load("./UppBot/data/config.txt"):toTable()

--[[
  structure:
    key is id of voted user
    value is a table of the IDs of users who have voted to ban said user, although it should be noted value[1] will always be the seconds since the epoch at which the vote was started
]]--
votes = {}

function voteban(message, args)
  for k,v in pairs(votes) do
    if os.time() - v[1] >= config.voteBanExpireTime then
      table.remove(votes, k)
      print("[INFO] The vote to ban a user by the ID of " .. k .. " has silently expired.")
    end
  end
  p(1)
  p(args[1]:match("%d+"))
  local voted = message.guild:getMember("id", args[1]:match("%d+"))
  if voted == nil then return end
  p(2)
  if not message.author.hasRole(message.guild:getRole("name", "Clickers")) then
    message.channel:sendMessage("You need to have the Clicker role to voteban users!")
    return
  end
  p(3)
  if voted.roleCount > 1 then
    message.channel:sendMessage("You can not voteban members with roles!")
    return
  end
  p(4)
  for k,v in pairs(votes) do
    if k == voted.id then
      for _,m in pairs(v) do
        if m == message.author.id then
          message.channel:sendMessage("You can not vote to kick a user twice in one attempt!")
          return
        end
      end
      if #v < config.minVoteMemeCount + 1 then
        message.channel:sendMessage("You have voted to ban " .. voted.name .. "! Your vote has been counted. " .. tostring((config.minVoteMemeCount + 1) - #v) .. " more votes are needed to ban " .. voted.name .. ".")
        table.insert(v, m.id)
      else
        voted:sendMessage("Unfortunately, you have been votebanned in the Click Converse server! If you feel this ban was in error, please contact a moderator from the server to appeal.")
        message.channel:sendMessage(voted.name .. " has been votebanned!")
        voted:ban(message.guild)
    print("[INFO] The vote to ban a user by the ID of " .. k .. " has gone through. User banned.")
      end

      return
    end
  end

  table.insert(votes, voted.id, {os.time(), message.author.id})
  message.channel:sendMessage("A voteban has started for " .. voted.name .. "! " .. tostring(config.minVoteMemeCount) .. " votes are required within " .. tostring(config.voteBanExpireTime / 60) .. " minutes or else the voteban will automatically expire!")
end

return voteban
