
minetest.register_chatcommand("init_arena", {
    privs = {
        battleship_debug = true,
        shout = true
    },
    description = "DEBUG - Initalizes a test area, also enters the player into a offset position ping (Retype to stop)",
    func = function (name, param)
        if not battleship._internal.init_arena_pos_ping[name] then
            local p_pos = minetest.get_player_by_name(name):get_pos()
            local a_pos = nil
            local modstore_pos = battleship.store:get_string("init_arena_pos") or ""
            if modstore_pos ~= "" and battleship._internal.init_arena_pos == nil then
                battleship._internal.init_arena_pos = battleship.tools.str2pos(modstore_pos)
            end
            if battleship._internal.init_arena_pos then
                a_pos = battleship._internal.init_arena_pos
            else
                a_pos = p_pos
                battleship._internal.init_arena_pos = a_pos
                battleship.store:set_string("init_arena_pos", battleship.tools.pos2str(a_pos))
                --minetest.place_schematic(a_pos, battleship._internal.ships.arena, "0", nil, true)
                battleship._internal.api.place_arena(a_pos)
            end
            battleship.tools.log("As raw: \'" .. modstore_pos .. "\'")
            local rc = battleship._internal.api.enter_build_state(battleship._internal.init_arena_pos)
            if not rc.result then
                battleship.tools.log("Enter Build State: " .. rc.errmsg)
            end
            battleship._internal.init_arena_pos_ping[name] = true
            minetest.chat_send_player(name, "Subscribed to debug pos offset ping.")
        else
            battleship._internal.init_arena_pos_ping[name] = false
            minetest.chat_send_player(name, "Unsubscribed to debug pos offset ping.")
        end
    end
})

minetest.register_chatcommand("test_dir", {
    privs = {
        battleship_debug = true,
        shout = true
    },
    description = "DEBUG - Outputs what dir a schematic would be placed in",
    func = function (name, param)
        local p_dir = battleship.tools.rad2deg(minetest.get_player_by_name(name):get_look_horizontal())
        minetest.chat_send_player(name, tostring(battleship.tools.to4dir(p_dir)))
    end
})

minetest.register_chatcommand("test_grid", {
    privs = {
        battleship_debug = true,
        shout = true
    },
    description = "DEBUG - Outputs players offset into grid position, and outputs 1,1 2,2 and 3,4 grid positions",
    func = function (name, param)
        local diff = battleship.tools.offset_pos(name)

        local p_grid = battleship.tools.pos2grid(diff)
        local grid1_1 = battleship.tools.grid2pos({x=1, y=1})
        local grid2_2 = battleship.tools.grid2pos({x=2, y=2})
        local grid3_4 = battleship.tools.grid2pos({x=3, y=4})
        minetest.chat_send_player(name, minetest.serialize(p_grid))
        minetest.chat_send_player(name, minetest.serialize(grid1_1))
        minetest.chat_send_player(name, minetest.serialize(grid2_2))
        minetest.chat_send_player(name, minetest.serialize(grid3_4))
    end
})

minetest.register_chatcommand("test_ship", {
    privs = {
        battleship_debug = true,
        shout = true
    },
    description = "DEBUG - Spawns a PT Boat at grid position, uses players facing dir",
    func = function (name, param)
        local offset = battleship.tools.offset_pos(name)
        local p_grid = battleship.tools.pos2grid(offset)
        local p_dir =  battleship.tools.to4dir(battleship.tools.rad2deg(minetest.get_player_by_name(name):get_look_horizontal()))

        local pass = minetest.place_schematic(battleship.tools.real_pos(battleship.tools.grid2pos(p_grid)), battleship._internal.ships.pt_boat, tostring(p_dir), nil, true)
        local pos = minetest.get_player_by_name(name):get_pos()
        minetest.get_player_by_name(name):set_pos(vector.add(pos, vector.new(0, 5, 0)))
        minetest.chat_send_player(name, "Placed PT Boat: " .. minetest.pos_to_string(battleship.tools.real_pos(battleship.tools.grid2pos(p_grid))))
    end
})