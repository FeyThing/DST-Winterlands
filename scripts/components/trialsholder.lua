local trials = require("polarbearking_trials")

local TrialsHolder = Class(function(self, inst)
	self.inst = inst
	
	self.trialdata = nil
	self.trialdata_follower = {}
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
--	 return {
		
--	 }
-- end

-- function TrialsHolder:OnLoad(data)
--	 if data then
		
--	 end
-- end

function TrialsHolder:SetTrialStartTestFn(fn)
	self.canstarttrial = fn
end

function TrialsHolder:DoStartTrial(trialdata, doer)
	self.trialdata = trialdata
	self.trialdata.trial_starter = doer
	
	if trialdata.solo then
		self.trialdata.player_participants = { [self.trialdata.trial_starter] = true }
		self.trialdata.players_left = { [self.trialdata.trial_starter] = true }
		self.trialdata.trial_starter:AddTag("player_trial_participator")
		self.trialdata.trial_starter.trialdata = trialdata
	else
		self.trialdata.player_participants = {  }
		self.trialdata.players_left = {  }
		
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local players = TheSim:FindEntities(x, y, z, trialdata.radius, { "player" }, { "playerghost" })
		for _, player in ipairs(players) do
			self.trialdata.player_participants[player] = true
			self.trialdata.players_left[player] = true
			player.trialdata = trialdata
			player:AddTag("player_trial_participator")
		end
	end
	
	if self.trialdata.start_fn ~= nil then
		self.trialdata.start_fn(self)
	end
	
	self.inst:PushEvent("trialstarted", trialdata)
	
	if self.inst.components.prototyper then
		self.inst.components.prototyper.restrictedtag = "NotNowIWatchTheSports"
	end
	
	self.inst:StartUpdatingComponent(self)
end

function TrialsHolder:TryStartTrial(trialname, doer)
	local trialdata = trials[trialname]
	local success = trialdata ~= nil and (self.canstarttrial == nil or self.canstarttrial(self.inst, trialdata, doer))
	local reason
	
	if success and trialdata.canstarttrial then
		success, reason = trialdata.canstarttrial(self, doer)
	end
	
	if not success then
		if self.onfailstarttrial then
			self.onfailstarttrial(self.inst, trialdata, reason)
		end
		
		self.inst:PushEvent("trialstartfailed")
		
		return false, reason
	end
	
	if trialdata.radius then
		self.radius_fx = SpawnPrefab("trial_radius_fx")
		self.radius_fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
		self.radius_fx.AnimState:SetScale(1.5 * trialdata.radius / (TILE_SCALE * 3), 1.5 * trialdata.radius / (TILE_SCALE * 3))
	end
	
	if trialdata.talkerstartstring and self.inst.components.talker then
		self.inst.components.talker:Say(trialdata.talkerstartstring[math.random(#trialdata.talkerstartstring)])
	end
	self.inst.SoundEmitter:PlaySound("polarsounds/polarbearking/jingle_start")
	
	self.inst:DoTaskInTime(TUNING.TRIALS_START_TIME, function()
		self:DoStartTrial(trialdata, doer)
	end)
	
	return true
end

function TrialsHolder:EndTrial(result, reason)
	if self.trialdata == nil then
		return
	end
	
	if self.trialdata.end_fn ~= nil then
		self.trialdata.end_fn(self, result, reason)
	end
	
	if result == "win" then
		self.inst.SoundEmitter:PlaySound("polarsounds/polarbearking/jingle_victory")
		
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local spectators = TheSim:FindEntities(x, y, z, 20, {"polarbear"}, {"bear_major", "INLIMBO", "isdead"})
		for _, spectator in ipairs(spectators) do
			spectator:DoTaskInTime(math.random() * 0.5, function()
				if spectator.sg and not spectator.sg:HasStateTag("busy") then
					spectator.sg:GoToState(math.random() < 0.7 and "cheer" or "funnyidle")
				end
			end)
		end
		
		for player, _ in pairs(self.trialdata.players_left) do
			player:PushEvent("won_trial")
			
			if self.trialdata.player_win_fn ~= nil then
				self.trialdata.player_win_fn(self, player, reason)
			end
			
			--self:LabelParticipant(player, TUNING.TRIAL_LABELS.WINNER)
		end
		
		self.inst:PushEvent("trial_end_won")
	elseif result == "lose" then
		self.inst.SoundEmitter:PlaySound("polarsounds/polarbearking/jingle_defeat")
		
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local spectators = TheSim:FindEntities(x, y, z, 20, {"polarbear"}, {"bear_major", "INLIMBO", "isdead"})
		for _, spectator in ipairs(spectators) do
			spectator:DoTaskInTime(math.random() * 0.5, function()
				if spectator.sg and not spectator.sg:HasStateTag("busy") then
					spectator.sg:GoToState(math.random() < 0.7 and "disapproval" or "funnyidle")
				end
			end)
		end
		
		for player, _ in pairs(self.trialdata.players_left) do
			player:PushEvent("lost_trial")
			
			if reason == "left" then
				self.trialdata.result_announced = true
				
				if self.inst.components.talker then
					self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_LOST_LEFT[math.random(#STRINGS.POLARBEARKING_TRIAL_LOST_LEFT)])
				end
			end
			if self.trialdata.player_lose_fn ~= nil then
				self.trialdata.player_lose_fn(self, player, reason)
			end
			
			--self:LabelParticipant(player, TUNING.TRIAL_LABELS.LOSER)
		end
		
		self.inst:PushEvent("trial_end_lost")
	elseif result == "interruption" then
		self.trialdata.result_announced = true
		
		if self.inst.components.talker then
			self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_LOST_CHEAT[math.random(#STRINGS.POLARBEARKING_TRIAL_LOST_CHEAT)])
		end
		
		self.inst:PushEvent("trial_end_interrupted")
	end
	
	for player, _ in pairs(self.trialdata.players_left) do
		player:RemoveTag("player_trial_participator")
	end
	
	for participant, _ in pairs(self.trialdata.participants) do
		participant:RemoveTag("trial_participator")
		if participant.components.timer and not participant.components.timer:TimerExists("trial_participator_ending") then
			participant.components.timer:StartTimer("trial_participator_ending", 2) -- minigame_participator gets removed here
		end
	end
	
	if self.radius_fx then
		if self.radius_fx.components.colourtweener then
			self.radius_fx.components.colourtweener:StartTween({1, 1, 1, 0}, 1, self.radius_fx.Remove)
		else
			self.radius_fx:Remove()
		end
		
		self.radius_fx = nil
	end
	
	self.inst:PushEvent("trailended")
	
	self.trialdata = nil
	
	if self.inst.components.prototyper then
		self.inst.components.prototyper.restrictedtag = nil
	end
	
	self.inst:StopUpdatingComponent(self)
end

function TrialsHolder:DisqualifyParticipant(participant, reason)
	if self.trialdata == nil then
		return
	elseif self.trialdata.players_left[participant] then
		if self.trialdata.disqualify_fn then
			self.trialdata.disqualify_fn(self, participant)
		end
		if self.trialdata then
			if reason == "left" then
				self.trialdata.result_announced = true
				
				if self.inst.components.talker then
					self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_LOST_LEFT[math.random(#STRINGS.POLARBEARKING_TRIAL_LOST_LEFT)])
				end
			end
			
			self.trialdata.players_left[participant] = nil
		end
		participant:RemoveTag("player_trial_participator")
		
		if self.trialdata and self.trialdata.player_lose_fn then
			self.trialdata.player_lose_fn(self, participant)
		end
	elseif self.trialdata.participants[participant] then
		if self.trialdata.disqualify_fn then
			self.trialdata.disqualify_fn(self, participant)
		end
		if self.trialdata then
			self.trialdata.participants[participant] = nil
		end
		
		participant:RemoveTag("trial_participator")
		if participant.components.timer and not participant.components.timer:TimerExists("trial_participator_ending") then
			participant.components.timer:StartTimer("trial_participator_ending", 2)
		end
	else
		return
	end
	
	if self.trialdata == nil then
		return
	end
	
	local players_left = 0
	for player, _ in pairs(self.trialdata.players_left) do
		players_left = players_left + 1
	end
	
	if players_left <= 0 then
		self:EndTrial("lose", reason)
		return
	end
	
	for participant, _ in pairs(self.trialdata.participants) do
		return
	end
	
	self:EndTrial("win", reason)
end

function TrialsHolder:IsTrialActive()
	return self.trialdata ~= nil
end

function TrialsHolder:OnUpdate(dt)
	for player, _ in pairs(self.trialdata.players_left) do
		if player:GetDistanceSqToPoint(self.inst:GetPosition()) > self.trialdata.radius * self.trialdata.radius then
			self:DisqualifyParticipant(player, "left")
		end
	end
end

return TrialsHolder