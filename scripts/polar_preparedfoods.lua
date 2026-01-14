local polar_preparedfoods = {
	iceburrito = {
		test = function(cooker, names, tags) return names.icelettuce and (names.oceanfish_medium_8_inv or names.oceanfish_medium_polar1_inv) end,
		hunger = TUNING.CALORIES_SMALL * 4,
		health = TUNING.HEALING_MEDLARGE,
		sanity = 0,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_LONG,
		perishtime = TUNING.PERISH_FAST,
		foodtype = FOODTYPE.MEAT,
		cooktime = 0.5,
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
	
	filet_o_flea = {
		test = function(cooker, names, tags) return tags.monster and tags.monster >= 1 and names.polarflea end,
		hunger = TUNING.CALORIES_SMALL * 4,
		health = -TUNING.HEALING_MED,
		sanity = -TUNING.SANITY_MEDLARGE,
		perishtime = TUNING.PERISH_SLOW,
		foodtype = FOODTYPE.MEAT,
		cooktime = 0.5,
		priority = 15,
		tags = {"monstermeat"},
		secondaryfoodtype = FOODTYPE.MONSTER,
		potlevel = "low",
		floater = {"med", nil, 0.58},
	},
	
	koalefried_trunk_summer = {
		test = function(cooker, names, tags) return (names.trunk_summer or names.trunk_cooked) and (names.onion or names.onion_cooked or names.potato or names.potato_cooked) and ((tags.meat and tags.meat >= 2) or (tags.veggie and tags.veggie >= 2)) end,
		hunger = TUNING.CALORIES_SMALL * 8,
		health = TUNING.HEALING_LARGE,
		sanity = TUNING.SANITY_LARGE,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		perishtime = TUNING.PERISH_MED,
		foodtype = FOODTYPE.MEAT,
		cooktime = 2,
		priority = 30,
		potlevel = "low",
		floater = {"med", nil, 0.68},
		prefabs = {"buff_huntmoar"},
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_HUNTMOAR_KOALEFANTS,
		oneatenfn = function(inst, eater)
			if eater.components.debuffable == nil then
				eater:AddComponent("debuffable")
			end
			
			local buff = eater.components.debuffable:AddDebuff("buff_huntmoar", "buff_huntmoar")
			if buff then
				buff.mode = "normal"
			end
		end,
		card_def = {ingredients = {{"trunk_cooked", 1}, {"onion", 1}, {"carrot", 2}}},
	},
	
	koalefried_trunk_winter = {
		test = function(cooker, names, tags) return names.trunk_winter and (names.onion or names.onion_cooked or names.potato or names.potato_cooked) and ((tags.meat and tags.meat >= 2) or (tags.veggie and tags.veggie >= 2)) end,
		hunger = TUNING.CALORIES_SMALL * 8,
		health = TUNING.HEALING_LARGE,
		sanity = TUNING.SANITY_LARGE,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		perishtime = TUNING.PERISH_MED,
		foodtype = FOODTYPE.MEAT,
		cooktime = 2,
		priority = 30,
		potlevel = "low",
		floater = {"med", nil, 0.68},
		prefabs = {"buff_huntmoar"},
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_HUNTMOAR_SURPRISES,
		oneatenfn = function(inst, eater)
			if eater.components.debuffable == nil then
				eater:AddComponent("debuffable")
			end
			
			local buff = eater.components.debuffable:AddDebuff("buff_huntmoar", "buff_huntmoar")
			if buff then
				buff.mode = "monster"
			end
		end,
		card_def = {ingredients = {{"trunk_winter", 1}, {"potato", 2}, {"onion", 1}}},
	},
	
	-- Alt recipes, postinit/components/stewer is where its at
	
	jellybean_fleaeggs = {
		test = function(cooker, names, tags) return names.polarfleaeggsack and not tags.inedible and not tags.monster end,
		name = "jellybean_fleaeggs",
		hunger = 0,
		health = TUNING.JELLYBEAN_TICK_VALUE,
		sanity = TUNING.SANITY_TINY,
		perishtime = nil,
		foodtype = FOODTYPE.GOODIES,
		cooktime = 2.5,
		priority = 12,
		stacksize = 1,
		tags = {"honeyed"},
		potlevel = "low",
		floater = {"small", nil, 0.85},
		noprefab = true,
		no_cookbook = true,
		overridebuild = "cook_pot_food",
		overridesymbolname = "jellybean",
		scrapbook_healthvalue = 122,
	},
	
	icecream_emperor = {
		test = function(cooker, names, tags) return names.emperor_egg and not tags.inedible and not tags.monster end,
		name = "icecream_emperor",
		hunger = TUNING.CALORIES_MED,
		health = 0,
		sanity = TUNING.SANITY_HUGE,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_LONG,
		perishtime = TUNING.PERISH_SUPERFAST,
		foodtype = FOODTYPE.GOODIES,
		cooktime = 0.5,
		priority = 40,
		stacksize = 6,
		potlevel = "low",
		floater = {"small", nil, nil},
		noprefab = true,
		no_cookbook = true,
		overridebuild = "cook_pot_food",
		overridesymbolname = "icecream",
		card_def = {ingredients = {{"emperor_egg", 1}, {"ice", 2}, {"honey", 1}}},
	},
}

for k, v in pairs(polar_preparedfoods) do
	v.name = v.name or k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
	
	if not v.no_cookbook then
		v.overridebuild = "cook_pot_food_polar"
		v.cookbook_atlas = "images/cookbook_polar.xml"
		v.cookbook_tex = "cookbook_"..k..".tex"
	end
	
	v.cookbook_category = "cookpot"
end

return polar_preparedfoods