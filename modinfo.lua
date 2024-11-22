name = "The Winterlands"
author = "Feything, Gearless, LukaS, ADM, Notka"

version = "retro_fit_in"
local info_version = "󰀔 [ Version "..version.." ]\n"

description = info_version..[[

It's a frozen island with stuff on it.]]

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
	biome_retrofit = "Manually retrofit missing parts of the mod in old worlds.\nThe config will return to \"Updated\" automatically once finished.",
	misc_shader = "It's always winter in here, visually speaking.",
	misc_snow = "Waves of snow will hide away small things in them.\nBut it all melts during hot days, go look inside!",
}

local options = {
	none = {{description = "", data = false}},
	language = {{description = "English", data = false}},
	retrofit = {{description = "Updated", data = 0, hover = "Change this to another setting if you miss some content."}, {description = "Generate Island", data = 1, hover = "Spawn The Winterlands as a setpiece at sea."}},
	toggle = {{description = "Disabled", data = false}, {description = "Enabled", data = true}},
}

configuration_options = {
--	Language 语言
	{name = "language",				label = configs.language,				hover = descs.language,			options = options.language, 	default = false},
--	Gene
	{name = "biome",				label = configs.biome,													options = options.none, 		default = false},
	{name = "biome_retrofit",		label = configs.biome_retrofit,			hover = descs.biome_retrofit,	options = options.retrofit,		default = 0},
--	Misc
	{name = "misc",					label = configs.misc,													options = options.none, 		default = false},
	{name = "misc_snow",			label = configs.misc_snow,				hover = descs.misc_snow,		options = options.toggle,		default = true},
	{name = "misc_shader",			label = configs.misc_shader,			hover = descs.misc_shader,		options = options.toggle,		default = true},
}