local assets = {
    Asset("ANIM", "anim/pig_king.zip")
}

local prefabs = {
    
}

local function OnInfighting(inst, attacker, victim)
    if inst.sg:HasStateTag("yelling") or inst.sg:HasStateTag("sleeping") or inst.components.trialsholder:IsTrialActive() then
        return
    end

    local tolarence_drain = TUNING.POLARBEARKING_INFIGHTING_TOLARANCE_DRAIN / 2 * (1 + math.random())
    inst.infighting_tolerance = inst.infighting_tolerance - tolarence_drain

    if inst.infighting_tolerance <= 0 then
        inst.infighting_tolerance = TUNING.POLARBEARKING_INFIGHTING_TOLARANCE

        inst:PushEvent("stopinfighting")
    else
        if inst._regain_tolerance_task then
            inst._regain_tolerance_task:Cancel()
            inst._regain_tolerance_task = inst:DoTaskInTime(TUNING.POLARBEARKING_INFIGHTING_TOLARANCE_RESET_TIME, function()
                inst.infighting_tolerance = TUNING.POLARBEARKING_INFIGHTING_TOLARANCE
                inst._regain_tolerance_task = nil
            end)
        end
    end
end

local function DoRoar(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local bears = TheSim:FindEntities(x, y, z, TUNING.POLARBEARKING_STOP_INFIGHTING_RANGE, { "bear" }, { "bear_major" })
    local preys = TheSim:FindEntities(x, y, z, TUNING.POLARBEARKING_STOP_INFIGHTING_RANGE, { "prey" })

    for _, bear in ipairs(bears) do
        if bear.components.health and not bear.components.health:IsDead() then
            if bear.components.combat:HasTarget() and bear.components.combat.target:HasTag("bear") then -- If they're targeting another bear, drop the target and face the major
                bear.components.combat:DropTarget()
            end
            
            if not bear.components.combat:HasTarget() or bear.components.combat.target:HasTag("bear") then
                bear.current_major = inst
                bear:DoTaskInTime(6, function(inst) inst.current_major = nil end)

                local str = bear.infighting_guilty and STRINGS.POLARBEAR_FACE_MAJOR_GUILTY[math.random(1, #STRINGS.POLARBEAR_FACE_MAJOR_GUILTY)]
                                                    or STRINGS.POLARBEAR_FACE_MAJOR_GENERIC[math.random(1, #STRINGS.POLARBEAR_FACE_MAJOR_GENERIC)]
                bear.components.talker:Say(str, 3.5)
            end

            if bear.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
                bear.components.timer:SetTimeLeft("rageover", 0)
            else
                bear:SetEnraged(false)
            end
        end
    end

    for _, prey in ipairs(preys) do
        if prey.components.hauntable then
            prey.components.hauntable:Panic(4)
        end
    end
end

-- TODO: Add a second return value, the reason for failing, use it later for talking
local TRIAL_OBSTACLE_TAGS = { "structure", "wall", "fire" }
local function CanStartTrial(inst, trialdata)
    local x, y, z = inst.Transform:GetWorldPosition()
    local obstacles = TheSim:FindEntities(x, y, z, trialdata.radius, nil, nil, TRIAL_OBSTACLE_TAGS)
    return not inst.sg:HasStateTag("sleeping") and
           not inst.sg:HasStateTag("yelling") and
           not inst.components.trialsholder:IsTrialActive() and
           #obstacles <= 0
end

local function OnActivatePrototyper(inst, doer, recipe)
    inst.components.trialsholder:StartTrial(recipe.name, doer)
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
    if isnight then
        inst.sg.mem.sleeping = true

        if inst.sg:HasStateTag("idle") then
            inst.sg:GoToState("sleep")
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2, 0.5)

    inst.MiniMapEntity:SetIcon("pigking.png")
    inst.MiniMapEntity:SetPriority(1)

    inst.DynamicShadow:SetSize(10, 5)

    inst.AnimState:SetBank("Pig_King")
    inst.AnimState:SetBuild("Pig_King")
    inst.AnimState:SetFinalOffset(1)

    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("bear")
    inst:AddTag("bear_major")
    inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")

    if not TheNet:IsDedicated() then
        inst:AddComponent("pointofinterest")
        inst.components.pointofinterest:SetHeight(70)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    -- inst:AddComponent("hauntable")
    -- inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("trialsholder")
    inst.components.trialsholder:SetTrialStartTestFn(CanStartTrial)

    inst.infighting_tolerance = TUNING.POLARBEARKING_INFIGHTING_TOLARANCE
    inst._regain_tolerance_task = nil

    inst.DoRoar = DoRoar
    inst.OnInfighting = OnInfighting

    inst:SetStateGraph("SGpolarbearking")

    inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)

    return inst
end

return Prefab("polarbearking", fn, assets, prefabs)
