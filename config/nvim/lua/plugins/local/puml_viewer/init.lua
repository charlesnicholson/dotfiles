-- plantuml_viewer/init.lua
--
-- A 100% Lua, cross-platform Neovim plugin to visualize PlantUML diagrams.
--
-- This single file contains:
-- 1. A PlantUML URL encoder.
-- 2. A complete, asynchronous HTTP and WebSocket server built on Neovim's `vim.loop`.
-- 3. The client-side HTML and JavaScript, embedded as a string.
-- 4. The Neovim autocommand to trigger updates on save.
--
-- No Python, no curl, no external dependencies.

-- =============================================================================
-- SECTION: Configuration
-- =============================================================================
local config = {
  http_port = 8764,
  websocket_port = 8765,
  host = "127.0.0.1",
}

-- =============================================================================
-- SECTION: LuaJIT bitops (required for Neovim)
-- =============================================================================
local ok, bit = pcall(require, "bit")
if not ok then
  error("[puml_viewer] Requires LuaJIT 'bit' library.")
end
local band, bor, bxor, bnot = bit.band, bit.bor, bit.bxor, bit.bnot
local lshift, rshift, rol, tobit = bit.lshift, bit.rshift, bit.rol, bit.tobit

-- =============================================================================
-- SECTION: Utility Functions (Crypto, Base64, and PlantUML Encoding)
-- =============================================================================

-- Pure-LuaJIT SHA-1 using bitlib (Lua 5.1 / LuaJIT friendly)
local sha1
do
  local function to_be(n)
    return string.char(
      band(rshift(n,24),0xff),
      band(rshift(n,16),0xff),
      band(rshift(n,8),0xff),
      band(n,0xff)
    )
  end

  function sha1(s)
    -- local debug prints if needed:
    -- print("--- DEBUG: Input to SHA1 function ---"); print(vim.inspect(s))

    local h0, h1, h2, h3, h4 =
      0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0

    local len = #s
    -- Pad so that (len + 1 + pad_len) % 64 == 56, then append 64-bit len (big-endian)
    local pad_len = (56 - ((len + 1) % 64)) % 64
    s = s .. '\128' .. string.rep('\0', pad_len) .. to_be(0) .. to_be(len * 8)

    -- print("--- DEBUG: Padded SHA1 input ---"); print(vim.inspect(s))

    for i = 1, #s, 64 do
      local chunk = s:sub(i, i + 63)
      local w = {}
      for j = 0, 15 do
        local a = chunk:byte(j*4 + 1)
        local b = chunk:byte(j*4 + 2)
        local c = chunk:byte(j*4 + 3)
        local d = chunk:byte(j*4 + 4)
        w[j] = bor(lshift(a,24), lshift(b,16), lshift(c,8), d)
      end
      for j = 16, 79 do
        w[j] = rol(bxor(w[j-3], w[j-8], w[j-14], w[j-16]), 1)
      end

      local a, b_, c, d, e = h0, h1, h2, h3, h4
      for j = 0, 79 do
        local f, k
        if j < 20 then
          f = bor(band(b_, c), band(bnot(b_), d))
          k = 0x5A827999
        elseif j < 40 then
          f = bxor(b_, c, d)
          k = 0x6ED9EBA1
        elseif j < 60 then
          f = bor(band(b_, c), band(b_, d), band(c, d))
          k = 0x8F1BBCDC
        else
          f = bxor(b_, c, d)
          k = 0xCA62C1D6
        end
        local temp = tobit(rol(a, 5) + f + e + w[j] + k)
        e, d, c, b_, a = d, c, rol(b_, 30), a, temp
      end
      h0 = tobit(h0 + a)
      h1 = tobit(h1 + b_)
      h2 = tobit(h2 + c)
      h3 = tobit(h3 + d)
      h4 = tobit(h4 + e)
    end
    return to_be(h0) .. to_be(h1) .. to_be(h2) .. to_be(h3) .. to_be(h4)
  end
end

-- Pure-Lua Base64 (standard alphabet)
local b64
do
  local s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  function b64(data)
    return ((data:gsub('.', function(x)
      local r, b = '', x:byte()
      for i = 8, 1, -1 do
        r = r .. (b % 2^i - b % 2^(i-1) > 0 and '1' or '0')
      end
      return r
    end)..'0000'):gsub('(%d%d%d?%d?%d?%d?)', function(x)
      if (#x < 6) then return '' end
      local c = 0
      for i = 1, 6 do c = c + (x:sub(i,i) == '1' and 2^(6-i) or 0) end
      return s:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data % 3 + 1])
  end
end

-- Minimal zlib "deflate" wrapper (stored/raw block) + Adler32
local zlib = {}
do
  local function adler32(buf)
    local s1, s2 = 1, 0
    for i = 1, #buf do
      s1 = (s1 + buf:byte(i)) % 65521
      s2 = (s2 + s1) % 65521
    end
    return s2 * 65536 + s1
  end
  function zlib.deflate(buf)
    local len = #buf
    local nlen = 65535 - len
    local b = string.char(0x78, 0x01) .. string.char(1) ..
              string.char(len % 256, math.floor(len / 256)) ..
              string.char(nlen % 256, math.floor(nlen / 256)) .. buf
    local a32 = adler32(buf)
    return b .. string.char(
      math.floor(a32 / 16777216) % 256,
      math.floor(a32 / 65536) % 256,
      math.floor(a32 / 256) % 256,
      a32 % 256
    )
  end
end

-- PlantUML's custom 64 alphabet (0-9A-Za-z-_), after zlib deflate
local function encode64_plantuml(data)
  local b64_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_'
  local result = ''
  for i = 1, #data, 3 do
    local c1, c2, c3 = string.byte(data, i, i + 2)
    c1 = c1 or 0; c2 = c2 or 0; c3 = c3 or 0
    result = result ..
      b64_chars:sub(math.floor(c1 / 4) + 1, math.floor(c1 / 4) + 1) ..
      b64_chars:sub(math.floor(((c1 % 4) * 16) + c2 / 16) + 1, math.floor(((c1 % 4) * 16) + c2 / 16) + 1) ..
      b64_chars:sub(math.floor(((c2 % 16) * 4) + c3 / 64) + 1, math.floor(((c2 % 16) * 4) + c3 / 64) + 1) ..
      b64_chars:sub(math.floor(c3 % 64) + 1, math.floor(c3 % 64) + 1)
  end
  return result
end

local function plantuml_encode(text)
  return encode64_plantuml(zlib.deflate(text))
end

-- =============================================================================
-- SECTION: Embedded HTML/JS Viewer
-- =============================================================================
local html_content = string.format([[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PlantUML Live Viewer</title>
    <style>
        body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;background-color:#f0f2f5;color:#333;margin:0;padding:0;display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:100vh}
        .container{width:90%%;max-width:1200px;background-color:#fff;border-radius:12px;box-shadow:0 4px 12px rgba(0,0,0,.1);padding:2rem;text-align:center}
        h1{color:#1a202c;margin-bottom:.5rem}#status{margin-bottom:1.5rem;font-size:.9rem;padding:.5rem 1rem;border-radius:8px;font-weight:500}
        .status-connecting{background-color:#fffbeb;color:#b45309}.status-connected{background-color:#f0fdf4;color:#166534}.status-disconnected{background-color:#fef2f2;color:#991b1b}
        #diagram-container{margin-top:1rem;min-height:300px;display:flex;align-items:center;justify-content:center;background-color:#f8fafc;border-radius:8px;padding:1rem}
        #puml-diagram{max-width:100%%;height:auto;display:none}#placeholder{color:#64748b}
    </style>
</head>
<body>
    <div class="container">
        <h1>PlantUML Live Viewer</h1>
        <div id="status" class="status-connecting">Connecting to server...</div>
        <div id="diagram-container">
            <p id="placeholder">Waiting for a diagram from Neovim. Save a <code>.puml</code> file to get started.</p>
            <img id="puml-diagram" alt="PlantUML Diagram">
        </div>
    </div>
    <script>
        const WEBSOCKET_PORT = %d;
        const statusDiv=document.getElementById("status"),diagramImg=document.getElementById("puml-diagram"),placeholder=document.getElementById("placeholder");
        function connect(){const socket=new WebSocket(`ws://%s:${WEBSOCKET_PORT}`);socket.onopen=function(e){console.log("[open] Connection established"),statusDiv.textContent="Connected. Ready for updates!",statusDiv.className="status-connected"},socket.onmessage=function(event){try{const data=JSON.parse(event.data);"update"===data.type&&data.url&&(console.log("[message] Received new URL:",data.url),placeholder.style.display="none",diagramImg.style.display="block",diagramImg.src=data.url)}catch(error){console.error("Error parsing message:",error)}},socket.onclose=function(event){event.wasClean?console.log(`[close] Connection closed cleanly, code=${event.code} reason=${event.reason}`):console.error("[close] Connection died"),statusDiv.textContent="Disconnected. Trying to reconnect in 3 seconds...",statusDiv.className="status-disconnected",setTimeout(connect,3e3)},socket.onerror=function(error){console.error(`[error] ${error.message}`)}}
        connect();
    </script>
</body>
</html>
]], config.websocket_port, config.host)

-- =============================================================================
-- SECTION: Lua HTTP & WebSocket Server
-- =============================================================================
local server = {}
local connected_clients = {}

local function encode_ws_frame(payload)
  local len = #payload
  if len <= 125 then
    return string.char(0x81, len) .. payload
  elseif len <= 65535 then
    return string.char(0x81, 126, math.floor(len / 256), len % 256) .. payload
  else
    -- For very large payloads, you'd emit 127 + 64-bit length. Not needed here.
    return ''
  end
end

function server.broadcast(message)
  local frame = encode_ws_frame(vim.json.encode({ type = "update", url = message }))
  for client, _ in pairs(connected_clients) do
    if client and not client:is_closing() then
      client:write(frame)
    else
      connected_clients[client] = nil
    end
  end
end

function server.start()
  -- HTTP server for the viewer page
  local http_server = vim.loop.new_tcp()
  http_server:bind(config.host, config.http_port)
  http_server:listen(128, function(err)
    assert(not err, err)
    local client = vim.loop.new_tcp()
    http_server:accept(client)
    client:read_start(function(_, data)
      if data then
        local response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: "
          .. #html_content .. "\r\n\r\n" .. html_content
        client:write(response, function() client:close() end)
      end
    end)
  end)

  -- WebSocket server for live updates
  local ws_server = vim.loop.new_tcp()
  ws_server:bind(config.host, config.websocket_port)
  ws_server:listen(128, function(err)
    assert(not err, err)
    local client = vim.loop.new_tcp()
    ws_server:accept(client)
    client:read_start(function(err2, data)
      if err2 then
        connected_clients[client] = nil
        client:close()
        return
      end
      if not data then
        connected_clients[client] = nil
        client:close()
        return
      end

      vim.schedule(function()
        -- local debug:
        -- print("--- DEBUG: Data Received on WebSocket ---")
        -- print(vim.inspect(data))

        local key = data:match("Sec%-WebSocket%-Key: ([%w%+/=]+)")
        if key then
          -- print("--- DEBUG: Extracted Key ---"); print(key)

          local guid = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
          local accept_key_sha1 = sha1(key .. guid)
          local accept_key_b64 = b64(accept_key_sha1)

          local response = "HTTP/1.1 101 Switching Protocols\r\n" ..
                           "Upgrade: websocket\r\n" ..
                           "Connection: Upgrade\r\n" ..
                           "Sec-WebSocket-Accept: " .. accept_key_b64 .. "\r\n\r\n"

          client:write(response)
          connected_clients[client] = true
        else
          -- Not a handshake we understand; ignore for now.
        end
      end)
    end)
  end)
end

-- =============================================================================
-- SECTION: Neovim Integration
-- =============================================================================
local M = {}

function M.update_diagram()
  local buffer_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  if buffer_content == '' then
    vim.notify("PlantUML: Buffer is empty, skipping.", vim.log.levels.WARN)
    return
  end
  local encoded_diagram = plantuml_encode(buffer_content)
  local plantuml_url = "http://www.plantuml.com/plantuml/png/~1" .. encoded_diagram
  server.broadcast(plantuml_url)
  vim.notify("PlantUML diagram updated.", vim.log.levels.INFO)
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("PlantUMLViewer", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    pattern = "*.puml",
    callback = M.update_diagram,
    desc = "Update PlantUML diagram via WebSocket",
  })
  server.start()
  vim.notify(
    "PlantUML HTTP server running on http://" .. config.host .. ":" .. config.http_port,
    vim.log.levels.INFO
  )
  print("PlantUML Viewer (100% Lua) loaded and configured.")
end

return M

