local file = require("../libs/file.lua")
local cutter = require("../libs/cutter.lua")

local files = {
  commands = file.load("./UppBot/data/commands.txt"),
}

local commands = files.commands:toTable()

function GetCommands(message, lookthrough)
  local fields = {}
  for name, command in pairs(lookthrough) do
    local canDo = false
    if command.roles == nil then
      for i, v in pairs(commands) do
        if i == command then
          name = i
          command = v
          break
        end
      end
    end
    if command.roles == nil or #command.roles == 0 then
      canDo = true
    end
    if message.guild ~= nil then
      for _, roleName in pairs(command.roles) do
        if canDo == true then break end
        for role in message.member.roles do
          if role.name == roleName then
            canDo = true
            break
          end
        end
      end
    end
    if message.guild == nil and command.type == "guild" then canDo = false end
    if message.guild ~= nil and command.type == "priv" then canDo = false end
    if canDo == true then
      table.insert(fields, {name=name, value=command.desc.." (args: "..command.args..")", inline=false})
    end
  end
  local messageToSend = {}
  if #fields > 0 then
    messageToSend.embed = {title="Commands: ", fields=fields}
  end
  message.author:sendMessage(messageToSend)
end

function main(message, args)
  if #args > 0 and args[1] ~= "" then
    GetCommands(message, args)
  else
    GetCommands(message, commands)
  end
end

return main
