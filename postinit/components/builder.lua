local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function HasSnowIngredient(self, ingredient)
	if ingredient.type and ingredient.type == "polarsnow_material" then
		local x, y, z = self.inst.Transform:GetWorldPosition()
		
		return self.inst.nearhighsnow:value()
	end
end

local Builder = require("components/builder")
	
	local OldHasTechIngredient = Builder.HasTechIngredient
	function Builder:HasTechIngredient(ingredient, ...)
		
		return HasSnowIngredient(self, ingredient) or OldHasTechIngredient(self, ingredient, ...)
	end
	
local BuilderReplica = require("components/builder_replica")
	
	local OldHasTechIngredientReplica = BuilderReplica.HasTechIngredient
	function BuilderReplica:HasTechIngredient(ingredient, ...)
		return HasSnowIngredient(self, ingredient) or OldHasTechIngredientReplica(self, ingredient, ...)
	end