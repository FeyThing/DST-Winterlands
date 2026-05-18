require("prefabs/veggies")

local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local function OnEat_IceLettuce(inst, eater)
	EatIceLettuce(inst, eater, TUNING.POLAR_IMMUNITY_DURATION, TUNING.ICELETTUCE_FREEZABLE_COLDNESS, TUNING.ICELETTUCE_COOLING)
end

local function OnEat_IceLettuceSeeds(inst, eater)
	if eater:HasTag("bird") and eater.components.freezable then
		eater.components.freezable:AddColdness(TUNING.ICELETTUCE_FREEZABLE_COLDNESS)
	end
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

local OVERSIZED_PHYSICS_RADIUS = 0.1
local OVERSIZED_MAXWORK = 1
local OVERSIZED_PERISHTIME_MULT = 4

local POLAR_VEGGIES = {
	icelettuce = MakeVegStats(0, TUNING.CALORIES_MEDSMALL, TUNING.HEALING_MED / 2, TUNING.PERISH_SUPERFAST, 0,
		nil, nil, nil, nil, {nil, 0.1, 0.75}, nil, nil, OnEat_IceLettuce),
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

local function oversized_calcweightcoefficient(name)
	if PLANT_DEFS[name].weight_data[3] and math.random() < PLANT_DEFS[name].weight_data[3] then
		return (math.random() + math.random()) / 2
	else
		return math.random()
	end
end

local function oversized_onequip(inst, owner)
	local swap = inst.components.symbolswapdata
	owner.AnimState:OverrideSymbol("swap_body", swap.build, swap.symbol)
end

local function oversized_onunequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function oversized_onfinishwork(inst, chopper)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function oversized_onburnt(inst)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function oversized_makeloots(inst, name)
	local product = name
	local seeds = name.."_seeds"
	
	return {product, product, seeds, seeds, math.random() < 0.75 and product or seeds}
end

local function oversized_onperish(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	local gym = owner and owner:HasTag("gym") and owner or nil
	local rot = nil
	local slot = nil
	
	if owner and gym == nil then
		local loots = {}
		for i = 1, #inst.components.lootdropper.loot do
			table.insert(loots, "spoiled_food")
		end
		
		inst.components.lootdropper:SetLoot(loots)
		inst.components.lootdropper:DropLoot()
	else
		rot = SpawnPrefab(inst.prefab.."_rotten")
		rot.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		if gym then
			slot = gym.components.inventory:GetItemSlot(inst)
		end
	end
	
	inst:Remove()
	
	if gym and rot then
		gym.components.mightygym:LoadWeight(rot, slot)
	end
end

local function Seed_GetDisplayName(inst)
	local registry_key = inst.plant_def.product
	
	local plantregistryinfo = inst.plant_def.plantregistryinfo
	return (ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo) and ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo))
		and STRINGS.NAMES["KNOWN_"..string.upper(inst.prefab)] or nil
end

local function Oversized_OnSave(inst, data)
	data.from_plant = inst.from_plant or false
	data.harvested_on_day = inst.harvested_on_day
end

local function Oversized_OnPreLoad(inst, data)
	inst.from_plant = (data and data.from_plant) ~= false
	if data then
		inst.harvested_on_day = data.harvested_on_day
	end
end

local function displayadjectivefn(inst)
	return STRINGS.UI.HUD.WAXED
end

local function dowaxfn(inst, doer, waxitem)
	local waxedveggie = SpawnPrefab(inst.prefab.."_waxed")
	
	if doer.components.inventory and doer.components.inventory:IsHeavyLifting() and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == inst then
		doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
		doer.components.inventory:Equip(waxedveggie)
	else
		waxedveggie.Transform:SetPosition(inst.Transform:GetWorldPosition())
		waxedveggie.AnimState:PlayAnimation("wax_oversized", false)
		waxedveggie.AnimState:PushAnimation("idle_oversized")
	end
	
	inst:Remove()
	
	return true
end

local function PlayWaxAnimation(inst)
	inst.AnimState:PlayAnimation("wax_oversized", false)
	inst.AnimState:PushAnimation("idle_oversized")
end

local function CancelWaxTask(inst)
	if inst._waxtask then
		inst._waxtask:Cancel()
		inst._waxtask = nil
	end
end

local function StartWaxTask(inst)
	if not inst.inlimbo and inst._waxtask == nil then
		inst._waxtask = inst:DoTaskInTime(GetRandomMinMax(20, 40), PlayWaxAnimation)
	end
end

local function GetHeatFn_IceLettuce(inst)
	return TUNING.ICELETTUCE_COOLER * (inst.components.perishable and inst.components.perishable:GetPercent() or 0.5)
end

local function MakeVeggie(name, has_seeds)
	local assets = {
		Asset("ANIM", "anim/"..name..".zip"),
	}
	
	local prefabs = {
		"spoiled_food",
	}
	
	
	if has_seeds then
		table.insert(assets, Asset("ANIM", "anim/oceanfishing_lure_mis.zip"))
		table.insert(prefabs, name.."_seeds")
	end
	
	local seeds_prefabs = has_seeds and {"farm_plant_"..name} or nil
	
	local assets_oversized = {}
	if has_seeds then
		table.insert(prefabs, name.."_oversized")
		table.insert(prefabs, name.."_oversized_waxed")
		table.insert(prefabs, name.."_oversized_rotten")
		table.insert(prefabs, "splash_green")
		
		table.insert(assets_oversized, Asset("ANIM", "anim/"..PLANT_DEFS[name].build..".zip"))
	end
	
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
		if name == "icelettuce" then
			inst.components.edible:SetOnEatenFn(OnEat_IceLettuceSeeds)
		end
		
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
			inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
			inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_AVERAGE
			inst.components.perishable:SetOnPerishFn(inst.Remove)
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
	
	local function fn_oversized()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		local plant_def = PLANT_DEFS[name]
		
		inst.AnimState:SetBank(plant_def.bank)
		inst.AnimState:SetBuild(plant_def.build)
		inst.AnimState:PlayAnimation("idle_oversized")
		
		inst:AddTag("heavy")
		inst:AddTag("waxable")
		inst:AddTag("oversized_veggie")
		inst:AddTag("show_spoilage")
		
		if name == "icelettuce" then
			inst:AddTag("HASHEATER")
			
			inst:AddComponent("polarmistemitter")
			inst.components.polarmistemitter.scale = 3
		end
		
		inst.gymweight = 4
		
		MakeHeavyObstaclePhysics(inst, OVERSIZED_PHYSICS_RADIUS)
		inst:SetPhysicsRadiusOverride(OVERSIZED_PHYSICS_RADIUS)
		
		inst._base_name = name
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.harvested_on_day = inst.harvested_on_day or (TheWorld.state.cycles + 1)
		
		inst:AddComponent("heavyobstaclephysics")
		inst.components.heavyobstaclephysics:SetRadius(OVERSIZED_PHYSICS_RADIUS)
		
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(VEGGIES[name].perishtime * OVERSIZED_PERISHTIME_MULT)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = nil
		inst.components.perishable:SetOnPerishFn(oversized_onperish)
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.cangoincontainer = false
		inst.components.inventoryitem:SetSinks(true)
		
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.BODY
		inst.components.equippable:SetOnEquip(oversized_onequip)
		inst.components.equippable:SetOnUnequip(oversized_onunequip)
		inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetOnFinishCallback(oversized_onfinishwork)
		inst.components.workable:SetWorkLeft(OVERSIZED_MAXWORK)
		
		inst:AddComponent("waxable")
		inst.components.waxable:SetWaxfn(dowaxfn)
		
		inst:AddComponent("submersible")
		
		inst:AddComponent("symbolswapdata")
		inst.components.symbolswapdata:SetData(plant_def.build, "swap_body")
		
		local weight_data = plant_def.weight_data
		inst:AddComponent("weighable")
		inst.components.weighable.type = TROPHYSCALE_TYPES.OVERSIZEDVEGGIES
		inst.components.weighable:Initialize(weight_data[1], weight_data[2])
		local coefficient = oversized_calcweightcoefficient(name)
		inst.components.weighable:SetWeight(Lerp(weight_data[1], weight_data[2], coefficient))
		
		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetLoot(oversized_makeloots(inst, name))
		
		if name == "icelettuce" then
			inst:AddComponent("heater")
			inst.components.heater:SetThermics(false, true)
			inst.components.heater.heatfn = GetHeatFn_IceLettuce
			inst.components.heater.equippedheat = TUNING.ICELETTUCE_COOLER
			
			inst.components.polarmistemitter:SetEnabled(true)
		end
		
		MakeMediumBurnable(inst)
		inst.components.burnable:SetOnBurntFn(oversized_onburnt)
		MakeMediumPropagator(inst)
		
		MakeHauntableWork(inst)
		
		inst.from_plant = false
		
		inst.OnSave = Oversized_OnSave
		inst.OnPreLoad = Oversized_OnPreLoad
		
		return inst
	end
	
	local function fn_oversized_waxed()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		local plant_def = PLANT_DEFS[name]
		
		inst.AnimState:SetBank(plant_def.bank)
		inst.AnimState:SetBuild(plant_def.build)
		inst.AnimState:PlayAnimation("idle_oversized")
		
		inst:AddTag("heavy")
		inst:AddTag("oversized_veggie")
		if name == "icelettuce" then
			inst:AddTag("HASHEATER")
		end
		
		inst.gymweight = 4
		
		inst.displayadjectivefn = displayadjectivefn
		inst:SetPrefabNameOverride(name.."_oversized")
		
		MakeHeavyObstaclePhysics(inst, OVERSIZED_PHYSICS_RADIUS)
		inst:SetPhysicsRadiusOverride(OVERSIZED_PHYSICS_RADIUS)
		
		inst._base_name = name
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("heavyobstaclephysics")
		inst.components.heavyobstaclephysics:SetRadius(OVERSIZED_PHYSICS_RADIUS)
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.cangoincontainer = false
		inst.components.inventoryitem:SetSinks(true)
		
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.BODY
		inst.components.equippable:SetOnEquip(oversized_onequip)
		inst.components.equippable:SetOnUnequip(oversized_onunequip)
		inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetOnFinishCallback(oversized_onfinishwork)
		inst.components.workable:SetWorkLeft(OVERSIZED_MAXWORK)
		
		inst:AddComponent("submersible")
		
		inst:AddComponent("symbolswapdata")
		inst.components.symbolswapdata:SetData(plant_def.build, "swap_body")
		
		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetLoot({"spoiled_food"})
		
		if name == "icelettuce" then
			inst:AddComponent("heater")
			inst.components.heater:SetThermics(false, true)
			inst.components.heater.heatfn = GetHeatFn_IceLettuce
			inst.components.heater.equippedheat = TUNING.ICELETTUCE_COOLER
		end
		
		MakeMediumBurnable(inst)
		inst.components.burnable:SetOnBurntFn(oversized_onburnt)
		MakeMediumPropagator(inst)
		
		MakeHauntableWork(inst)
		
		inst:ListenForEvent("onputininventory", CancelWaxTask)
		inst:ListenForEvent("ondropped", StartWaxTask)
		
		inst.OnEntitySleep = CancelWaxTask
		inst.OnEntityWake = StartWaxTask
		
		StartWaxTask(inst)
		
		return inst
	end
	
	local function fn_oversized_rotten()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		local plant_def = PLANT_DEFS[name]
		
		inst.AnimState:SetBank(plant_def.bank)
		inst.AnimState:SetBuild(plant_def.build)
		inst.AnimState:PlayAnimation("idle_rot_oversized")
		
		inst:AddTag("heavy")
		inst:AddTag("farm_plant_killjoy")
		inst:AddTag("pickable_harvest_str")
		inst:AddTag("pickable")
		inst:AddTag("oversized_veggie")
		inst.gymweight = 3
		
		MakeHeavyObstaclePhysics(inst, OVERSIZED_PHYSICS_RADIUS)
		inst:SetPhysicsRadiusOverride(OVERSIZED_PHYSICS_RADIUS)
		
		inst._base_name = name
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("heavyobstaclephysics")
		inst.components.heavyobstaclephysics:SetRadius(OVERSIZED_PHYSICS_RADIUS)
		
		inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = "VEGGIE_OVERSIZED_ROTTEN"
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetOnFinishCallback(oversized_onfinishwork)
		inst.components.workable:SetWorkLeft(OVERSIZED_MAXWORK)
		
		inst:AddComponent("pickable")
		inst.components.pickable.remove_when_picked = true
		inst.components.pickable:SetUp(nil)
		inst.components.pickable.use_lootdropper_for_product = true
		inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.cangoincontainer = false
		inst.components.inventoryitem:SetSinks(true)
		
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.BODY
		inst.components.equippable:SetOnEquip(oversized_onequip)
		inst.components.equippable:SetOnUnequip(oversized_onunequip)
		inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT
		
		inst:AddComponent("submersible")
		
		inst:AddComponent("symbolswapdata")
		inst.components.symbolswapdata:SetData(plant_def.build, "swap_body_rotten")
		
		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetLoot(plant_def.loot_oversized_rot)
		
		inst.components.inventoryitem:ChangeImageName(name.."_oversized_rot")
		
		MakeMediumBurnable(inst)
		inst.components.burnable:SetOnBurntFn(oversized_onburnt)
		MakeMediumPropagator(inst)
		
		MakeHauntableWork(inst)
		
		return inst
	end
	
	local exported_prefabs = {}
	
	if has_seeds then
		table.insert(exported_prefabs, Prefab(name.."_seeds", fn_seeds, assets_seeds, seeds_prefabs))
		table.insert(exported_prefabs, Prefab(name.."_oversized", fn_oversized, assets_oversized))
		table.insert(exported_prefabs, Prefab(name.."_oversized_waxed", fn_oversized_waxed, assets_oversized))
		table.insert(exported_prefabs, Prefab(name.."_oversized_rotten", fn_oversized_rotten, assets_oversized))
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