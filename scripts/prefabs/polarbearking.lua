local assets = {
	Asset("ANIM", "anim/polarbearking.zip")
}

local function OnInfighting(inst, attacker, victim)
	if inst.sg:HasStateTag("yelling") or inst.sg:HasStateTag("sleeping") or inst.components.trialsholder:IsTrialActive() then
		return
	end
	
	local tolarence_drain = TUNING.POLARBEARKING_INFIGHTING_TOLARANCE_DRAIN / 2 * (1 + math.random())
	inst.infighting_tolerance = inst.infighting_tolerance - tolarence_drain
	
	if inst.infighting_tolerance <= 0 then
		if inst._regain_tolerance_task then
			inst._regain_tolerance_task:Cancel()
			inst._regain_tolerance_task = nil
		end
		
		inst._regain_tolerance_task = inst:DoTaskInTime(TUNING.POLARBEARKING_INFIGHTING_TOLARANCE_RESET_TIME, function()
			inst.infighting_tolerance = TUNING.POLARBEARKING_INFIGHTING_TOLARANCE
			inst.sg.mem.angry = nil
			inst:PushEvent("calmdown")
		end)
		
		inst.sg.mem.angry = true
		inst:PushEvent("stopinfighting")
	else
		if inst._regain_tolerance_task then
			inst._regain_tolerance_task:Cancel()
			inst._regain_tolerance_task = nil
		end
		
		inst._regain_tolerance_task = inst:DoTaskInTime(TUNING.POLARBEARKING_INFIGHTING_TOLARANCE_RESET_TIME, function()
			inst.infighting_tolerance = TUNING.POLARBEARKING_INFIGHTING_TOLARANCE
			inst._regain_tolerance_task = nil
		end)
	end
end

local BEAR_TAGS = {"polarbear", "_combat"}
local BEAR_NOT_TAGS = {"bear_major", "isdead"}
local PREY_ONE_OF_TAGS = {"prey", "bird"}
local PREY_NOT_TAGS = {"INLIMBO", "isdead"}

local function DoRoar(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local bears = TheSim:FindEntities(x, y, z, TUNING.POLARBEARKING_STOP_INFIGHTING_RANGE, BEAR_TAGS, BEAR_NOT_TAGS)
	local preys = TheSim:FindEntities(x, y, z, TUNING.POLARBEARKING_STOP_INFIGHTING_RANGE, nil, PREY_NOT_TAGS, PREY_ONE_OF_TAGS)
	
	for _, bear in ipairs(bears) do
		if bear.components.health and not bear.components.health:IsDead() then
			if bear.components.combat:HasTarget() and bear.components.combat.target:HasTag("polarbear") then -- If they're targeting another bear, drop the target and face the major
				bear.components.combat:DropTarget()
			end
			
			if not bear.components.combat:HasTarget() or bear.components.combat.target:HasTag("polarbear") then
				bear.current_major = inst
				bear:DoTaskInTime(6, function(inst) inst.current_major = nil end)
				
				local str = bear.infighting_guilty and STRINGS.POLARBEAR_FACE_MAJOR_GUILTY[math.random(#STRINGS.POLARBEAR_FACE_MAJOR_GUILTY)]
					or STRINGS.POLARBEAR_FACE_MAJOR_GENERIC[math.random(#STRINGS.POLARBEAR_FACE_MAJOR_GENERIC)]
				
				bear.components.talker:Say(str, 3.5)
			end

			if bear.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
				bear.components.timer:SetTimeLeft("rageover", 0)
			else
				bear:SetEnraged(false)
			end
		end
	end
	
	if inst.components.epicscare then
		inst.components.epicscare:Scare(3)
	end
	
	for _, prey in ipairs(preys) do
		if prey.components.homeseeker and prey.components.homeseeker:HasHome() then
			prey:PushEvent("gohome")
		elseif prey:HasTag("bird") then
			prey:PushEvent("flyaway")
		elseif prey.components.hauntable then
			prey.components.hauntable:Panic(3)
		end
	end
end

local function OnHaunt(inst)
	inst:PushEvent("stopinfighting")
	
	return true
end

local TRIAL_OBSTACLE_TAGS = {"structure", "wall", "fire"}

local function CanStartTrial(inst, trialdata, doer)
	local x, y, z = inst.Transform:GetWorldPosition()
	local obstacles = TheSim:FindEntities(x, y, z, trialdata.radius, nil, nil, TRIAL_OBSTACLE_TAGS)
	
	return not inst.sg:HasStateTag("sleeping") and
		not inst.sg:HasStateTag("yelling") and
		not inst.components.trialsholder:IsTrialActive() -- and #obstacles <= 0
end

local function OnFailStartTrial(inst, doer, reason)
	if reason and reason == "LOWHEALTH" then
		inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_LOW_HEALTH[math.random(#STRINGS.POLARBEARKING_TRIAL_LOW_HEALTH)])
	end
end

local function OnActivatePrototyper(inst, doer, recipe)
	inst.components.trialsholder:TryStartTrial(recipe.name, doer)
end

local function OnTurnOnPrototyper(inst)
	
end

local function EnableTrials(inst)
	if inst.components.prototyper == nil then
		inst:AddComponent("prototyper")
		inst.components.prototyper.onactivate = OnActivatePrototyper
		inst.components.prototyper.onturnon = OnTurnOnPrototyper
		inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.POLARBEARKING_TRIALS
	end
end

local function DisableTrials(inst)
	if inst.components.prototyper then
		inst:RemoveComponent("prototyper")
	end
end

local function OnIsNight(inst, isnight)
	if isnight and not (inst.components.trialsholder and inst.components.trialsholder:IsTrialActive()) then
		inst.sg.mem.sleeping = true
		inst.sg.mem.angry = nil
		
		if inst.sg:HasStateTag("idle") then
			inst.sg:GoToState("sleep", true)
		end
		
		DisableTrials(inst)
	else
		inst.sg.mem.sleeping = false
		
		if inst.sg:HasStateTag("sleeping") then
			inst.sg:GoToState("wake")
		end
		
		EnableTrials(inst)
	end
end

local function OnTalk(inst, script)
	-- inst.SoundEmitter:PlaySound("")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2, 0.5)
	
	inst.MiniMapEntity:SetIcon("polarbearking.png")
	inst.MiniMapEntity:SetPriority(1)
	
	inst.DynamicShadow:SetSize(10, 5)
	
	inst.AnimState:SetBank("polarbearking")
	inst.AnimState:SetBuild("polarbearking")
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("bear")
	inst:AddTag("bear_major")
	inst:AddTag("birdblocker")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("snowblocker")
	
	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -740, 0)
	inst.components.talker.ontalk = OnTalk
	inst.components.talker.mod_str_fn = function(ret) return PolarifySpeech(ret, inst) end
	
	if not TheNet:IsDedicated() then
		inst:AddComponent("pointofinterest")
		inst.components.pointofinterest:SetHeight(70)
	end
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "polarbearking._snowblockrange")
	inst._snowblockrange:set(15)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("epicscare")
	table.insert(inst.components.epicscare.scareexcludetags, "polarbear")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst:AddComponent("trialsholder")
	inst.components.trialsholder:SetTrialStartTestFn(CanStartTrial)
	inst.components.trialsholder.onfailstarttrial = OnFailStartTrial
	
	inst.infighting_tolerance = TUNING.POLARBEARKING_INFIGHTING_TOLARANCE
	inst._regain_tolerance_task = nil
	
	inst.DoRoar = DoRoar
	inst.OnInfighting = OnInfighting
	
	inst:SetStateGraph("SGpolarbearking")
	
	inst:WatchWorldState("isnight", OnIsNight)
	OnIsNight(inst, TheWorld.state.isnight)
	
	return inst
end

--

local function trial_builder()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	
	inst:AddTag("CLASSIFIED")
	
	inst.persists = false
	
	inst:DoTaskInTime(0, inst.Remove)
	
	return inst
end

local prefabs = {Prefab("polarbearking", fn, assets)}

for k, v in pairs(require("polarbearking_trials")) do
	table.insert(prefabs, Prefab(k, trial_builder))
end

return unpack(prefabs)