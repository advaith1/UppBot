function main(message, args)
  message.channel:sendMessage(message.author.mentionString.." pong!")
end

return main
