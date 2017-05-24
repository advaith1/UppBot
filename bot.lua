-- Important libraries
local discordia = require('discordia') -- Cool Discord API library
local client = discordia.Client()
local file = require("./libs/file.lua") -- Cool file reader and lua table converter thing I wrote
local addon = require("./libs/addons.lua")

-- Files
local files = {
  database = file.load("./UppBot/data/database.txt"),
  config = file.load("./UppBot/data/config.txt")
}
-- File Tables
local database = files.database:toTable()
local config = files.config:toTable()

-- Addons:
local addons = { }
addons.guildSetup = addon.new("guildSetup")
addons.commands = addon.new("commands")
addons.permissions = addon.new("permissions")

client:on("ready", function()
  print("Initialising...")
  addon.load(addons.guildSetup, "main", client)
  print("Initialising finished.")
end)

client:on("messageCreate", function(message)
  local permissions = addon.load(addons.permissions, "globalCheck", message) or {} -- Permissions
  local command = addon.load(addons.commands, "globalCheck", message) -- Commands
  p(permissions, command)
end)

client:run(config.token)
