local polar_preparedfoods_warly = {
	dryicecream = {
		test = function(cooker, names, tags) return names.polar_dryice and tags.inedible and tags.inedible >= 1 end,
		hunger = TUNING.CALORIES_LARGE,
		health = 0,
		sanity = TUNING.SANITY_TINY,
		cooktime = 0.5,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		priority = 20,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		floater = {"med", nil, 0.5},
		tags = {"masterfood"},
		prefabs = {"buff_polarimmunity"},
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_ICELETTUCE,
		oneatenfn = function(inst, eater)
			EatIceLettuce(inst, eater, TUNING.POLAR_IMMUNITY_DURATION_SHORT)
		end,
	},
}

for k, v in pairs(polar_preparedfoods_warly) do
	v.name = k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
	v.overridebuild = v.overridebuild or "cook_pot_food_polar"
	v.cookbook_atlas = "images/cookbook_polar.xml"
	v.cookbook_tex = "cookbook_"..k..".tex"
	v.cookbook_category = "portablecookpot"
end

return polar_preparedfoods_warly