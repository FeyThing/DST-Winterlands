local assets =
{
	Asset("ANIM", "anim/hat_polarcrown.zip"),
}

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideSymbol("swap_hat", skin_build or "hat_polarcrown", "swap_hat")
	else
		owner.AnimState:OverrideSymbol("swap_hat", "hat_polarcrown", "swap_hat")
	end
	
	owner.AnimState:Show("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
		owner.AnimState:Hide("HEAD_HAT_NOHELM")
		owner.AnimState:Hide("HEAD_HAT_HELM")
	end
end

local function OnUnequip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end
	
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
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polarcrown")
	inst.AnimState:SetBuild("hat_polarcrown")
	inst.AnimState:PlayAnimation("anim")
	
	inst:AddTag("hat")
	inst:AddTag("polarsnowimmunity")
	
	local swap_data = {bank = "polarcrown", anim = "anim"}
	MakeInventoryFloatable(inst, "med", 0.05, 0.75)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("armor")
	inst.components.armor:InitCondition(TUNING.ARMOR_POLARCROWNHAT, TUNING.ARMOR_POLARCROWNHAT_ABSORPTION)
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable.polar_slowtime = 4
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_MED_LARGE)
	inst.components.insulator:SetSummer()
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab("polarcrownhat", fn, assets)