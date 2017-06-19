local basic = {}
basic.name = "activityBoard"
basic.desc = "Counts the amount of letters sent from the past 7 days for each user."

function basic.event_added(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  local cmdName = "board"
  if not dataGuild.commands[cmdName] then
    dataGuild.commands[cmdName] = {addon=basic.name, name="main"}
  end
  message.channel:sendMessage("Activity now being measured!")
end

function basic.event_removed(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  local cmdName = "board"
  if dataGuild.commands[cmdName] and dataGuild.commands[cmdName].addon == basic.name then
    dataGuild.commands[cmdName] = nil
  end
end

function basic.cmd_main(pack)
  local message = pack.message
  local member = message.member
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  local dataSpace = dataGuild.addons[basic.name]
  local currentTime = os.time()
  local board = {}
  local maxUsernameLength = 0
  local memberCount = 0
  for member in message.guild.members do
    memberCount = memberCount + 1
    board[member.username] = {}
    board[member.username].letters = 0
    board[member.username].messages = 0
    if #member.username > maxUsernameLength then maxUsernameLength = #member.username end
    local memberInfo = dataSpace[member.id]
    for i, v in pairs(memberInfo) do
      if currentTime - v.time >= 604800 then
        memberInfo[i] = nil
      else
        board[member.username].letters = board[member.username].letters + v.length
        board[member.username].messages = board[member.username].messages + 1
      end
    end
  end

  local toSend = "```"
  local wentThrough = 0
  while #board ~= 0 do
    local highestLetters = -1
    local chosen = nil
    for i, v in pairs(board) do
      if v.letters > highestLetters then
        highestLetters = v.letters
        chosen = i
        board[i] = nil
      end
    end
    if chosen then
      wentThrough = wentThrough + 1
      local addTo = string.rep(" ", #tostring(memberCount)-#tostring(wentThrough)) .. wentThrough .. " | " .. chosen .. " " .. string.rep("-", maxUsernameLength-#chosen) .. " " .. highestLetters .. "\n"
      toSend = toSend .. addTo
    else
      break
    end
  end
  toSend = toSend .. "```"
  message.channel:sendMessage(toSend)
end

function basic.event_messageCreate(pack)
  local message = pack.message
  local files = pack.files
  local dataGuild = files.database.table[message.guild.id]
  if not dataGuild.addons[basic.name] then return end
  if dataGuild.addons[basic.name] == nil then dataGuild.addons[basic.name] = {} end
  local dataSpace = dataGuild.addons[basic.name]
  local t = os.time()
  local length = #message.cleanContent
  p(t, length)
  if dataSpace[message.author.id] == nil then dataSpace[message.author.id] = {} end
  table.insert(dataSpace[message.author.id], {time=t, length=length})
end

return basic
