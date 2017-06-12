local basic = {}
basic.name = "fusionLinks"
basic.desc = "Adds a few commands to links for Fusion"

function basic.event_added(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if not dataGuild.commands.extlist then
    dataGuild.commands.extlist = {addon="fusionLinks", name="extlist"}
  end
end

function basic.event_removed(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if dataGuild.commands.extlist and dataGuild.commands.extlist.addon == "fusionLinks" then
    dataGuild.commands.extlist = nil
  end
end

function basic.cmd_extlist(pack)
  local message = pack.message
  message.channel:sendMessage("Darkwire Extension List: \https://dark-wire.com/store/extlist.php\nOfficial Clickteam Extension Manager List: \https://www.clickteam.com/cem\nClickWiki Extension List: \https://clickwiki.net/wiki/Extensions#Extension_List")
end

return basic
