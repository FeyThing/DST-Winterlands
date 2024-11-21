local assets = {
	Asset("ANIM", "anim/polar_dryice.zip"),
}

local names = {"f1", "f2", "f3"}

local function OnPutInInv(inst, owner)
	if inst._droppedice and owner.components.freezable then
		owner.components.freezable:AddColdness(TUNING.DRYICE_FREEZABLE_COLDNESS * (not owner:HasTag("player") and 4 or 1))
	end
	if owner.prefab == "mole" and owner.components.inventory then
		owner.components.inventory:DropItem(inst, true, true)
	end
	
	inst.components.polarmistemitter:StopMisting()
	inst._droppedice = nil
end

local function OnDropped(inst)
	inst.components.polarmistemitter:StartMisting()
	inst._droppedice = true
end

local function OnEntitySleep(inst)
	inst.components.polarmistemitter:StopMisting()
end

local function OnEntityWake(inst)
	if not inst.inlimbo then
		inst.components.polarmistemitter:StartMisting()
	end
end

local function OnSave(inst, data)
	data.anim = inst.animname
end

local function OnLoad(inst, data)
	if data and data.anim then
		inst.animname = data.anim
		inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polar_dryice")
	inst.AnimState:SetBuild("polar_dryice")
	inst.AnimState:SetScale(0.8, 0.8)
	
	inst:AddTag("molebait")
	inst:AddTag("dryice")
	
	inst.pickupsound = "rock"
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
	   return inst
	end
	
	inst.animname = names[math.random(#names)]
	inst.AnimState:PlayAnimation(inst.animname)
	
	inst:AddComponent("bait")
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
	inst.components.edible.healthvalue = TUNING.HEALING_TINY * 2
	inst.components.edible.hungervalue = TUNING.CALORIES_TINY
	inst.components.edible.degrades_with_spoilage = false
	inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
	inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_LONG * 1.5
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.MED_FUEL
	inst.components.fuel.fueltype = FUELTYPE.DRYICE
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInv)
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()
	
	inst:AddComponent("polarmistemitter")
	inst.components.polarmistemitter.maxmist = 8
	inst.components.polarmistemitter.scale = 1.5
	inst.components.polarmistemitter:StartMisting()
	
	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = MATERIALS.DRYICE
	inst.components.repairer.perishrepairpercent = 0.25
	
	inst:AddComponent("smotherer")
	
	inst:AddComponent("stackable")
	
	inst:AddComponent("tradable")
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab("polar_dryice", fn, assets)