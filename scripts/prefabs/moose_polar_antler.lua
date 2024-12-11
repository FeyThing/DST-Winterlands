local assets = {
	Asset("ANIM", "anim/moose_polar_antler.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("moose_polar_antler")
	inst.AnimState:SetBuild("moose_polar_antler")
	inst.AnimState:PlayAnimation("idle")
	
	inst.pickupsound = "rock"
	
	MakeInventoryFloatable(inst, "small", nil, {0.6, 0.55, 0.6})
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
	
	MakeHauntableLaunchAndSmash(inst)
	
	return inst
end

return Prefab("moose_polar_antler", fn, assets)