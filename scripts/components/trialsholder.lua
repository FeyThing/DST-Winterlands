local trials = require("polarbearking_trials")

local TrialsHolder = Class(function(self, inst)
	self.inst = inst

    self.trialdata = nil
    self.canstarttrial = nil
end)

function TrialsHolder:OnRemoveEntity()
    self:OnRemoveFromEntity()
end

function TrialsHolder:OnRemoveFromEntity()
    if self:IsTrialActive() then
        self:EndTrial("interruption")
    end
end

-- function TrialsHolder:OnSave()
--     return {
        
--     }
-- end

-- function TrialsHolder:OnLoad(data)
--     if data then
        
--     end
-- end

function TrialsHolder:SetTrialStartTestFn(fn)
    self.canstarttrial = fn
end

function TrialsHolder:StartTrial(trialname, doer)
    local trialdata = trials[trialname]

    if trialdata == nil then
        if self.onfailstarttrial ~= nil then
            self.onfailstarttrial(self.inst, trialdata)
        end

        self.inst:PushEvent("trialstartfailed")

        return false
    end

    if (self.canstarttrial ~= nil and not self.canstarttrial(self.inst, trialdata)) or
    (trialdata.canstarttrial ~= nil and not trialdata.canstarttrial()) then
        if self.onfailstarttrial ~= nil then
            self.onfailstarttrial(self.inst, trialdata)
        end

        self.inst:PushEvent("trialstartfailed")

        return false
    end

    self.trialdata = trialdata
    self.trialdata.trial_starter = doer

    if trialdata.solo then
        self.trialdata.player_participants = { [self.trialdata.trial_starter] = true }
        self.trialdata.players_left = { [self.trialdata.trial_starter] = true }
        self.trialdata.trial_starter:AddTag("player_trial_participator")
    else
        self.trialdata.player_participants = {  }
        self.trialdata.players_left = {  }

        local x, y, z = self.inst.Transform:GetWorldPosition()
        local players = TheSim:FindEntities(x, y, z, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS, { "player" }, { "playerghost" })
        for _, player in ipairs(players) do
            self.trialdata.player_participants[player] = true
            self.trialdata.players_left[player] = true
            player:AddTag("player_trial_participator")
        end
    end

    self.radius_fx = SpawnPrefab("trial_radius_fx")
    self.radius_fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    self.radius_fx.AnimState:SetScale(1.5 * self.trialdata.radius / (TILE_SCALE * 3), 1.5 * self.trialdata.radius / (TILE_SCALE * 3))

    if self.trialdata.start_fn ~= nil and not self.trialdata.start_fn(self) then
        for player, _ in pairs(self.trialdata.player_participants) do
            player:RemoveTag("player_trial_participator")
        end

        self.radius_fx:Remove()

        self.trialdata = nil

        if self.onfailstarttrial ~= nil then
            self.onfailstarttrial(self.inst, trialdata)
        end

        self.inst:PushEvent("trialstartfailed")

        return false
    end

    self.inst:PushEvent("trialstarted", trialdata)

    self.inst:StartUpdatingComponent(self)

    return true
end

function TrialsHolder:EndTrial(reason)
    if self.trialdata.end_fn ~= nil then
        self.trialdata.end_fn(self, reason)
    end

    if reason == "win" then
        for player, _ in pairs(self.trialdata.players_left) do
            player:PushEvent("won_trial")

            if self.trialdata.player_win_fn ~= nil then
                self.trialdata.player_win_fn(self, player)
            end

            -- self:LabelParticipant(player, TUNING.TRIAL_LABELS.WINNER)
        end

        self.inst:PushEvent("trial_end_won")
    elseif reason == "lose" then
        for player, _ in pairs(self.trialdata.players_left) do
            player:PushEvent("lost_trial")

            if self.trialdata.player_lose_fn ~= nil then
                self.trialdata.player_lose_fn(self, player)
            end

            -- self:LabelParticipant(player, TUNING.TRIAL_LABELS.LOSER)
        end

        self.inst:PushEvent("trial_end_lost")
    elseif reason == "interruption" then
        self.inst:PushEvent("trial_end_interrupted")
    end

    for player, _ in pairs(self.trialdata.players_left) do
        player:RemoveTag("player_trial_participator")
    end

    for participant, _ in pairs(self.trialdata.participants) do
        participant:RemoveTag("trial_participator")
    end

    if self.radius_fx ~= nil then
        self.radius_fx:Remove()
    end

    self.inst:PushEvent("trailended")

    self.trialdata = nil

    self.inst:StopUpdatingComponent(self)
end

function TrialsHolder:DisqualifyParticipant(participant)
    if self.trialdata.players_left[participant] then
        if self.trialdata.disqualify_fn ~= nil then
            self.trialdata.disqualify_fn(self, participant)
        end
        
        self.trialdata.players_left[participant] = nil
        participant:RemoveTag("player_trial_participator")

        if self.trialdata.player_lose_fn ~= nil then
            self.trialdata.player_lose_fn(self, participant)
        end
    elseif self.trialdata.participants[participant] then
        if self.trialdata.disqualify_fn ~= nil then
            self.trialdata.disqualify_fn(self, participant)
        end

        self.trialdata.participants[participant] = nil
        participant:RemoveTag("trial_participator")
    else
        return
    end

    local players_left = 0
    for player, _ in pairs(self.trialdata.players_left) do
        players_left = players_left + 1
    end

    if players_left <= 0 then
        self:EndTrial("lose")
        return
    end

    for participant, _ in pairs(self.trialdata.participants) do
        return
    end

    self:EndTrial("win")
end

function TrialsHolder:IsTrialActive()
    return self.trialdata ~= nil
end

function TrialsHolder:OnUpdate(dt)
    for player, _ in pairs(self.trialdata.players_left) do
        if player:GetDistanceSqToPoint(self.inst:GetPosition()) > self.trialdata.radius * self.trialdata.radius then
            self:DisqualifyParticipant(player)
        end
    end
end

return TrialsHolder