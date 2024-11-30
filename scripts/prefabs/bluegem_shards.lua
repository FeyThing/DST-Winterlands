local assets = {
	Asset("ANIM", "anim/bluegem_shards.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("bluegem_shards")
	inst.AnimState:SetBuild("bluegem_shards")
	inst.AnimState:PlayAnimation("idle")
	
	inst.pickupsound = "gem"
	
	inst:AddTag("molebait")
	inst:AddTag("renewable")
	inst:AddTag("quakedebris")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
	inst.components.edible.hungervalue = 1
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunchAndSmash(inst)
	
	return inst
end

return Prefab("bluegem_shards", fn, assets)