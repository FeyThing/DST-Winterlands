local ENV = env
local modimport = ENV.modimport
GLOBAL.ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	Strings, Translations

local translation = ENV.GetModConfigData("language")

require("polar_strings/strings")
if translation and softresolvefilepath("scripts/polar_strings/"..translation.."/strings.lua") then
	require("polar_strings/"..translation.."/strings")
end

for i, character in ipairs(DST_CHARACTERLIST) do
	if softresolvefilepath("scripts/polar_strings/"..character..".lua") then
		require("polar_strings/"..character)
	end
	if translation and softresolvefilepath("scripts/polar_strings/"..translation.."/"..character..".lua") then
		require("polar_strings/"..translation.."/"..character)
	end
end

ENV.AddSimPostInit(function()
	for i, character in ipairs(MODCHARACTERLIST) do
		if softresolvefilepath("scripts/polar_strings/modded/"..character..".lua") then
			require("polar_strings/modded/"..character)
		end
		if translation and softresolvefilepath("scripts/polar_strings/"..translation.."/modded/"..character..".lua") then
			require("polar_strings/"..translation.."/modded/"..character)
		end
	end
end)

--	Main, Postinits

require("polarmain")

local inits = {
	"init_actions",
	"init_assets",
	"init_cooking",
	"init_prefabs",
	"init_recipes",
	"init_retrofit",
	"init_skins",
	"init_tuning",
	"init_widgets",
	"fx",
}

for _, v in pairs(inits) do
	modimport("init/"..v)
end

local prefabs = {
	"abigail",
	"antlion_sinkhole",
	"bearger",
	"birds",
	"birdcage",
	"boat_ice",
	"books",
	"bluegem",
	"cookingrecipecard",
	"desiccant",
	"dirtpile",
	"farm_plants",
	"flower",
	"forest",
	"frogs",
	"grass",
	--"heatrock",
	"ice",
	"klaus_sack",
	"krampus",
	"lavae",
	"minerhat",
	"mole",
	"moonbase",
	"mushroom_farm",
	"oceanfish",
	"oceanfishableflotsam",
	"penguin",
	"perd",
	"pond",
	"rabbit",
	"rainometer",
	"reskin_tool",
	"rock_ice",
	"shadowworker",
	"snowball_item",
	"stickheads",
	"trees",
	"tree_rock_data",
	"trinkets",
	"walrus",
	"walrus_camp",
	"wilson",
	"winona_spotlight",
	"wintersfeastcookedfoods",
	
	"any", -- shovels, hound, walrus, ...
	"bear_treasures",
	"chesspieces_polar_materials",
	"ents_onfreeze",
	--"fiery_weapons",
	"hot_stuff",
	"polar_walking",
	"waxed_plants",
	"wx78_modules",
}

local components = {
	"ambientsound",
	"birdspawner",
	"builder",
	"brushable",
	"combat",
	"container",
	"debuffable",
	"deerclopsspawner",
	"deployable",
	"dynamicmusic", -- : (
	"drawable",
	"expertsailor",
	"explosive",
	"follower",
	"freezable",
	"groundpounder",
	"health",
	"hounded",
	"hullhealth",
	"hunger",
	"hunter",
	"inspectable",
	"klaussackloot",
	"kramped",
	"locomotor",
	"map",
	"mightygym",
	"moisture",
	"moonstormmanager",
	"oceanfishinghook",
	"pickable",
	"plantregrowth",
	"playeractionpicker",
	"playercontroller",
	"playerspawner",
	"playervision",
	"preserver",
	"pushable",
	"regrowthmanager",
	"repairable",
	"rider",
	"sandstorms",
	"sanity",
	"sentientaxe",
	"shadowcreaturespawner",
	"shaveable",
	"sheltered",
	"slipperyfeet",
	"snowballmelting",
	"snowmandecortable",
	"stewer",
	"stormwatcher",
	"submersible",
	"teamleader",
	"temperature",
	"wanderingtraderspawner",
	"wateryprotection",
	"wavemanager",
	"weather",
	"wisecracker",
}

local stategraphs = {
	"boat_ice",
	"hound",
	"krampus",
	"lavae",
	"penguin",
	"walrus",
	"wilson",
	
	"walrusbeartrap_states",
}

local brains = {
	"walrus",
}

for _, v in pairs(prefabs) do
	modimport("postinit/prefabs/"..v)
end

for _, v in pairs(components) do
	modimport("postinit/components/"..v)
end

for _, v in pairs(stategraphs) do
	modimport("postinit/stategraphs/"..v)
end

for _, v in pairs(brains) do
	modimport("postinit/brains/"..v)
end

require("brains/braincommon_polar")
require("polarcommands")