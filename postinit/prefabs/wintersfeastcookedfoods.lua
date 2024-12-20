local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local fooddef = require("wintersfeastcookedfoods")

local polarfood = {
	polarcrablegs = {
		cooktime = 1.2,
	}
}

for prefab, data in pairs(polarfood) do
	if fooddef.foods then
		fooddef.foods[prefab] = data
	end
	
	ENV.AddPrefabPostInit(prefab, function(inst)
		inst.AnimState:OverrideSymbol("swap_food", "food_winters_feast_polar", prefab)
	end)
end

-- Why have def files anyway ?

local FOOD_PREFABS
local WINTERS_FEAST_COOKED_FOODS

local OldSetupDish
local function SetupDish(inst, itemname, ...)
	if OldSetupDish then
		OldSetupDish(inst, itemname, ...)
	end
	
	if polarfood[itemname] then
		inst.AnimState:OverrideSymbol("swap_food", "food_winters_feast_polar", itemname)
	end
end

ENV.AddPrefabPostInit("wintersfeastoven", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.madsciencelab then
		if FOOD_PREFABS == nil and inst.components.prototyper then
			local CanCookPrefab = PolarUpvalue(inst.components.prototyper.onactivate, "CanCookPrefab")
			
			FOOD_PREFABS = PolarUpvalue(CanCookPrefab, "FOOD_PREFABS")
			WINTERS_FEAST_COOKED_FOODS = PolarUpvalue(inst.components.madsciencelab.OnScienceWasMade, "WINTERS_FEAST_COOKED_FOODS")
			
			if FOOD_PREFABS and WINTERS_FEAST_COOKED_FOODS then
				for prefab, data in pairs(polarfood) do
					table.insert(FOOD_PREFABS, prefab)
					WINTERS_FEAST_COOKED_FOODS["wintercooking_"..prefab] = prefab
				end
			end
		end
		
		if OldSetupDish == nil then
			OldSetupDish = PolarUpvalue(inst.components.madsciencelab.OnScienceWasMade, "SetupDish")
			PolarUpvalue(inst.components.madsciencelab.OnScienceWasMade, "SetupDish", SetupDish)
		end
	end
end)

--

local OldSetFoodSymbol
local function SetFoodSymbol(inst, foodname, override_build, ...)
	if OldSetFoodSymbol then
		OldSetFoodSymbol(inst, foodname, override_build, ...)
	end
	
	if polarfood[foodname] and override_build == nil then
		inst.AnimState:OverrideSymbol("swap_cooked", "food_winters_feast_polar", foodname)
	end
end

ENV.AddPrefabPostInit("table_winters_feast", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if OldSetFoodSymbol == nil and inst.components.shelf then
		OldSetFoodSymbol = PolarUpvalue(inst.components.shelf.onshelfitemfn, "SetFoodSymbol")
		PolarUpvalue(inst.components.shelf.onshelfitemfn, "SetFoodSymbol", SetFoodSymbol)
	end
end)