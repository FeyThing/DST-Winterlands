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

--	[ 	Station Defs	]	--

PROTOTYPER_DEFS["polarsnow"] = {icon_atlas = CRAFTING_ICONS_ATLAS, icon_image = "station_none.tex", is_crafting_station = false}

local OldIsTechIngredient = IsTechIngredient
local POLAR_TECHING = {"polarsnow_material"}
function IsTechIngredient(ingredienttype, ...)
	if table.contains(POLAR_TECHING, ingredienttype) then
		return true
	end
	
	return OldIsTechIngredient(ingredienttype, ...)
end

--	[ 		Recipes		]	--

--	Refine
PolarRecipe("polar_dryice", 		{Ingredient("ice", 4)--[[, Ingredient(TECH_INGREDIENT.POLARSNOW, 1)]]}, 					TECH.SCIENCE_TWO, 		nil, 									{"REFINE"}, {"refined_dust"})

--	Structures
PolarRecipe("polarbearhouse", 		{Ingredient("boards", 4), Ingredient("polar_dryice", 3), Ingredient("polarbearfur", 4)}, 	TECH.SCIENCE_TWO, 		{placer = "polarbearhouse_placer"}, 	{"STRUCTURES"}, {"rabbithouse"})
PolarRecipe("turf_polar_caves", 	{Ingredient("ice", 2), Ingredient("rocks", 1)}, 											TECH.TURFCRAFTING_TWO, 	{numtogive = 4}, 						{"DECOR"}, {"turf_underrock"})
PolarRecipe("turf_polar_dryice", 	{Ingredient("polar_dryice", 1), Ingredient("bluegem", 1)}, 									TECH.LOST, 				{numtogive = 4}, 						{"DECOR"}, {"turf_dragonfly"})
PolarRecipe("wall_polar_item", 		{Ingredient("polar_dryice", 2)}, 															TECH.LOST, 				{numtogive = 6}, 						{"STRUCTURES", "DECOR"}, {"wall_moonrock_item", "wall_moonrock_item"})

--	Deconstruction
local AddDeconstructRecipe = ENV.AddDeconstructRecipe

--AddDeconstructRecipe("polar_spear", {Ingredient("ice", 1), Ingredient("twigs", 2)})