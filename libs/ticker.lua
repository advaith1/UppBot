local timer = require("timer")
local ticker = {}
ticker.ticks = 0

local tickList = {}
function ticker.addTickEvent(event, every)
  table.insert(tickList,{every=every,current=0,event=event})
end

function tick()
  ticker.ticks = ticker.ticks + 1
  for i, v in pairs(tickList) do
    v.current = v.current + 1
    if v.current == v.every then
      v.current = 0
      v.event()
    end
  end
  timer.setTimeout(1000, tick)
end

timer.setTimeout(1000, tick)

return ticker
