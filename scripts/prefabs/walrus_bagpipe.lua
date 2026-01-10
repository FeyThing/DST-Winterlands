local assets = {
	Asset("ANIM", "anim/armor_walrus_bagpipe.zip"),
}

local bagpipedt = 1
local FOLLOWER_ONEOF_TAGS = {"walrus", "hound", "farm_plant"}
local FOLLOWER_CANT_TAGS = {"player"}

local function bagpipe_update(inst)
	local doer = inst.components.inventoryitem and inst.components.inventoryitem.owner or inst
	if not (doer and doer:IsValid()) then
		return
	end
	
	local x, y, z = doer.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.ONEMANBAND_RANGE, nil, FOLLOWER_CANT_TAGS, FOLLOWER_ONEOF_TAGS)
	
	for i, v in ipairs(ents) do
		if v.components.farmplanttendable then
			v.components.farmplanttendable:TendTo(doer)
		end
	end
	
	if doer.components.leader then
		for k, v in pairs(doer.components.leader.followers) do
			if k.components.combat then
				k:AddDebuff("buff_walrusally", "buff_walrusally")
			end
		end
	end
	
	for i, v in ipairs(AllPlayers) do
		if not v:HasTag("playerghost") and v:GetDistanceSqToPoint(x, y, z) < TUNING.ONEMANBAND_RANGE * TUNING.ONEMANBAND_RANGE and
			not (v.components.timer and v.components.timer:TimerExists("walrusally_oncooldown")) then
			
			v:AddDebuff("buff_walrusally", "buff_walrusally")
		end
	end
end

local function OnEquip(inst, owner)
	inst.updatetask = inst:DoPeriodicTask(bagpipedt, bagpipe_update, 0)
	
	owner.AnimState:OverrideSymbol("swap_body_tall", "armor_walrus_bagpipe", "torso")
	owner:DoTaskInTime(0.2 + math.random() * 0.5, function()
		if owner.SoundEmitter and inst.updatetask then
			owner.SoundEmitter:PlaySound("polarsounds/walrus/bagpipes", "walrus_bagpipe")
		end
	end)
	
	TheWorld:PushEvent("pausehounded", {source = inst, reason = "bagpipe"}) -- A little more than the standard pause, Houndwaves won't progress at all!
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()
	end
end

local function OnUnequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_body_tall")
	if owner.SoundEmitter then
		owner.SoundEmitter:KillSound("walrus_bagpipe")
	end
	
	TheWorld:PushEvent("unpausehounded", {source = inst, reason = "bagpipe"})
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
	
	if inst.updatetask then
		inst.updatetask:Cancel()
		inst.updatetask = nil
	end
end

local function OnEquipToModel(inst, owner)
	if owner.SoundEmitter then
		owner.SoundEmitter:KillSound("walrus_bagpipe")
	end
	
	TheWorld:PushEvent("unpausehounded", {source = inst})
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
	
	if inst.updatetask then
		inst.updatetask:Cancel()
		inst.updatetask = nil
	end
end

local function OnPerish(inst)
	if inst.updatetask then
		inst.updatetask:Cancel()
		inst.updatetask = nil
	end
	
	inst:Remove()
end

local function OnHaunt(inst)
	if inst._hauntedtask == nil then
		inst._hauntedtask = inst:DoPeriodicTask(bagpipedt, function()
			local x, y, z = inst.Transform:GetWorldPosition()
			
			if inst.components.inventoryitem and not inst:IsInLimbo() and inst.components.inventoryitem.is_landed then
				inst.components.inventoryitem:DoDropPhysics(x, y, z, true, math.random())
			end
			
			bagpipe_update(inst)
		end, 0)
	end
	
	inst.SoundEmitter:PlaySound("polarsounds/walrus/bagpipes", "haunted_bagpipe")
	
	return true
end

local function OnUnHaunt(inst)
	if inst._hauntedtask then
		inst._hauntedtask:Cancel()
		inst._hauntedtask = nil
	end
	
	inst.SoundEmitter:KillSound("haunted_bagpipe")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst:AddTag("band") -- Helps us enter basic onemanband states if no other idle exits take the take before, then we swap over bagpipe states
	inst:AddTag("walrusbagpipe")
	
	inst.AnimState:SetBank("walrus_bagpipe")
	inst.AnimState:SetBuild("armor_walrus_bagpipe")
	inst.AnimState:PlayAnimation("anim")
	
	inst.foleysound = "cloth"
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.WALRUS_BAGPIPE_PERISHTIME)
	inst.components.fueled:SetDepletedFn(OnPerish)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("leader")
	
	inst:AddComponent("hauntable")
	inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_HUGE
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	inst.components.hauntable:SetOnUnHauntFn(OnUnHaunt)
	
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
	MakeSmallPropagator(inst)
	
	return inst
end

return Prefab("walrus_bagpipe", fn, assets)