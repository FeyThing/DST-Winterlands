--	Strings, Translations

require("polar_strings/strings")

local characters = {"wilson", "willow", "wolfgang", "wendy", "wx78", "wickerbottom", "woodie", "waxwell", "wathgrithr", "webber", "winona", "warly", "wortox", "wormwood", "wurt", "walter", "wanda"}
local translation = GetModConfigData("language")

for i, character in ipairs(characters) do
	require("polar_strings/"..character)
end

if translation then
	require("polar_strings/"..translation.."/strings")
	
	for i, character in ipairs(characters) do
		require("polar_strings/"..translation.."/"..character)
	end
end

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
	"antlion_sinkhole",
	"bearger",
	"birds",
	"birdcage",
	"boat_ice",
	"books",
	"bluegem",
	"cookingrecipecard",
	"dirtpile",
	"evergreen",
	"farm_plants",
	"flower",
	"forest",
	"frogs",
	"grass",
	--"heatrock",
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
	"rock_ice",
	"shadowworker",
	"snowball_item",
	"stickheads",
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
	"playeractionpicker",
	"playercontroller",
	"playerspawner",
	"playervision",
	"preserver",
	"regrowthmanager",
	"repairable",
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