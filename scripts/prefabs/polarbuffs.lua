-------------------------------------------------------------------------
---------------------- Attach and dettach functions ---------------------
-------------------------------------------------------------------------

--	[[			Frozen Wetness			]]	--

local HEATSOURCE_TAGS = {"HASHEATER"}
local HEATSOURCE_NOT_TAGS = {"heatrock"}

local function wetness_ontick(inst, target)
	if target.components.moisture and target.components.moisture:GetMoisturePercent() <= 0 then -- or target:HasDebuff("buff_polarimmunity") then
		SetPolarWetness(target, 0) -- This should only be happening in case of Cordon Bleu or other witchcrafts
		
		return
	end
	
	if inst.components.temperature then
		local level = GetPolarWetness(target)
		local level_max = TUNING.POLAR_WETNESS_LVLS
		local temperature = math.max(inst.components.temperature:GetCurrent(), 0)
		local temperature_level = level_max - math.floor(temperature / inst.components.temperature.overheattemp * level_max)
		
		if target.components.snowedshader then
			target.components.snowedshader:SetFreezeAmount(1 - temperature / inst.components.temperature.overheattemp)
		end
		
		local x, y, z = target.Transform:GetWorldPosition()
		local heat_sources = TheSim:FindEntities(x, y, z, 10, HEATSOURCE_TAGS, HEATSOURCE_NOT_TAGS)
		local warming = false
		
		for i, v in ipairs(heat_sources) do
			local heat = v.components.heater and v.components.heater:GetHeat(target) or 0
			
			if heat > 0 then
				warming = true
				break
			end
		end
		
		local in_snow = TheWorld.Map:IsPolarSnowAtPoint(x, y, z, true) and not TheWorld.Map:IsPolarSnowBlocked(x, y, z)
		local immune = HasPolarDebuffImmunity(target)
		
		if (not immune and (in_snow or warming)) or (immune and warming) then
			inst.components.temperature:SetTemp(nil)
		else
			inst.components.temperature:SetTemp(temperature)
		end
		
		if warming then
			inst.components.temperature:SetModifier("meltinghelper", TUNING.POLAR_WETNESS_TEMP_MODIFIER) -- This is to avoid incapacity of melting at low-fuel campfires
		else
			inst.components.temperature:RemoveModifier("meltinghelper")
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

--	[[		Frozen Wetness Imunity		]]	--

local function Immunity_OnAttached(inst, target)
	target:AddTag("polarimmune")
end

local function Immunity_OnDetached(inst, target)
	target:RemoveTag("polarimmune")
end

--	[[		Player's Bagpipes Buff		]]	--

local function walrusally_onattackother(target, data)
	local victim = data and data.target
	
	if victim and (victim:HasTag("walrus") or victim:HasTag("hound")) then
		target:RemoveDebuff("buff_walrusally")
		
		if target.components.timer then
			if target.components.timer:TimerExists("walrusally_oncooldown") then
				target.components.timer:SetTimeLeft("walrusally_oncooldown", 4 + math.random())
			else
				target.components.timer:StartTimer("walrusally_oncooldown", 4 + math.random())
			end
		end
	end
end

local function WalrusAlly_OnAttached(inst, target)
	target:AddTag("walruspal")
	inst:ListenForEvent("onattackother", walrusally_onattackother, target)
end

local function WalrusAlly_OnDetached(inst, target)
	target:RemoveTag("walruspal")
	inst:RemoveEventCallback("onattackother", walrusally_onattackother, target)
end

--	[[		MaTusk's Support Buffs		]]	--

local function walrusboost_onattackother(target, data)
	local victim = data and data.target
	
	if target._walrusboost and victim and victim.components.freezable and not victim.components.freezable:IsFrozen() then
		victim.components.freezable:AddColdness(2)
	end
end

local function walrusboost_ontick(inst, target)
	if not target._walrusboost then
		if not (target.components.health and target.components.health:IsDead()) then
			if target:HasTag("hound") then
				target.sg:GoToState("howl", {})
				target._walrusboost = true
			else
				target:PushEvent("walrusboosted")
			end
		end
	elseif target:HasTag("hound") and inst.buff_fx == nil then
		inst.buff_fx = SpawnPrefab("beargerfur_sack_frost_fx")
		inst.buff_fx.Transform:SetScale(1.5, 1.5, 1.5)
		inst.buff_fx.entity:SetParent(target.entity)
	end
end

local function WalrusBoost_OnAttached(inst, target)
	inst.task = inst:DoPeriodicTask(math.random() * 0.5, walrusboost_ontick, nil, target)
	
	if target:HasTag("hound") then
		inst:ListenForEvent("onattackother", walrusboost_onattackother, target)
	end
end

local function WalrusBoost_OnDetached(inst, target)
	if inst.buff_fx and inst.buff_fx:IsValid() then
		inst.buff_fx:Remove()
		inst.buff_fx = nil
	end
	
	if target:HasTag("hound") then
		inst:RemoveEventCallback("onattackother", walrusboost_onattackother, target)
	end
	
	target._walrusboost = false
end

--	[[		Snoot Platter Hunting		]]	--

local DIRTPILE_TAGS = {"dirtpile"}

local function huntmoar_onhunt(target, data)
	local hunt = data and data.hunt
	if hunt and data.pt and data.hunt.direction then
		local dir = data.hunt.direction
		local rot = dir / DEGREES - 90
		
		local dx, dz = math.cos(dir), -math.sin(dir)
		local px, pz = -dz, dx
		
		local ismonster = hunt.monster_track_num and hunt.trackspawned >= hunt.monster_track_num
		local dist = TUNING.HUNT_SPAWN_DIST - 2 - (ismonster and 5 or 0)
		for i = 2, dist, 2 do
			target:DoTaskInTime(0.19 * i, function()
				local j = (math.random() * 2 - 1) * 1.2
				local x, y, z = data.pt.x + dx * i + px * j, 0, data.pt.z + dz * i + pz * j
				
				if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) then
					local track = SpawnPrefab("animal_track")
					
					if ismonster then
						track.AnimState:PlayAnimation("clawed"..math.random(1, 3))
					end
					track.Transform:SetPosition(x, y, z)
					track.Transform:SetRotation(rot)
					PlayFootstep(track, 0.2 + math.random() * 0.3)
					track:AddTag("NOBLOCK")
					track:AddTag("NOCLICK")
					
					if track.SetBaseAlpha then
						track:SetBaseAlpha(0)
						if track.components.colourtweener == nil then
							track:AddComponent("colourtweener")
						end
						
						track.components.colourtweener:StartTween({1, 1, 1, 0.5}, 1, function() track:SetBaseAlpha(0.5) end)
					end
				end
			end)
		end
	end
end

local function HuntMoar_OnAttached(inst, target)
	inst:ListenForEvent("huntmoartracking", huntmoar_onhunt, target)
end

local function HuntMoar_OnDetached(inst, target)
	inst:RemoveEventCallback("huntmoartracking", huntmoar_onhunt, target)
end

local function HuntMoar_OnSave(inst, data)
	data.mode = inst.mode
end

local function HuntMoar_OnLoad(inst, data)
	if data and data.mode then
		inst.mode = data.mode
	end
end

--	[[			Ursa Major Buff			]]	--

local function UrsaMajor_OnAttached(inst, target) -- TODO: We should add some nice visuals to actions performed while this is active
	if target.components.combat then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.BUFF_ATTACK_MULTIPLIER)
	end
	
	if target.components.health then
		target.components.health.externalabsorbmodifiers:SetModifier(inst, TUNING.BUFF_PLAYERABSORPTION_MODIFIER)
	end
	
	if target.components.workmultiplier == nil then
		target:AddComponent("workmultiplier")
	end
	target.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, inst)
	target.components.workmultiplier:AddMultiplier(ACTIONS.MINE, TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, inst)
	target.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER, inst)
end

local function UrsaMajor_OnDetached(inst, target)
	if target.components.combat then
		target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
	end
	
	if target.components.health then
		target.components.health.externalabsorbmodifiers:RemoveModifier(inst)
	end
	
	if target.components.workmultiplier then
		target.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP, inst)
		target.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE, inst)
		target.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, inst)
	end
end

--	[[	Timefreeze Watch Invincibility	]]	--

local function wandatimefreeze_debugstatdrain(inst, stat, amt)
	if inst._statdrains == nil then
		inst._statdrains = {}
		for k, v in pairs(TUNING.POCKERWATCH_BUFF_DRAINS) do
			inst._statdrains[k] = 0
		end
	end
	
	if inst._statdrains[stat] then
		inst._statdrains[stat] = inst._statdrains[stat] + amt
	end
	
	if inst._debugdraintask == nil then
		inst._debugdraintask = inst:DoPeriodicTask(1, function()
			print("Timefreeze Watch Start drain :")
			local total = 0
			for k, v in pairs(inst._statdrains) do
				total = total + v
				print(string.format("	%-12s %.3fs", k..":", v))
			end
			print(string.format("		total: %.3fs\n", total))
		end)
	end
end

local function wandatimefreeze_ontemperaturedelta(inst, target, data)
	if not target:HasTag("frozenstats") or target.components.temperature == nil then
		return
	end
	
	local dangeriness = math.abs(target.components.temperature.delta) * math.abs(target.components.temperature.delta)
	local mult = TUNING.POCKERWATCH_BUFF_DRAINS.temperature
	local drain = dangeriness * mult * FRAMES
	
	local timeleft = inst.components.timer and inst.components.timer:GetTimeLeft("buffover")
	if timeleft then
		if inst.debugstatdrain then
			inst:debugstatdrain("temperature", drain)
		end
		
		inst.components.timer:SetTimeLeft("buffover", math.max(0, timeleft - drain))
	end
end

local function wandatimefreeze_nexttween(inst)
	if inst and inst:IsValid() then
		inst._tweening = inst._tweening == 2 and 3 or 1
	end
end

local function wandatimefreeze_ontick(inst, target)
	target:AddTag("vigorbuff")
	
	local fx = SpawnPrefab("wandatimefreeze_player_fx")
	if fx and fx.SetPuppetStyle then
		local x, y, z = target.Transform:GetWorldPosition()
		fx:SetPuppetStyle({doer = target, x = x, y = y - 0.08, z = z})
	end
	
	if target.components.colourtweener then
		if inst._tweening == 1 then
			inst._tweening = 2
			target.components.colourtweener:StartTween({0.63, 0.7, 0.9, 0.6}, 1, function() wandatimefreeze_nexttween(inst) end)
		elseif inst._tweening == 3 then
			inst._tweening = 4
			target.components.colourtweener:StartTween({0.8, 0.8, 0.8, 1}, 1, function() wandatimefreeze_nexttween(inst) end)
		end
	end
	
	local percent = math.clamp(inst.components.timer:GetTimeLeft("buffover") / TUNING.POCKETWATCH_BUFF_DURATION, 0, 1)
	target:PushEvent("timefreezepercent_changed", {percent = percent})
	if target._timefreezepercent then
		target._timefreezepercent:set(percent)
	end
end

local function WandaTimeFreeze_OnAttached(inst, target)
	target:AddTag("frozenstats")
	target.SoundEmitter:PlaySound("polarsounds/timefreeze/clock_start")
	
	--This tests how much time is lost per stats
	inst.debugstatdrain = function(src, stat, amt) wandatimefreeze_debugstatdrain(inst, stat, amt) end
	inst.ontemperaturedeltafn = function(src, data) wandatimefreeze_ontemperaturedelta(inst, target, data) end
	inst:ListenForEvent("temperaturedelta", inst.ontemperaturedeltafn, target)
	
	inst:DoTaskInTime(1, function() inst._tweening = 1 end)
	inst.task = inst:DoPeriodicTask(TUNING.POCKETWATCH_BUFF_TICK, wandatimefreeze_ontick, nil, target)
end

local function WandaTimeFreeze_OnDetached(inst, target)
	target:RemoveTag("frozenstats")
	target.SoundEmitter:PlaySound("polarsounds/timefreeze/clock_stop")
	
	if target.components.colourtweener then
		target.components.colourtweener:EndTween()
	end
	target.AnimState:SetMultColour(1, 1, 1, 1)
	
	inst:RemoveEventCallback("temperaturedelta", inst.ontemperaturedeltafn, target)
	
	target:PushEvent("timefreezepercent_changed", {percent = 0})
	if target._timefreezepercent then
		target._timefreezepercent:set(0)
	end
end

-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
	if data.name == "buffover" then
		inst.components.debuff:Stop()
	end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, announce, temperature, savefn, loadfn)
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
		
		if savefn ~= nil then
			inst.OnSave = savefn
			inst.OnLoad = loadfn
		else
			inst.persists = false
		end
		
		return inst
	end
	
	return Prefab("buff_"..name, fn)
end

return MakeBuff("polarwetness", Wetness_OnAttached, nil, Wetness_OnDetached, nil, 2, true, TUNING.POLARWETNESS_DEBUFF_STARTTEMP),
	MakeBuff("polarimmunity", Immunity_OnAttached, nil, Immunity_OnDetached, TUNING.POLAR_IMMUNITY_DURATION, 2, false),
	MakeBuff("walrusally", WalrusAlly_OnAttached, nil, WalrusAlly_OnDetached, TUNING.POLAR_WALRUSALLY_BUFF_DURATION, 2, false),
	MakeBuff("walrusboost", WalrusBoost_OnAttached, nil, WalrusBoost_OnDetached, TUNING.POLAR_WALRUSBOOST_BUFF_DURATION, 2, false),
	MakeBuff("huntmoar", HuntMoar_OnAttached, nil, HuntMoar_OnDetached, TUNING.MOARHUNT_BUFF_DURATION, 2, true, nil, HuntMoar_OnSave, HuntMoar_OnLoad),
	MakeBuff("ursamajor", UrsaMajor_OnAttached, nil, UrsaMajor_OnDetached, TUNING.URSAMAJOR_BUFF_DURATION, 2, false),
	MakeBuff("wandatimefreeze", WandaTimeFreeze_OnAttached, nil, WandaTimeFreeze_OnDetached, TUNING.POCKETWATCH_BUFF_DURATION, 2, true)