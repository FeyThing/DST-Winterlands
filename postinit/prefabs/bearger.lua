local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldShouldSleep
local function ShouldSleep(inst, ...)
	if IsInPolar(inst) and not (inst.components.combat:HasTarget() or inst.components.health.takingfiredamage) then
		if inst.components.shedder then
			inst.components.shedder:StopShedding()
		end
		inst:AddTag("hibernation")
		inst:AddTag("asleep")
		inst.AnimState:OverrideSymbol("bearger_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "bearger_yule" or "bearger_build", "bearger_head_groggy")
		
		return true
	else
		return OldShouldSleep(inst, ...)
	end
end

local OldShouldWake
local function ShouldWake(inst, occupied, ...)
	if IsInPolar(inst) then
		return false
	else
		return OldShouldWake(inst, ...)
	end
end

local OldOnSeasonChange
local function OnSeasonChange(inst, season, ...)
	if OldOnSeasonChange then
		OldOnSeasonChange(inst, season, ...)
	end
	
	if IsInPolar(inst) then
		inst:AddTag("hibernation")
	end
end

local function PolarInit(inst)
	if inst.worldstatewatching["season"] then
		if OldOnSeasonChange == nil then
			OldOnSeasonChange = inst.worldstatewatching["season"][1]
		end
		
		inst.worldstatewatching["season"][1] = OnSeasonChange
	end
	
	if IsInPolar(inst) then
		inst:AddTag("hibernation")
	end
end

ENV.AddPrefabPostInit("bearger", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.sleeper then
		if OldShouldSleep == nil then
			OldShouldSleep = inst.components.sleeper.sleeptestfn
		end
		if OldShouldWake == nil then
			OldShouldWake = inst.components.sleeper.waketestfn
		end
		
		inst.components.sleeper:SetSleepTest(ShouldSleep)
		inst.components.sleeper:SetWakeTest(ShouldWake)
	end
	
	inst:DoTaskInTime(0, PolarInit)
end)