-- Important libraries
local discordia = require('discordia') -- Cool Discord API library
local client = discordia.Client()
local file = require("./libs/file.lua") -- Cool file reader and lua table converter thing I wrote
local addon = require("./libs/addons.lua")

-- Files
local files = {
  database = file.loadWithTable("./UppBot/data/database.txt"),
  config = file.loadWithTable("./UppBot/data/config.txt")
}
if files.database.table == nil then files.database.table = {} end -- New database is made if one doesn't exist

-- Addons:
local addons = { } -- Addons with _ at the beginning of their name are global addons and they cannot be added or removed from a server.
addons._guildSetup = addon.new("guildSetup")
addons._commands = addon.new("commands")
addons._permissions = addon.new("permissions")
addons._config = addon.new("config")
addons.basic = addon.new("basic")
addons.rolesStay = addon.new("rolesStay")

-- For fetching stuff in here, just in case:
function get(p)
  if p == "addon" then return addon end
end

-- BOT EVENTS
client:on("ready", function()
  print("Initialising...")
  for guild in client.guilds do
    addon.load(addons._guildSetup, "main", {client=client, files=files, guild=guild})
  end
  files.database:saveFromTable()
  print("Initialising finished.")
end)

client:on("memberJoin", function(member)
  local pack = {client=client, member=member, files=files, addons=addons, get=get}
  for name, guildAddon in pairs(files.database.table[member.guild.id].addons) do
    pack.addon = guildAddon
    addon.load(addons[name], "event_memberJoin", pack)
  end
  files.database:saveFromTable()
  files.config:saveFromTable()
end)

client:on("memberLeave", function(member)
  local pack = {client=client, member=member, files=files, addons=addons, get=get}
  for name, guildAddon in pairs(files.database.table[member.guild.id].addons) do
    pack.addon = guildAddon
    addon.load(addons[name], "event_memberLeave", pack)
  end
  files.database:saveFromTable()
  files.config:saveFromTable()
end)

-- MESSAGE EVENTS

client:on("messageCreate", function(message)
  local database = files.database.table
  local dataGuild
  if message.guild then dataGuild = database[message.guild.id] end
  local pack = {message=message, files=files}
  local permissions = addon.load(addons._permissions, "globalCheck", pack) or {}
  local command = addon.load(addons._commands, "globalCheck", pack)

  if command.name then
    -- Printing
    local toprint, print_p = "", ""
    for i, v in pairs(permissions) do print_p = print_p .. i .. ", " end
    print_p = print_p:sub(1, #print_p-2)
    toprint = message.author.username .. " (" .. print_p .. "): " .. command.name
    if command.argContent then toprint = toprint .. " (args: " .. command.argContent .. ")" end
    if toprint ~= "" then print(toprint) end

    -- Executing command
    if dataGuild then
      local location = dataGuild.commands[command.name]
      if location and addons[location.addon] and dataGuild.addons[location.addon] then
        local pack = {client=client, message=message, permissions=permissions, command=command, files=files, addon=dataGuild.addons[location.addon], addons=addons, get=get}
        addon.load(addons[location.addon], "cmd_" .. location.name, pack)
      end
    end

    -- Executing addons' messageCreate event
    if dataGuild then
      local pack = {client=client, message=message, permissions=permissions, files=files, addons=addons, get=get}
      for name, guildAddon in pairs(dataGuild.addons) do
        pack.addon = guildAddon
        addon.load(addons[name], "event_messageCreate", pack)
      end
    end

    files.database:saveFromTable()
    files.config:saveFromTable()
  end
end)

-- Automated events:

local events = {
  ready = {},
  resumed = {"shardID"},
  userUpdate = {"user"},
  guildAvailable = {"guild"},
  guildCreateUnavailable = {"guild"},
  guildCreate = {"guild"},
  guildUpdate = {"guild"},
  guildUnavailable = {"guild"},
  guildDelete = {"guild"},
  emojisUpdate = {"guild"},
  channelCreate = {"channel"},
  channelUpdate = {"channel"},
  channelDelete = {"channel"},
  typingStart = {"user", "channel", "timestamp"},
  typingStartUncached = {"data"},
  voiceChannelJoin = {"member", "channel"},
  voiceChannelLeave = {"member", "channel"},
  userBan = {"user", "guild"},
  userUnban = {"user", "guild"},
  memberJoin = {"member"},
  memberLeave = {"member"},
  memberUpdate = {"member"},
  presenceUpdate = {"member"},
  voiceConnect = {"member", "mute", "deaf"},
  voiceDisconnect = {"member", "mute", "deaf"},
  voiceUpdate = {"member", "mute", "deaf"},
  roleCreate = {"role"},
  roleUpdate = {"role"},
  roleDelete = {"role"},
  messageCreate = {"message"},
  messageUpdate = {"message"},
  messageUpdateUncached = {"channel", "messageID"},
  messageDelete = {"message"},
  reactionAdd = {"reaction", "user"},
  reactionAddUncached = {"data"},
  reactionRemove = {"reaction", "user"},
  reactionRemoveUncached = {"data"}
}

for eventName, eventArgs in pairs(events) do
  client:on(eventName, function(...)
    local args = {...}
    local pack = {client=client, files=files, addons=addons, get=get}
    for i, v in pairs(args) do
      pack[eventArgs[i]] = v
    end
    for addonName, addon in pairs(addons) do
      addon.load(addon, "event_" .. eventName, pack)
    end
  end)
end

client:run(files.config.table.token)
