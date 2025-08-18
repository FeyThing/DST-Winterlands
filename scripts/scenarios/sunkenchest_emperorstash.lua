local chestfunctions = require("scenarios/chestfunctions")

---------------------------------------------------------------------------------------------------------

local LOOT = {
	{item = "chesspiece_emperor_penguin_fruity_sketch", count = 1},
	{item = "chesspiece_emperor_penguin_magestic_sketch", count = 1},
	{item = "chesspiece_emperor_penguin_juggle_sketch", count = 1},
	{item = "chesspiece_emperor_penguin_spin_sketch", count = 1},
	{item = "compass_polar", count = 1},
	{item = "emperor_egg", count = 1},
	{item = "emperor_penguinhat", count = 1},
	{item = "polar_spear_blueprint", count = 1},
	{item = "tower_polar_flag_item", count = 1},
}

---------------------------------------------------------------------------------------------------------

local function OnCreate(inst, scenariorunner)
	chestfunctions.AddChestItems(inst, LOOT)
end

---------------------------------------------------------------------------------------------------------

return {
	OnCreate  = OnCreate,
}