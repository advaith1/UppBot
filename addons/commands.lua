local cmd = {}

local file = require("../libs/file.lua")

-- Files
local files = {
  config = file.load("./UppBot/data/config.txt")
}

function cmd.globalCheck(args)
  local message = args[1]
  files.config = file.load("./UppBot/data/config.txt")
  local config = files.config:toTable()
  local command = {}
  for i, v in pairs(config.prefixes) do
    if v == message.cleanContent:sub(1, #v) then
      command.name = message.cleanContent:sub(#v+1, message.cleanContent:find("%s")-1)
      break
    end
  end
  return command
end

cmd.name = "commands"

return cmd
