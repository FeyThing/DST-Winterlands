name = "The Winterlands"
author = "Feything, Gearless, LukaS, ADM, Notka"

version = "snowy_day"
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
	
}

local descs = {
	misc_shader = "It's always winter in here, visually speaking.",
	misc_snow = "High Snow will hide away small things in the snow.\nBut it melts away in Summer for you to look inside!",
}

local options = {
	none = {{description = "", data = false}},
	language = {{description = "English", data = false}},
	toggle = {{description = "Disabled", data = false}, {description = "Enabled", data = true}},
}

local configs = {
	language = "Language",
	misc = "Misc",
	misc_shader = "Winter Shader",
	misc_snow = "Tall Snow",
}

configuration_options = {
--	Language 语言
	{name = "language",				label = configs.language,				hover = descs.language,			options = options.language, 	default = false},
--	Misc
	{name = "misc",					label = configs.misc,													options = options.none, 		default = false},
	{name = "misc_snow",			label = configs.misc_snow,				hover = descs.misc_snow,		options = options.toggle,		default = true},
	{name = "misc_shader",			label = configs.misc_shader,			hover = descs.misc_shader,		options = options.toggle,		default = true},
}