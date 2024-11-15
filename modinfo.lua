name = "The Winterlands"
author = "Feything, Gearless, LukaS, ADM, Notka"

version = "chomp_growl"
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
	misc_snow = "High Snow is meant to hide away small things.\nStill... you might want to adjust it?",
}

local options = {
	none = {{description = "", data = false}},
	language = {{description = "English", data = false}},
	snow = {{description = "Full", data = 1}, {description = "Less", data = 0.7}, {description = "Few", data = 0.4}, {description = "Melted", hover = "It's gone.", data = 0}},
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
	{name = "misc_shader",			label = configs.misc_shader,			hover = descs.misc_shader,		options = options.toggle,		default = true},
}