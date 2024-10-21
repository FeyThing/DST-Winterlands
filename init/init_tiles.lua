local NOISES = require("noisetilefunctions")
local ChangeTileRenderOrder = ChangeTileRenderOrder

local WINTERLANDS_COLOR =
{
	primary_color =        {5, 15, 45,  255}, -- {153, 76, 0,  200},
	secondary_color =      {5,  20, 20, 200}, -- {102,  51, 0, 255/2},
	secondary_color_dusk = {0,  2, 10, 125}, -- {51,  25, 0, 80},
	minimap_color =        {3,  12,  23,  150},
}


local WINTERLANDS_WAVETINTS =
{
    winter = {249, 180, 45} -- 1,  0.20,   0.10
}

AddTile("OCEAN_WINTER", "OCEAN",
    {
		ground_name = "Winter Waves", 
	},
    {
        name = "cave",
        noise_texture = "levels/textures/ocean_noise.tex",
        runsound="dontstarve/movement/run_marsh",
        walksound="dontstarve/movement/walk_marsh",
        snowsound="dontstarve/movement/run_ice",
        mudsound = "dontstarve/movement/run_mud",
        ocean_depth = "SHALLOW",
        colors = WINTERLANDS_COLOR,
        wavetint = WINTERLANDS_WAVETINTS.winter,
    },
    {
        name = "map_edge",
        noise_texture = "levels/textures/mini_water_coral.tex",
    }
)


AddTile("ICEFIELD", "LAND",
	{
		ground_name 	= "Icy Ground",
	},
	{
		name			= "fluffysnow",
		noise_texture	= "levels/textures/ground_noise_icefield.tex",
		runsound 		= "dontstarve/movement/run_dirt",
        walksound 		= "dontstarve/movement/walk_dirt",
		snowsound		= "dontstarve/movement/run_snow",
		mudsound        = "dontstarve/movement/run_mud",
		ocean_depth = "SHALLOW",
		colors = WINTERLANDS_COLOR,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/mini_noise_icefield.tex",
        pickupsound = "grainy",
	}

)


AddTile("ICETUNDRA", "LAND",
	{
		ground_name 	= "Tundra Desert",
	},
	{
		name			= "fluffysnow",
		noise_texture	= "levels/textures/ground_noise_icetundra.tex",
		runsound 		= "dontstarve/movement/run_dirt",
        walksound 		= "dontstarve/movement/walk_dirt",
		snowsound		= "dontstarve/movement/run_ice",
		mudsound        = "dontstarve/movement/run_mud",
		ocean_depth = "SHALLOW",
		colors = WINTERLANDS_COLOR,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/mini_noise_icetundra.tex",
		pickupsound = "grainy",
	}
)

AddTile("ICEWASTE", "LAND",
	{
		ground_name 	= "Icy Wasteland",
	},
	{
		name			= "icy",
		noise_texture	= "levels/textures/ground_noise_icewaste.tex",
		runsound="dontstarve/movement/run_dirt",
        walksound="dontstarve/movement/walk_dirt",
        snowsound="dontstarve/movement/run_snow",
        mudsound="dontstarve/movement/run_mud",
		ocean_depth = "SHALLOW",
		colors = WINTERLANDS_COLOR,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/mini_noise_icewaste.tex",
        pickupsound = "grainy",
	}
)

AddTile("ICECAVE", "LAND",
	{
		ground_name 	= "Icy Cave",
	},
	{
		name			= "icy",
		noise_texture	= "levels/textures/ground_noise_icecave.tex",
		runsound="dontstarve/movement/run_dirt",
        walksound="dontstarve/movement/walk_dirt",
        snowsound="dontstarve/movement/run_snow",
        mudsound="dontstarve/movement/run_mud",
        hard			= true,
		ocean_depth = "SHALLOW",
		colors = WINTERLANDS_COLOR,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/mini_noise_icecave.tex",
	}
)

AddTile("ICETUNDRA_NOISE", "NOISE")

local function GetTileForIcetundraNoise(noise)
    return noise < .5 and WORLD_TILES.ICETUNDRA or WORLD_TILES.ROCKY
end

NOISES[WORLD_TILES.ICETUNDRA_NOISE] = GetTileForIcetundraNoise

AddTile("ICEFIELD_NOISE", "NOISE")

local function GetTileForIcewasteNoise(noise)
    return noise < .6 and WORLD_TILES.ICEFIELD or noise < .3 and WORLD_TILES.ICETUNDRA or WORLD_TILES.ICEWASTE
end

NOISES[WORLD_TILES.ICEFIELD_NOISE] = GetTileForIcewasteNoise

AddTile("ICECAVE_NOISE", "NOISE")

local function GetTileForIcecaveNoise(noise)
    return noise < .6 and WORLD_TILES.ICECAVE or WORLD_TILES.OCEAN_ICE
end

NOISES[WORLD_TILES.ICECAVE_NOISE] = GetTileForIcecaveNoise

ChangeTileRenderOrder(WORLD_TILES.OCEAN_WINTER, WORLD_TILES.OCEAN_HAZARDOUS, true)

ChangeTileRenderOrder(WORLD_TILES.ICEFIELD, WORLD_TILES.DIRT)
ChangeTileRenderOrder(WORLD_TILES.ICETUNDRA, WORLD_TILES.DIRT)
ChangeTileRenderOrder(WORLD_TILES.ICEWASTE, WORLD_TILES.DIRT)
ChangeTileRenderOrder(WORLD_TILES.ICECAVE, WORLD_TILES.DIRT)
