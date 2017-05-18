local http = require("https")

local get = {}

function get.new(info)
  local req
  req = http.request(info.url, function(res)
    --p("on_connect", {status_code = res.status_code, headers = res.headers})
    res:on('data', function (chunk)
      info.data(chunk)
    end)
    res:on("end", function ()
      info.ended()
    end)
    req:on("error", function(e)
      p("Error: "..e)
    end)
  end)
  req:done()
end

return get
