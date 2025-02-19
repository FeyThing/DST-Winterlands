local assets =
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_polarflea_sack.zip"),
}

local FLEA_TAGS = {"flea"}
local FLEA_NOT_TAGS = {"INLIMBO"}

local function UpdateFleas(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
	if inst.components.container and inst.components.container:IsFull() and owner and owner.components.inventory and owner.components.inventory:IsFull() then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.POLARFLEA_SACK_CALL_DIST, FLEA_TAGS, FLEA_NOT_TAGS)
	
	for i, v in ipairs(ents) do
		if v.components.sleeper and v.components.sleeper:IsAsleep() then
			v.components.sleeper:WakeUp()
		end
		
		local target = v.components.combat and v.components.combat.target
		if target == nil or (target and target:IsValid() and target:HasTag("player")) then
			v:PushEvent("fleafindhost", {caller = inst})
		end
	end
end

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("backpack", skin_build, "backpack", inst.GUID, "swap_polarflea_sack")
		owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "swap_polarflea_sack")
	else
		owner.AnimState:OverrideSymbol("backpack", "swap_polarflea_sack", "backpack")
		owner.AnimState:OverrideSymbol("swap_body", "swap_polarflea_sack", "swap_body")
	end
	
	inst.components.container:Open(owner)
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()
	end
	
	inst._updatefleas = inst:DoPeriodicTask(0.5, inst.UpdateFleas)
end

local function OnUnequip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end
	owner.AnimState:ClearOverrideSymbol("swap_body")
	owner.AnimState:ClearOverrideSymbol("backpack")
	
	inst.components.container:Close(owner)
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
	
	if inst._updatefleas then
		inst._updatefleas:Cancel()
		inst._updatefleas = nil
	end
end

local function OnEquipToModel(inst, owner)
	inst.components.container:Close(owner)
end

local function OnDepleted(inst)
	if inst.components.container then
		inst.components.container:DropEverything()
		inst.components.container:Close()
	end
	
	inst:Remove()
end

local function FleaPreserverRate(inst, item)
	return (item and item:HasTag("flea")) and TUNING.POLARFLEA_SACK_PRESERVER_RATE or nil
end

local function OnBurnt(inst)
	if inst.components.container then
		inst.components.container:DropEverything()
		inst.components.container:Close()
	end
	
	SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst:Remove()
end

local function OnIgnite(inst)
	if inst.components.container then
		inst.components.container.canbeopened = false
	end
end

local function OnExtinguish(inst)
	if inst.components.container then
		inst.components.container.canbeopened = true
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.MiniMapEntity:SetIcon("polarflea_sack.png")
	
	inst.AnimState:SetBank("backpack1")
	inst.AnimState:SetBuild("swap_polarflea_sack")
	inst.AnimState:PlayAnimation("anim")
	
	inst.foleysound = "dontstarve/movement/foley/fur"
	
	inst:AddTag("backpack")
	inst:AddTag("fleapack")
	inst:AddTag("waterproofer")
	
	local swap_data = {bank = "backpack1", anim = "anim"}
	MakeInventoryFloatable(inst, "med", 0.1, 0.65, nil, nil, swap_data)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("polarflea_sack")
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.POLARFLEA_SACK_PERISHTIME)
	inst.components.fueled:SetDepletedFn(OnDepleted)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_MED_LARGE)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = false
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(FleaPreserverRate)
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	inst.components.burnable:SetOnBurntFn(OnBurnt)
	inst.components.burnable:SetOnIgniteFn(OnIgnite)
	inst.components.burnable:SetOnExtinguishFn(OnExtinguish)
	
	MakeHauntableLaunchAndDropFirstItem(inst)
	
	inst.UpdateFleas = UpdateFleas
	
	return inst
end

return Prefab("polarflea_sack", fn, assets)