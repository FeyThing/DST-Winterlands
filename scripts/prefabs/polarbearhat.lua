local assets = {
	Asset("ANIM", "anim/hat_polarbear.zip"),
}

local DEFAULT_PAINTING = "blue"
local HAT_PAINTINGS = {
	"blue",
	"red",
}

local function OnAttacked(owner, data, inst)
	if data and data.attacker and not data.attacker:HasTag("bear") and owner.components.combat then
		owner.components.combat:SetTarget(data.attacker)
		owner.components.combat:ShareTarget(data.attacker, 30, function(dude)
			return dude:HasTag("bear") and dude.components.health and not dude.components.health:IsDead()
		end, 10)
	end
end

local function OnEquip(inst, owner)
	if inst.hat_paint == nil then
		inst:SetPainting(HAT_PAINTINGS[math.random(#HAT_PAINTINGS)])
	end
	
	if inst.fx then
		inst.fx:Remove()
	end
	inst.fx = SpawnPrefab("polarbearhat_fx_"..inst.hat_paint)
	inst.fx:AttachToOwner(owner)
	
	owner.AnimState:Show("HAT")
	owner.AnimState:Hide("HAIR_NOHAT")
	owner.AnimState:Hide("HAIR")
	
	owner:AddTag("bearbuddy")
	if owner:HasTag("player") then
		owner.AnimState:Hide("HEAD")
		owner.AnimState:Show("HEAD_HAT")
		owner.AnimState:Show("HEAD_HAT_NOHELM")
		owner.AnimState:Hide("HEAD_HAT_HELM")
		owner.AnimState:HideSymbol("beard")
	end
	
	inst:ListenForEvent("attacked", inst._onblocked, owner)
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()
	end
end

local function OnUnequip(inst, owner)
	if inst.fx then
		inst.fx:Remove()
		inst.fx = nil
	end
	
	owner.AnimState:ClearOverrideSymbol("swap_hat")
	owner.AnimState:Hide("HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	
	owner:RemoveTag("bearbuddy")
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
		owner.AnimState:Hide("HEAD_HAT_NOHELM")
		owner.AnimState:Hide("HEAD_HAT_HELM")
		owner.AnimState:ShowSymbol("beard")
	end
	
	inst:RemoveEventCallback("attacked", inst._onblocked, owner)
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
end

local function OnEquipToModel(inst, owner)
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
end

local function SetPainting(inst, colour)
	if colour ~= DEFAULT_PAINTING then
		inst.AnimState:OverrideSymbol("hat01", "hat_polarbear", "hat01_"..colour)
	else
		inst.AnimState:ClearOverrideSymbol("hat01")
	end
	
	if inst.components.inventoryitem then
		inst.components.inventoryitem:ChangeImageName("polarbearhat"..(colour == DEFAULT_PAINTING and "" or ("_"..colour)))
	end
	inst.hat_paint = colour
end

local function OnSave(inst, data)
	data.colour = inst.hat_paint
end

local function OnLoad(inst, data)
	if data and data.colour then
		inst:SetPainting(data.colour)
	end
end

local function OnInit(inst)
	if inst.hat_paint == nil then
		inst:SetPainting(inst.hat_paint or HAT_PAINTINGS[math.random(#HAT_PAINTINGS)])
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polarbearhat")
	inst.AnimState:SetBuild("hat_polarbear")
	inst.AnimState:PlayAnimation("anim")
	
	inst:AddTag("hat")
	inst:AddTag("bearhead")
	
	inst:AddComponent("snowmandecor")
	
	local swap_data = {bank = "polarbearhat", anim = "anim"}
	MakeInventoryFloatable(inst, "med", 0.07, 0.72)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable.dapperness = -TUNING.DAPPERNESS_SMALL
	inst.components.equippable.flipdapperonmerms = true
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.POLARBEARHAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = POLAR_ATLAS
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunch(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.SetPainting = SetPainting
	
	inst._onblocked = function(owner, data) OnAttacked(owner, data, inst) end
	
	inst:DoTaskInTime(0, OnInit)
	
	return inst
end

--

local function CreateFxFollowFrame(i, anim, colour)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("polarbearhat")
	inst.AnimState:SetBuild("hat_polarbear")
	inst.AnimState:PlayAnimation(anim..tostring(i))
	
	if colour ~= DEFAULT_PAINTING then
		inst.AnimState:OverrideSymbol("hat01", "hat_polarbear", "hat01_"..colour)
	else
		inst.AnimState:ClearOverrideSymbol("hat01")
	end
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	
	return inst
end

local function fx_OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx) do
		v:Remove()
	end
end

local function fx_SpawnFxForOwner(inst, owner)
	inst.owner = owner
	inst.fx = {}
	
	local parts = {"jaw", "top"}
	for i, v in ipairs(parts) do
		for j = 1, 3 do
			local fx = CreateFxFollowFrame(j, v, inst.bearhat_colour)
			
			fx.entity:SetParent(owner.entity)
			fx.Follower:FollowSymbol(owner.GUID, "headbase_hat", 0, -5, 0, true, nil, j - 1)
			fx.components.highlightchild:SetOwner(owner)
			table.insert(inst.fx, fx)
		end
	end
	
	inst.OnRemoveEntity = fx_OnRemoveEntity
end

local function fx_OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	if owner ~= nil then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function fx_AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	if not TheNet:IsDedicated() then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function MakeHatFX(colour)
	local function fx()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddNetwork()
		
		inst:AddTag("FX")
		
		inst.bearhat_colour = colour
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			inst.OnEntityReplicated = fx_OnEntityReplicated
			
			return inst
		end
		
		inst.persists = false
		
		inst.AttachToOwner = fx_AttachToOwner
		
		return inst
	end

	return Prefab("polarbearhat_fx_"..colour, fx, assets)
end

local ret = {}

table.insert(ret, Prefab("polarbearhat", fn, assets))

for i, v in ipairs(HAT_PAINTINGS) do
	table.insert(ret, MakeHatFX(v))
end

return unpack(ret)