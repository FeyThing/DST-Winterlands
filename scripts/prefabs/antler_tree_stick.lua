local assets = {
	Asset("ANIM", "anim/antler_tree_stick.zip"),
}

local tree_sticcs = {"low", "med", "high"}

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideSymbol("swap_object", skin_build or "antler_tree_stick", "swap_sticc")
	else
		owner.AnimState:OverrideSymbol("swap_object", "antler_tree_stick", "swap_sticc")
	end
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
	
	if inst.dropped_anim then
		inst.dropped_anim = nil
		inst.AnimState:PlayAnimation("idle")
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
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
end

local function OnEquipToModel(inst, owner)
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
end

local function OnAttack(inst, attacker, target)
	if inst.components.fueled then
		inst.components.fueled:DoDelta(-TUNING.ANTLER_TREE_STICK_ATTACK_PERCENT * inst.components.fueled.maxfuel)
	end
	
	if target and target.SoundEmitter then
		target.SoundEmitter:PlaySound("polarsounds/antler_tree/bonk", nil, nil, true)
	end
end

local function DropSticc(inst, tree, anim)
	anim = anim or tree_sticcs[math.random(#tree_sticcs)]
	
	inst.dropped_anim = "dropped_"..anim
	inst.AnimState:PlayAnimation(inst.dropped_anim)
end

local function OnSave(inst, data)
	data.dropped_anim = inst.dropped_anim
end

local function OnLoad(inst, data)
	if data and data.dropped_anim then
		inst.dropped_anim = data.dropped_anim
		inst.AnimState:PlayAnimation(inst.dropped_anim)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("antler_tree_stick")
	inst.AnimState:SetBuild("antler_tree_stick")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("antlerstick")
	inst:AddTag("weapon")
	
	inst.pickupsound = "wood"
	
	local swap_data = {sym_name = "swap_sticc", sym_build = "antler_tree_stick", bank = "antler_tree_stick", anim = "idle"}
	MakeInventoryFloatable(inst, "med", nil, {0.9, 0.6, 0.9}, true, -18, swap_data)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.updatetargets = {}
	
	inst:AddComponent("equippable")
	inst.components.equippable.polar_slowtime = 4
	inst.components.equippable.walkspeedmult = TUNING.ANTLER_TREE_STICK_SPEED_MULT
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled.no_sewing = true
	inst.components.fueled:InitializeFuelLevel(TUNING.ANTLER_TREE_STICK_PERISHTIME)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("tradable")
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.ANTLER_TREE_STICK_DAMAGE)
	inst.components.weapon:SetOnAttack(OnAttack)
	
	MakeHauntableLaunch(inst)
	
	inst.DropSticc = DropSticc
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab("antler_tree_stick", fn, assets)