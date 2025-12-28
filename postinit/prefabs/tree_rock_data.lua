local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local TREE_ROCK_DATA = require("prefabs/tree_rock_data")

--

local WEIGHTED_VINE_LOOT = TREE_ROCK_DATA.WEIGHTED_VINE_LOOT

local LOOT = {
	POLAR_AREA = {
		["rocks"] 			= 3,
		["flint"] 			= 2,
		["polarflea"] 		= 2,
		["boneshard"] 		= 3,
	},
	
	POLARCAVE_AREA = {
		["rocks"] 			= 8,
		["flint"] 			= 5,
		["goldnugget"] 		= 2,
		["nitre"] 			= 2,
		["bluegem"] 		= 1,
		["bluegem_shards"] 	= 2,
	},
}

for k, v in pairs(LOOT) do
	WEIGHTED_VINE_LOOT[k] = v
end

--

local VINE_LOOT_DATA = TREE_ROCK_DATA.VINE_LOOT_DATA

local LOOT_DATA = {
	["bluegem_shards"] = 	{build = "tree_rock_polar", symbols = {"swap_bluegem_shards"}},
	["polarflea"] = 		{build = "tree_rock_polar", symbols = {"swap_polarflea1", "swap_polarflea2", "swap_polarflea3"}},
}

for k, v in pairs(LOOT_DATA) do
	VINE_LOOT_DATA[k] = v
end

--

local ROOMS_TO_LOOT_KEY = TREE_ROCK_DATA.ROOMS_TO_LOOT_KEY

local ROOMS = {
	["PolarIsland_BG"] = 			"POLAR_AREA",
	["PolarIsland_Village"] = 		"POLAR_AREA",
	["PolarIsland_Lakes"] = 		"POLAR_AREA",
	["PolarIsland_Walrus"] = 		"POLAR_AREA",
	["PolarIsland_FloeField"] = 	"POLAR_AREA",
	["PolarIsland_BurntForest"] = 	"POLAR_AREA",
	["PolarIsland_BigLake"] = 		"POLAR_AREA",
	["PolarIsland_Rink"] = 			"POLAR_AREA",
	
	["PolarIsland_Caves"] = 		"POLARCAVE_AREA",
	["PolarIsland_TrappedCaves"] = 	"POLARCAVE_AREA",
}

for k, v in pairs(ROOMS) do
	ROOMS_TO_LOOT_KEY[k] = v
end

--	Just changing dirt to snow...

local tree_rocks = {"tree_rock1", "tree_rock2"}

local function PolarInit(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 32) then
		inst.AnimState:OverrideSymbol("tree_ground_rocks", "dirt_to_polar_builds", "tree_ground_rocks")
	end
end

for i, v in ipairs(tree_rocks) do
	ENV.AddPrefabPostInit(v, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:DoTaskInTime(0, PolarInit)
	end)
end