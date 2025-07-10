local assets = {
	Asset("ANIM", "anim/emperor_egg.zip"),
}

local function OnDropped(inst)
	inst.AnimState:PlayAnimation("drop")
	inst.AnimState:PushAnimation("idle")
end

local function OnFireMelt(inst)
	if inst.components.perishable then
		inst.components.perishable.frozenfiremult = true
	end
end

local function OnStopFireMelt(inst)
	if inst.components.perishable then
		inst.components.perishable.frozenfiremult = false
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("emperor_egg")
	inst.AnimState:SetBuild("emperor_egg")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetScale(1.25, 1.25)
	
	inst:AddTag("frozen")
	inst:AddTag("icebox_valid")
	inst:AddTag("penguin_egg")
	inst:AddTag("show_spoilage")
	
	inst.pickupsound = "rock"
	
	MakeInventoryFloatable(inst, "med", 0.05, {0.65, 0.5, 0.65})
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
	   return inst
	end
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = TUNING.CALORIES_MED
	inst.components.edible.degrades_with_spoilage = false
	inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
	inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF * 1.5
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	inst.components.fuel.fueltype = FUELTYPE.DRYICE
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnStopFireMelt)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(inst.Remove)
	
	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = MATERIALS.DRYICE
	inst.components.repairer.perishrepairpercent = 1
	
	inst:AddComponent("smotherer")
	
	inst:AddComponent("stackable")
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunch(inst)
	
	inst:ListenForEvent("firemelt", OnFireMelt)
	inst:ListenForEvent("stopfiremelt", OnStopFireMelt)
	
	return inst
end

return Prefab("emperor_egg", fn, assets)