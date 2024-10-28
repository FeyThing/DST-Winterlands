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

--	Refine
PolarRecipe("polar_dryice", 		{Ingredient("ice", 4)}, 																	TECH.SCIENCE_TWO, 		nil, 									{"REFINE"}, {"cutstone"})

--	Structures
PolarRecipe("polarbearhouse", 		{Ingredient("boards", 4), Ingredient("polar_dryice", 3), Ingredient("polarbearfur", 4)}, 	TECH.SCIENCE_TWO, 		{placer = "polarbearhouse_placer"}, 	{"STRUCTURES"}, {"rabbithouse"})
PolarRecipe("wall_polar_item", 		{Ingredient("polar_dryice", 2)}, 															TECH.LOST, 				{numtogive = 6}, 						{"STRUCTURES", "DECOR"}, {"wall_stone_item", "wall_stone_item"})

--	Deconstruction
local AddDeconstructRecipe = ENV.AddDeconstructRecipe

--AddDeconstructRecipe("polar_spear", {Ingredient("ice", 1), Ingredient("twigs", 2)})