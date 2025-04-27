if WORLD_TILES.POLAR_ICE ~= nil then
	return
end

local NOISES = require("noisetilefunctions")
local ChangeTileRenderOrder = ChangeTileRenderOrder

local POLAR_COLOR = {
	primary_color = 		{5, 	20, 	95, 	200},
	secondary_color = 		{40, 	170, 	215, 	230},
	secondary_color_dusk = 	{30, 	150, 	195, 	200},
	minimap_color = 		{15, 	90, 	120, 	170},
}

local POLAR_WAVETINTS = {
	winter = {215, 255, 255},
}

--	Lands

-- TODO(?) change cannotbedug to some new thing and require a special pitchfork made of charged bluegem to retrieve turfs from the island?

AddTile("POLAR_ICE", "LAND",
	{
		ground_name = 	"Polar Ice",
	},
	{
		name = 			"polarice",
		noise_texture = "levels/textures/noise_polarice.tex",
		runsound = 		"dontstarve/movement/run_iceslab",
		walksound = 	"dontstarve/movement/walk_iceslab",
		snowsound = 	"dontstarve/movement/run_iceslab",
		mudsound = 		"dontstarve/movement/run_iceslab",
		colors = 		POLAR_COLOR,
		cannotbedug = 	true,
		hard = 			true,
	},
	{
		name = 			"map_edge",
		noise_texture = "levels/textures/mini_noise_polarice.tex",
	}
)

AddTile("POLAR_SNOW", "LAND",
	{
		ground_name = 	"Polar Snow",
	},
	{
		name = 			"polarsnow",
		noise_texture = "levels/textures/noise_polarsnow.tex",
		runsound = 		"dontstarve/movement/run_snow",
		walksound = 	"dontstarve/movement/run_snow",
		snowsound = 	"dontstarve/movement/run_snow",
		mudsound = 		"dontstarve/movement/run_snow",
		colors = 		POLAR_COLOR,
		cannotbedug = 	true,
	},
	{
		name = 			"map_edge",
		noise_texture = "levels/textures/mini_noise_polarsnow.tex",
	}
)

AddTile("POLAR_CAVES", "LAND",
	{
		ground_name = 	"Polar Caves",
	},
	{
		name = 			"blocky",
		noise_texture = "levels/textures/noise_polar.tex",
		runsound = 		"turnoftides/movement/run_meteor",
		walksound = 	"turnoftides/movement/run_meteor",
		snowsound = 	"dontstarve/movement/run_ice",
		mudsound = 		"dontstarve/movement/run_mud",
		hard = 			true,
	},
	{
		name = 			"map_edge",
		noise_texture = "levels/textures/mini_noise_polar.tex",
	},
	{		
		name = 			"polar_caves",
		anim = 			"turf2",
		bank_build = 	"turf_polar",
		pickupsound = 	"rock",
	}
)

AddTile("POLAR_DRYICE", "LAND",
	{
		ground_name = 	"Dry Ice",
	},
	{
		name = 			"blocky",
		noise_texture = "levels/textures/noise_dryice.tex",
		runsound = 		"dontstarve/movement/run_ice",
		walksound = 	"dontstarve/movement/run_ice",
		snowsound = 	"dontstarve/movement/run_ice",
		mudsound = 		"dontstarve/movement/run_ice",
		colors = 		POLAR_COLOR,
		flooring = 		true,
		hard = 			true,
		roadways = 		true,
	},
	{
		name = 			"map_edge",
		noise_texture = "levels/textures/mini_noise_dryice.tex",
	},
	{
		name = 			"polar_dryice",
		anim = 			"turf",
		bank_build = 	"turf_polar",
		pickupsound = 	"grainy",
	}
)

AddTile("POLAR_CAVES_NOISE", "NOISE")
AddTile("POLAR_FOREST_NOISE", "NOISE")
AddTile("POLAR_TUNDRA_NOISE", "NOISE")
AddTile("POLAR_FLOE_NOISE", "NOISE")
AddTile("POLAR_QUARRY_NOISE", "NOISE")

--	Oceans

AddTile("OCEAN_POLAR", "OCEAN",
	{
		ground_name = 	"Polar Shore", 
	},
	{
		name = 			"cave",
		noise_texture = "levels/textures/ocean_noise.tex",
		runsound = 		"dontstarve/movement/run_marsh",
		walksound = 	"dontstarve/movement/walk_marsh",
		snowsound = 	"dontstarve/movement/run_ice",
		mudsound = 		"dontstarve/movement/run_mud",
		ocean_depth = 	"POLAR",
		colors = 		POLAR_COLOR,
		wavetint = 		POLAR_WAVETINTS.winter,
	},
	{
		name = 			"map_edge",
		noise_texture = "levels/textures/mini_water_coral.tex",
	}
)

--	Noise Tiles

local function GetTileForPolarCaves(noise)
	return noise < 0.3 and WORLD_TILES.OCEAN_POLAR or WORLD_TILES.POLAR_CAVES
end

local function GetTileForPolarForest(noise)
	return noise < 0.4 and WORLD_TILES.OCEAN_POLAR or noise < 0.55 and WORLD_TILES.PEBBLEBEACH or WORLD_TILES.POLAR_SNOW
end

local function GetTileForPolarTundra(noise)
	return noise < 0.35 and WORLD_TILES.POLAR_SNOW or noise < 0.4 and WORLD_TILES.OCEAN_POLAR or noise < 0.45 and WORLD_TILES.ROCKY
		or WORLD_TILES.POLAR_SNOW
end

local function GetTileForPolarFloe(noise)
	return noise < 0.7 and WORLD_TILES.OCEAN_POLAR or WORLD_TILES.POLAR_SNOW
end

local function GetTileForPolarQuarry(noise)
	return noise < 0.3 and WORLD_TILES.POLAR_CAVES or noise < 0.6 and WORLD_TILES.POLAR_SNOW or WORLD_TILES.POLAR_CAVES
end

NOISES[WORLD_TILES.POLAR_CAVES_NOISE] = GetTileForPolarCaves
NOISES[WORLD_TILES.POLAR_FOREST_NOISE] = GetTileForPolarForest
NOISES[WORLD_TILES.POLAR_TUNDRA_NOISE] = GetTileForPolarTundra
NOISES[WORLD_TILES.POLAR_FLOE_NOISE] = GetTileForPolarFloe
NOISES[WORLD_TILES.POLAR_QUARRY_NOISE] = GetTileForPolarQuarry

--	Tile Order

ChangeTileRenderOrder(WORLD_TILES.OCEAN_POLAR, WORLD_TILES.OCEAN_HAZARDOUS, true)
ChangeTileRenderOrder(WORLD_TILES.POLAR_CAVES, WORLD_TILES.ROCKY, true)
ChangeTileRenderOrder(WORLD_TILES.POLAR_ICE, WORLD_TILES.UNDERROCK, true)
ChangeTileRenderOrder(WORLD_TILES.POLAR_DRYICE, WORLD_TILES.WOODFLOOR)

--	Setpiece Ground Type

local POLAR_GROUND_TYPES = {
	WORLD_TILES.IMPASSABLE, WORLD_TILES.POLAR_SNOW, WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.POLAR_DRYICE, -- 1, 2, 3, 4, 5
	WORLD_TILES.OCEAN_POLAR, WORLD_TILES.DIRT, WORLD_TILES.ROCKY, WORLD_TILES.UNDERROCK, WORLD_TILES.MONKEY_DOCK, -- 6, 7, 8, 9, 10
	WORLD_TILES.OCEAN_COASTAL_SHORE, WORLD_TILES.WOODFLOOR, -- 11, 12
}

if WORLD_TILES.OCEAN_SHALLOW ~= nil then
	local POLAR_GROUND_TYPES_SW = GLOBAL.deepcopy(POLAR_GROUND_TYPES)
	-- 	SW replacements so water tiles doesn't glitch the hell out of players' movement
	
	POLAR_GROUND_TYPES_SW[1] = WORLD_TILES.OCEAN_SHALLOW
	POLAR_GROUND_TYPES_SW[6] = WORLD_TILES.OCEAN_DEEP
	POLAR_GROUND_TYPES_SW[11] = WORLD_TILES.OCEAN_SHALLOW
	
	GLOBAL.POLAR_GROUND_TYPES_SW = POLAR_GROUND_TYPES_SW
end

GLOBAL.POLAR_GROUND_TYPES = POLAR_GROUND_TYPES