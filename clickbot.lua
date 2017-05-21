--[[
////////////////////////////////////////////////////

                    Click Bot
           For the Click Converse Server
            Version: I'm alive (0.1.0)

////////////////////////////////////////////////////
]]

-- Important libraries
local discordia = require('discordia') -- Cool Discord API library
local client = discordia.Client()
local ticker = require("./libs/ticker.lua") -- Cool timer thing I wrote which I will probably never use
local file = require("./libs/file.lua") -- Cool file reader and lua table converter thing I wrote
local cutter = require("./libs/cutter.lua") -- Cool delimiter thing I wrote

-- Files
local files = {
  config = file.load("./UppBot/data/config.txt"),
  commands = file.load("./UppBot/data/commands.txt"),
  memberInfo = file.load("./UppBot/data/memberInfo.txt")
}

-- File Tables
local config = files.config:toTable()
local commands = files.commands:toTable()
local memberInfo = files.memberInfo:toTable()

-- Loading in command .lua files
for i, v in pairs(commands) do
  v.main = require("./commands/"..i..".lua")
end

client:on("ready", function()
  print("Logged in as " .. client.user.username)
  client:setGameName("type .help for my list of commands")
  client:getChannel("315560822438887429"):sendMessage("Restarted.")
end)

-- Double-check every user's memberinfo
-- also this probably isn't top performance but who cares
function doublecheckmemberinfo(user)
  if memberInfo[user.id] == nil then
    memberInfo[user.id] = {}
  end

  if memberInfo[user.id]["roles"] == nil then
    memberInfo[user.id]["roles"] = {}
  end

  if memberInfo[user.id]["karma"] == nil then
    memberInfo[user.id]["karma"] = 0
  end
end

function commandExecute(message, command, args)
  -- Unknown command
  if commands[command] == nil then
    p(message.author.username.." ATTEMPTED", command, args)
    -- message.channel:sendMessage(message.author.mentionString..", this command does not exist.")
    return
  end

  -- Failsafes, if guild commands get executed on private channels, things can explode.
  if message.guild == nil and commands[command].type == "guild" then return end
  if message.guild ~= nil and commands[command].type == "priv" then return end

  -- Checking if member has at least one required role

  local gotRoles = false

  if #commands[command].roles > 0 then
    for id, roleName in pairs(commands[command].roles) do
      local memberRole = message.member:hasRole(message.guild:getRole("name", roleName))
      p(memberRole)
      if memberRole then gotRoles = true break end
    end
  else
    gotRoles = true
  end

    -- Known command, executing

  if commands[command].main ~= nil and gotRoles == true then
    p(message.author.username.." ACCESSED", command, args)
    commands[command].main(message, args)
  else
    -- Known command but .lua file in commands folder does not exist.
    p(message.author.username.." ACCESSED BUT FAILED", command, args)
  end
end

-- Main thing
client:on("messageCreate", function(message)
  -- Check senders's memberInfo
  doublecheckmemberinfo(message.author)
  
  -- Getting first word
  local nearest_space = message.content:find(" ")
  local command = nil
  if nearest_space ~= nil then
    command = message.content:lower():sub(1,nearest_space-1)
  else
    command = message.content:lower()
  end
  -- Checking if the first word was prefixed
  local commandPrefixed = nil
  for i, v in pairs(config.prefixes) do -- Looping through prefixes
    local result = command:sub(1, #v)
    if result == v then -- Found prefix used.
      commandPrefixed = v
      command = command:sub(#v+1, #command)
      break
    end
  end
  -- If a prefix was used then...
  if commandPrefixed ~= nil then
    local cmdContent = cutter.cut(message.content, "%p%s+") -- Cutting rest of the text using ", " and then making them arguments
    cmdContent[1] = cmdContent[1]:sub(#command+#commandPrefixed+2, #cmdContent[1]) -- Cutting the first word from the first argument
    if cmdContent[1] == "" then cmdContent[1] = nil end -- When the first argument is "", remove it completely.
    commandExecute(message, command, cmdContent) -- Forwarding the info to the function
  end

  -- Do nothing if no prefix was used ¯\_(ツ)_/¯ (jk we do something now)
  if message.content:lower():find("thanks") then
    local users = {}
    for user in message.mentionedUsers do
      doublecheckmemberinfo(user)
      table.insert(users, user)
    end

    if #users > 0 then
      local messageToSend = ""
      for user in pairs(users) do
        if message.author.id ~= user.id and not user.bot then
          messageToSend = messageToSend + string.format("**%s** has given thanks to **%s**\n", message.author.name, user.name)
          memberInfo[user.id]["karma"] = memberInfo[user.id]["karma"] + 1
        end
      end
      files.memberInfo:saveFromTable(memberInfo)
      message.channel:sendMessage(messageToSend)
    end
  end
end)

-- Reassigning roles
-- Credits:
-- Idea and main code: Lumez
-- Fixes: Uppernate

client:on("memberJoin", function(member)
  doublecheckmemberinfo(member)

  for _,v in pairs(memberInfo[member.id]["roles"]) do
    for role in member.guild.roles do
      if role.id == v then
        member:addRoles(role)
      end
    end
  end
end)

client:on("memberLeave", function(member)
  doublecheckmemberinfo(member)

  for r in member.roles do
    table.insert(memberInfo[member.id]["roles"], r.id)
  end
  files.memberInfo:saveFromTable(memberInfo)
end)

-- Reassigning roles end

p("Click Bot running")
client:run(config.token)
