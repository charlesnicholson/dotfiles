-- plantuml_viewer/init.lua

local config = {
  http_port = 8764,
  websocket_port = 8765,
  host = "127.0.0.1",
}

-- Hard requirements for this version of the plugin
assert(pcall(require, "ffi"), "[puml_viewer] Requires LuaJIT with FFI.")
assert(pcall(require, "bit"), "[puml_viewer] Requires LuaJIT 'bit' library.")
local ffi = require "ffi"
local bit = require "bit"

local zlib = {}
function zlib.deflate(buf)
  local zlib_name = ffi.os == "Windows" and "zlib1" or "z"
  local libz = ffi.load(zlib_name)

  ffi.cdef[[
    typedef unsigned long uLong;
    int compress(unsigned char *dest, uLong *destLen, const unsigned char *source, uLong sourceLen);
    uLong compressBound(uLong sourceLen);
  ]]

  local source_len = #buf
  local dest_len_val = libz.compressBound(source_len)
  local dest_len = ffi.new("uLong[1]", dest_len_val)
  local source = ffi.cast("const unsigned char*", buf)
  local dest = ffi.new("unsigned char[?]", dest_len[0])

  if libz.compress(dest, dest_len, source, source_len) == 0 then
    return ffi.string(dest, dest_len[0])
  else
    error("[puml_viewer] zlib compression failed.")
  end
end

local function encode64_plantuml(data)
  local map = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_'
  local out = {}
  local i, n = 1, #data
  while i <= n do
    local c1, c2, c3 = data:byte(i, i + 2)
    c1 = c1 or 0
    local b1 = bit.rshift(c1, 2)
    if not c2 then
      local b2 = bit.band(bit.lshift(c1, 4), 0x3F)
      out[#out+1] = map:sub(b1 + 1, b1 + 1)
      out[#out+1] = map:sub(b2 + 1, b2 + 1)
      break
    else
      local b2 = bit.band(bit.bor(bit.lshift(bit.band(c1, 0x3), 4), bit.rshift(c2, 4)), 0x3F)
      if not c3 then
        local b3 = bit.band(bit.lshift(bit.band(c2, 0xF), 2), 0x3F)
        out[#out+1] = map:sub(b1 + 1, b1 + 1)
        out[#out+1] = map:sub(b2 + 1, b2 + 1)
        out[#out+1] = map:sub(b3 + 1, b3 + 1)
        break
      else
        local b3 = bit.band(bit.bor(bit.lshift(bit.band(c2, 0xF), 2), bit.rshift(c3, 6)), 0x3F)
        local b4 = bit.band(c3, 0x3F)
        out[#out+1] = map:sub(b1 + 1, b1 + 1)
        out[#out+1] = map:sub(b2 + 1, b2 + 1)
        out[#out+1] = map:sub(b3 + 1, b3 + 1)
        out[#out+1] = map:sub(b4 + 1, b4 + 1)
        i = i + 3
      end
    end
  end
  return table.concat(out)
end

local sha1, b64
do
  local band, bor, bxor = bit.band, bit.bor, bit.bxor
  local lshift, rshift, rol, tobit = bit.lshift, bit.rshift, bit.rol, bit.tobit

  local function to_be(n)
    return string.char(
      band(rshift(n,24),255),
      band(rshift(n,16),255),
      band(rshift(n,8),255),
      band(n,255)
    )
  end

  function sha1(s)
    local h0,h1,h2,h3,h4 = 0x67452301,0xEFCDAB89,0x98BADCFE,0x10325476,0xC3D2E1F0
    local len = #s
    s = s .. '\128' .. string.rep('\0', (55 - len) % 64) .. to_be(0) .. to_be(len * 8)
    for i=1, #s, 64 do
      local chunk = s:sub(i, i+63)
      local w = {}
      for j=0,15 do
        w[j]=bor(
          lshift(chunk:byte(j*4+1),24),
          lshift(chunk:byte(j*4+2),16),
          lshift(chunk:byte(j*4+3),8),
          chunk:byte(j*4+4)
        )
      end
      for j=16,79 do w[j] = rol(bxor(w[j-3],w[j-8],w[j-14],w[j-16]), 1) end
      local a,b,c,d,e=h0,h1,h2,h3,h4
      for j=0,79 do
        local f,k
        if j<20 then f,k=bor(band(b,c),band(bit.bnot(b),d)),0x5A827999
        elseif j<40 then f,k=bxor(b,c,d),0x6ED9EBA1
        elseif j<60 then f,k=bor(band(b,c),band(b,d),band(c,d)),0x8F1BBCDC
        else f,k=bxor(b,c,d),0xCA62C1D6 end
        local temp=tobit(rol(a,5)+f+e+w[j]+k)
        e,d,c,b,a=d,c,rol(b,30),a,temp
      end
      h0,h1,h2,h3,h4=tobit(h0+a),tobit(h1+b),tobit(h2+c),tobit(h3+d),tobit(h4+e)
    end
    return to_be(h0)..to_be(h1)..to_be(h2)..to_be(h3)..to_be(h4)
  end

  local map="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

  function b64(data)
    return((data:gsub('.',function(x)
      local r,b='',x:byte()
      for i=8,1,-1 do r=r.. (b%2^i-b%2^(i-1)>0 and '1' or '0') end
      return r
    end)..'0000'):gsub('(%d%d%d?%d?%d?%d?)',function(x)
      if(#x<6)then return'' end
      local c=0
      for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
      return map:sub(c+1,c+1)
    end)..({'','==','='})[#data%3+1])
  end
end

local html_content = [[
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>PlantUML Viewer</title>
<style>
  :root{--bg:#0b0c0e;--fg:#d7d7db;--muted:#8b8d94;--pill-bg:#1a1b1e;--ok:#2ea043;--warn:#b8821f;--err:#be3431;--panel:#0f1013}
  *{box-sizing:border-box} html,body{height:100%;overflow:hidden;}
  body{margin:0;background:var(--bg);color:var(--fg);font:14px/1.45 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;display:flex;flex-direction:column}
  .top{display:flex;align-items:center;gap:.75rem;padding:.5rem .75rem;border-bottom:1px solid #111318;background:var(--panel)}
  .dot{width:.5rem;height:.5rem;border-radius:999px;display:inline-block;vertical-align:middle;background:var(--warn)}
  .pill{display:inline-flex;align-items:center;gap:.35rem;padding:.15rem .45rem;border-radius:999px;background:var(--pill-bg);color:var(--muted);font-size:.75rem;font-weight:500}
  .pill.ok .dot{background:var(--ok)} .pill.err .dot{background:var(--err)}
  .file{margin-left:.25rem;color:var(--fg);font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .spacer{flex:1}
  .wrap{flex:1;min-height:0;padding:0.75rem}
  .board{position:relative;width:100%;height:100%;display:flex;align-items:center;justify-content:center;border-radius:8px;background:#0c0d10;outline:1px solid #111318;overflow:hidden;}
  #img{display:block;opacity:0;transition:opacity .2s ease-in-out;max-width:100%;max-height:100%;width:auto;height:auto;}
  #ph{color:var(--muted);font-size:.9rem}
</style>
</head>
<body>
  <div class="top">
    <span id="status" class="pill"><span class="dot"></span><span id="status-text">connecting</span></span>
    <span class="file" id="file" title="filename">untitled</span>
    <span class="spacer"></span>
  </div>
  <div class="wrap">
    <div class="board" id="board">
      <img id="img" alt="PlantUML diagram">
      <p id="ph">Waiting for a diagram… save a <code>.puml</code> file in Neovim.</p>
    </div>
  </div>
<script>
  const statusEl=document.getElementById("status"), statusText=document.getElementById("status-text");
  const fileEl=document.getElementById("file"), ph=document.getElementById("ph");
  const img=document.getElementById("img");

  function setStatus(kind,text){
    statusEl.classList.remove("ok","err");
    if(kind==="ok")statusEl.classList.add("ok");
    if(kind==="err")statusEl.classList.add("err");
    statusText.textContent=text;
  }

  // No template substitution: assume WS port = HTTP port + 1 (defaults 8764 -> 8765).
  function wsPort() {
    const p = parseInt(location.port || "0", 10);
    if (p > 0) return String(p + 1);
    // Fallback for file:// or unknown: default to 8765
    return "8765";
  }

  function connect(){
    const host = location.hostname || "127.0.0.1";
    const wsUrl = "ws://" + host + ":" + wsPort();
    const ws = new WebSocket(wsUrl);
    ws.onopen = () => setStatus("ok","connected");
    ws.onmessage = e => {
      try{
        const data=JSON.parse(e.data);
        if(data.type==="update"&&data.url){
          img.style.opacity = 0;
          if(data.filename){fileEl.textContent=data.filename; fileEl.title=data.filename;}
          ph.style.display="none";
          img.src=data.url;
        }
      }catch(err){console.error(err);}
    };
    ws.onclose = () => { setStatus("", "reconnecting…"); setTimeout(connect, 1200); };
    ws.onerror = () => setStatus("err","error");
  }

  img.onload = () => { img.style.opacity = 1; };
  setStatus("", "connecting");
  connect();
</script>
</body>
</html>
]]

local server = {}
local connected_clients = {}

local function encode_ws_frame(payload)
  local len = #payload
  if len <= 125 then
    return string.char(0x81, len) .. payload
  elseif len <= 65535 then
    return string.char(0x81, 126, math.floor(len / 256), len % 256) .. payload
  else
    local b7 = len % 256
    local b6 = math.floor(len / 256) % 256
    local b5 = math.floor(len / 65536) % 256
    local b4 = math.floor(len / 16777216) % 256
    return string.char(0x81, 127, 0, 0, 0, 0, b4, b5, b6, b7) .. payload
  end
end

function server.broadcast(tbl)
  local frame = encode_ws_frame(vim.json.encode(tbl))
  for client, _ in pairs(connected_clients) do
    if client and not client:is_closing() then
      client:write(frame)
    else
      connected_clients[client] = nil
    end
  end
end

function server.start()
  local http_server = vim.loop.new_tcp()
  http_server:bind(config.host, config.http_port)
  http_server:listen(128, function(err)
    assert(not err, err)
    local client = vim.loop.new_tcp()
    http_server:accept(client)
    client:read_start(function(_, data)
      if data then
        local response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: "..#html_content.."\r\n\r\n"..html_content
        client:write(response, function() client:close() end)
      end
    end)
  end)

  local ws_server = vim.loop.new_tcp()
  ws_server:bind(config.host, config.websocket_port)
  ws_server:listen(128, function(err)
    assert(not err, err)
    local client = vim.loop.new_tcp()
    ws_server:accept(client)
    client:read_start(function(err2, data)
      if err2 or not data then connected_clients[client] = nil; client:close(); return end
      vim.schedule(function()
        local key = data:match("Sec%-WebSocket%-Key: ([%w%+/=]+)")
        if key then
          local guid = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
          local accept_key_b64 = b64(sha1(key .. guid))
          local response =
            "HTTP/1.1 101 Switching Protocols\r\n" ..
            "Upgrade: websocket\r\n" ..
            "Connection: Upgrade\r\n" ..
            "Sec-WebSocket-Accept: "..accept_key_b64.."\r\n\r\n"
          client:write(response)
          connected_clients[client] = true
        end
      end)
    end)
  end)
end

local M = {}

function M.update_diagram()
  local buf = 0
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local buffer_content = table.concat(lines, '\n')
  if buffer_content:match("^%s*$") then
    vim.schedule(function() vim.print("PlantUML: buffer empty, skipping.") end)
    return
  end
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
  if filename == "" then filename = "untitled.puml" end
  local compressed_data = zlib.deflate(buffer_content)
  local encoded_data = encode64_plantuml(compressed_data)
  local plantuml_url = "http://www.plantuml.com/plantuml/png/~1" .. encoded_data

  if #plantuml_url > 8000 then
    vim.notify("PlantUML: Resulting URL is very long and may be rejected by the server.", vim.log.levels.WARN)
  end

  server.broadcast({ type = "update", url = plantuml_url, filename = filename })
  vim.schedule(function() vim.print("PlantUML updated: " .. filename) end)
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("PlantUMLViewer", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "BufEnter", "TabEnter" }, {
    group = augroup,
    pattern = "*.puml",
    callback = M.update_diagram,
    desc = "Update PlantUML diagram via WebSocket",
  })
  server.start()
end

return M

