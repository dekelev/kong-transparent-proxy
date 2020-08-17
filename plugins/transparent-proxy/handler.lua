local BasePlugin = require "kong.plugins.base_plugin"

local TransparentProxyHandler = BasePlugin:extend()


TransparentProxyHandler.PRIORITY = 2
TransparentProxyHandler.VERSION = "1.0.0"


function TransparentProxyHandler:new()
  TransparentProxyHandler.super.new(self, "transparent-proxy")
end


function TransparentProxyHandler:access(conf)
  TransparentProxyHandler.super.access(self)

  local host_parts = split(kong.request.get_header(conf.host_request_header), ":")
  local host, port

  for key, value in pairs(host_parts) do
    if key == 1 then
      host = value
    elseif key == 2 then
      port = value
    end
  end

  if port == nil then
    port = 80
  end

  ngx.var.upstream_host = host
  ngx.ctx.balancer_address.host = host
  ngx.ctx.balancer_address.port = port

  kong.log.debug("[transparent-proxy plugin] Forwarding request to " .. ngx.ctx.balancer_address.scheme .. "://" .. ngx.ctx.balancer_address.host .. ":" .. ngx.ctx.balancer_address.port .. ngx.var.request_uri)
end

function split(s, delimiter)
  local result = {}
  for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

return TransparentProxyHandler
