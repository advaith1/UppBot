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

-- Addons:
local addons = { } -- Addons with _ at the beginning of their name are global addons and they cannot be added or removed from a server.
addons._guildSetup = addon.new("guildSetup")
addons._commands = addon.new("commands")
addons._permissions = addon.new("permissions")
addons.config = addon.new("config")
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
    local dataGuild = files.database.table[guild.id]
    local pack = {client=client, files=files, guild=guild, addons=addons, get=get}
    for name, guildAddon in pairs(dataGuild.addons) do
      pack.addon = guildAddon
      addon.load(addons[name], "event_ready", pack)
    end
  end
  files.database:saveFromTable()
  print("Initialising finished.")
end)

client:on("resumed", function(shardID)

end)

client:on("userUpdate", function(user)

end)

-- GUILD EVENTS

client:on("guildAvailable", function(guild)

end)

client:on("guildCreateUnavailable", function(guild)

end)

client:on("guildCreate", function(guild)

end)

client:on("guildUpdate", function(guild)

end)

client:on("guildUnavailable", function(guild)

end)

client:on("guildDelete", function(guild)

end)

client:on("emojisUpdate", function(guild)

end)

-- CHANNEL EVENTS

client:on("channelCreate", function(channel)

end)

client:on("channelUpdate", function(channel)

end)

client:on("channelDelete", function(channel)

end)

client:on("typingStart", function(user, channel, timestamp)

end)

client:on("typingStartUncached", function(data)

end)

client:on("voiceChannelJoin", function(member, channel)

end)

client:on("voiceChannelLeave", function(member, channel)

end)

-- USER EVENTS

client:on("userBan", function(user, guild)

end)

client:on("userUnban", function(user, guild)

end)

-- MEMBER EVENTS

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

client:on("memberUpdate", function(member)

end)

client:on("presenceUpdate", function(member)

end)

client:on("voiceConnect", function(member, mute, deaf)

end)

client:on("voiceDisconnect", function(member, mute, deaf)

end)

client:on("voiceUpdate", function(member, mute, deaf)

end)

-- ROLE EVENTS

client:on("roleCreate", function(role)

end)

client:on("roleUpdate", function(role)

end)

client:on("roleDelete", function(role)

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
        addon.load(addons[location.addon], location.name, pack)
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

client:on("messageUpdate", function(message)

end)

client:on("messageUpdateUncached", function(channel, messageID)

end)

client:on("messageDelete", function(message)

end)

-- REACTION EVENTS

client:on("reactionAdd", function(reaction, user)

end)

client:on("reactionAddUncached", function(data)

end)

client:on("reactionRemove", function(reaction, user)

end)

client:on("reactionAddUncached", function(data)

end)

client:run(files.config.table.token)
