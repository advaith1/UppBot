local botConfig = {}
botConfig.name = "permissions"
botConfig.desc = "Main permissions - Global addon"

--[[
  Permissions:
    Check permissions of a member, varies in different servers. Member's roles and channel can change its permissions.

    How it works example:
      All permissions are checked whether or not they include:
       - Member
       - Member's Roles
       - The channel id the message was sent
      If they do, they get returned.
      Server owner has all permissions no matter what.

    It is up to the addons/commands how they use these permissions, they can be used in these:
      - if (not) authorPermissions.permission_name_here then ... end   -> every command automatically gets message's author permissions in one of their parameters.
      - permissions.getPerms(member)   -> Returns permissions list for particular member. (Excluding channel permissions)
      - permissions.getRolePerms(role)   -> Returns permissions list for particular role.
      - permissions.getChanPerms(channel)   -> Returns permissions list for particular channel.

]]

function botConfig.globalCheck(pack)
  local message = pack.message
  local files = pack.files
  local database = files.database.table
  if message.member == nil then return end
  if message.guild == nil then return end
  local dataGuild = database[message.guild.id]
  local permissions = {}
  local save = false
  if not dataGuild.permissions then dataGuild.permissions = {} save = true end
  if not dataGuild.permissions.admin then dataGuild.permissions.admin = {roleIDs = {}, memberIDs = {}, channelIDs = {}, desc = "Used to configure the bot and bypass other permissions."} save = true end
  local adminRole
  for i, v in pairs(dataGuild.permissions.admin.roleIDs) do
    local role = message.guild:getRole(v)
    if role then
      adminRole = role
      break
    end
  end
  if not adminRole then
    adminRole = message.guild:getRole("name", "Click Bot Admin Temp") or message.guild:createRole("Click Bot Admin Temp")
    if adminRole then
      table.insert(dataGuild.permissions.admin.roleIDs, adminRole.id)
      save = true
    end
  end
  if save then
    if adminRole then
      message.channel:sendMessage("This server doesn't have permission roles set up, making temporary admin role (This appears first setup)".."\n".."Anyone with "..adminRole.mentionString.." will have Admin permissions. All permissions can be changed by Admins.".."\n".."The Owner of the server has all permissions.")
    end
  end
  if message.member == message.guild.owner then return dataGuild.permissions end
  for permName, perm in pairs(dataGuild.permissions) do
    local has = false
    -- Checking individual members
    for _, memberID in pairs(perm.memberIDs) do
      if memberID == message.member.id then
        has = true
        break
      end
    end
    -- Checking member's roles
    for _, roleID in pairs(perm.roleIDs) do
      local localbreak = false
      if localbreak then break end
      for role in message.member.roles do
        if role.id == roleID then
          has = true
          localbreak = true
          break
        end
      end
    end
    -- Checking channel used to send message
    for _, channelID in pairs(perm.channelIDs) do
      if channelID == message.channel.id then
        has = true
        break
      end
    end
    if has then
      permissions[permName] = perm
    end
  end
  return permissions
end

function botConfig.getMessagePerms(message, database)
  if message.member == nil then return end
  if message.guild == nil then return end
  local dataGuild = database[message.guild.id]
  local permissions = {}
  if message.member == message.guild.owner then return dataGuild.permissions end
  for permName, perm in pairs(dataGuild.permissions) do
    local has = false
    -- Checking individual members
    for _, memberID in pairs(perm.memberIDs) do
      if memberID == message.member.id then
        has = true
        break
      end
    end
    -- Checking member's roles
    for _, roleID in pairs(perm.roleIDs) do
      local localbreak = false
      if localbreak then break end
      for role in message.member.roles do
        if role.id == roleID then
          has = true
          localbreak = true
          break
        end
      end
    end
    -- Checking channel used to send message
    for _, channelID in pairs(perm.channelIDs) do
      if channelID == message.channel.id then
        has = true
        break
      end
    end
    if has then
      permissions[permName] = perm
    end
  end
  return permissions
end

function botConfig.getPerms(member, database)
  local permissions = {}
  local dataGuild = database[member.guild.id]
  if member == member.guild.owner then return dataGuild.permissions end
  for permName, perm in pairs(dataGuild.permissions) do
    local has = false
    -- Checking individual members
    for _, memberID in pairs(perm.memberIDs) do
      if memberID == member.id then
        has = true
        break
      end
    end
    -- Checking member's roles
    for _, roleID in pairs(perm.roleIDs) do
      local localbreak = false
      if localbreak then break end
      for role in member.roles do
        if role.id == roleID then
          has = true
          localbreak = true
          break
        end
      end
    end
    if has then
      permissions[permName] = perm
    end
  end
  return permissions
end

function botConfig.getRolePerms(role, database)
  local permissions = {}
  local dataGuild = database[role.guild.id]
  for permName, perm in pairs(dataGuild.permissions) do
    for _, roleID in pairs(perm.roleIDs) do
      if roleID == role.id then
        permissions[permName] = perm
        break
      end
    end
  end
  return permissions
end

function botConfig.getChannelPerms(channel, database)
  local permissions = {}
  local dataGuild = database[channel.guild.id]
  for permName, perm in pairs(dataGuild.permissions) do
    for _, channelID in pairs(perm.channelIDs) do
      if channelID == channel.id then
        permissions[permName] = perm
        break
      end
    end
  end
  return permissions
end

function botConfig.returner()
  local re = {}
  re.getChannelPerms = botConfig.getChannelPerms
  re.getRolePerms = botConfig.getRolePerms
  re.getMemberPerms = botConfig.getPerms
  re.getMessagePerms = botConfig.getMessagePerms
  return re
end

return botConfig
