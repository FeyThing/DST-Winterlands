local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local TREE_ROCK_DATA = require("prefabs/tree_rock_data")

--

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
	["PolarIsland_Caves"] = "POLARCAVE_AREA",
	["PolarIsland_TrappedCaves"] = "POLARCAVE_AREA",
}

for k, v in pairs(ROOMS) do
	TREE_ROCK_DATA.ROOMS_TO_LOOT_KEY[k] = v
end

local TASKS = {
	["Polar Lands"] = "POLAR_AREA", -- Default Winterlands loot
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