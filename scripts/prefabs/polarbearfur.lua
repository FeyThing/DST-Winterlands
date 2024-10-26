local assets = {
	Asset("ANIM", "anim/polarbearfur.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polarbearfur")
	inst.AnimState:SetBuild("polarbearfur")
	inst.AnimState:PlayAnimation("idle")
	
	MakeInventoryFloatable(inst, "med", nil, 0.66)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("stackable")
	
	MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab("polarbearfur", fn, assets)