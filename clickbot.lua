local discordia = require('discordia')
local client = discordia.Client()
local ticker = require("./libs/ticker.lua")
local file = require("./libs/file.lua")
local cutter = require("./libs/cutter.lua")

--Files
local files = {
  config = file.load("./UppBot/data/config.txt"),
  commands = file.load("./UppBot/data/commands.txt")
}

--File Tables
local config = files.config:toTable()
local commands = files.commands:toTable()

if commands == nil then commands = {} end

for i, v in pairs(commands) do
  v.main = require("./commands/"..i..".lua")
end

client:on("ready", function()
  print('Logged in as '.. client.user.username)
  client:setGameName("type .help for my list of commands")
end)

function commandExecute(message, command, args)
  if commands[command] == nil then
    p(message.author.username.." ATTEMPTED", command, args)
    --message.channel:sendMessage(message.author.mentionString..", this command does not exist.")
    return
  end
  if message.guild == nil and commands[command].type == "guild" then return end
  if message.guild ~= nil and commands[command].type == "priv" then return end
  if commands[command].main ~= nil then
    p(message.author.username.." ACCESSED", command, args)
    commands[command].main(message, args)
  else
    p(message.author.username.." ACCESSED BUT FAILED", command, args)
  end
end

client:on("messageCreate", function(message)
  local nearest_space = message.content:find(" ")
  local command = nil
  if nearest_space ~= nil then
    command = message.content:lower():sub(1,nearest_space-1)
  else
    command = message.content:lower()
  end
  --Checking if the first word was prefixed
  local commandPrefixed = nil
  for i, v in pairs(config.prefixes) do
    local result = command:sub(1, #v)
    if result == v then commandPrefixed = v command = command:sub(#v+1, #command) break end
  end
  if commandPrefixed ~= nil then
    local cmdContent = cutter.cut(message.content, "%p%s+")
    cmdContent[1] = cmdContent[1]:sub(#command+#commandPrefixed+2, #cmdContent[1])
    commandExecute(message, command, cmdContent)
  end
end)

p("Click Bot running")
client:run(config.token)
