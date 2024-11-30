local assets = {
	Asset("ANIM", "anim/bluegem_overcharged.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetBank("bluegem_overcharged")
	inst.AnimState:SetBuild("bluegem_overcharged")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetSymbolLightOverride("gem", 0.1)
	inst.AnimState:SetSymbolLightOverride("fx", 0.8)
	inst.AnimState:SetSymbolLightOverride("glow", 0.45)
	inst.AnimState:SetScale(1.2, 1.2)
	
	inst.pickupsound = "gem"
	
	inst:AddTag("molebait")
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
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunchAndSmash(inst)
	
	return inst
end

return Prefab("bluegem_overcharged", fn, assets)