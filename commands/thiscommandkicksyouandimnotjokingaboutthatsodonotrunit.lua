function thiscommandkicksyouandimnotjokingaboutthatsodonotrunit(message, args)
  message.author:sendMessage"Here's an invite link back to Click Converse: https://discord.gg/kduHDNE"
  message.author:kick(message.guild)
  message:delete()
end

return thiscommandkicksyouandimnotjokingaboutthatsodonotrunit
