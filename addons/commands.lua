local cmd = {}
cmd.name = "commands"
cmd.desc = "Main commands - Global addon"

function cmd.globalCheck(pack)
  local message = pack.message
  local files = pack.files
  local config = files.config.table
  local command = {}
  if message.content == nil then return command end
  for i, v in pairs(config.prefixes) do
    if v == message.content:sub(1, #v) then
      local space = message.content:find("%s")
      if space then
        command.name = message.content:sub(#v+1, space-1)
        command.argContent = message.content:sub(space+1):trim()
        command.spaces = command.argContent:split(" ")
        command.list = command.argContent:split(", ")
        break
      else
        command.name = message.content:sub(#v+1)
        break
      end
    end
  end
  return command
end

return cmd
