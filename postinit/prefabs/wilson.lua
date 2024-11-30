local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddPrefabPostInit = ENV.AddPrefabPostInit

--

local function PolarSnowUpdate(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local polarsnowlevel = TheWorld.components.polarsnow_manager:GetDataAtPoint(x, y, z)
	
	inst.player_classified.polarsnowlevel:set(polarsnowlevel)
end

ENV.AddPlayerPostInit(function(inst)
	if not TheNet:IsDedicated() then
		inst._polarsnowfx = SpawnPrefab("snow_polar")
		inst._polarsnowfx.entity:SetParent(inst.entity)
		inst._polarsnowfx.particles_per_tick = 0
		inst._polarsnowfx:PostInit()
		
		inst:AddComponent("snowwaver")
	end
	
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("polarstormwatcher")
	
	if inst.components.areaaware then
		inst.components.areaaware:StartWatchingTile(WORLD_TILES.POLAR_ICE)
	end
	
	inst:AddComponent("polarwalker")
	
	if not inst.components.updatelooper then
		inst:AddComponent("updatelooper")
	end
	
	inst:AddComponent("tumblewindattractor")
	
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

local function Wolfgang_Polar_SlowMult(inst, mult)
	if inst.components.rider and inst.components.rider:IsRiding() then
		return mult
	end
	
	local state = inst.components.mightiness and inst.components.mightiness:GetState() or nil
	local legday = inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated("wolfgang_normal_speed")
	
	local mighty_mult = state == "mighty" and TUNING.MIGHTINESS_POLAR_SLOWMULT
		or state == "wimpy" and TUNING.WIMPY_POLAR_SLOWMULT
		or (legday and state == "normal") and TUNING.LEGDAY_POLAR_SLOWMULT
		or 1
	
	return math.min(1, mult * mighty_mult)
end

local function Wolfgang_Polar_Time(inst, slowtime)
	if inst.components.rider and inst.components.rider:IsRiding() then
		return slowtime
	end
	
	local state = inst.components.mightiness and inst.components.mightiness:GetState() or nil
	local legday = inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated("wolfgang_normal_speed")
	
	local mighty_time = state == "mighty" and TUNING.MIGHTINESS_POLAR_SLOWTIME
		or state == "wimpy" and TUNING.WIMPY_POLAR_SLOWTIME
		or (legday and state == "normal") and TUNING.LEGDAY_POLAR_SLOWTIME
		or 0
	
	return slowtime + mighty_time
end

ENV.AddPrefabPostInit("wolfgang", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.polar_slowedmult = Wolfgang_Polar_SlowMult
	inst.polar_slowingmult = Wolfgang_Polar_SlowMult
	inst.polar_slowtime = Wolfgang_Polar_Time
end)

--	Woodie transformations deal with snow easier (or with his cane!)

local function Woodie_Polar_SlowMult(inst, mult)
	return inst:HasTag("wereplayer") and math.min(1, inst:HasTag("wereplayer") and mult * TUNING.WEREMODE_POLAR_SLOWMULT) or mult
end

local function Woodie_Polar_Time(inst, slowtime)
	return inst:HasTag("wereplayer") and (slowtime + TUNING.WEREMODE_POLAR_SLOWTIME) or slowtime
end

ENV.AddPrefabPostInit("woodie", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.polar_slowedmult = Woodie_Polar_SlowMult
	inst.polar_slowingmult = Woodie_Polar_SlowMult
	inst.polar_slowtime = Woodie_Polar_Time
end)