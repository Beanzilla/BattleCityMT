
-- A collection of utility functions for making lua less difficult
battleship.tools = {}
local tools = battleship.tools

-- Centralize logging
tools.log = function (input)
    minetest.log("action", "[battleship] "..tostring(input))
end

tools.debug_log = function (input)
    if battleship.settings.debug then
        minetest.log("action", "(DEBUG)[battleship] "..tostring(input))
    end
end

-- Centralize errors
tools.error = function (input)
    tools.log("Version: " .. battleship.VERSION)
    error("[battleship] "..tostring(input))
end

-- Returns space seperated position
tools.pos2str = function (pos)
    return "" .. tostring(math.floor(pos.x)) .. " " .. tostring(math.floor(pos.y)) .. " " .. tostring(math.floor(pos.z))
end

-- Returns a xyz vector from space seperated position
tools.str2pos = function (str)
    local pos = tools.split(str, " ")
    return vector.new(tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3]))
end

-- Returns a table of the string split by the given seperation string
tools.split = function (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

-- Returns 0, 90, 180, 270 based on direction given (assumes degree)
tools.to4dir = function (dir)
    local dir4 = math.floor(dir) / 90
    tools.log(tostring(dir4))
    if dir4 > 3.5 or dir4 < 0.5 then
        return 180
    elseif dir4 > 2.5 and dir4 < 3.5 then
        return 270
    elseif dir4 > 1.5 and dir4 < 2.5 then
        return 0
    elseif dir4 > 0.5 and dir4 < 3.5 then
        return 90
    end
    tools.log("to4dir(" .. tostring(dir) .. ") failed with " .. tostring(dir4))
    return -1
end

-- Given radians returns degrees
tools.rad2deg = function (rads)
    return (rads * 180) / 3.14159
end

-- Given degrees returns radians
tools.deg2rad = function (deg)
    return (deg * 3.14159) / 180
end

-- Given the xyz offset position returns the likely xy grid position
tools.pos2grid = function (pos)
    local grid = {x=0, y=0}
    --[[
        4, 1, 4 = 1, 1
        4, 1, 8 = 2, 1
        8, 1, 4 = 1, 2
    ]]
    grid.x = math.floor(pos.z / 4) + 1
    grid.y = math.floor(pos.x / 4) + 1
    return grid
end

-- Given xy grid position returns the likely xyz offset position
tools.grid2pos = function (grid)
    local pos = vector.new(0, 1, 0)
    local arena_pos = nil
    local modstore_pos = battleship.store:get_string("init_arena_pos")
    if modstore_pos ~= "" and battleship._internal.init_arena_pos == nil then
        battleship._internal.init_arena_pos = tools.str2pos(modstore_pos)
    end
    if battleship._internal.init_arena_pos then
        arena_pos = battleship._internal.init_arena_pos
    end
    pos.z = math.floor(grid.x * 4)
    pos.x = math.floor(grid.y * 4)
    pos.y = arena_pos.y
    return pos
end

-- Given player name and arena position obtains their offset position
tools.offset_pos = function (player)
    local p_pos = player:get_pos()
    local arena_pos = nil
    local modstore_pos = battleship.store:get_string("init_arena_pos")
    if modstore_pos ~= "" and battleship._internal.init_arena_pos == nil then
        battleship._internal.init_arena_pos = tools.str2pos(modstore_pos)
    end
    if battleship._internal.init_arena_pos then
        arena_pos = battleship._internal.init_arena_pos
    end
    local diff = vector.subtract(p_pos, arena_pos)
    diff.x = math.floor(diff.x)
    diff.y = math.floor(diff.y)
    diff.z = math.floor(diff.z)
    return vector.add(diff, vector.new(1, 0, 1))
end

-- Given offset position returns real position based on arena position
tools.real_pos = function (offset)
    local arena_pos = nil
    local modstore_pos = battleship.store:get_string("init_arena_pos")
    if modstore_pos ~= "" and battleship._internal.init_arena_pos == nil then
        battleship._internal.init_arena_pos = tools.str2pos(modstore_pos)
    end
    if battleship._internal.init_arena_pos then
        arena_pos = battleship._internal.init_arena_pos
    end
    return vector.add(vector.new(offset.x-2, 1, offset.z-2), arena_pos)
end

-- Converts the given string so the first letter is uppercase (Returns the converted string)
tools.firstToUpper = function (str)
    return (str:gsub("^%l", string.upper))
end

-- https://stackoverflow.com/questions/2282444/how-to-check-if-a-table-contains-an-element-in-lua
-- Checks if a value is in the given table (True if the value exists, False otherwise)
tools.tableContainsValue = function (table, element)
    for key, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

tools.tableContainsKey = function (table, element)
    for key, value in pairs(table) do
        if key == element then
            return true
        end
    end
    return false
end

-- Given a table returns it's keys (Returns a table)
tools.tableKeys = function (t)
    local keys = {}
    for k, v in pairs(t) do
        table.insert(keys, v)
    end
    return keys
end

-- Returns whole percentage given current and max values
tools.getPercent = function (current, max)
    if max == nil then
        max = 100
    end
    return math.floor( (current / max) * 100 )
end
