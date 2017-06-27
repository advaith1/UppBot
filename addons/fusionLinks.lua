local basic = {}
basic.name = "fusionLinks"
basic.desc = "Adds a few commands to links for Fusion"

function basic.event_added(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  local cmdName = "extlist"
  local cmdName = "shaders"
  if not dataGuild.commands[cmdName] then
    dataGuild.commands[cmdName] = {addon="fusionLinks", name="extlist"}
    dataGuild.commands[cmdName] = {addon="fusionLinks", name="shaders"}
  end
end

function basic.event_removed(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  local cmdName = "extlist"
  if dataGuild.commands[cmdName] and dataGuild.commands[cmdName].addon == "fusionLinks" then
    dataGuild.commands[cmdName] = nil
  local cmdName = "shaders"
  if dataGuild.commands[cmdName] and dataGuild.commands[cmdName].addon == "fusionLinks" then
    dataGuild.commands[cmdName] = nil
  end
end

function basic.cmd_extlist(pack)
  local message = pack.message
  message.channel:sendMessage("Darkwire Extension List: https://dark-wire.com/store/extlist.php\nOfficial Clickteam Extension Manager List: https://www.clickteam.com/cem\nClickWiki Extension List: https://clickwiki.net/wiki/Extensions#Extension_List")
end

function basic.cmd_shaders(pack)
  local message = pack.message
  message.channel:sendMessage("ClickStore Shaders page: http://clickstore.clickteam.com/libraries/shaders\nPhi's Shader List: https://sites.google.com/site/mmf2stuff/shaders")
end

return basic
