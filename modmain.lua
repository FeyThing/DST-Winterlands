--	Strings, Translations
local characters = {"wilson", "willow", "wolfgang", "wendy", "wx78", "wickerbottom", "woodie", "waxwell", "wathgrithr", "webber", "winona", "warly", "wortox", "wormwood", "wurt", "walter", "wanda"}
POLAR_LANG = GetModConfigData("language")

require("polar_strings/strings_"..POLAR_LANG)

for i, character in ipairs(characters) do
	require("polar_strings/"..character.."_"..POLAR_LANG)
end
	
--	Main, Postinits

require("polarmain")

local inits = {
	"init_actions",
	"init_assets",
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
	"penguin",
	"rabbit",
	"rock_ice",
	"shadowworker",
	"shovels",
	"walrus",
	"wilson",
	
	"ents_onfreeze",
	"polar_walking",
	"snow_heaters",
	"waxed_plants",
}

local components = {
	"ambientsound",
	"birdspawner",
	"builder",
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
	"pickable",
	"playervision",
	"preserver",
	"repairable",
	"retrofitforestmap_anr",
	"shadowcreaturespawner",
	"sheltered",
	"slipperyfeet",
	"stormwatcher",
	"temperature",
	"wavemanager",
	"weather",
	"wisecracker",
}

local stategraphs = {
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