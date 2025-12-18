local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function HasPolarIngredient(self, ingredient)
	if ingredient.type and ingredient.type == "polarsnow_material" then
		return self.inst.nearhighsnow:value()
	end

	if ingredient.type and ingredient.type == "polarbear_material" then
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local bears = TheSim:FindEntities(x, y, z, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS, { "bear" }, { "bear_major" })
		local angries = 0

		for _, bear in ipairs(bears) do
			if bear.enraged then
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
		
		if recipe and recipe.placer and block_range > 0 then
			SpawnPolarSnowBlocker(pt, block_range, TUNING.POLARPLOW_BLOCKER_DURATION, self.inst)
		end
		
		return OldDoBuild(self, recname, pt, ...)
	end
	
	local OldHasTechIngredient = Builder.HasTechIngredient
	function Builder:HasTechIngredient(ingredient, ...)
		
		return HasPolarIngredient(self, ingredient) or OldHasTechIngredient(self, ingredient, ...)
	end
	
local BuilderReplica = require("components/builder_replica")
	
	local OldHasTechIngredientReplica = BuilderReplica.HasTechIngredient
	function BuilderReplica:HasTechIngredient(ingredient, ...)
		return HasPolarIngredient(self, ingredient) or OldHasTechIngredientReplica(self, ingredient, ...)
	end