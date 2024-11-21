--	Strings, Translations
	
	require("polar_strings/strings")
	
	local characters = {"wilson", "wolfgang", "warly", "wormwood", "walter"}
	--local translation = GetModConfigData("language")
	
	for i, character in ipairs(characters) do
		require("polar_strings/"..character)
	end
	
	--[[if translation then
		require("polar_strings/translation_"..translation.."/strings")
		
		for i, character in ipairs(characters) do
			require("polar_strings/translation_"..translation.."/"..character)
		end
	end]]
	
--	Main, Postinits

require("polarmain")

local inits = {
	"init_actions",
	"init_assets",
	"init_prefabs",
	"init_recipes",
	"init_tuning",
	"init_widgets",
	"fx",
}

for _, v in pairs(inits) do
	modimport("init/"..v)
end

modimport("scripts/winterlands_tiles_manager")

local prefabs = {
	"bearger",
	"birds",
	"evergreen",
	"flower",
	"forest",
	"penguin",
	"rabbit",
	"rock_ice",
	"seastack",
	"shovels",
	"walrus",
	"wilson",
	"antlion_sinkhole",
	
	"polar_walking",
}

local components = {
	"ambientsound",
	"builder",
	"dynamicmusic", -- : (
	"explosive",
	"groundpounder",
	"hounded",
	"hunter",
	"inspectable",
	"locomotor",
	"map",
	"moisture",
	"pickable",
	"playervision",
	"repairable",
	"shadowcreaturespawner",
	"sheltered",
	"slipperyfeet",
	"temperature",
	"wavemanager",
	"wisecracker",
}

local stategraphs = {
	"penguin",
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