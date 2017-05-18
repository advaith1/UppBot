--Libs and stuff
local http = require("./libs/get.lua")
local file = require("./libs/file.lua")

print("Starting UppBot...")

local config = file.load("./data/config.txt")
print(config.content)
config:toTable()
print(config)

print("Getting latest version number...")

--local ver_num = http.new(config.versionURL)
