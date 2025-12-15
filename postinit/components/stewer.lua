local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Cooking = require("cooking")

local Stewer = require("components/stewer")
	
	local function OnGetPolarFlea(inst, data)
		local flea = data and data.flea
		
		if inst.components.stewer and not inst.components.stewer:IsCooking() and inst.components.container and
			not inst.components.container:IsOpen() and inst.components.container:IsFull() then
			
			inst.components.stewer:StartCooking() -- Should flea be cooker ?
		end
	end
	
	local OldStewer_ctor = Stewer._ctor
	Stewer._ctor = function(self, ...)
		OldStewer_ctor(self, ...)
		
		self.OnGetPolarFlea = OnGetPolarFlea
		
		self.inst:ListenForEvent("gotpolarflea", self.OnGetPolarFlea)
	end

	local OldHarvest = Stewer.Harvest
	function Stewer:Harvest(harvester, ...)
		local icecream_emperor = self.done and self.product == "icecream_emperor"
		local recipe_emperor = icecream_emperor and Cooking.GetRecipe(self.inst.prefab, "icecream_emperor") or nil
		
		local jellybean_fleaeggs = self.done and self.product == "jellybean_fleaeggs"
		local recipe_fleaeggs = jellybean_fleaeggs and Cooking.GetRecipe(self.inst.prefab, "jellybean_fleaeggs") or nil
		
		local oldstacksize
		local recipe = (icecream_emperor and Cooking.GetRecipe(self.inst.prefab, "icecream"))
			or (jellybean_fleaeggs and Cooking.GetRecipe(self.inst.prefab, "jellybean"))
			or nil
		
		-- Sure wish doing alternative recipes wasn't this hacky
		if recipe and recipe_emperor then
			oldstacksize = recipe.stacksize
			recipe.stacksize = recipe_emperor.stacksize
			
			self.product = "icecream"
		elseif recipe and recipe_fleaeggs then
			oldstacksize = recipe.stacksize
			recipe.stacksize = recipe_fleaeggs.stacksize
			
			self.product = "jellybean"
		end
		
		local ret = OldHarvest(self, harvester, ...)
		
		if recipe then
			recipe.stacksize = oldstacksize
		end
		
		return ret
	end