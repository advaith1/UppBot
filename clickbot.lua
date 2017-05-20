--[[
////////////////////////////////////////////////////

                    Click Bot
           For the Click Converse Server
              Version: Boop (0.1.0)

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
  memberRoles = file.load("./UppBot/data/memberInfo.txt")
}

-- File Tables
local config = files.config:toTable()
local commands = files.commands:toTable()
local memberRoles = files.memberRoles:toTable()

-- Loading in command .lua files
for i, v in pairs(commands) do
  v.main = require("./commands/"..i..".lua")
end

client:on("ready", function()
  print("Logged in as " .. client.user.username)
  client:setGameName("type .help for my list of commands")
end)

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

  -- Do nothing if no prefix was used ¯\_(ツ)_/¯
end)

-- Reassigning roles
-- Credits:
-- Idea and main code: Lumez
-- Fixes: Uppernate

client:on("memberJoin", function(member)
  if memberRoles[member.id] ~= nil then
    for _,v in pairs(memberRoles[member.id]) do
      for role in member.guild.roles do
        if role.id == v then
          member:addRoles(role)
        end
      end
    end
  end
end)

client:on("memberLeave", function(member)
  memberRoles[member.id] = {}
  for r in member.roles do
    table.insert(memberRoles[member.id], r.id)
  end
  files.memberRoles:saveFromTable(memberRoles)
end)

-- Reassigning roles end

p("Click Bot running")
client:run(config.token)
