local http = require("http")

local get = {}

function get.new(url)
  local req = http.request(url, function(res)
      local str = ""
      --p("on_connect", {status_code = res.status_code, headers = res.headers})
      res:on('data', function (chunk)
        --p("on_data", #chunk)
        str = str..chunk
      end)
      res:on("end", function ()
        print(str)
        return str
      end)
    end)

    req:done()
end

return get
