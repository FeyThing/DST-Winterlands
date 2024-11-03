local assets =
{
	Asset("ANIM", "anim/hat_polarmoose.zip"),
}

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideSymbol("swap_hat", skin_build or "hat_polarmoose", "swap_hat")
	else
		owner.AnimState:OverrideSymbol("swap_hat", "hat_polarmoose", "swap_hat")
	end
	
	owner.AnimState:Show("HAT")
	owner.AnimState:Show("HAIR_HAT")
	owner.AnimState:Hide("HAIR_NOHAT")
	owner.AnimState:Hide("HAIR")
	if owner:HasTag("player") then
		owner.AnimState:Hide("HEAD")
		owner.AnimState:Show("HEAD_HAT")
	end
	
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()
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
	end
	
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
end

local function OnEquipToModel(inst, owner)
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polarmoosehat")
	inst.AnimState:SetBuild("hat_polarmoose")
	inst.AnimState:PlayAnimation("anim")
	
	inst:AddTag("hat")
	
	local swap_data = {bank = "polarmoosehat", anim = "anim"}
	MakeInventoryFloatable(inst, "med", 0.05, 0.75)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY
	inst.components.equippable.polar_slowtime = 4
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.POLARMOOSEHAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab("polarmoosehat", fn, assets)