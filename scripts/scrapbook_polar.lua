local POLAR_SCRAPBOOK = {
	--	Items / Foods
	antler_tree_stick = {type = "item", subcat = "weapon", weapondamage = 48, finiteuses = 625, fueledmax = 4800, fueledrate = 1, fueledtype1 = "USAGE", build = "antler_tree_stick", bank = "antler_tree_stick", anim = "idle", specialinfo = "ANTLER_TREE_STICK"},
	bluegem_overcharged = {type = "item", subcat = "element", stacksize = 40, hungervalue = 1, healthvalue = 10, sanityvalue = 0, foodtype = "ELEMENTAL", build = "bluegem_overcharged", bank = "bluegem_overcharged", anim = "idle"},
	bluegem_shards = {type = "item", subcat = "element", stacksize = 40, hungervalue = 1, healthvalue = 10, sanityvalue = 0, foodtype = "ELEMENTAL", build = "bluegem_shards", bank = "bluegem_shards", anim = "idle", deps = {"bluegem"}},
	icelettuce = {type = "food", stacksize = 40, hungervalue = 18.75, healthvalue = 10, sanityvalue = 5, foodtype = "VEGGIE", perishable = 1440, burnable = true, build = "icelettuce", bank = "icelettuce", anim = "idle", deps = {"icelettuce_seeds"}, specialinfo = "ICELETTUCE"},
	icelettuce_seeds = {type = "food", subcat = "tackle", stacksize = 40, hungervalue = 9.375, healthvalue = 0.5, sanityvalue = 0, foodtype = "SEEDS", perishable = 19200, lure_charm = 0.2, lure_dist = 1, lure_radius = 3, burnable = true, build = "polar_seeds", bank = "polar_seeds", anim = "icelettuce", deps = {"farm_plant_icelettuce", "seeds_cooked", "spoiled_food"}},
	polar_dryice = {type = "item", subcat = "element", stacksize = 40, hungervalue = 9.375, healthvalue = 2, sanityvalue = 0, foodtype = "ELEMENTAL", build = "polar_dryice", bank = "polar_dryice", anim = "f1", perishable = 19200},
	polarbearfur = {type = "item", stacksize = 20, build = "polarbearfur", bank = "polarbearfur", anim = "idle", fueltype = "BURNABLE", fuelvalue = 45, burnable = true},
	polaricepack = {type = "item", perishable = 28800, build = "polaricepack", bank = "polaricepack", anim = "idle", deps = {"bluegem_shards", "polar_dryice", "mosquito_sack"}, specialinfo = "POLARICEPACK"},
	polarmoosehat = {type = "item", subcat = "hat", insulator = 240, insulator_type = "winter", waterproofer = 0.2, dapperness = 0.022222222222222, fueledmax = 2400, fueledrate = 1, fueledtype1 = "USAGE", sewable = true, build = "hat_polarmoose", bank = "polarmoosehat", anim = "anim"},
	polartrinket_1 = {type = "item", subcat = "trinket", stacksize = 40, build = "polartrinkets", bank = "polartrinkets", anim = "1"},
	polartrinket_2 = {type = "item", subcat = "trinket", stacksize = 40, build = "polartrinkets", bank = "polartrinkets", anim = "2"},
	polarwargstooth = {type = "item", stacksize = 10, perishable = 7200, build = "polarwarg_tooth", bank = "polarwarg_tooth", anim = "idle"},
	wall_polar_item = {type = "item", subcat = "wall", stacksize = 20, build = "wall_polar", bank = "wall", anim = "idle", deps = {"polar_dryice", "wall_polar"}, specialinfo = "WALL_POLAR"},
	winter_ornament_polar_icicle_blue = {type = "item", subcat = "ornament", name = "winter_ornamentpolar", speechname = "winter_ornamentpolar", stacksize = 40, build = "winter_ornaments_polar", bank = "winter_ornaments_polar", anim = "polar_icicle_blue", deps = {"tumbleweed_polar"}, specialinfo = "WINTERTREE_ORNAMENT"},
	winter_ornament_polar_icicle_white = {type = "item", subcat = "ornament", name = "winter_ornamentpolar", speechname = "winter_ornamentpolar", stacksize = 40, build = "winter_ornaments_polar", bank = "winter_ornaments_polar", anim = "polar_icicle_white", deps = {"tumbleweed_polar"}, specialinfo = "WINTERTREE_ORNAMENT"},
	
	--	Creatures / Giants
	moose_polar = {type = "creature", health = 1000, damage = "35-50", build = "moose_polar", bank = "deer", anim = "idle", hide = {"CHAIN"}, overridesymbol = {{"swap_neck_collar", "moose_polar", "swap_neck"}, {"swap_antler_red", "moose_polar", "swap_antler1"}}, deps = {"boneshard", "meat", "antler_tree", "antler_tree_stick"}},
	polarbear = {type = "creature", health = 800, damage = "50-75", hide = {"hat", "ARM_carry_up"}, build = "polarbear_build", bank = "pigman", anim = "idle_loop", deps = {"meat", "polarbearfur"}},
	polarfox = {type = "creature", health = 200, build = "polarfox", bank = "polarfox", anim = "idle", animoffsety = -20, deps = {"smallmeat", "manrabbit_tail"}},
	polarwarg = {type = "creature", health = 1300, damage = 60, build = "warg_polar", bank = "warg", anim = "idle_loop", deps = {"houndstooth", "icehound", "monstermeat"}},
	shadow_icicler = {type = "creature", subcat = "shadow", health = 200, damage = 35, build = "shadow_polar_basic", bank = "shadowcreaturepolar", anim = "idle_loop", deps = {"nightmarefuel"}, notes = {shadow_aligned = true}},
	
	--	Things / POI
	antler_tree = {type = "thing", subcat = "tree", workable = "CHOP", burnable = true, build = "antler_tree", bank = "antler_tree", anim = "idle", deps = {"antler_tree_stick", "charcoal", "log", "twigs"}, specialinfo = "ANTLER_TREE"},
	farm_plant_icelettuce = {type = "thing", subcat = "farmplant", workable = "DIG", burnable = true, speechname = "FARM_PLANT", build = "farm_plant_icelettuce", bank = "farm_plant_icelettuce", anim = "crop_full", overridesymbol = {"soil01", "farm_soil", "soil01"}, deps = {"spoiled_food", "icelettuce", "icelettuce_seeds"}},
	grass_polar = {type = "thing", workable = "DIG", pickable = true, burnable = true, build = "grass_polar", bank = "grass_tall", anim = "idle", deps = {"cutgrass", "cutreeds", "dug_grass"}, specialinfo = "NEEDFERTILIZER"},
	polar_icicle = {type = "thing", damage = 300, build = "icicle_roof", bank = "icicle_roof", anim = "idle_med", deps = {"polar_icicle_rock", "winter_ornament_polar_icicle_blue", "winter_ornament_polar_icicle_white"}},
	polar_icicle_rock = {type = "thing", damage = 300, workable = "MINE", build = "icicle_rock", bank = "icicle_rock", anim = "med", deps = {"ice"}},
	polarbearhouse = {type = "thing", subcat = "structure", workable = "HAMMER", burnable = true, build = "polarbearhouse", bank = "polarbearhouse", anim = "idle", deps = {"boards", "polar_dryice", "polarbear", "polarbearfur"}},
	rock_polar = {type = "thing", workable = "MINE", build = "rock_polar", bank = "rock_polar", anim = "idle_full", deps = {"bluegem", "bluegem_shards", "ice"}},
	tumbleweed_polar = {type = "thing", pickable = true, build = "tumbleweed_polar", bank = "tumbleweed_polar", anim = "idle", deps = {"antler_tree_stick", "berries", "bird_egg", "blowdart_pipe", "bluegem", "bluegem_shards", "blueprint", "boneshard", "cookingrecipecard", "dug_grass", "dug_marsh_bush", "feather_crow", "feather_robin_winter", "fishsticks", "furtuft", "greengem", "houndstooth", "ice", "icelettuce", "icelettuce_seeds", "mole", "polarbearfur", "polarfox", "polartrinket_1", "polartrinket_2", "purplegem", "rabbit", "rottenegg", "scrapbook_page", "seeds", "spider_dropper", "spoiled_fish", "spoiled_fish_small", "winter_ornament_polar_icicle_blue", "winter_ornament_polar_icicle_white", "wobster_sheller_land"}},
	wall_polar = {type = "thing", subcat = "wall", health = 600, repairitems = {"polar_dryice", "wall_polar_item"}, workable = "HAMMER", build = "wall_polar", bank = "wall", anim = "half", deps = {"wall_polar_item"}, specialinfo = "WALL_POLAR"},
}

return POLAR_SCRAPBOOK