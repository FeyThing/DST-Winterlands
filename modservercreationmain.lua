FrontEndAssets = {
	Asset("IMAGE", "images/worldgen_polar.tex"),
	Asset("ATLAS", "images/worldgen_polar.xml"),
	
	Asset("SOUNDPACKAGE", "sound/polarsounds.fev"),
	Asset("SOUND", "sound/polarsounds.fsb"),
}

ReloadFrontEndAssets()

modimport("init/init_tuning")

--	Reset retrofit, should have run the previous time

require("polar_util")
GLOBAL.ChangePolarConfigs("biome_retrofit", 0)