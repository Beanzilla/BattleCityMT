
-- This provides the nodes we over use for the game grid

local S = minetest.get_translator("battleship_terrain")

-- In more official versions
-- Remove the groups from these nodes or change them so they can't be accessed by default hands

-- Our lighter colored block (For lines)
minetest.register_node("battleship_terrain:sand", {
  description = S("Sand"),
  tiles = {"battleship_terrain_sand.png"},
  groups = {crumbly = 3, soil = 1},
  light_source=6
})

-- Our darker colored blueish block (For inners of a slot/spot)
minetest.register_node("battleship_terrain:blue", {
  description = S("Blue"),
  tiles = {"battleship_terrain_blue.png"},
  groups = {crumbly = 3, soil = 1},
  light_source=6
})

minetest.register_node("battleship_terrain:ghostly", {
  description = S("Ghostly"),
  tiles = {"battleship_terrain_ghostly.png"},
  groups = {crumbly = 3, soil = 1},
  light_source=10
})

-- Our selector block (Trigger based on what kind of selector this is)
-- In this case it's a temp
minetest.register_node("battleship_terrain:selector", {
  description = S("Selector"),
  tiles = {"battleship_terrain_yellow.png"},
  groups = {crumbly = 3, soil = 1},
  light_source=14
})

-- HIT scheme block
minetest.register_node("battleship_terrain:hit", {
  description = S("Hit"),
  tiles = {"battleship_terrain_hit.png"},
  groups = {crumbly = 3, soil = 1},
  light_source=14
})

-- MISS scheme block
minetest.register_node("battleship_terrain:miss", {
  description = S("Miss"),
  tiles = {"battleship_terrain_miss.png"},
  groups = {crumbly = 3, soil = 1},
  light_source=14
})

-- Valid block indicator
minetest.register_node("battleship_terrain:valid", {
  description = S("Valid"),
  tiles = {"battleship_terrain_green.png"},
  groups = {crumbly = 3, soil = 1},
  light_source=14
})

--[[ Selector block is used for:
  * Ship selection (Which ship do you want to fire where?) <-- Each player selects one of their ships (So up to 2 ships per team per turn in a 2 versus 2)
  * Ship placement (Limits where a player can place their ships, also needs to be clear for placement to be allowed)
  * Match making (Once clicked on it enters the player into the match queue looking for a match against other players, can be used to indicated games/matches)

]]