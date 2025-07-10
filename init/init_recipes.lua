local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function PolarRecipe(name, ingredients, tech, config, filters, order)
	if config == nil then
		config = {}
	end
	
	ENV.AddRecipe2(name, ingredients, tech, config, filters)
	ENV.AddRecipeToFilter(name, CRAFTING_FILTERS.MODS.name)
	
	if order then
		for i, filter in ipairs(filters) do
			if filter ~= "CRAFTING_STATION" then
				local FILTER = CRAFTING_FILTERS[filter]
				local resort = true
				for j, recipe in ipairs(FILTER.recipes) do
					if recipe == order[i] and resort then
						table.insert(FILTER.recipes, j + 1, name)
						resort = false
					elseif recipe == name and resort then
						table.remove(FILTER.recipes, j)
					else
						resort = true
					end
				end
			end
		end
	end
end

--	[ 	Station 	Defs	]	--

local POLAR_CRAFTING_ATLAS = "images/crafting_menu_polar.xml"

PROTOTYPER_DEFS["polarsnow"] = {icon_atlas = POLAR_CRAFTING_ATLAS, icon_image = "station_none.tex", is_crafting_station = false}
PROTOTYPER_DEFS["polaramulet_station"] = {icon_atlas = POLAR_CRAFTING_ATLAS, icon_image = "polaramulet_station.tex", action_str = "TRADE", is_crafting_station = true, filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.POLARAMULET_STATION}

local POLAR_TECHING = {"polarsnow_material"}

local OldIsTechIngredient = IsTechIngredient
function IsTechIngredient(ingredienttype, ...)
	if table.contains(POLAR_TECHING, ingredienttype) then
		return true
	end
	
	return OldIsTechIngredient(ingredienttype, ...)
end

--	[ 		Recipes			]	--

--	Refine
PolarRecipe("shards_bluegem", 		{Ingredient("bluegem_shards", 3)}, 														TECH.SCIENCE_TWO, 	{product = "bluegem", description = "shards_bluegem"}, 	{"REFINE"}, {"purplegem"})
PolarRecipe("polar_dryice", 		{Ingredient("ice", 6), Ingredient(TECH_INGREDIENT.POLARSNOW, 2)}, 						TECH.LOST, 			nil, 													{"REFINE"}, {"bearger_fur"})

--	Tools / Weapons
PolarRecipe("polar_spear", 			{Ingredient("ice", 1), Ingredient("twigs", 2)}, 										TECH.LOST, 			nil, 		{"WEAPONS"}, {"spear_wathgrithr_lightning"})
PolarRecipe("trap_polarteeth", 		{Ingredient("ice", 1), Ingredient("cutstone", 1), Ingredient("polarwargstooth", 1)}, 	TECH.SCIENCE_TWO, 	nil, 		{"WEAPONS"}, {"trap_teeth"})
PolarRecipe("winters_fists", 		{Ingredient("emperor_egg", 2), Ingredient("polar_dryice", 2)}, 							TECH.LOST, 			nil, 		{"WEAPONS", "SUMMER"}, {"wathgrithr_shield", "icehat"})

--	Armor / Clothing
PolarRecipe("armorpolar", 			{Ingredient("polarbearfur", 3), Ingredient("pigskin", 1)}, 								TECH.SCIENCE_TWO, 	nil, 		{"ARMOUR", "WINTER"}, {"armor_bramble", "raincoat"})
PolarRecipe("polarbearhat", 		{Ingredient("polarbearfur", 1), Ingredient("meat", 1)}, 								TECH.SCIENCE_ONE, 	nil, 		{"CLOTHING", "WINTER"}, {"beefalohat", "beefalohat"})
PolarRecipe("polarflea_sack", 		{Ingredient("polarbearfur", 2), Ingredient("polarflea", 2), Ingredient("cutreeds", 6)}, TECH.SCIENCE_TWO, 	nil, 		{"CONTAINERS", "WINTER"}, {"spicepack", "beargervest"})

--	Cooking / Food
PolarRecipe("polaricepack", 		{Ingredient("polar_dryice", 1), Ingredient("bluegem_shards", 2), Ingredient("mosquitosack", 1)}, 	TECH.SCIENCE_TWO, 	nil, 	{"COOKING"}, {"icepack"})

--	Boating / Fishing
PolarRecipe("polarice_plow_item", 	{Ingredient("log", 3), Ingredient("cutstone", 1), Ingredient("mole", 1)}, 	TECH.SEAFARING_ONE, 	nil, 	{"FISHING", "WINTER"}, {"ocean_trawler_kit", "winterometer"})

--	Decor / Structure
PolarRecipe("polar_brazier_item", 	{Ingredient("boneshard", 3), Ingredient("cutstone", 1), Ingredient("rope", 1)}, 			TECH.LOST, 				nil, 									{"LIGHT", "STRUCTURES", "WINTER"}, {"dragonflyfurnace", "dragonflyfurnace", "dragonflyfurnace"})
PolarRecipe("polarbearhouse", 		{Ingredient("boards", 4), Ingredient("polar_dryice", 3), Ingredient("polarbearfur", 4)}, 	TECH.SCIENCE_TWO, 		{placer = "polarbearhouse_placer"}, 	{"STRUCTURES"}, {"rabbithouse"})
PolarRecipe("turf_polar_caves", 	{Ingredient("ice", 2), Ingredient("rocks", 1)}, 											TECH.TURFCRAFTING_TWO, 	{numtogive = 4}, 						{"DECOR"}, {"turf_underrock"})
PolarRecipe("turf_polar_dryice", 	{Ingredient("polar_dryice", 1), Ingredient("bluegem", 1)}, 									TECH.SCIENCE_TWO, 		{numtogive = 4}, 						{"DECOR"}, {"turf_dragonfly"})
PolarRecipe("wall_polar_item", 		{Ingredient("polar_dryice", 2), Ingredient("bluegem", 1)}, 									TECH.SCIENCE_TWO, 		{numtogive = 6}, 						{"STRUCTURES", "DECOR"}, {"wall_moonrock_item", "wall_moonrock_item"})

PolarRecipe("chesspiece_emperor_penguin_fruity_builder", 	{Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, 	{nounlock = true, actionstr = "SCULPTING", image = "chesspiece_emperor_penguin_fruity.tex"}, 	{"CRAFTING_STATION"}, {"chesspiece_sharkboi_builder"})
PolarRecipe("chesspiece_emperor_penguin_juggle_builder", 	{Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, 	{nounlock = true, actionstr = "SCULPTING", image = "chesspiece_emperor_penguin_juggle.tex"}, 	{"CRAFTING_STATION"}, {"chesspiece_sharkboi_builder"})
PolarRecipe("chesspiece_emperor_penguin_magestic_builder", 	{Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, 	{nounlock = true, actionstr = "SCULPTING", image = "chesspiece_emperor_penguin_magestic.tex"}, 	{"CRAFTING_STATION"}, {"chesspiece_sharkboi_builder"})
PolarRecipe("chesspiece_emperor_penguin_spin_builder", 		{Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, 	{nounlock = true, actionstr = "SCULPTING", image = "chesspiece_emperor_penguin_spin.tex"}, 		{"CRAFTING_STATION"}, {"chesspiece_sharkboi_builder"})

--	Events
PolarRecipe("arctic_fool_fish", 			{Ingredient("papyrus", 1), Ingredient("silk", 1)}, 						TECH.ARCTIC_FOOLS, 				{numtogive = 4, hint_msg = "NEEDSARCTIC_FOOL"}, 													{"SPECIAL_EVENT"})
PolarRecipe("snowball_item_polar", 			{Ingredient("ice", 1), Ingredient(TECH_INGREDIENT.POLARSNOW, 2)}, 		TECH.WINTERS_FEAST, 			{product = "snowball_item", description = "snowball_item_polar", hint_msg = "NEEDSWINTERS_FEAST"}, 	{"SPECIAL_EVENT"}, {"giftwrap"})
PolarRecipe("wintercooking_polarcrablegs",	{Ingredient("wintersfeastfuel", 1), Ingredient("polarflea", 2)}, 		TECH.WINTERSFEASTCOOKING_ONE, 	{nounlock = true, manufactured = true, actionstr = "COOK", image = "polarcrablegs.tex"}, 			{"CRAFTING_STATION"}, {"wintercooking_tourtiere"})

--	Survivors
PolarRecipe("wx78module_naughty", 		{Ingredient("scandata", 4), Ingredient("charcoal", 2)}, 	TECH.ROBOTMODULECRAFT_ONE, 		{builder_tag = "upgrademoduleowner", nounlock = false}, 	{"CHARACTER", "MAGIC"}, {"wx78module_light", "nightmarefuel"})

--	[ 	Crafting Station	]	--

PolarRecipe("polaramulet_builder", 		{Ingredient("rope", 3)}, 		TECH.POLARAMULET_STATION, 	{image = "polaramulet.tex", manufactured = true, nounlock = true, sg_state = "give"}, 	{"CRAFTING_STATION"})

PolarRecipe("bluegem_overcharged", 		{Ingredient("moose_polar_antler", 1), Ingredient("bluegem", 1)}, 											TECH.POLARAMULET_STATION, 	{nounlock = true, sg_state = "give"}, 																{"CRAFTING_STATION"})
PolarRecipe("polarcrownhat", 			{Ingredient("ice", 200), Ingredient("bluegem_overcharged", 1)}, 											TECH.LOST, 					{nounlock = true, actionstr = "TRADE", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})--{"ARMOUR", "MAGIC"}, {"dreadstonehat", "dreadstonehat"})
PolarRecipe("frostwalkeramulet", 		{Ingredient("bluegem_shards", 3), Ingredient("bluegem_overcharged", 1)}, 									TECH.LOST, 					{nounlock = true, actionstr = "TRADE", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"blueamulet"})
PolarRecipe("iciclestaff", 				{Ingredient("polar_dryice", 1), Ingredient("bluegem_overcharged", 1), Ingredient("deerclops_eyeball", 1)}, 	TECH.LOST, 					{nounlock = true, actionstr = "TRADE", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"icestaff"})
PolarRecipe("polaricestaff", 			{Ingredient("antler_tree_stick", 1), Ingredient("bluegem_overcharged", 1)}, 								TECH.LOST, 					{nounlock = true, actionstr = "TRADE", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"icestaff"})
PolarRecipe("polar_lavae_tooth", 		{Ingredient("lavae_egg", 1), Ingredient("redgem", 2)}, 														TECH.LOST, 					{product = "lavae_tooth", description = "polar_lavae_tooth", nounlock = true, actionstr = "TRADE", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})

PolarRecipe("polar_fishingrod",			{Ingredient("smallmeat", 2)}, 							TECH.POLARAMULET_STATION, 	{product = "fishingrod", nounlock = true, image = "fishingrod.tex", actionstr = "TRADE", sg_state = "give"}, 			{"CRAFTING_STATION"})
PolarRecipe("polar_oceanfishingrod",	{Ingredient("fishingrod", 1), Ingredient("meat", 4)}, 	TECH.POLARAMULET_STATION, 	{product = "oceanfishingrod", nounlock = true, image = "oceanfishingrod.tex", actionstr = "TRADE", sg_state = "give"}, 	{"CRAFTING_STATION"})
--PolarRecipe("polar_birdtrap",			{Ingredient("fishmeat", 2)}, 							TECH.POLARAMULET_STATION, 	{product = "birdtrap", nounlock = true, image = "birdtrap.tex", actionstr = "TRADE", sg_state = "give"}, 				{"CRAFTING_STATION"}) Note: ...not useful... frost tails do the job and trader said it won't trade fish!
PolarRecipe("winters_fists_blueprint", 	{Ingredient("papyrus", 1), Ingredient("emperor_egg", 1)}, 													TECH.POLARAMULET_STATION, 	{nounlock = true, image = "blueprint_rare.tex", actionstr = "TRADE", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})

--	[ 	Deconstruction		]	--

local AddDeconstructRecipe = ENV.AddDeconstructRecipe

AddDeconstructRecipe("emperor_penguinhat", 	{Ingredient("fishmeat_small", 4), Ingredient("ice", 20)})
AddDeconstructRecipe("compass_polar", 		{Ingredient("compass", 1), Ingredient("ice", 3)})
AddDeconstructRecipe("polar_brazier", 		{Ingredient("boneshard", 3), Ingredient("cutstone", 1), Ingredient("rope", 1)})
AddDeconstructRecipe("polaramulet", 		{Ingredient("rope", 3), Ingredient("nightmarefuel", 1)})
AddDeconstructRecipe("polarmoosehat", 		{Ingredient("cutgrass", 6), Ingredient("boneshard", 4), Ingredient("polarflea", 2)})
AddDeconstructRecipe("tower_polar_flag", 	{Ingredient("tower_polar_flag_item", 1)})