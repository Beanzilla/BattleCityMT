To fix:

2021-12-04 14:59:17: ERROR[Main]: ServerError: AsyncErr: Lua: Runtime error from mod 'battleship_core' in callback on_chat_message(): ...e/beanzilla/.minetest/mods/battleship_core/tool_belt.lua:142: bad argument #1 to 'pairs' (table expected, got nil)
2021-12-04 14:59:17: ERROR[Main]: stack traceback:
2021-12-04 14:59:17: ERROR[Main]: 	[C]: in function 'pairs'
2021-12-04 14:59:17: ERROR[Main]: 	...e/beanzilla/.minetest/mods/battleship_core/tool_belt.lua:142: in function 'tableContainsValue'


* Ships place properly facing forward and left, but are placed incorrectly on right and back (perhaps take into account the ship size and adjust grid pos based on that and dir)

> I.E. Placing a PT Boat at 3, 2 facing right would actually place it at 4, 2,
>
> Just like placing a PT Boat at 3, 2 facing down should actully place it at 3, 1.
>
> Proper directions: 270, 
> Broken directions: 180 (Placed one grid ahead), 90 (Placed one grid back), 0 (Placed one grid back)
>

* Decouple the arena position from the grid2pos and pos2grid so it's a parameter.
* Move arena position and ship position tracking to seperate _internal fields. (till we get it so you can /play and /leave a game keep arena and ship pos in modstore)

To do:

* Add code to check that a ship won't collide with another ship or walls
* Move ship placement from chat command to item based on_use where pointed_thing is the position we will use
* Move away from single arena position to support multiple arenas at one time (Just because we can)
* Work on target grid (grid on wall) rather than own grid (bottom grid) (Hit/Miss and target indicator, those sound simple and easy compared to dealing with ships)
* Make Basic AI for 1 Player Vs. Computer gameplay
* Support 1 Player Vs. 1 Player gameplay
* Make some kind of "spawn"
* Make cool "tutorial" upon joining for first time (Auto place into a 1 Player Vs. Computer game)
