local file = require("../libs/file.lua")

--[[
  presumed defaults for stuff:
    minVotebanCount is the amount of votes required to ban someone, defaults to 5
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

function main(message, args)
  -- Removing expired votes
  for memberID, voteTypes in pairs(votes) do
    for voter, memVote in pairs(voteTypes.ban) do
      if os.time() - memVote.time >= config.voteBanExpireTime then
        print("[INFO] The vote to ban a user by the ID of " .. memVote.id .. " has silently expired.")
        table.remove(voteTypes.ban, voter)
      end
    end
  end
  -- Detecting Mentioned Users and turning them into members
  local members = {}
  for users in message.mentionedUsers do
    table.insert(members, users:getMembership(message.guild))
  end
  -- Limiting members voted for
  if #members == 0 then print("No users to vote ban to...") return end
  if #members > 1 then print("Too much users voted for") return end

  -- Meeting author requirements
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
    -- Meeting target requirements
    if member.roleCount > 0 then message.channel:sendMessage("You can not voteban members with roles!") break end
    -- Starting main
    local firstVote = false
    if votes[member.id] == nil then
      votes[member.id] = {}
      firstVote = true
      message.channel:sendMessage(message.member.mentionString .. " has started a vote to ban " .. member.mentionString .. "! " .. (config.minVotebanCount-1) .. " more votes are required.")
    end
    if votes[member.id].ban == nil then
      votes[member.id].ban = {}
    end
    local unique = true
    for i, v in pairs(votes[member.id].ban) do if v.id == message.member.id then unique = false break end end
    if unique then
      table.insert( votes[member.id].ban, { id = message.member.id, time = os.time() } )
      p(message.member.id, votes[member.id].ban[#votes[member.id].ban], #votes[member.id].ban)
      if (config.minVotebanCount-#votes[member.id].ban) > 0 then
        if firstVote == false then 
          message.channel:sendMessage(message.member.mentionString .. " has voted to ban " .. member.username .. ". " .. (config.minVotebanCount-#votes[member.id].ban) .. " more votes are required.")
        end
      else
        message.channel:sendMessage(message.member.mentionString .. " has voted to ban " .. member.username .. ". The votes necessary have been reached. " .. member.username .. " has been banned.")
      end
    else
      message.channel:sendMessage(message.member.mentionString .. " you have already voted for " .. member.username)
    end
    if #votes[member.id].ban == config.minVotebanCount then
      member:sendMessage("Unfortunately, you have been votebanned in the Click Converse server! If you feel this ban was in error, please contact a moderator from the server to appeal e.g. Uppernate#2858.")
      --message.channel:sendMessage(member.username .. " has been successfully voted to be banned from this server.")
      print("INFO: " .. member.username .. " has been votebanned from the server.")
      member:ban(message.guild)
    end
  end
  files.votes:saveFromTable(votes)
end

return main
