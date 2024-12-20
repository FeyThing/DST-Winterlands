local assets = {
	Asset("ANIM", "anim/hat_polarcrown.zip"),
}

local forcefield_fx = {
	Asset("ANIM", "anim/forcefield.zip"),
}

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideSymbol("swap_hat", skin_build or "hat_polarcrown", "swap_hat")
	else
		owner.AnimState:OverrideSymbol("swap_hat", "hat_polarcrown", "swap_hat")
	end
	
	if inst._fx == nil and not (inst.components.rechargeable and not inst.components.rechargeable:IsCharged()) then --and not owner:HasTag("equipmentmodel") then
		inst:StartForceField(owner)
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
	
	inst:StopForceField(owner)
	
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

local function OnCharged(inst)
	if inst.components.equippable and inst.components.equippable:IsEquipped() then
		inst:StartForceField()
	end
end

local function OnDischarged(inst)
	inst:StopForceField()
end

local function TryBreak(inst, owner, data)
	if data and not data.redirected and math.random() < TUNING.ARMOR_POLARCROWNHAT_BREAK_CHANCE then
		inst:StopForceField()
		if inst.components.rechargeable then
			inst.components.rechargeable:Discharge(TUNING.ARMOR_POLARCROWNHAT_BREAK_COOLDOWN)
		end
	end
end

local TARGET_TAGS = {"freezable", "smolder"}
local TARGET_NOT_TAGS = {"INLIMBO", "flight"}

local function DoFreezeAOE(inst, owner)
	if not (owner and owner:IsValid()) or (inst.components.equippable and not inst.components.equippable:IsEquipped()) then
		return
	end
	
	local x, y, z = owner.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.ARMOR_POLARCROWNHAT_FREEZINESS_RANGE, nil, TARGET_NOT_TAGS, TARGET_TAGS)
	for i, v in ipairs(ents) do
		if v ~= owner and not (v:HasTag("player") and not TheNet:GetPVPEnabled()) then
			if v.components.burnable and v.components.burnable:IsSmoldering() then
				v.components.burnable:SmotherSmolder()
			end
			if v.components.freezable and not v.components.freezable:IsFrozen() then
				v.components.freezable:AddColdness(TUNING.ARMOR_POLARCROWNHAT_FREEZINESS)
			end
		end
	end
end

local function StartForceField(inst, owner)
	inst._owner = owner or inst._owner
	if inst._fx then
		inst._fx:kill_fx()
		inst._fx = nil
	end
	
	inst._fx = SpawnPrefab("polarcrownhat_forcefield")
	inst._fx.entity:SetParent(inst._owner.entity)
	inst._fx.Transform:SetPosition(0, -2, 0)
	
	if inst._owner then
		inst._owner:AddTag("icicleimmune")
		inst:ListenForEvent("attacked", inst.breakfn, inst._owner)
		
		if inst._freezytask == nil then
			inst._freezytask = inst:DoPeriodicTask(TUNING.ARMOR_POLARCROWNHAT_FREEZINESS_RATE, inst.DoFreezeAOE, nil, inst._owner)
		end
	end
end

local function StopForceField(inst, owner)
	owner = owner or inst._owner
	if inst._fx then
		inst._fx:kill_fx()
		inst._fx = nil
	end
	
	if owner then
		owner:RemoveTag("icicleimmune")
		inst:RemoveEventCallback("attacked", inst.breakfn, owner)
	end
	
	if inst._freezytask then
		inst._freezytask:Cancel()
		inst._freezytask = nil
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
	
	inst:AddComponent("snowmandecor")
	
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
	
	inst:AddComponent("rechargeable")
	inst.components.rechargeable:SetOnChargedFn(OnCharged)
	inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunch(inst)
	
	inst.breakfn = function(owner, data) TryBreak(inst, owner, data) end
	inst.DoFreezeAOE = DoFreezeAOE
	inst.StartForceField = StartForceField
	inst.StopForceField = StopForceField
	
	return inst
end

--

local function kill_fx(inst)
	inst.AnimState:PlayAnimation("close")
	inst:RemoveTag("blizzardprotection")
	
	inst:DoTaskInTime(0.6, inst.Remove)
end

local function UpdateField(inst)
	if inst._erode_percent > 0.5 then
		inst._drop_erode = true
	elseif inst._drop_erode and inst._erode_percent < 0.1 then
		inst._drop_erode = nil
	end
	
	inst._erode_percent = inst._erode_percent + (inst._drop_erode and -FRAMES or FRAMES)
	inst.AnimState:SetErosionParams(inst._erode_percent, 0.8, 0.8)
end

local function forcefield()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst:AddTag("blizzardprotection")
	inst:AddTag("NOCLICK")
	
	inst.blizzardprotect_rad = TUNING.POLAR_STORM_PROTECTION.CROWN
	
	inst.AnimState:SetBank("forcefield")
	inst.AnimState:SetBuild("forcefield")
	inst.AnimState:PlayAnimation("open")
	inst.AnimState:PushAnimation("idle_loop", true)
	inst.AnimState:SetLightOverride(0.2)
	inst.AnimState:SetAddColour(0, 0.5, 1, 0)
	inst.AnimState:SetMultColour(0.2, 0.5, 1, 0.8)
	inst.AnimState:SetScale(2, 1.78)
	
	inst.SoundEmitter:PlaySound("polarsounds/icecrown/active_LP", "loop")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.kill_fx = kill_fx
	
	inst._erode_percent = 0
	inst:DoPeriodicTask(FRAMES * 5, UpdateField)
	
	return inst
end

return Prefab("polarcrownhat", fn, assets),
	Prefab("polarcrownhat_forcefield", forcefield, forcefield_fx)