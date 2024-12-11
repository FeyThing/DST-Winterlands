-------------------------------------------------------------------------
---------------------- Attach and dettach functions ---------------------
-------------------------------------------------------------------------

local function Immunity_OnAttached(inst, target)
	target:AddTag("polarimmune")
end

local function Immunity_OnDetached(inst, target)
	target:RemoveTag("polarimmune")
end

--

local HEATSOURCE_TAGS = {"HASHEATER"}
local HEATSOURCE_NOT_TAGS = {"heatrock"}

local function wetness_ontick(inst, target)
	if target.components.moisture and target.components.moisture:GetMoisturePercent() <= 0 then
		SetPolarWetness(target, 0) -- This should only be happening in case of Cordon Bleu or other witchcrafts
		
		return
	end
	
	if inst.components.temperature then
		local level = GetPolarWetness(target)
		local level_max = TUNING.POLAR_WETNESS_LVLS
		local temperature = math.max(inst.components.temperature:GetCurrent(), 0)
		local temperature_level = level_max - math.ceil((temperature / inst.components.temperature.overheattemp) * level_max)
		
		local x, y, z = target.Transform:GetWorldPosition()
		local heat_sources = TheSim:FindEntities(x, y, z, 10, HEATSOURCE_TAGS, HEATSOURCE_NOT_TAGS)
		local in_snow = TheWorld.Map:IsPolarSnowAtPoint(x, y, z, true) and not TheWorld.Map:IsPolarSnowBlocked(x, y, z) -- TODO: Ignore blockers if source of snow is blizard
		
		local immune = HasPolarDebuffImmunity(target)
		if not immune and (in_snow or #heat_sources > 0) then
			inst.components.temperature:SetTemp(nil)
		else
			inst.components.temperature:SetTemp(temperature)
		end
		
		if target.components.temperature then
			target.components.temperature:SetModifier("polarwetness", TUNING.POLARWETNESS_DEBUFF_TEMP_MODIFIER * level)
		end
		
		local waterproofness = immune and 1 or (target.components.moisture and target.components.moisture:GetWaterproofness() or 0)
		inst.components.temperature.inherentinsulation = TUNING.POLAR_WETNESS_MAX_INSULATION * waterproofness * (immune and 4 or 1)
		
		SetPolarWetness(target, (temperature_level <= 0 and not in_snow) and 0 or math.max(level, temperature_level))
	end
end

local function Wetness_OnAttached(inst, target)
	if target.components.moisture and target.components.moisture:GetMoisturePercent() < 0.05 then
		target.components.moisture:SetPercent(0.05)
	end
	if target.components.health then
		target.components.health.externalfiredamagemultipliers:SetModifier("polarwetness", 1 - TUNING.POLARWETNESS_DEBUFF_FIRE_RESIST)
	end
	
	inst.task = inst:DoPeriodicTask(TUNING.POLARWETNESS_DEBUFF_TICK, wetness_ontick, nil, target)
end

local function Wetness_OnDetached(inst, target)
	if target.components.health then
		target.components.health.externalfiredamagemultipliers:RemoveModifier("polarwetness")
	end
	if target.components.health then
		target.components.temperature:RemoveModifier("polarwetness")
	end
	
	SetPolarWetness(target, 0)
end

-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
	if data.name == "buffover" then
		inst.components.debuff:Stop()
	end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, announce, temperature)
	local function OnAttached(inst, target)
		inst.entity:SetParent(target.entity)
		inst.Transform:SetPosition(0, 0, 0)
		
		inst:ListenForEvent("death", function() inst.components.debuff:Stop() end, target)
		
		if announce then
			target:PushEvent("foodbuffattached", {buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority})
		end
		
		if onattachedfn then
			onattachedfn(inst, target)
		end
	end
	
	local function OnExtended(inst, target)
		if duration then
			inst.components.timer:StopTimer("buffover")
			inst.components.timer:StartTimer("buffover", duration)
		end
		
		if onextendedfn then
			onextendedfn(inst, target)
		end
	end
	
	local function OnDetached(inst, target)
		if ondetachedfn then
			ondetachedfn(inst, target)
		end
		
		if announce then
			target:PushEvent("foodbuffdetached", {buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name), priority = priority})
		end
		
		inst:Remove()
	end
	
	local function fn()
		local inst = CreateEntity()
		
		if not TheWorld.ismastersim then
			inst:DoTaskInTime(0, inst.Remove)
			
			return inst
		end
		
		inst.entity:AddTransform()
		
		inst.entity:Hide()
		
		inst:AddTag("CLASSIFIED")
		
		inst:AddComponent("debuff")
		inst.components.debuff:SetAttachedFn(OnAttached)
		inst.components.debuff:SetDetachedFn(OnDetached)
		inst.components.debuff:SetExtendedFn(OnExtended)
		inst.components.debuff.keepondespawn = true
		
		if temperature then
			inst:AddComponent("temperature")
			inst.components.temperature.overheattemp = TUNING.POLAR_WETNESS_OVERHEATS
			inst.components.temperature:SetTemperature(temperature)
		end
		
		inst:AddComponent("timer")
		if duration then
			inst.components.timer:StartTimer("buffover", duration)
		end
		
		inst:ListenForEvent("timerdone", OnTimerDone)
		
		inst.persists = false
		
		return inst
	end
	
	return Prefab("buff_"..name, fn)
end

return MakeBuff("polarwetness", Wetness_OnAttached, nil, Wetness_OnDetached, nil, 2, true, TUNING.POLARWETNESS_DEBUFF_STARTTEMP),
	MakeBuff("polarimmunity", Immunity_OnAttached, nil, Immunity_OnDetached, TUNING.POLAR_IMMUNITY_DURATION, 2, false)