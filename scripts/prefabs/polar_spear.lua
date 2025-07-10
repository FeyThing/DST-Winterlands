local assets = {
	Asset("ANIM", "anim/spear.zip"),
	Asset("ANIM", "anim/swap_polar_spear.zip"),
}

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_polar_spear", inst.GUID, "swap_spear")
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_polar_spear", "swap_spear")
	end
	
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end
end

local function OnFireMelt(inst)
	inst.components.perishable.frozenfiremult = true
end

local function OnStopFireMelt(inst)
	inst.components.perishable.frozenfiremult = false
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("spear")
	inst.AnimState:SetBuild("swap_polar_spear")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("frozen")
	inst:AddTag("icebox_valid")
	inst:AddTag("pointy")
	inst:AddTag("sharp")
	inst:AddTag("show_spoilage")
	inst:AddTag("weapon")
	
	MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(inst.Remove)
	
	inst:AddComponent("smotherer")
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.POLAR_SPEAR_DAMAGE)
	
	MakeHauntableLaunch(inst)
	
	inst:ListenForEvent("firemelt", OnFireMelt)
	inst:ListenForEvent("stopfiremelt", OnStopFireMelt)
	
	return inst
end

return Prefab("polar_spear", fn, assets)