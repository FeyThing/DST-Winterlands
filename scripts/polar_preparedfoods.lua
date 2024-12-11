local polar_preparedfoods = {
	iceburrito = {
		test = function(cooker, names, tags) return names.icelettuce and (names.oceanfish_medium_8_inv or names.oceanfish_medium_polar1_inv) end,
		hunger = TUNING.CALORIES_SMALL * 4,
		health = TUNING.HEALING_MEDLARGE,
		sanity = 0,
		cooktime = 0.5,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		priority = 30,
		tags = {"catfood"},
		floater = {"med", 0, {1, 0.8, 1}},
		prefabs = {"buff_polarimmunity"},
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_ICELETTUCE,
		oneatenfn = function(inst, eater)
			EatIceLettuce(inst, eater, TUNING.POLAR_IMMUNITY_DURATION_LONG, TUNING.ICELETTUCE_FREEZABLE_COLDNESS, TUNING.ICELETTUCE_COOLING)
		end,
		card_def = {ingredients = {{"icelettuce", 2}, {"oceanfish_medium_polar1_inv", 1}, {"tomato", 1}}},
	},
}

for k, v in pairs(polar_preparedfoods) do
	v.name = k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
	v.overridebuild = "cook_pot_food_polar"
	v.cookbook_atlas = "images/cookbook_polar.xml"
	v.cookbook_tex = "cookbook_"..k..".tex"
	v.cookbook_category = "cookpot"
end

return polar_preparedfoods