local POLAR_SCRAPBOOK = {
	--	Items / Foods
	polar_dryice = {type = "item", subcat = "element", stacksize = 40, hungervalue = 9.375, healthvalue = 2, sanityvalue = 0, foodtype = "ELEMENTAL", build = "polar_dryice", bank = "polar_dryice", anim = "f1", perishable = 19200},
	polarbearfur = {type = "item", stacksize = 20, build = "polarbearfur", bank = "polarbearfur", anim = "idle", fueltype = "BURNABLE", fuelvalue = 45, burnable = true},
	polarmoosehat = {type = "item", subcat = "hat", insulator = 240, insulator_type = "winter", waterproofer = 0.2, dapperness = 0.022222222222222, fueledmax = 2400, fueledrate = 1, fueledtype1 = "USAGE", sewable = true, build = "hat_polarmoose", bank = "polarmoosehat", anim = "anim"},
	wall_polar_item = {type = "item", subcat = "wall", stacksize = 20, build = "wall_polar", bank = "wall", anim = "idle", deps = {"polar_dryice", "wall_polar"}, specialinfo = "WALL_POLAR"},
	
	--	Creatures / Giants
	polarbear = {type = "creature", health = 800, damage = "50-75", hide = {"hat", "ARM_carry_up"}, build = "polarbear_build", bank = "pigman", anim = "idle_loop", deps = {"meat", "polarbearfur"}},
	polarfox = {type = "creature", health = 300, damage = 20, build = "polarfox", bank = "polarfox", anim = "idle", animoffsety = -20, deps = {"smallmeat", "manrabbit_tail"}},
	polarwarg = {type = "creature", health = 1300, damage = 60, build = "warg_polar", bank = "warg", anim = "idle_loop", deps = {"houndstooth", "icehound", "monstermeat"}},
	shadow_icicler = {type = "creature", subcat = "shadow", health = 200, damage = 35, build = "shadow_polar_basic", bank = "shadowcreaturepolar", anim = "idle_loop", deps = {"nightmarefuel"}, notes = {shadow_aligned = true}},
	
	--	Things / POI
	antler_tree = {type = "thing", subcat = "tree", workable = "CHOP", burnable = true, build = "antler_tree", bank = "antler_tree", anim = "idle", deps = {"log", "twigs"}},
	polar_icicle = {type = "thing", damage = 300, build = "icicle_roof", bank = "icicle_roof", anim = "idle_med", deps = {"polar_icicle_rock"}},
	polar_icicle_rock = {type = "thing", damage = 300, workable = "MINE", build = "icicle_rock", bank = "icicle_rock", anim = "med", deps = {"ice"}},
	polarbearhouse = {type = "thing", subcat = "structure", workable = "HAMMER", burnable = true, build = "polarbearhouse", bank = "polarbearhouse", anim = "idle", deps = {"boards", "polar_dryice", "polarbear", "polarbearfur"}},
	rock_polar = {type = "thing", workable = "MINE", build = "polar_rocks", bank = "polar_rocks", anim = "idle_full", deps = {"bluegem", "ice"}},
	wall_polar = {type = "thing", subcat = "wall", health = 600, repairitems = {"polar_dryice", "wall_polar_item"}, workable = "HAMMER", build = "wall_polar", bank = "wall", anim = "half", deps = {"wall_polar_item"}, specialinfo = "WALL_POLAR"},
}

return POLAR_SCRAPBOOK