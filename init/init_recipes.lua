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
PolarRecipe("shards_bluegem", 		{Ingredient("bluegem_shards", 3)}, 															TECH.SCIENCE_TWO, 		{product = "bluegem", description = "shards_bluegem"}, 	{"REFINE"}, {"purplegem"})
PolarRecipe("polar_dryice", 		{Ingredient("ice", 6), Ingredient(TECH_INGREDIENT.POLARSNOW, 2)}, 							TECH.LOST, 				nil, 													{"REFINE"}, {"refined_dust"})

--	Tools / Weapons
PolarRecipe("trap_polarteeth", 		{Ingredient("ice", 1), Ingredient("cutstone", 1), Ingredient("polarwargstooth", 1)}, 						TECH.SCIENCE_TWO, 		nil, 	{"WEAPONS"}, {"trap_teeth"})

--	Armor / Clothing

--	Cooking / Food
PolarRecipe("polaricepack", 		{Ingredient("polar_dryice", 1), Ingredient("bluegem_shards", 2), Ingredient("mosquitosack", 1)}, 	TECH.SCIENCE_TWO, 		nil, 		{"COOKING"}, {"icepack"})

--	Decor / Structure
PolarRecipe("polarbearhouse", 		{Ingredient("boards", 4), Ingredient("polar_dryice", 3), Ingredient("polarbearfur", 4)}, 	TECH.SCIENCE_TWO, 		{placer = "polarbearhouse_placer"}, 	{"STRUCTURES"}, {"rabbithouse"})
PolarRecipe("turf_polar_caves", 	{Ingredient("ice", 2), Ingredient("rocks", 1)}, 											TECH.TURFCRAFTING_TWO, 	{numtogive = 4}, 						{"DECOR"}, {"turf_underrock"})
PolarRecipe("turf_polar_dryice", 	{Ingredient("polar_dryice", 1), Ingredient("bluegem", 1)}, 									TECH.SCIENCE_TWO, 		{numtogive = 4}, 						{"DECOR"}, {"turf_dragonfly"})
PolarRecipe("wall_polar_item", 		{Ingredient("polar_dryice", 2), Ingredient("bluegem", 1)}, 									TECH.SCIENCE_TWO, 		{numtogive = 6}, 						{"STRUCTURES", "DECOR"}, {"wall_moonrock_item", "wall_moonrock_item"})

--	[ 		Crafting Station	]	--

PolarRecipe("polaramulet_builder", 	{Ingredient("rope", 3)}, 		TECH.POLARAMULET_STATION, 	{image = "polaramulet.tex", manufactured = true, nounlock = true, sg_state = "give"}, 	{"CRAFTING_STATION"})
--	Those are TEMP !
PolarRecipe("bluegem_overcharged", 	{Ingredient("moose_polar_antler", 1), Ingredient("bluegem", 3)}, 											TECH.POLARAMULET_STATION, 	{nounlock = true, sg_state = "give"}, 								{"CRAFTING_STATION"})
PolarRecipe("polarcrownhat", 		{Ingredient("ice", 200), Ingredient("bluegem_overcharged", 1)}, 											TECH.LOST, 					{no_deconstruction = true, nounlock = true, sg_state = "give"}, 	{"CRAFTING_STATION"})--{"ARMOUR", "MAGIC"}, {"dreadstonehat", "dreadstonehat"})
PolarRecipe("frostwalkeramulet", 	{Ingredient("bluegem_shards", 3), Ingredient("bluegem_overcharged", 1)}, 									TECH.LOST, 					{no_deconstruction = true, nounlock = true, sg_state = "give"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"blueamulet"})
PolarRecipe("iciclestaff", 			{Ingredient("polar_dryice", 1), Ingredient("bluegem_overcharged", 1), Ingredient("deerclops_eyeball", 1)}, 	TECH.LOST, 					{no_deconstruction = true, nounlock = true, sg_state = "give"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"icestaff"})
PolarRecipe("polaricestaff", 		{Ingredient("antler_tree_stick", 1), Ingredient("bluegem_overcharged", 1)}, 								TECH.LOST, 					{no_deconstruction = true, nounlock = true, sg_state = "give"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"icestaff"})

--	[ 		Deconstruction		]	--

local AddDeconstructRecipe = ENV.AddDeconstructRecipe

AddDeconstructRecipe("polarmoosehat", {Ingredient("cutgrass", 3), Ingredient("boneshard", 2)})
--AddDeconstructRecipe("polar_spear", {Ingredient("ice", 1), Ingredient("twigs", 2)})