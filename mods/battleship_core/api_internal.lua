
-- The internal api which does some stuff in the background
battleship._internal.api = {}
local api = battleship._internal.api

--[[
    All functions here will return a table of result and errmsg (error message), and value.

    I.E. 
        Calling battleship._internal.api.place_arena({x=0, y=0, z=0})
            Can return:
                {result=false, errmsg="Found existing arena at position", value=nil}
                {result=false, errmsg="Failed placing schematic", value=nil}
                {result=true, errmsg="", value=nil}
        
            Checking the above call for success:
                local rc = battleship._internal.api.place_arena({x=0, y=0, z=0})
                if not rc.result then
                    -- It failed, but why?
                    minetest.log("action", "[battleship] "..rc.errmsg)
                else
                    -- It passed
                end
]]

-- Places an arena given position
api.place_arena = function (pos)
    local arenas = minetest.deserialize(battleship.store:get_string("battleship:arenas")) or {}
    if battleship.tools.tableContainsValue(arenas, battleship.tools.pos2str(pos))  then
        return {result=false, errmsg="Found existing arena at position "..battleship.tools.pos2str(pos), value=nil}
    end
    battleship.tools.log("place_schematic("..battleship.tools.pos2str(pos)..", battleship._internal.ships.arena, \"0\", nil, true)")
    local valid = minetest.place_schematic(pos, battleship._internal.ships.arena, "0", nil, true)
    if not valid then
        return {result=false, errmsg="Failed placing schematic", value=nil}
    end
    table.insert(arenas, battleship.tools.pos2str(pos))
    battleship.store:set_string("battleship:arenas", minetest.serialize(arenas) )
    return {result=true, errmsg="", value=nil}
end

-- Places selectors on the bottom for both players of the given arena
api.enter_build_state = function (arena_pos)
    local arenas = minetest.deserialize(battleship.store:get_string("battleship:arenas")) or {}
    local keys = battleship.tools.tableKeys(arenas)
    battleship.tools.log( minetest.serialize(keys) )
    if not battleship.tools.tableContainsValue(arenas, battleship.tools.pos2str(arena_pos)) then
        return {result=false, errmsg="No areana at position "..battleship.tools.pos2str(arena_pos), value=nil}
    end
    -- Place selectors on bottom of player0
    battleship.tools.debug_log("+++ Placing Selectors +++")
    for x=1, 8, 1 do
        for y=1, 8, 1 do
            local grid = battleship.tools.grid2pos( {x=x, y=y} )
            grid.x = grid.x + 1
            grid.y = 0
            grid.z = grid.z + 1
            grid = battleship.tools.real_pos( grid )
            grid.x = math.floor(grid.x)
            grid.y = math.floor(grid.y)
            grid.z = math.floor(grid.z)
            battleship.tools.debug_log("+0 Grid ("..tostring(x)..", "..tostring(y)..") = "..battleship.tools.pos2str(grid))
            minetest.swap_node(grid, {name="battleship_terrain:selector"})
            local meta = minetest.get_meta(grid)
            meta:set_string("grid", battleship.tools.pos2str(grid))
            meta:set_string("infotext", "Selector ("..tostring(x)..", "..tostring(y)..")")
        end
    end
    -- Place selectors on bottom of player1
    for x=1, 8, 1 do
        for y=1, 8, 1 do
            local grid = battleship.tools.grid2pos( {x=x, y=y+8} )
            grid.x = grid.x + 3
            grid.y = 0
            grid.z = grid.z + 1
            grid = battleship.tools.real_pos( grid )
            grid.x = math.floor(grid.x)
            grid.y = math.floor(grid.y)
            grid.z = math.floor(grid.z)
            battleship.tools.debug_log("+1 Grid ("..tostring(x)..", "..tostring(y)..") = "..battleship.tools.pos2str(grid))
            minetest.swap_node(grid, {name="battleship_terrain:selector"})
            local meta = minetest.get_meta(grid)
            meta:set_string("grid", battleship.tools.pos2str(grid))
            meta:set_string("infotext", "Selector ("..tostring(x)..", "..tostring(y)..")")
        end
    end
    -- Just test also removing them too
    minetest.after(10.0, api.exit_build_state, arena_pos)
    return {result=true, errmsg="", value=nil}
end

api.exit_build_state = function (arena_pos)
    local arenas = minetest.deserialize(battleship.store:get_string("battleship:arenas")) or {}
    if not battleship.tools.tableContainsValue(arenas, battleship.tools.pos2str(arena_pos)) then
        return {result=false, errmsg="No areana at position "..battleship.tools.pos2str(arena_pos), value=nil}
    end
    -- Place selectors on bottom of player0
    battleship.tools.debug_log("--- Removing selectors ---")
    for x=1, 8, 1 do
        for y=1, 8, 1 do
            local grid = battleship.tools.grid2pos( {x=x, y=y} )
            grid.x = grid.x + 1
            grid.y = 0
            grid.z = grid.z + 1
            grid = battleship.tools.real_pos( grid )
            grid.x = math.floor(grid.x)
            grid.y = math.floor(grid.y)
            grid.z = math.floor(grid.z)
            battleship.tools.debug_log("-0 Grid ("..tostring(x)..", "..tostring(y)..") = "..battleship.tools.pos2str(grid))
            minetest.swap_node(grid, {name="battleship_terrain:blue"})
            local meta = minetest.get_meta(grid)
            meta:set_string("grid", battleship.tools.pos2str(grid))
            meta:set_string("infotext", "")
        end
    end
    -- Place selectors on bottom of player1
    for x=1, 8, 1 do
        for y=1, 8, 1 do
            local grid = battleship.tools.grid2pos( {x=x, y=y+8} )
            grid.x = grid.x + 3
            grid.y = 0
            grid.z = grid.z + 1
            grid = battleship.tools.real_pos( grid )
            grid.x = math.floor(grid.x)
            grid.y = math.floor(grid.y)
            grid.z = math.floor(grid.z)
            battleship.tools.debug_log("-1 Grid ("..tostring(x)..", "..tostring(y)..") = "..battleship.tools.pos2str(grid))
            minetest.swap_node(grid, {name="battleship_terrain:blue"})
            local meta = minetest.get_meta(grid)
            meta:set_string("grid", battleship.tools.pos2str(grid))
            meta:set_string("infotext", "")
        end
    end
    return {result=true, errmsg="", value=nil}
end
