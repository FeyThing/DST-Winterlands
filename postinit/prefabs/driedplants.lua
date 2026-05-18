local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local driedplants_defs = require("prefabs/driedplants_defs")

table.insert(driedplants_defs.plants, {
	name = "petals_polar",
	bank = "flower_petals_polar",
	build = "flower_petals_polar",
	healthvalue = -TUNING.HEALING_MEDSMALL,
	sanityvalue = TUNING.SANITY_TINY,
})

--

local hermitcrabtea_defs = require("prefabs/hermitcrabtea_defs")

table.insert(hermitcrabtea_defs.teas, {
	name = "petals_polar",
	build = "hermitcrab_tea_polar",
	healthvalue = -TUNING.HEALING_MEDSMALL * 8,
	sanityvalue = TUNING.SANITY_TINY,
	--foodtype = FOODTYPE.CROCUS,
})

ENV.AddPrefabPostInit("hermitcrabtea_petals_polar", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.edible then
		inst.components.edible.secondaryfoodtype = FOODTYPE.CROCUS -- Any creature can take a sip from the Crocus Petal Tea
	end
end)