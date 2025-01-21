local assets = {
	Asset("ANIM", "anim/armor_polar.zip"),
}

local function OnBlocked(owner)
	owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_fur")
end

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_polar")
	else
		owner.AnimState:OverrideSymbol("swap_body", "armor_polar", "swap_body")
	end
	
	inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function OnUnequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_body")
	inst:RemoveEventCallback("blocked", OnBlocked, owner)
	
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("armor_polar")
	inst.AnimState:SetBuild("armor_polar")
	inst.AnimState:PlayAnimation("anim")
	
	inst:AddTag("fur")
	
	inst.foleysound = "dontstarve/movement/foley/fur"
	
	local swap_data = {bank = "armor_polar", anim = "anim"}
	MakeInventoryFloatable(inst, "small", 0.15, 0.9, nil, nil, swap_data)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("armor")
	inst.components.armor:InitCondition(TUNING.ARMORPOLAR, TUNING.ARMORPOLAR_ABSORPTION)
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable.polar_slowtime = 4
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALLMED)
	
	MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab("armorpolar", fn, assets)