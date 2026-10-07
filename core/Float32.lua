-- Round values assigned to C float fields. Extended x87 registers are not emulated.
local M = {}
local storage
if buffer then storage = buffer.create(4) end
function M.round(value)
    if storage then
        buffer.writef32(storage, 0, value)
        return buffer.readf32(storage, 0)
    end
    if string.pack and string.unpack then
        return (string.unpack("<f", string.pack("<f", value)))
    end
    error("Float32 requires Roblox buffer or Lua 5.3+ string.pack")
end
function M.bits(value)
    if storage then buffer.writef32(storage,0,value); return buffer.readu32(storage,0) end
    return (string.unpack("<I4",string.pack("<f",value)))
end
function M.fromBits(value)
    if storage then buffer.writeu32(storage,0,value); return buffer.readf32(storage,0) end
    return (string.unpack("<f",string.pack("<I4",value)))
end
function M.inverseSqrt(x)
    -- 0054cab0, bit reinterpretation (decompiler casts are misleading).
    local bits=math.floor(((0xbe7ffffd-M.bits(x))%4294967296)/2)
    local y=M.fromBits(bits)
    y=M.round((1.5-y*y*0.5*x)*y)
    return M.round((1.5-y*y*0.5*x)*y)
end
return M
