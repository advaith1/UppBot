--Libs and stuff
local http = require("./libs/get.lua")
local file = require("./libs/file.lua")
local timer = require("timer")

print("Starting up...")

--Files
local files = {
  config = file.load("./UppBot/data/config.txt")
}

--File Tables
local config = files.config:toTable()

print("Version: "..config.version)
print("Checking updates...")

local fetchedVersion = ""

function init4() --Running
  require("./"..config.toRun..".lua")
end

function init3() --Updating
  print("Updating not yet implemented, skipping for now")
  init4() --I don't know how to make updating for now, welp
end

function init2() --Checking if to update
  fetchedVersion = tonumber(fetchedVersion)
  --p("Latest version is '"..fetchedVersion.."', current version is '"..config.version.."'")
  if fetchedVersion ~= nil and fetchedVersion > tonumber(config.version) then
    local behind = fetchedVersion - tonumber(config.version)
    local text = ""
    if behind == 1 then text = "An update behind, " else text = behind.." updates behind, " end
    print(text.."getting latest update...")
    init3()
  elseif fetchedVersion ~= nil and fetchedVersion <= tonumber(config.version) then
    print("Up to date.")
    init4()
  elseif fetchedVersion == nil then
    print("Error: Was not able to get latest version, skipping...")
    init4()
  end
end

function getVersion()
  http.new({
    url = config.versionURL,
    data = function(chunk) fetchedVersion = fetchedVersion..chunk end,
  ended = function() init2() end
  })
end

if config.update == "true" then
  print("If you don't want to check for updates, change 'update' in data/config.txt to false.")
  getVersion()
  config.update = "true-nonotify"
elseif config.update == "true-nonotify" then
  getVersion()
elseif config.update == "false" then
  print("Updates are disabled, if you want them again change 'update' in data/config.txt to true")
  config.update = "false-nonotify"
end

files.config:saveFromTable(config)
