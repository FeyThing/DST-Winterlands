local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local driedplants_defs = require("prefabs/driedplants_defs")

table.insert(driedplants_defs.plants, {
	name = "petals_polar",
	bank = "flower_petals_polar",
	build = "flower_petals_polar",
	healthvalue = -TUNING.HEALING_MEDSMALL,
	sanityvalue = TUNING.SANITY_SUPERTINY,
})