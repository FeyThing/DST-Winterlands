local assets = {
	Asset("ANIM", "anim/compass_polar.zip"),
}

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "compass_polar", "swap_compass")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
	
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()
	end
	if owner.components.maprevealable then
		owner.components.maprevealable:AddRevealSource(inst, "compassbearer")
	end
	owner:AddTag("compassbearer")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
	if owner.components.maprevealable then
		owner.components.maprevealable:RemoveRevealSource(inst)
	end
	owner:RemoveTag("compassbearer")
end

local function OnEquipToModel(inst, owner, from_ground)
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
	if owner.components.maprevealable then
		owner.components.maprevealable:RemoveRevealSource(inst)
	end
	owner:RemoveTag("compassbearer")
end

local function OnDepleted(inst)
	if inst.components.inventoryitem and inst.components.inventoryitem.owner then
		local data = {
			prefab = inst.prefab,
			equipslot = inst.components.equippable.equipslot,
			announce = "ANNOUNCE_COMPASS_OUT",
		}
		inst.components.inventoryitem.owner:PushEvent("itemranout", data)
	end
	
	inst:Remove()
end

local function OnAttack(inst, attacker, target)
	if inst.components.fueled then
		inst.components.fueled:DoDelta(inst.components.fueled.maxfuel * TUNING.COMPASS_ATTACK_DECAY_PERCENT)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("compass_polar")
	inst.AnimState:SetBuild("compass_polar")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("chillycompass")
	inst:AddTag("weapon")
	
	MakeInventoryFloatable(inst, "med", 0.1, 0.6)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	
	--[[inst:AddComponent("fueled")
	inst.components.fueled:InitializeFuelLevel(TUNING.COMPASS_FUEL)
	inst.components.fueled:SetDepletedFn(OnDepleted)
	inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)]]
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.UNARMED_DAMAGE)
	inst.components.weapon:SetOnAttack(OnAttack)
	
	MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab("compass_polar", fn, assets)