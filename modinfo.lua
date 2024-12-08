name = "The Winterlands"
author = "ADM, Feything, Gearless, LukaS, Notka 󰀃"

version = "1.0.0"
local info_version = "󰀔 [ Version "..version.." ]"

description = info_version..[[ Freshly Released


󰀛 Set sails to a perilous frozen island -

Where winter reigns eternal, and deadlier than ever... amid the snow lies a world brimming with untamed beauty to undig.


󰀏 Best experienced with Winter's Feast enabled!

Look up your configs + new world settings before starting ⬇]]

forumthread = ""
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
	biome = "Winterlands",
	biome_retrofit = "Retrofit",
	misc = "Misc",
	misc_shader = "Winter Shader",
	misc_snow = "High Snow",
}

local descs = {
	language = "Set the language of the mod!",
	biome_retrofit = "Manually retrofit missing parts of the mod in old worlds.\nThe config will return to \"Updated\" automatically once finished.",
	misc_shader = "It's always winter in here, visually speaking.",
	misc_snow = "Waves of snow will hide away small things in them.\nBut it all melts during hot days, go look inside!",
}

local options = {
	none = {{description = "", data = false}},
	language = {{description = "English", data = "en"}, {description="Polish", data = "pl"}},
	retrofit = {{description = "Updated", data = 0, hover = "Change this to another setting if you miss some content."}, {description = "Generate Island", data = 1, hover = "Spawn The Winterlands as a setpiece at sea."}},
	toggle = {{description = "Disabled", data = false}, {description = "Enabled", data = true}},
}

configuration_options = {
--	Language 语言
	{name = "language",				label = configs.language,				hover = descs.language,			options = options.language, 	default = "en"},
--	Gene
	{name = "biome",				label = configs.biome,													options = options.none, 		default = false},
	{name = "biome_retrofit",		label = configs.biome_retrofit,			hover = descs.biome_retrofit,	options = options.retrofit,		default = 0},
--	Misc
	{name = "misc",					label = configs.misc,													options = options.none, 		default = false},
	{name = "misc_snow",			label = configs.misc_snow,				hover = descs.misc_snow,		options = options.toggle,		default = true},
	{name = "misc_shader",			label = configs.misc_shader,			hover = descs.misc_shader,		options = options.toggle,		default = true},
}