local assets = {
	Asset("ANIM", "anim/polarwarg_tooth.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polarwarg_tooth")
	inst.AnimState:SetBuild("polarwarg_tooth")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("frozen")
	inst:AddTag("show_spoilage")
	--inst:AddTag("blowpipeammo")
	--inst:AddTag("reloaditem_ammo")
	
	inst.pickupsound = "rock"
	
	MakeInventoryFloatable(inst, "small", nil, {0.6, 0.55, 0.6})
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	--inst:AddComponent("reloaditem")
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "houndstooth"
	
	inst:AddComponent("snowmandecor")
	
	inst:AddComponent("stackable")
	
	MakeHauntableLaunchAndSmash(inst)
	
	return inst
end

return Prefab("polarwargstooth", fn, assets)