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
	"evergreen",
	"farm_plants",
	"flower",
	"forest",
	"frogs",
	"grass",
	"heatrock",
	"krampus",
	"oceanfish",
	"oceanfishableflotsam",
	"penguin",
	"rabbit",
	"rock_ice",
	"shadowworker",
	"shovels",
	"snowball_item",
	"walrus",
	"wilson",
	"wintersfeastcookedfoods",
	
	"blizzard_fires",
	"ents_onfreeze",
	"polar_walking",
	"snow_heaters",
	"waxed_plants",
	"wx78_modules",
}

local components = {
	"ambientsound",
	"birdspawner",
	"builder",
	"brushable",
	"dynamicmusic", -- : (
	"expertsailor",
	"explosive",
	"follower",
	"groundpounder",
	"hounded",
	"hullhealth",
	"hunter",
	"inspectable",
	"locomotor",
	"map",
	"moisture",
	"moonstormmanager",
	"oceanfishinghook",
	"pickable",
	"playervision",
	"preserver",
	"repairable",
	"retrofitforestmap_anr",
	"shadowcreaturespawner",
	"sheltered",
	"slipperyfeet",
	"snowballmelting",
	"stormwatcher",
	"teamleader",
	"temperature",
	"wavemanager",
	"weather",
	"wisecracker",
}

local stategraphs = {
	"krampus",
	"penguin",
	"wilson",
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

require("polarcommands")