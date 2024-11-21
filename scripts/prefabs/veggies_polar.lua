require("prefabs/veggies")

local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local function IceLettuce_Fruut(inst, eater)
	if eater.components.freezable then
		eater.components.freezable:AddColdness(TUNING.ICELETTUCE_FREEZABLE_COLDNESS)
	end
	
	local temperature = eater.components.temperature and eater.components.temperature.current or nil
	if temperature then
		eater.components.temperature:SetTemperature(temperature + TUNING.ICELETTUCE_COOLING)
	end
	
	eater:AddDebuff("buff_polarimmunity", "buff_polarimmunity")
end

local function MakeVegStats(seedweight, hunger, health, perish_time, sanity, cooked_hunger, cooked_health, cooked_perish_time, cooked_sanity, float_settings, cooked_float_settings, dryable, oneatfn, secondary_foodtype)
	return {
		health = health,
		hunger = hunger,
		cooked_health = cooked_health,
		cooked_hunger = cooked_hunger,
		seed_weight = seedweight,
		perishtime = perish_time,
		cooked_perishtime = cooked_perish_time,
		sanity = sanity,
		float_settings = float_settings,
		cooked_sanity = cooked_sanity,
		cooked_float_settings = cooked_float_settings,
		dryable = dryable,
		secondary_foodtype = secondary_foodtype,
		oneatfn = oneatfn,
	}
end

local POLAR_VEGGIES = {
	icelettuce = MakeVegStats(0, TUNING.CALORIES_MEDSMALL, TUNING.HEALING_MED / 2, TUNING.PERISH_SUPERFAST, TUNING.SANITY_TINY,
		nil, nil, nil, nil, {nil, 0.1, 0.75}, nil, nil, IceLettuce_Fruut),
}

for k, v in pairs(POLAR_VEGGIES) do
	VEGGIES[k] = v
end

VEGGIES.icelettuce.extra_tags_fresh = {"frozen"}

local SEEDLESS = {
	
}

local COOKLESS = {
	icelettuce = true,
}

local assets_seeds = {
	Asset("ANIM", "anim/polar_seeds.zip"),
}

local prefabs_seeds = {
	"plant_normal_ground",
	"seeds_placer",
}

local function can_plant_seed(inst, pt, mouseover, deployer)
	local x, z = pt.x, pt.z
	return TheWorld.Map:CanTillSoilAtPoint(x, 0, z, true)
end

local function OnDeploy(inst, pt, deployer)
	local plant = SpawnPrefab(inst.components.farmplantable.plant)
	plant.Transform:SetPosition(pt.x, 0, pt.z)
	plant:PushEvent("on_planted", {in_soil = false, doer = deployer, seed = inst})
	
	TheWorld.Map:CollapseSoilAtPoint(pt.x, 0, pt.z)
	
	inst:Remove()
end

local function Seed_GetDisplayName(inst)
	local registry_key = inst.plant_def.product
	
	local plantregistryinfo = inst.plant_def.plantregistryinfo
	return (ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo) and ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo))
		and STRINGS.NAMES["KNOWN_"..string.upper(inst.prefab)] or nil
end

local function MakeVeggie(name, has_seeds)
	local assets = {
		Asset("ANIM", "anim/"..name..".zip"),
		Asset("INV_IMAGE", name),
	}
	
	local prefabs = {
		"spoiled_food",
	}
	
	
	if has_seeds then
		table.insert(assets, Asset("ANIM", "anim/oceanfishing_lure_mis.zip"))
		table.insert(prefabs, name.."_seeds")
	end
	
	local seeds_prefabs = has_seeds and {"farm_plant_"..name} or nil
	
	local function fn_seeds()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("polar_seeds")
		inst.AnimState:SetBuild("polar_seeds")
		inst.AnimState:PlayAnimation(name)
		inst.AnimState:SetRayTestOnBB(true)
		
		inst.pickupsound = "vegetation_firm"
		
		inst:AddTag("cookable")
		inst:AddTag("deployedplant")
		inst:AddTag("deployedfarmplant")
		inst:AddTag("oceanfishing_lure")
		
		inst.overridedeployplacername = "seeds_placer"
		
		inst.plant_def = PLANT_DEFS[name]
		inst.displaynamefn = Seed_GetDisplayName
		
		inst._custom_candeploy_fn = can_plant_seed
		
		MakeInventoryFloatable(inst)
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("edible")
		inst.components.edible.foodtype = FOODTYPE.SEEDS
		inst.components.edible.healthvalue = TUNING.HEALING_TINY / 2
		inst.components.edible.hungervalue = TUNING.CALORIES_TINY
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("tradable")
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")
		
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
		
		inst:AddComponent("cookable")
		inst.components.cookable.product = "seeds_cooked"
		
		inst:AddComponent("bait")
		
		inst:AddComponent("farmplantable")
		inst.components.farmplantable.plant = "farm_plant_"..name
		
		inst:AddComponent("plantable")
		inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
		inst.components.plantable.product = name
		
		inst:AddComponent("deployable")
		inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
		inst.components.deployable.restrictedtag = "plantkin"
		inst.components.deployable.ondeploy = OnDeploy
		
		inst:AddComponent("oceanfishingtackle")
		inst.components.oceanfishingtackle:SetupLure({build = "oceanfishing_lure_mis", symbol = "hook_seeds", single_use = true, lure_data = TUNING.OCEANFISHING_LURE.SEED})
		
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		
		MakeHauntableLaunchAndPerish(inst)
		
		return inst
	end
	
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("idle")
		
		inst.pickupsound = "vegetation_firm"
		
		if not COOKLESS[name] then
			inst:AddTag("cookable")
		end
		
		if VEGGIES[name].extra_tags_fresh then
			for _, extra_tag in ipairs(VEGGIES[name].extra_tags_fresh) do
				inst:AddTag(extra_tag)
			end
		end
		
		local float = VEGGIES[name].float_settings
		if float then
			MakeInventoryFloatable(inst, float[1], float[2], float[3])
		else
			MakeInventoryFloatable(inst)
		end
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = VEGGIES[name].health
		inst.components.edible.hungervalue = VEGGIES[name].hunger
		inst.components.edible.sanityvalue = VEGGIES[name].sanity or 0
		inst.components.edible.foodtype = FOODTYPE.VEGGIE
		inst.components.edible.secondaryfoodtype = VEGGIES[name].secondary_foodtype
		inst.components.edible:SetOnEatenFn(VEGGIES[name].oneatfn)
		
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(VEGGIES[name].perishtime)
		inst.components.perishable:StartPerishing()
		
		if name == "icelettuce" then
			inst.components.edible.degrades_with_spoilage = false
		else
			inst.components.perishable.onperishreplacement = "spoiled_food"
		end
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")
		
		if not SEEDLESS[name] then
			inst:AddComponent("weighable")
			inst.components.weighable.type = TROPHYSCALE_TYPES.OVERSIZEDVEGGIES
		end
		
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		
		inst:AddComponent("bait")
		
		inst:AddComponent("tradable")
		
		if not COOKLESS[name] then
			inst:AddComponent("cookable")
			inst.components.cookable.product = name.."_cooked"
		end
		
		MakeHauntableLaunchAndPerish(inst)
		
		return inst
	end
	
	local exported_prefabs = {}
	
	if has_seeds then
		table.insert(exported_prefabs, Prefab(name.."_seeds", fn_seeds, assets_seeds, seeds_prefabs))
	end
	
	table.insert(exported_prefabs, Prefab(name, fn, assets, prefabs))
	
	if not COOKLESS[name] then
		table.insert(exported_prefabs, Prefab(name.."_cooked", fn_cooked, assets_cooked))
	end
	
	return exported_prefabs
end

local prefs = {}

for veggiename, veggiedata in pairs(POLAR_VEGGIES) do
	local veggies = MakeVeggie(veggiename, not SEEDLESS[veggiename])
	
	for _, v in ipairs(veggies) do
		table.insert(prefs, v)
	end
end

return unpack(prefs)