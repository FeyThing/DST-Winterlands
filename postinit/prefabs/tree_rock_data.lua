local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local TREE_ROCK_DATA = require("prefabs/tree_rock_data")

--

local LOOT = {
	POLAR_AREA = {
		["rocks"] 			= 3,
		["flint"] 			= 2,
		["boneshard"] 		= 1,
		["bluegem"] 		= 0.5,
		["bluegem_shards"] 	= 1,
		["polarflea"] 		= 2.5,
	},
	
	POLARCAVE_AREA = {
		["rocks"] 			= 3,
		["flint"] 			= 1,
		["goldnugget"] 		= 0.5,
		["nitre"] 			= 0.5,
		["bluegem"] 		= 1.5,
		["bluegem_shards"] 	= 3,
		["polarflea"] 		= 0.5,
	},
}

for k, v in pairs(LOOT) do
	TREE_ROCK_DATA.WEIGHTED_VINE_LOOT[k] = v
end

--

local LOOT_DATA = {
	["bluegem_shards"] = 	{build = "tree_rock_polar", symbols = {"swap_bluegem_shards"}},
	["polarflea"] = 		{build = "tree_rock_polar", symbols = {"swap_polarflea1", "swap_polarflea2", "swap_polarflea3"}},
}

for k, v in pairs(LOOT_DATA) do
	TREE_ROCK_DATA.VINE_LOOT_DATA[k] = v
end

--

local ROOMS = {
	["PolarIsland_BG"] = "POLAR_AREA",
	["PolarIsland_Caves"] = "POLARCAVE_AREA",
	["PolarIsland_TrappedCaves"] = "POLARCAVE_AREA",
}

for k, v in pairs(ROOMS) do
	TREE_ROCK_DATA.ROOMS_TO_LOOT_KEY[k] = v
end

local TASKS = {
	["Polar Caves"] = "POLAR_AREA",
	["Polar Deciduous Lands"] = "POLAR_AREA",
	["Polar Floe"] = "POLAR_AREA",
	["Polar Gnomes"] = "POLAR_AREA",
	["Polar Icerink"] = "POLAR_AREA",
	["Polar Lands"] = "POLAR_AREA",
	["Polar Quarry"] = "POLAR_AREA",
	["Polar Village"] = "POLAR_AREA",
}

for k, v in pairs(TASKS) do
	TREE_ROCK_DATA.TASKS_TO_LOOT_KEY[k] = v
end

local LAYOUTS = {
	["Polar Lands"] = "POLAR_AREA", -- Retrofitted Winterlands fallback
}

for k, v in pairs(LAYOUTS) do
	TREE_ROCK_DATA.STATIC_LAYOUTS_TO_LOOT_KEY[k] = v
end

--	Just changing dirt to snow...

local tree_rocks = {"tree_rock1", "tree_rock2"}

for i, v in ipairs(tree_rocks) do
	ENV.AddPrefabPostInit(v, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		MakeSnowAndDirtToggleable(inst, {symbol = "tree_ground_rocks", build = "dirt_to_polar_builds"})
	end)
end