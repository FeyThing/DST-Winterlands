local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddPrefabPostInit = ENV.AddPrefabPostInit

ENV.AddPlayerPostInit(function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.areaaware then
		inst.components.areaaware:StartWatchingTile(WORLD_TILES.POLAR_ICE)
	end
	
	inst:AddComponent("polarwalker")
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