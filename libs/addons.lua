local file = require("./file.lua")

local addons = {}

function errHandler( err )
   print( "ERROR:", err )
end

function addons.new(parent)
  local addon, err = pcall(require, "../addons/"..parent..".lua")
  if not addon then
    print("WARNING: '"..parent.."' addon did not load correctly, taking a look might be worthy.")
    print("ERROR: "..err)
    print("ERROR END")
  else
    addon = require("../addons/"..parent..".lua")
  end
  return addon
end

function addons.load(addon, sub, ...)
  if addon == nil then return nil end
  if addon[sub] == nil then return nil end
  local args = {...}
  local status, err = pcall(addon[sub], args)
  if not status then
    local addonName = addon.name or "UNKNOWN"
    print("WARNING: '"..sub.."' in '"..addonName.."' did not load correctly, taking a look might be worthy.")
    print("ERROR: "..err)
    print("ERROR END, '"..addonName.."' will be disabled.")
    addons[addon] = nil
    return nil
  else
    return err
  end
end

return addons
