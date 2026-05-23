local assets = {
	Asset("ANIM", "anim/hat_flower_polar.zip"),
}

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideSymbol("swap_hat", skin_build or "hat_flower_polar", "swap_hat")
	else
		owner.AnimState:OverrideSymbol("swap_hat", "hat_flower_polar", "swap_hat")
	end
	
	owner.AnimState:Show("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	
	owner.AnimState:Show("HEAD")
	owner.AnimState:Hide("HEAD_HAT")
	owner.AnimState:Hide("HEAD_HAT_NOHELM")
	owner.AnimState:Hide("HEAD_HAT_HELM")
	
	inst.equipped_update:set(true)
end

local function OnUnequip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end
	
	owner:RemoveTag("emperorpengullcrowned")
	
	owner.AnimState:ClearOverrideSymbol("swap_hat")
	owner.AnimState:Hide("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
		owner.AnimState:Hide("HEAD_HAT_NOHELM")
		owner.AnimState:Hide("HEAD_HAT_HELM")
	end
	
	inst.equipped_update:set(false)
end

local function UpdateHatSide(inst)
	local owner = inst.entity:GetParent()
	
	if owner and owner.AnimState then
		if owner.AnimState:GetCurrentFacing() == FACING_LEFT then
			owner.AnimState:OverrideSymbol("swap_hat", "hat_flower_polar", "swap_hat_left")
		else
			owner.AnimState:OverrideSymbol("swap_hat", "hat_flower_polar", "swap_hat")
		end
	end
end

local function OnEquippedDirty(inst)
	if inst.components.updatelooper then
		if inst.equipped_update:value() then
			inst.components.updatelooper:AddOnUpdateFn(UpdateHatSide)
		else
			inst.components.updatelooper:RemoveOnUpdateFn(UpdateHatSide)
		end
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("flower_polarhat")
	inst.AnimState:SetBuild("hat_flower_polar")
	inst.AnimState:PlayAnimation("anim")
	
	inst:AddTag("crocushat")
	inst:AddTag("hat")
	inst:AddTag("icebox_valid")
	inst:AddTag("open_top_hat")
	inst:AddTag("show_spoilage")
	
	inst:AddComponent("snowmandecor")
	
	local swap_data = {bank = "flower_polarhat", anim = "anim"}
	MakeInventoryFloatable(inst, "med", nil, 0.68)
	
	inst:AddComponent("updatelooper")
	
	inst.equipped_update = net_bool(inst.GUID, "flower_polarhat.equipped_update", "equipped_updatedirty")
	
	if not TheNet:IsDedicated() then
		inst:ListenForEvent("equipped_updatedirty", OnEquippedDirty)
	end
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	--inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY
	--inst.components.equippable.flipdapperonmerms = true
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("forcecompostable")
	inst.components.forcecompostable.green = true
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(inst.Remove)
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunchAndPerish(inst)
	
	return inst
end

return Prefab("flower_polarhat", fn, assets)