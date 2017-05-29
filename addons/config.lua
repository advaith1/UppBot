local serverConfig = {}
serverConfig.name = "config"
serverConfig.desc = "Master addon (DO NOT REMOVE)"

function changePermissions(message, command, files)
  local dataGuild = files.database.table[message.guild.id]
  if command.spaces[2] == "new" then
    if command.spaces[3] ~= "admin" then dataGuild.permissions[command.spaces[3]] = {roleIDs={}, channelIDs={}, memberIDs={}} end
    message.channel:sendMessage("Permission has been created.")
    files.database:saveFromTable()
  end
  if command.spaces[2] == "delete" then
    if command.spaces[3] ~= "admin" then dataGuild.permissions[command.spaces[3]] = nil end
    message.channel:sendMessage("Permission has been removed.")
    files.database:saveFromTable()
  end
  if command.spaces[2] == "add" then
    if not dataGuild.permissions[command.spaces[3]] then dataGuild.permissions[command.spaces[3]] = {roleIDs={}, channelIDs={}, memberIDs={}} end
    for role in message.mentionedRoles do
      table.insert(dataGuild.permissions[command.spaces[3]].roleIDs, role.id)
    end
    for user in message.mentionedUsers do
      table.insert(dataGuild.permissions[command.spaces[3]].memberIDs, user.id)
    end
    for channel in message.mentionedChannels do
      table.insert(dataGuild.permissions[command.spaces[3]].channelIDs, channel.id)
    end
    message.channel:sendMessage("Permissions have been updated.")
    files.database:saveFromTable()
  end
  if command.spaces[2] == "remove" then
    if not dataGuild.permissions[command.spaces[3]] then dataGuild.permissions[command.spaces[3]] = {roleIDs={}, channelIDs={}, memberIDs={}} end
    for role in message.mentionedRoles do
      for i, v in pairs(dataGuild.permissions[command.spaces[3]].roleIDs) do
        if v == role.id then
          table.remove(dataGuild.permissions[command.spaces[3]].roleIDs, i)
        end
      end
    end
    for user in message.mentionedUsers do
      for i, v in pairs(dataGuild.permissions[command.spaces[3]].memberIDs) do
        if v == user.id then
          table.remove(dataGuild.permissions[command.spaces[3]].memberIDs, i)
        end
      end
    end
    for channel in message.mentionedChannels do
      for i, v in pairs(dataGuild.permissions[command.spaces[3]].channelIDs) do
        if v == channel.id then
          table.remove(dataGuild.permissions[command.spaces[3]].channelIDs, i)
        end
      end
    end
    message.channel:sendMessage("Permissions have been updated.")
    files.database:saveFromTable()
  end
end

function changeAddons(message, command, files, addons, get)
  local dataGuild = files.database.table[message.guild.id]
  if command.spaces[2] == "add" then
    if command.spaces[3]:sub(1, 2) ~= "_" then
      if addons[command.spaces[3]] then
        dataGuild.addons[command.spaces[3]] = {}
        message.channel:sendMessage("'" .. command.spaces[3] .. "' addon has been added.")
        get("addon").load(addons[command.spaces[3]], "event_added", {message=message, command=command, files=files, addons=addons, get=get})
        files.database:saveFromTable()
      end
    end
  end
  if command.spaces[2] == "remove" then
    if command.spaces[3]:sub(1, 2) ~= "_" then
      if addons[command.spaces[3]] then
        get("addon").load(addons[command.spaces[3]], "event_removed", {message=message, command=command, files=files, addons=addons, get=get})
        dataGuild.addons[command.spaces[3]] = nil
        message.channel:sendMessage("'" .. command.spaces[3] .. "' addon has been removed.")
        files.database:saveFromTable()
      end
    end
  end
  if not command.spaces[2] then
    local msg = {}
    msg.embed = {}
    msg.embed.description = ""
    msg.embed.title = "Server Addons: "
    for i, v in pairs(dataGuild.addons) do
      local addonDesc = " - " .. addons[i].desc or ""
      msg.embed.description = msg.embed.description .. i .. addonDesc .. "\n"
    end
    message.channel:sendMessage(msg)
  end
end

function serverConfig.cmd_main(pack)
  local client = pack.client
  local message = pack.message
  local permissions = pack.permissions
  local command = pack.command
  local files = pack.files
  local addons = pack.addons
  local get = pack.get
  if not permissions.admin then return end
  if command.spaces[1] == "permissions" then changePermissions(message, command, files, get) end
  if command.spaces[1] == "addons" then changeAddons(message, command, files, addons, get) end
end

return serverConfig
