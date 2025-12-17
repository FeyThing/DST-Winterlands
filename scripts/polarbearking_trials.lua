-- [ Generic event functions ]

local Generic_Participant_OnRemove

--  [ Fist Fight ]
local FistFight_Player_OnHealthDelta
local FistFight_Bear_OnAttacked
local FistFight_Bear_OnHealthDelta
local function StartFistFightTrail(self)
    Generic_Participant_OnRemove = function(inst)
        self:DisqualifyParticipant(inst)
    end

    FistFight_Player_OnHealthDelta = function(inst, data)
        if data.newpercent <= 0.1 then
            self:DisqualifyParticipant(inst)
        -- self:LabelParticipant(inst, TUNING.TRIAL_LABELS.LOSER)
        end
    end

    FistFight_Bear_OnAttacked = function(inst, data)
        if data.attacker then
            if self.trialdata.players_left[data.attacker] then
                if data.weapon ~= nil then -- Attacked with a weapon
                    -- self:LabelParticipant(inst, TUNING.TRIAL_LABELS.CHEATER)
                    self:DisqualifyParticipant(data.attacker)
                    return
                end
            elseif data.attacker:HasTag("player") then
                -- self:LabelParticipant(data.attacker, TUNING.TRIAL_LABELS.CHEATER)
                self:EndTrial("interruption")
            else
                self:EndTrial("interruption")
            end
        end
    end

    FistFight_Bear_OnHealthDelta = function(inst, data)
        if data.newpercent <= 0.5 then
            inst:DoTaskInTime(0, function() -- Delay the check 1 tick because "attacked" gets called after
                self:DisqualifyParticipant(inst)
            end)
        end
    end

    local bear = FindEntity(self.inst, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS + 4,
function(guy) return not guy.components.health:IsDead() end,
    { "bear" }, { "bear_major", "INLIMBO" })

    if bear == nil then
        return false
    end

    self.trialdata.participants = { [bear] = true }
    bear:AddTag("trial_participator")

    bear.trialdata = self.trialdata

    if bear.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
        bear.components.timer:SetTimeLeft("rageover", 0)
    else
        bear:SetEnraged(false)
    end

    if bear.components.health then
        bear.components.health:SetPercent(1)
    end

    bear:ListenForEvent("attacked", FistFight_Bear_OnAttacked)
    bear:ListenForEvent("healthdelta", FistFight_Bear_OnHealthDelta)
    bear:ListenForEvent("onremove", Generic_Participant_OnRemove)
    bear.components.combat:DropTarget()
    bear.components.combat:TryRetarget()

    for player, _ in pairs(self.trialdata.player_participants) do
        player:ListenForEvent("healthdelta", FistFight_Player_OnHealthDelta)
        player:ListenForEvent("onremove", Generic_Participant_OnRemove)
    end

    return true
end

local function EndFistFightTrail(self, reason)
    for player, _ in pairs(self.trialdata.player_participants) do
        player:RemoveEventCallback("healthdelta", FistFight_Player_OnHealthDelta)
        player:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
        player.trialdata = nil
    end

    for participant, _ in pairs(self.trialdata.participants) do
        participant:RemoveEventCallback("attacked", FistFight_Bear_OnAttacked)
        participant:RemoveEventCallback("healthdelta", FistFight_Bear_OnHealthDelta)
        participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
        participant.trialdata = nil
        participant.components.health:SetInvincible(true)
        participant:DoTaskInTime(2, function(inst) inst.components.health:SetInvincible(false) end)

        participant.components.combat:DropTarget()
    end
end

local function OnDisqualifyFistFightTrial(self, participant)
    if self.trialdata.players_left[participant] then
        participant:RemoveEventCallback("healthdelta", FistFight_Player_OnHealthDelta)
        participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
        participant.trialdata = nil
    elseif self.trialdata.participants[participant] then
        participant:RemoveEventCallback("attacked", FistFight_Bear_OnAttacked)
        participant:RemoveEventCallback("healthdelta", FistFight_Bear_OnHealthDelta)
        participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
        participant.trialdata = nil
        participant.components.health:SetInvincible(true)
        participant:DoTaskInTime(2, function(inst) inst.components.health:SetInvincible(false) end)

        participant.components.combat:DropTarget()
    end
end

local function WinFistFightTrial(self, player)
    self.inst.components.talker:Say("NOW THAT'S WHAT I LIKE TO SEE!")
end

local function LoseFistFightTrial(self, player)
    self.inst.components.talker:Say("THEY'LL BURY YOU IN A LUNCHBOX!")
end
--

--  [ Endurence Fight ]
local EndurenceFight_Player_OnHealthDelta
local EndurenceFight_Bear_OnAttacked
local EndurenceFight_Bear_OnHealthDelta
local function StartEndurenceFightTrail(self)
    Generic_Participant_OnRemove = function(inst)
        self:DisqualifyParticipant(inst)
    end

    EndurenceFight_Player_OnHealthDelta = function(inst, data)
        if data.newpercent <= 0.1 then
            self:DisqualifyParticipant(inst)
        end
    end

    EndurenceFight_Bear_OnAttacked = function(inst, data)
        if data.attacker then
            if self.trialdata.players_left[data.attacker] == nil then
                if data.attacker:HasTag("player") then
                    -- self:LabelParticipant(data.attacker, TUNING.TRIAL_LABELS.CHEATER)
                end

                self:EndTrial("interruption")
            end
        end
    end

    EndurenceFight_Bear_OnHealthDelta = function(inst, data)
        if data.newpercent <= 0.1 then
            inst:DoTaskInTime(0, function() -- Delay the check 1 tick because "attacked" gets called after
                self:DisqualifyParticipant(inst)
            end)
        end
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()
    local bears = TheSim:FindEntities(x, y, z, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS + 4, { "bear" }, { "bear_major", "INLIMBO" })

    if #bears < 2 then
        return false
    end

    self.trialdata.participants = {  }
    for i, bear in ipairs(bears) do
        if i >= 3 then
            break
        end

        self.trialdata.participants[bear] = true
        bear:AddTag("trial_participator")

        bear.trialdata = self.trialdata

        if bear.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
            bear.components.timer:SetTimeLeft("rageover", 0)
        else
            bear:SetEnraged(false)
        end

        if bear.components.health then
            bear.components.health:SetPercent(1)
        end

        bear:ListenForEvent("attacked", EndurenceFight_Bear_OnAttacked)
        bear:ListenForEvent("healthdelta", EndurenceFight_Bear_OnHealthDelta)
        bear:ListenForEvent("onremove", Generic_Participant_OnRemove)
        bear.components.combat:DropTarget()
        bear.components.combat:TryRetarget()
    end

    for player, _ in pairs(self.trialdata.player_participants) do
        player:ListenForEvent("healthdelta", EndurenceFight_Player_OnHealthDelta)
        player:ListenForEvent("onremove", Generic_Participant_OnRemove)
    end

    return true
end

local function EndEndurenceFightTrail(self, reason)
    for player, _ in pairs(self.trialdata.player_participants) do
        player:RemoveEventCallback("healthdelta", EndurenceFight_Player_OnHealthDelta)
        player:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
        player.trialdata = nil
    end

    for participant, _ in pairs(self.trialdata.participants) do
        participant:RemoveEventCallback("attacked", EndurenceFight_Bear_OnAttacked)
        participant:RemoveEventCallback("healthdelta", EndurenceFight_Bear_OnHealthDelta)
        participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
        participant.trialdata = nil
        participant.components.health:SetInvincible(true)
        participant:DoTaskInTime(2, function(inst) inst.components.health:SetInvincible(false) end)

        if participant.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
            participant.components.timer:SetTimeLeft("rageover", 0)
        else
            participant:SetEnraged(false)
        end

        participant.components.combat:DropTarget()
    end
end

local function OnDisqualifyEndurenceFightTrial(self, participant)
    if self.trialdata.players_left[participant] then
        participant:RemoveEventCallback("healthdelta", EndurenceFight_Player_OnHealthDelta)
        participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
        participant.trialdata = nil
    elseif self.trialdata.participants[participant] then
        participant:RemoveEventCallback("attacked", EndurenceFight_Bear_OnAttacked)
        participant:RemoveEventCallback("healthdelta", EndurenceFight_Bear_OnHealthDelta)
        participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
        participant.trialdata = nil
        participant.components.health:SetInvincible(true)
        participant:DoTaskInTime(2, function(inst) inst.components.health:SetInvincible(false) end)
        participant.nearby_trial = self.inst
        participant:AddTag("trial_spectator")

        if participant.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
            participant.components.timer:SetTimeLeft("rageover", 0)
        else
            participant:SetEnraged(false)
        end

        participant.components.combat:DropTarget()

        participant.sg:GoToState("idle")
        participant.brain:ForceUpdate() -- Force them to leave the trial radius
    end
end

local function WinEndurenceFightTrial(self, player)
    self.inst.components.talker:Say("NOW THAT'S WHAT I LIKE TO SEE!")
end

local function LoseEndurenceFightTrial(self, player)
    self.inst.components.talker:Say("THEY'LL BURY YOU IN A LUNCHBOX!")
end
--

local trials = {
    trial_fist_fight = {
        name = "trial_fist_fight",
        radius = 10,
        solo = true,
        combat_trial = true,
        audience_valid = true,

        canstarttrial = function() return TheWorld.state.isday end,

        disqualify_fn = OnDisqualifyFistFightTrial,
        start_fn = StartFistFightTrail,
        end_fn = EndFistFightTrail,
        player_win_fn = WinFistFightTrial,
        player_lose_fn = LoseFistFightTrial
    },
    trial_endurence_fight = {
        name = "trial_endurence_fight",
        radius = 16,
        solo = true,
        combat_trial = true,
        audience_valid = true,

        canstarttrial = function() return TheWorld.state.isday end,
        
        disqualify_fn = OnDisqualifyEndurenceFightTrial,
        start_fn = StartEndurenceFightTrail,
        end_fn = EndEndurenceFightTrail,
        player_win_fn = WinEndurenceFightTrial,
        player_lose_fn = LoseEndurenceFightTrial
    },
    -- trial_all_out_rumble = { -- LET'S GET READY TO RRRRRRRRUMBLEEEEEEE
    --     name = "trial_all_out_rumble",
    --     radius = 16,
    --     combat_trial = true,
    --     audience_valid = true,
    --     canstarttrial = function() return TheWorld.state.isday end,
    --     -- start_fn = StartFistFightTrail,
    --     -- end_fn = EndFistFightTrail,
    --     -- player_win_fn = WinFistFightTrial,
    --     -- player_lose_fn = LoseFistFightTrial
    -- },
    -- trial_hide_and_hunt = {
    --     name = "trial_hide_and_hunt",
    --     radius = 60,
    --     fun_trial = true,
    --     -- start_fn = StartFistFightTrail,
    --     -- end_fn = EndFistFightTrail,
    --     -- player_win_fn = WinFistFightTrial,
    --     -- player_lose_fn = LoseFistFightTrial
    -- }
}

return trials