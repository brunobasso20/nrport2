-- Configuration dependency port from NR2003.exe; not a motion solver.
-- Source addresses are retained below. Lua 5.1+ and Roblox Luau.
local M = {}

local function band(value, mask)
    local result, place = 0, 1
    while mask > 0 do
        if value % 2 == 1 and mask % 2 == 1 then result = result + place end
        value, mask, place = math.floor(value / 2), math.floor(mask / 2), place * 2
    end
    return result
end

-- FUN_005b2b10, offsets 0x6d, 0x75, 0x71.
function M.clearLinks(node)
    node.parent, node.firstChild, node.nextSibling = nil, nil, nil
end

-- FUN_005b2b20: exact, case-sensitive name lookup.
function M.find(nodes, name)
    for i = 1, #nodes do
        if nodes[i].name == name then return nodes[i] end
    end
    return nil
end

-- FUN_005b2ac0: append after the final sibling.
function M.appendSibling(node, sibling)
    while sibling.nextSibling do sibling = sibling.nextSibling end
    sibling.nextSibling = node
end

-- FUN_005b2a30 + FUN_005b2af0: unknown parent becomes a root.
function M.attach(node, parentName, nodes, roots)
    local parent = M.find(nodes, parentName)
    if not parent then
        roots[#roots + 1] = node
        return
    end
    node.parent = parent
    if parent.firstChild then
        M.appendSibling(node, parent.firstChild)
    else
        parent.firstChild = node
    end
end

-- FUN_005b29c0: clear all links before attaching in record order.
-- Added validation rejects malformed user data; the embedded records pass it.
function M.build(nodes)
    local seen = {}
    for i = 1, #nodes do
        local node = nodes[i]
        assert(type(node.name) == "string" and not seen[node.name], "Invalid/duplicate component name")
        assert(type(node.parentName) == "string", "Missing parent name")
        assert(type(node.flags) == "number" and node.flags >= 0 and node.flags < 2^32
            and node.flags == math.floor(node.flags), "Invalid flags")
        seen[node.name] = node
        M.clearLinks(node)
    end
    for i = 1, #nodes do
        local chain, node = {}, nodes[i]
        while node do
            assert(not chain[node], "Component parent cycle")
            chain[node] = true
            node = seen[node.parentName]
        end
    end
    local roots = {}
    for i = 1, #nodes do M.attach(nodes[i], nodes[i].parentName, nodes, roots) end
    return roots
end

-- FUN_005b2c40. This counts numerical state entries, NOT degrees of freedom.
function M.countStates(node)
    local flags = node.flags
    local count = 2 * (band(flags, 1) + band(math.floor(flags / 2), 1)
        + band(math.floor(flags / 4), 1))
    if band(flags, 0x380) == 0 then
        if band(flags, 0x18) == 0 then
            if band(flags, 0x20) ~= 0 then count = count + 7 end
        else
            count = count + 2
        end
    else
        count = count + 2
    end
    if node.firstChild then count = count + M.countStates(node.firstChild) end
    if node.nextSibling then count = count + M.countStates(node.nextSibling) end
    return count
end

return M
