local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddPrefabPostInit = ENV.AddPrefabPostInit

local function OverrideIsCarefulWalking(inst)
	local old_IsCarefulWalking = inst.IsCarefulWalking
	inst.IsCarefulWalking = function(inst, ...)
		return old_IsCarefulWalking(inst, ...) or inst.deepinhighsnow:value()
	end
end

--

local function PolarSnowUpdate(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local polarsnowlevel = TheWorld.components.polarsnow_manager and TheWorld.components.polarsnow_manager:GetDataAtPoint(x, y, z)
	
	if polarsnowlevel then
		inst.player_classified.polarsnowlevel:set(polarsnowlevel)
	end
end

local function OnNearHighSnowDirty(inst)
	inst:PushEvent("refreshcrafting")
end

--

local OldOnSave
local function OnSave(inst, data, ...)
	if inst:HasTag("arcticfooled") and TheWorld.components.arcticfoolfishsavedata then
		local fish = TheWorld.components.arcticfoolfishsavedata:GetFishForTarget(inst)
		
		if fish and fish.components.arcticfoolfish then
			data.arctic_fooled_by = fish.components.arcticfoolfish.pranker_id
		end
	end
	
	if OldOnSave then
		return OldOnSave(inst, data, ...)
	end
end

local OldOnLoad
local function OnLoad(inst, data, ...)
	if data and data.arctic_fooled_by then
		local fish = SpawnPrefab("arctic_fool_fish")
		local back = fish.components.arcticfoolfish:StickOnBack(inst)
		
		if back and back.components.arcticfoolfish then
			back.components.arcticfoolfish.pranker_id = data.arctic_fooled_by
		end
	end
	
	if OldOnLoad then
		return OldOnLoad(inst, data, ...)
	end
end

local function RemoveArcticFoolFish(inst)
	if inst:HasTag("arcticfooled") then
		local fish = TheWorld.components.arcticfoolfishsavedata:GetFishForTarget(inst)
		
		if fish and fish.components.arcticfoolfish then
			fish.components.arcticfoolfish:UnstickFromBack(inst)
			fish:Remove()
		else
			inst:RemoveTag("arcticfooled")
		end
		
		inst:DoTaskInTime(0.2 + math.random() * 0.5, function()
			if inst.components.wisecracker then
				inst:PushEvent("removearcticfoolfish")
			end
		end)
	end
end

local function OnUsedArcticFoolFish(inst)
	TheFrontEnd:GetSound():PlaySound("polarsounds/arctic_fools/stick_fish")
end

ENV.AddPlayerPostInit(function(inst)
	if not TheNet:IsDedicated() then
		inst._polarsnowfx = SpawnPrefab("snow_polar")
		inst._polarsnowfx.entity:SetParent(inst.entity)
		inst._polarsnowfx.particles_per_tick = 0
		inst._polarsnowfx:PostInit()
	end
	
	OverrideIsCarefulWalking(inst)
	
	inst.nearhighsnow = net_bool(inst.GUID, "polarwalker.nearhighsnow", "nearhighsnowdirty")
	inst.deepinhighsnow = net_bool(inst.GUID, "polarwalker.deepinhighsnow")
	inst.deepinhighsnow:set(false)
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "localplayer._snowblockrange") -- Mostly for WX
	inst._snowblockrange:set(0)
	
	inst._usearcticfoolfish = net_event(inst.GUID, "localplayer._usearcticfoolfish")
	
	inst:AddComponent("snowedshader")
	
	if not TheWorld.ismastersim then
		inst:ListenForEvent("nearhighsnowdirty", OnNearHighSnowDirty)
		inst:ListenForEvent("localplayer._usearcticfoolfish", OnUsedArcticFoolFish)
		
		return
	end
	
	inst:AddComponent("polarstormwatcher")
	
	if inst.components.areaaware then
		inst.components.areaaware:StartWatchingTile(WORLD_TILES.POLAR_ICE)
		inst.components.areaaware:StartWatchingTile(WORLD_TILES.POLAR_SNOW)
	end
	
	inst:AddComponent("polarwalker")
	
	if not inst.components.updatelooper then
		inst:AddComponent("updatelooper")
	end
	
	inst:AddComponent("tumblewindattractor")
	
	if OldOnSave == nil then
		OldOnSave = inst.OnSave
	end
	if OldOnLoad == nil then
		OldOnLoad = inst.OnLoad
	end
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.RemoveArcticFoolFish = RemoveArcticFoolFish
	
	inst:DoTaskInTime(1, function() -- Delay the first check to make sure the polarsnowlevel is synced
		PolarSnowUpdate(inst)
		inst.components.updatelooper:AddOnUpdateFn(PolarSnowUpdate)
	end)
end)

AddPrefabPostInit("player_classified", function(inst)
	inst.stormtypechange = net_event(inst.GUID, "stormtypedirty") -- stormtype lacks a dirty event

	local base_polarsnow_particles_per_tick = 16
	inst.polarsnowlevel = net_float(inst.GUID, "polarsnowlevel", "polarsnowleveldirty")
	
	inst:DoStaticTaskInTime(0, function(inst)
		inst:ListenForEvent("polarsnowleveldirty", function(inst)
			if inst._parent._polarsnowfx then
				inst._parent._polarsnowfx.particles_per_tick = base_polarsnow_particles_per_tick * inst.polarsnowlevel:value()

				if inst.stormtype:value() == STORM_TYPES.POLARSTORM then
					inst._parent._polarsnowfx.particles_per_tick = inst._parent._polarsnowfx.particles_per_tick * 4
				end
			end
		end)

		inst:ListenForEvent("stormtypedirty", function(inst)
			if inst._parent._polarsnowfx then
				inst._parent._polarsnowfx.particles_per_tick = base_polarsnow_particles_per_tick * inst.polarsnowlevel:value()

				if inst.stormtype:value() == STORM_TYPES.POLARSTORM then
					inst._parent._polarsnowfx.particles_per_tick = inst._parent._polarsnowfx.particles_per_tick * 4
					inst._parent._polarsnowfx.particles_acceleration = { 0, -20, -9.80 * 4, 24 }
				else
					inst._parent._polarsnowfx.particles_acceleration = { 0, -1, -9.80, 1 }
				end
			end
		end)
	end)
end)

--	Wolfgang beats snow when mighty, not when wimpy :<

local function Wolfgang_Polar_Time(inst, slowtime)
	if inst.components.rider and inst.components.rider:IsRiding() then
		return
	end
	
	local state = inst.components.mightiness and inst.components.mightiness:GetState() or nil
	local legday = inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated("wolfgang_normal_speed")
	
	local mighty_time = state == "mighty" and TUNING.MIGHTINESS_POLAR_SLOWTIME
		or state == "wimpy" and TUNING.WIMPY_POLAR_SLOWTIME
		or (legday and state == "normal") and TUNING.LEGDAY_POLAR_SLOWTIME
		or 0
	
	return mighty_time
end

ENV.AddPrefabPostInit("wolfgang", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.polar_slowtime = Wolfgang_Polar_Time
end)

--	Woodie transformations deal with snow easier (or with his cane!)

local function Woodie_Polar_Time(inst, slowtime)
	return inst:HasTag("wereplayer") and (slowtime * TUNING.WEREMODE_POLAR_SLOWTIME) or 0
end

ENV.AddPrefabPostInit("woodie", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.polar_slowtime = Woodie_Polar_Time
end)