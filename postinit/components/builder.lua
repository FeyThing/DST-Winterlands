local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local BEAR_TAGS = {"polarbear", "_combat"}
local BEAR_NOT_TAGS = {"bear_major", "INLIMBO", "isdead"}

local function HasPolarIngredient(self, ingredient)
	if ingredient.type and ingredient.type == "polarsnow_material" then
		return self.inst.nearhighsnow:value()
	end
	
	if ingredient.type and ingredient.type == "polarbear_material" then
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local bears = TheSim:FindEntities(x, y, z, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS, BEAR_TAGS, BEAR_NOT_TAGS)
		local angries = 0
		
		for _, bear in ipairs(bears) do
			if bear:HasTag("hostile") then
				angries = angries + 1
			end
		end
		
		if #bears - angries >= ingredient.amount then
			return true
		end
	end
end

local Builder = require("components/builder")
	
	local OldDoBuild = Builder.DoBuild
	function Builder:DoBuild(recname, pt, ...)
		local recipe = recname and GetValidRecipe(recname)
		local block_range = TUNING.SNOW_PLOW_RANGES.REPLACED or 0
		
		-- Building structures (deploying too) creates a short High Snow blocker
		if recipe and recipe.placer and block_range > 0 then
			local duration = GetPolarPlowDuration(self.inst, nil, "building")
			SpawnPolarSnowBlocker(pt, block_range, duration, self.inst)
		end
		
		return OldDoBuild(self, recname, pt, ...)
	end
	
	local OldHasTechIngredient = Builder.HasTechIngredient
	function Builder:HasTechIngredient(ingredient, ...)
		return HasPolarIngredient(self, ingredient) or OldHasTechIngredient(self, ingredient, ...)
	end
	
	local OldRemoveIngredients = Builder.RemoveIngredients
	function Builder:RemoveIngredients(ingredients, recname, discounted, ...)
		OldRemoveIngredients(self, ingredients, recname, discounted, ...)
		
		-- Bear Rug crafting consumes only 1 use of a Sewing Kit, not the full item.
		
		-- NOTE: Keep an eye out for future game updates if this type of system becomes officially supported, outside of here...
		-- it's kind of wacky but we have no better space when it comes to buffered recipes
		local recipe = recname and GetValidRecipe(recname)
		if recname == "polarbear_rug" and recipe and not self.freebuildmode then
			for k, v in pairs(recipe.ingredients) do
				if v.type == "sewing_kit" and v.amount == 0 then
					local inventory = self.inst.components.inventory or self.inst.components.container
					
					local sewing_kit = inventory and inventory:FindItem(function(item) return item.prefab == "sewing_kit" end)
					if sewing_kit and sewing_kit.components.finiteuses then
						sewing_kit.components.finiteuses:Use(1)
						break
					end
				end
			end
		end
	end
	
--

local BuilderReplica = require("components/builder_replica")
	
	local OldHasTechIngredientReplica = BuilderReplica.HasTechIngredient
	function BuilderReplica:HasTechIngredient(ingredient, ...)
		return HasPolarIngredient(self, ingredient) or OldHasTechIngredientReplica(self, ingredient, ...)
	end