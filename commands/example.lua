local file = require("../libs/file.lua")
local cutter = require("../libs/cutter.lua")
local http = require('http')

function newEmbed(title, url, source)
  local embed = {
    type = "rich",
    --description = "Description here",
    url = url,
    title = title,
    --timestamp = date,
    color = 44*256*256 + 119*256 + 226,
    --fields={ {name="eh", value="double eh", inline=true}, {name="triple", value="quad", inline=true} },
    --thumbnail={url="url here, no pngs"},
    footer={ text="Source: "..source }
  }
  return embed
end



function main(message, args)
  local examples = file.load("./UppBot/data/examples.txt"):toTable()
  local scmd = {}
  for v in message.content:gmatch("%S+") do
    table.insert(scmd, v)
  end
  table.remove(scmd, 1)
  p(scmd)
  local accepted_search = {}
  for o, p in pairs(scmd) do
    if #accepted_search == 0 then
      for i, v in pairs(examples) do
        local find = i:lower():find(p:lower(),1,true)
        if find ~= nil then
          table.insert(accepted_search, i)
        end
      end
    else
      for i, v in pairs(accepted_search) do
        local find = v:lower():find(p:lower(),1,true)
        if find == nil then
          accepted_search[i] = nil
        end
      end
    end
  end
  if #accepted_search > 4 then
    local toSend = "```"
    for i, v in pairs(accepted_search) do
      toSend = toSend .. v.." -> "..examples[v].link.."\n"
    end
    toSend = toSend .. "```"
    message.author:sendMessage("Search results: \n"..toSend)
    message.channel:sendMessage("Too many results, results have been private messaged.")
    return
  end
  local amountofEx = 0
  for i, v in pairs(accepted_search) do
    amountofEx = amountofEx + 1
    local picked = examples[v]
    message.channel:sendMessage( {embed=newEmbed(v, picked.link, "http://www.castles-of-britain.com/mmf2examples.htm")})
  end
  if amountofEx == 0 then
    message.channel:sendMessage("No examples have been found based on these keywords.")
  end
end

return main
