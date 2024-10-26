local POLAR_SCRAPBOOK = {
	--	Items / Foods
	polar_dryice = {type = "item", subcat = "element", stacksize = 40, hungervalue = 9.375, healthvalue = 2, sanityvalue = 0, foodtype = "ELEMENTAL", build = "polar_dryice", bank = "polar_dryice", anim = "f1", perishable = 19200},
	polarbearfur = {type = "item", stacksize = 20, build = "polarbearfur", bank = "polarbearfur", anim = "idle", fueltype = "BURNABLE", fuelvalue = 45, burnable = true},
	wall_polar_item = {type = "item", subcat = "wall", stacksize = 20, build = "wall_polar", bank = "wall", anim = "idle", deps = {"polar_dryice"}, specialinfo = "WALL_POLAR"},
	
	--	Creatures / Giants
	polarbear = {type = "creature", health = 500, damage = 33, hide = {"hat", "ARM_carry_up"}, build = "polarbear_build", bank = "pigman", anim = "idle_loop", deps = {"meat", "polarbearfur"}},
	
	--	Things / POI
	polarbearhouse = {type = "thing", subcat = "structure", build = "polarbearhouse", bank = "polarbearhouse", anim = "idle", workable = "HAMMER", burnable = true, deps = {"boards", "polar_dryice", "polarbear", "polarbearfur"}},
	wall_polar = {type = "thing", subcat = "wall", health = 600, repairitems = {"polar_dryice", "wall_polar_item"}, workable = "HAMMER", build = "wall_polar", bank = "wall", anim = "half", deps = {"wall_polar_item"}, specialinfo = "WALL_POLAR"},
}

return POLAR_SCRAPBOOK