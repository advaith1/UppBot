--Libs and stuff
local http = require("./libs/get.lua")
local file = require("./libs/file.lua")
local timer = require("timer")

print("Starting up...")

--Files
local files = {
  config = file.loadWithTable("./UppBot/data/config.txt")
}

if files.config.table == nil then
  files.config.table = {
    prefixes={
      "."
    },
    toRun="bot",
    absoluteDir="/home/pi/Luvit/UppBot/",
    update="true",
    token="Insert your bot token here"
  }
  files.config:saveFromTable()
  print("A new Config file has been created in UppBot/data/config.txt, please change the token to your own and restart this.")
  return
end

--File Tables
local config = files.config:toTable()

function init3() --Running
  require("./"..config.toRun..".lua")
end

function init2() -- Git check update and add onto update
  local handle = io.popen("cd " .. config.absoluteDir .. " \n git pull")
  local result = handle:read("*a")
  handle:close()
  print(result)
  init3() -- Run bot
end

if config.update == "true" then
  print("Checking updates...")
  print("If you don't want to check for updates, change 'update' in data/config.txt to false.")
  init2()
  config.update = "true-nonotify"
elseif config.update == "true-nonotify" then
  print("Checking updates...")
  init2()
elseif config.update == "false" then
  print("Updates are disabled, if you want them again change 'update' in data/config.txt to true")
  config.update = "false-nonotify"
end

files.config:saveFromTable(config)
