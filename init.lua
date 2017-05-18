--Libs and stuff
local http = require("./libs/get.lua")
local file = require("./libs/file.lua")
local discordia = require('discordia')
local client = discordia.Client()

print("Starting UppBot...")

local config = file.load("./UppBot/data/config.txt")
config = config:toTable()
print("Getting latest version number from "..config.versionURL.."...")

function init2()
  fetchedVersion = tonumber(fetchedVersion)
  p(fetchedVersion)
end

local fetchedVersion = ""
http.new({
  url = config.versionURL,
  data = function(chunk) fetchedVersion = fetchedVersion..chunk end,
ended = function() init2() end
})

client:run(config.token)
