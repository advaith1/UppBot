local rolesStay = {}
rolesStay.name = "rolesStay"
rolesStay.desc = "Gives back users' roles when they join back the server"

function rolesStay.event_memberJoin(pack)
  local files = pack.files
  local member = pack.member
  local data = files.database.table[member.guild.id].addons.rolesStay
  if data[member.id] then
    for i, v in pairs(data[member.id]) do
      member:addRole(member.guild:getRole(v))
    end
  end
end

function rolesStay.event_memberLeave(pack)
  local files = pack.files
  local member = pack.member
  local data = files.database.table[member.guild.id].addons.rolesStay
  data[member.id] = {}
  for role in member.roles do
    table.insert(data[member.id], role.id)
  end
end

return rolesStay
