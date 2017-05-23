function rule(message, args)
  args[1] = tonumber(args[1])
  local ruleToSend
  if args[1] == 1 then
    ruleToSend = "Don't use swear words nor discuss non G-rated topics; keep it family friendly. Excessive use will be warned and / or banned temporarily / permanently."
  elseif args[1] == "swearing" then
    ruleToSend = "Don't use swear words nor discuss non G-rated topics; keep it family friendly. Excessive use will be warned and / or banned temporarily / permanently."
  elseif args[1] == 2 then
    ruleToSend = "Don't spam text or images. This will be warned but can result in a mute. (Spamming the same text, same images, three big images in a row, having a lot of new lines in a message, posting too much invitation links, etc)"
  elseif args[1] == "spamming" then
    ruleToSend = "Don't spam text or images. This will be warned but can result in a mute. (Spamming the same text, same images, three big images in a row, having a lot of new lines in a message, posting too much invitation links, etc)"
  elseif args[1] == 3 then
    ruleToSend = "Use the #help channel for help with Fusion, as the #converse channel might be full of conversation."
  elseif args[1] == "help" then
    ruleToSend = "Use the #help channel for help with Fusion, as the #converse channel might be full of conversation."
  elseif args[1] == 4 then
    ruleToSend = "Respect other members, moderators and staff. Do not troll. Critique is acceptable, personal attacks aren't and are punishable by a kick and even a ban."
  elseif args[1] == "respect" then
    ruleToSend = "Respect other members, moderators and staff. Do not troll. Critique is acceptable, personal attacks aren't and are punishable by a kick and even a ban."
  elseif args[1] == 5 then
    ruleToSend = "Posting links to viruses / things that break these rules will be removed, and possibly banned depending on the rules broken."
  elseif args[1] == "links" then
    ruleToSend = "Posting links to viruses / things that break these rules will be removed, and possibly banned depending on the rules broken."
  elseif args[1] == 6 then
    ruleToSend = "Ban evading is prohibited, alt accounts will also be banned."
  elseif args[1] == "alts" then
    ruleToSend = "Ban evading is prohibited, alt accounts will also be banned."
  elseif args[1] == 7 then
    ruleToSend = "For ease of moderation, please talk in English only."
  elseif args[1] == "english" then
    ruleToSend = "For ease of moderation, please talk in English only."
  else
    message.channel:sendMessage("I wasn't able to find that rule! Sorry.")
    return
  end
  message.channel:sendMessage("Rule #" .. tostring(args[1]) .. ":\n" .. ruleToSend)
end

return rule
