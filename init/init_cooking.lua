local Cooking = require("cooking")
	
--	Ingredients
	
	AddIngredientValues({"polar_dryice"}, {frozen = 2})
	AddIngredientValues({"icelettuce"}, {veggie = 1, frozen = 1})
	AddIngredientValues({"oceanfish_medium_polar1_inv"}, {meat = 1, fish = 1})
	
--	Add Recipes
	
	local cookpots = {"cookpot", "portablecookpot", "archive_cookpot"}
	local cookpots_master = {"portablecookpot"}
	local spicers = {"portablespicer"}
	
	local polar_recipes = require("polar_preparedfoods")
	local spiced_recipes = require("polar_spicedfoods")
	local recipe_cards = Cooking.recipe_cards
	
	for _, cooker in pairs(cookpots) do for _, recipe in pairs(polar_recipes) do AddCookerRecipe(cooker, recipe) end end
	for _, cooker in pairs(spicers) do for _, recipe in pairs(spiced_recipes) do AddCookerRecipe(cooker, recipe) end end
	for _, recipe in pairs(polar_recipes) do if recipe.card_def then table.insert(recipe_cards, {recipe_name = recipe.name, cooker_name = "cookpot"}) end end