name = "The Winterlands"
author = "ADM, Feything, Gearless, LukaS, Notka 󰀃"

version = "1.2.12"
local info_version = "󰀔 [ Version "..version.." ]"

--description = info_version..[[ The Imperial Waddle
description = info_version..[[ 

󰀛 Set sails to a perilous frozen island -

Where winter reigns eternal, and deadlier than ever... amid the snow lies a world brimming with untamed beauty to undig.


󰀏 Best experienced with Winter's Feast enabled!


Look up your configs + new world settings before starting ⬇]]

forumthread = ""
wiki_link = "https://winterlands.wiki.gg/"

api_version = 10

all_clients_require_mod = true
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
	"winterlands",
}

local configs = {
	language = "Language",
	biome = "Worldgen",
	difficulty = "Difficulty",
	misc = "Misc",
	
	biometype = "Winterlands Type ",
	biomeshard = "Winterlands Shard ",
	wormhole = "Wormhole ",
	retrofit = "Retrofit ",
	
	blizzards = "Blizzard ",
	icegen = "Ice Layer ",
	snow = "High Snow ",
	
	menumelt = "Melt the Menu ",
	music = "Winterlands OST ",
	shader = "Winter Shader ",
}

local descs = {
	language = "Translate the mod, thanks to the community help.",
	
	biometype = "Set the generation style for the Winterlands.",
	biomeshard = "Set in which world the Winterlands should generate.",
	wormhole = "Add a pair of Wormholes between the Mainland & Winterlands.\nThey caught a cold, so go easy on them (but they respawn).",
	retrofit = "Manually retrofit missing parts of the mod in old worlds.\nThe config will return to \"Updated\" automatically once finished.",
	
--	TODO: We might want to move those under into world settings, no ?
	blizzards = "Ajust the frequency of Blizzards on the Winterlands.",
	icegen = "Grow or shrink more the Ice Tiles generation around the Winterlands.",
	snow = "Toggle for the tall waves of snow that freezes and slows you...\nfire and warm days will melt it, go look for hidden resources inside!",
	
	menumelt = "Turn on the heater to remove the frosty jumpscare\nwhen enabling Winterlands on your server. Brr!",
	music = "Enable or disable the mod's soundtrack.",
	shader = "It's always winter in here, visually speaking.",
}

local options = {
	none = {{description = "", data = false}},
	toggle = {{description = "Disabled", data = false}, {description = "Enabled", data = true}},
	moreless = {{description = "None", data = -2}, {description = "Less", data = -1}, {description = "Default", data = 0}, {description = "More", data = 1}, {description = "Most", data = 2}},
	language = {{description = "English", data = false}, {description = "简体中文", data = "zhs", hover = "By heavenmoon0107"}, {description = "繁體中文", data = "zht", hover = "By heavenmoon0107"}, {description = "Français", hover = "By ADM & Steamerclaw", data = "fr"}, {description = "한국인", hover = "By taeseong1120", data = "kr"}, {description = "Polski", hover = "By LukaS", data = "pl"}},
	biometype = {{description = "Island", data = "island", hover = "As its own separated region. Recommended!"}, {description = "Mainland", data = "mainland", hover = "Connected with the rest. Not recommended..."}, {description = "Skip", data = "skip", hover = "Will not generate (can be useful for multi-shards setup)."}},
	shards = {{description = "Forest", data = "forest", hover = "The surface, default location"}, {description = "Shipwrecked", data = "shipwrecked", hover = "For Island Adventures"}, {description = "Anywhere Possible", data = "all", hover = "Won't generate in Caves, nor Hamlet, Volcano..."}},
	retrofit = {{description = "Updated", data = 0, hover = "Change this to another setting if you miss some content."}, {description = "Generate Island", data = 1, hover = "Spawn The Winterlands as a setpiece at sea."}},
}

configuration_options = {
--	Language 语言
	{name = "language",				label = configs.language,			hover = descs.language,			options = options.language, 	default = false},
--	Worldgen
	{name = "biome",				label = configs.biome,												options = options.none, 		default = false},
	{name = "biome_type",			label = configs.biometype,			hover = descs.biometype,		options = options.biometype,	default = "island"},
	{name = "biome_shard",			label = configs.biomeshard,			hover = descs.biomeshard,		options = options.shards,		default = "forest"},
	{name = "biome_wormhole",		label = configs.wormhole,			hover = descs.wormhole,			options = options.toggle,		default = true},
	{name = "biome_retrofit",		label = configs.retrofit,			hover = descs.retrofit,			options = options.retrofit,		default = 0},
--	Re-balance
	{name = "difficulty",			label = configs.difficulty,											options = options.none, 		default = false},
	{name = "polar_blizzards",		label = configs.blizzards,			hover = descs.blizzards,		options = options.moreless,		default = 0},
	{name = "polar_icegen",			label = configs.icegen,				hover = descs.icegen,			options = options.moreless,		default = 0},
	{name = "polar_snow",			label = configs.snow,				hover = descs.snow,				options = options.toggle,		default = true},
--	Other
	{name = "misc",					label = configs.misc,												options = options.none, 		default = false},
	{name = "misc_menumelt",		label = configs.menumelt,			hover = descs.menumelt,			options = options.toggle,		default = false},
	{name = "misc_music",			label = configs.music,				hover = descs.music,			options = options.toggle,		default = true},
	{name = "misc_shader",			label = configs.shader,				hover = descs.shader,			options = options.toggle,		default = true},
}