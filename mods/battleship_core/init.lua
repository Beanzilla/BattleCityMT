
battleship = {}

battleship.S = minetest.get_translator("battleship_core")
battleship.MODPATH = minetest.get_modpath("battleship_core")
battleship.GAMEMODE = "battleship"
battleship.VERSION = "1.0-dev"
battleship.store = minetest.get_mod_storage()

dofile(battleship.MODPATH.."/settings.lua")
dofile(battleship.MODPATH.."/tool_belt.lua")

battleship.tools.log("Running version: "..battleship.VERSION)
battleship.tools.debug_log("!!!   !!!   !!! Warning we are running in debug mode !!!   !!!   !!!")

battleship._internal = {}
battleship._internal.init_arena_pos_ping = {}
battleship._internal.init_arena_pos = nil

battleship._internal.ships = {}
battleship._internal.ships.arena = minetest.read_schematic(minetest.get_modpath("battleship_terrain").."/schematics/battlezone.mts", {write_yslice_prob="low"})
battleship._internal.ships._arena = minetest.read_schematic(minetest.get_modpath("battleship_terrain").."/schematics/no_battlezone.mts", {write_yslice_prob="low"})

battleship._internal.ships.pt_boat = minetest.read_schematic(minetest.get_modpath("battleship_vessels").."/schematics/pt_boat.mts", {write_yslice_prob="low"})
battleship._internal.ships._pt_boat = minetest.read_schematic(minetest.get_modpath("battleship_vessels").."/schematics/no_pt_boat.mts", {write_yslice_prob="low"})
battleship._internal.ships.battleship = minetest.read_schematic(minetest.get_modpath("battleship_vessels").."/schematics/battleship.mts", {write_yslice_prob="low"})
battleship._internal.ships._battleship = minetest.read_schematic(minetest.get_modpath("battleship_vessels").."/schematics/no_battleship.mts", {write_yslice_prob="low"})

dofile(battleship.MODPATH.."/api_internal.lua")
dofile(battleship.MODPATH.."/privs.lua")
dofile(battleship.MODPATH.."/cmds.lua")

local interval = 0
minetest.register_globalstep(function (dtime)
    interval = interval - dtime
    if interval <= 0 then
        for _, player in ipairs(minetest.get_connected_players()) do
            local p = player
            if not minetest.is_player(p) then
                p = minetest.get_player_by_name(p)
            end
            local pname = p:get_player_name()
            if battleship._internal.init_arena_pos_ping[pname] then
                minetest.chat_send_player(pname, minetest.pos_to_string(battleship.tools.offset_pos(p)))
            end
        end
        interval = 1.0
    end
end)