
--[[ Blocks
 Hull
 Smokestack
 Guns (Machine guns, Cannons)
]]

local S = minetest.get_translator("battleship_terrain") -- Reuse it's translations so we don't need to make many copies

-- Basic Hull blocks
minetest.register_node("battleship_vessels:hull", {
  description = S("Hull"),
  tiles = {"battleship_vessels_metal.png"},
  groups = {crumbly=3, soil=1},
  light_source=8
})

minetest.register_node("battleship_vessels:deck", {
  description = S("Deck"),
  tiles = {"battleship_vessels_wood.png"},
  groups = {crumbly=3, soil=1},
  light_source=8
})

minetest.register_node("battleship_vessels:smokestack", {
  description = S("Smokestack"),
  tiles = {"battleship_vessels_smokestack.png"},
  groups = {crumbly=3, soil=1},
  light_source=10
})

-- Ships as items
minetest.register_craftitem("battleship_vessels:battleship_item", {
  description = S("Battleship"),
  inventory_image = "battleship_vessels_battleship.png",
  stack_max = 1
})

minetest.register_craftitem("battleship_vessels:destroyer_item", {
  description = S("Destroyer"),
  inventory_image = "battleship_vessels_destroyer.png",
  stack_max = 1
})

minetest.register_craftitem("battleship_vessels:carrier_item", {
  description = S("Aircraft Carrier"),
  inventory_image = "battleship_vessels_carrier.png",
  stack_max = 1
})

minetest.register_craftitem("battleship_vessels:submarine_item", {
  description = S("Submarine"),
  inventory_image = "battleship_vessels_sub.png",
  stack_max = 1
})

minetest.register_craftitem("battleship_vessels:ptboat_item", {
  description = S("PT Boat"),
  inventory_image = "battleship_vessels_ptboat.png",
  stack_max = 1
})

-- Allow placement onto ship spots
-- https://github.com/minetest/minetest/blob/master/doc/lua_api.txt#L5802
