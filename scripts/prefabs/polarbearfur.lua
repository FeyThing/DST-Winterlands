local assets = {
	Asset("ANIM", "anim/polarbearfur.zip"),
}

local function OnPickedUp(inst)
	inst.AnimState:ClearOverrideSymbol("fur")
	inst.colour = nil
end

local function OnSave(inst, data)
	data.colour = inst.colour
end

local function OnLoad(inst, data)
	if data and data.colour then
		inst.colour = data.colour
		inst.AnimState:OverrideSymbol("fur", "polarbearfur", "fur_"..inst.colour)
	end
end

local function OnLootDropped(inst, data)
	if data and data.dropper then
		inst.colour = data.dropper.body_paint
		if inst.colour then
			inst.AnimState:OverrideSymbol("fur", "polarbearfur", "fur_"..inst.colour)
		end
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polarbearfur")
	inst.AnimState:SetBuild("polarbearfur")
	inst.AnimState:PlayAnimation("idle")
	
	inst.pickupsound = "cloth"
	
	MakeInventoryFloatable(inst, "med", nil, 0.66)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickedUp)
	
	inst:AddComponent("stackable")
	
	MakeHauntableLaunch(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("on_loot_dropped", OnLootDropped)
	
	return inst
end

return Prefab("polarbearfur", fn, assets)