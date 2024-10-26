--	Strings, Translations
	
	require("polar_strings/strings")
	
	local characters = {"wilson"}
	--local translation = GetModConfigData("language")
	
	for i, character in ipairs(characters) do
		require("polar_strings/"..character)
	end
	
	--[[if translation then
		require("badlands_strings/translation_"..translation.."/strings")
		
		for i, character in ipairs(characters) do
			require("badlands_strings/translation_"..translation.."/"..character)
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

modimport("scripts/snowstorm")

local prefabs = {
	"birds",
	"evergreen",
	"flower",
	"forest",
	"wilson",
	
	"polar_walking",
}

local components = {
	"ambientsound",
	"map",
	"moisture",
	"pickable",
	"sheltered",
	"slipperyfeet",
	"temperature",
	"wavemanager",
	"wisecracker",
}

local stategraphs = {
	
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