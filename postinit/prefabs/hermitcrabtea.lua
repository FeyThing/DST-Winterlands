local ENV = env
GLOBAL.setfenv(1, GLOBAL)

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

-- NOTE: Tea shop adds all tea recipes locally instead of relying on the def file :/

local TEA_RECIPES

ENV.AddPrefabPostInit("hermitcrab_teashop", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if TEA_RECIPES == nil then
		local MakePrototyper = PolarUpvalue(Prefabs["hermitcrab_teashop"].fn, "MakePrototyper")
		local UpdateRecipes = PolarUpvalue(MakePrototyper, "UpdateRecipes")
		
		TEA_RECIPES = PolarUpvalue(UpdateRecipes, "TEA_RECIPES")
		
		if TEA_RECIPES and not table.contains(TEA_RECIPES, "hermitcrabtea_petals_polar") then
			table.insert(TEA_RECIPES, "hermitcrabtea_petals_polar")
		end
	end
end)