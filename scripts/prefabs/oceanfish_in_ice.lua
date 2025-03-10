local FISH_DATA = require("prefabs/oceanfishdef")

local assets = {
	Asset("ANIM", "anim/oceanfish_in_ice.zip"),
}

local NUM_FLOAT_ANIMS = 3

local function SetMeltingAlpha(inst)
	local a = 0.9
	
	if inst.components.hatchable then
		a = 0.9 - (inst.components.hatchable.progress / inst.components.hatchable.hatchtime) * (0.9 - 0.3)
	end
	
	inst.AnimState:SetMultColour(1, 1, 1, a)
	
	return a
end


local function OnHatchState(inst, state)
	if state == "hatch" and inst.components.lootdropper then
		local def = inst:GetFishDef(inst.trapped_fish)
		
		if def then
			local fish = inst.components.lootdropper:SpawnLootPrefab(def.prefab.."_inv")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
			
			if fish then
				if fish.components.weighable then
					fish.components.weighable:SetPlayerAsOwner(inst)
				end
			end
			
			for i = 1, 1 + math.random(2) do
				inst.components.lootdropper:SpawnLootPrefab("ice")
			end
		end
		
	    inst:Remove()
	end
end

local function OnDropped(inst)
	if inst.components.hatchable then
		inst.components.hatchable:StartUpdating()
	end
end

local function OnPutInInventory(inst)
    if inst.components.hatchable then
		inst.components.hatchable:StopUpdating()
	end
end

--

local function OnEntitySleep(inst)
	if inst._setalphatask then
		inst._setalphatask:Cancel()
		inst._setalphatask = nil
	end
end

local function OnEntityWake(inst)
	if inst._setalphatask == nil then
		inst._setalphatask = inst:DoPeriodicTask(0.2, inst.SetMeltingAlpha, 0)
	end
end

local function OnSave(inst, data)
	data.cube_scale = inst.cube_scale or 1
	data.trapped_fish = inst.trapped_fish
end

local function OnLoad(inst, data)
	if data then
		if data.cube_scale then
			inst.cube_scale = data.cube_scale
			inst.AnimState:SetScale(inst.cube_scale, 1)
		end
		if data.trapped_fish then
			inst:SetTrappedFish(data.trapped_fish)
		end
	end
end

local function OnPolarFreeze(inst, forming)
	local spawner = TheWorld.components.oceanfish_in_ice_spawner
	if forming and spawner and spawner.fishies_in_ice[inst] then
		spawner:onicecubepickedup(inst)
		
		inst:Remove()
	end
end

local function GetFishDef(inst, name)
	local def = FISH_DATA.fish[name]
	
	return def
end

local function SetTrappedFish(inst, name, data)
	if inst._fish and inst._fish:IsValid() then
		inst._fish:Remove()
	end
	
	local def = inst:GetFishDef(name)
	local fish
	
	if def then
		data = data or {}
		
		fish = SpawnPrefab("oceanfish_in_ice_fish")
		
		fish.entity:SetParent(inst.entity)
		fish.entity:AddFollower()
		fish.Follower:FollowSymbol(inst.GUID, "swap_fish", nil, nil, nil, true, nil, 0)
		
		fish.AnimState:SetBank(data.bank or def.bank)
		fish.AnimState:SetBuild(data.build or def.build)
		fish.AnimState:PlayAnimation(data.anim or "flop_pst")
	end
		
	inst._fish = fish
	inst.trapped_fish = name
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("oceanfish_in_ice")
	inst.AnimState:SetBuild("oceanfish_in_ice")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("fishyicecube")
	inst:AddTag("furnituredecor")
	
	inst.no_wet_prefix = true
	
	inst.pickupsound = "rock"
	
	MakeInventoryFloatable(inst, "large", 0.4, 0.7)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("furnituredecor")
	
	inst:AddComponent("hatchable")
	inst.components.hatchable:SetOnState(OnHatchState)
	inst.components.hatchable:SetCrackTime(TUNING.OCEANFISH_IN_ICE_HATCH_CRACK_TIME)
	inst.components.hatchable:SetHatchTime(TUNING.OCEANFISH_IN_ICE_HATCH_TIME)
	inst.components.hatchable:SetHatchFailTime(1) -- Just chilling
	inst.components.hatchable:SetHeaterPrefs(true, true, true)
	inst.components.hatchable:StartUpdating()
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunch(inst)
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnPolarFreeze = OnPolarFreeze
	inst.GetFishDef = GetFishDef
	inst.SetTrappedFish = SetTrappedFish
	inst.SetMeltingAlpha = SetMeltingAlpha
	
	inst.cube_scale = math.random() > 0.5 and 1 or -1
	inst.AnimState:SetScale(inst.cube_scale, 1)
	
	inst:ListenForEvent("floater_startfloating", function(inst)
		inst.AnimState:PlayAnimation("float_"..math.random(NUM_FLOAT_ANIMS))
		inst:DoTaskInTime(0, function()
			inst.AnimState:SetFloatParams(0.2, 1, inst.components.floater and inst.components.floater.bob_percent or 0.5)
		end)
	end)
	inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)
	
	return inst
end

local function fish()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("oceanfish_small")
	inst.AnimState:SetBuild("oceanfish_small_1")
	inst.AnimState:PlayAnimation("flop_pst")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	return inst
end

return Prefab("oceanfish_in_ice", fn, assets),
	Prefab("oceanfish_in_ice_fish", fish, assets)