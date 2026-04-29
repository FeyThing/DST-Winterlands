-- [ Generic event functions ]

local Generic_Participant_OnRemove

local function Generic_Participant_RestoreLeader(self, participant, oldleader) -- This is the bear loyalty logic but oh I suppose it's fine for anything
	if oldleader and oldleader:IsValid() and oldleader.components.leader then
		oldleader.components.leader:AddFollower(participant)
		
		local hasboost = oldleader.components.timer and oldleader.components.timer:TimerExists("polarbear_loyaltyboost")
		local loyalty = 50 * TUNING.POLARBEAR_LOYALTY_PER_HUNGER
		
		participant.components.follower:AddLoyaltyTime(loyalty * (hasboost and TUNING.POLARBEAR_LOYALTYBOOST_MULT or 1))
		participant.components.follower.maxfollowtime = oldleader:HasTag("polite")
			and TUNING.POLARBEAR_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS or TUNING.POLARBEAR_LOYALTY_MAXTIME
	end
	
	self.trialdata_follower[participant] = nil
end

local function Generic_PlayerRewards(player, maxhealing_mult)
	player:DoTaskInTime(0.5 + math.random(), function()
		if player.sg then
			player.sg:GoToState("challenge_bearking", true)
		end
		if player.components.health then
			player.components.health:DeltaPenalty(TUNING.TRIALS_WIN_MAX_HEALING * maxhealing_mult)
		end
	end)
end

local function Generic_CanStartCombatTrial(self, doer)
	local hashealth = doer.components.health == nil or doer.components.health.currenthealth > 1
		or doer.components.health.maxhealth == 1 -- Well damn
	
	if not hashealth then
		return false, "LOWHEALTH"
	end
	
	return true
end

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
			--self:LabelParticipant(inst, TUNING.TRIAL_LABELS.LOSER)
		end
	end
	
	FistFight_Bear_OnAttacked = function(inst, data)
		if data.attacker then
			if self.trialdata.players_left[data.attacker] then
				if data.weapon ~= nil then -- Attacked with a weapon
					--self:LabelParticipant(inst, TUNING.TRIAL_LABELS.CHEATER)
					self:DisqualifyParticipant(data.attacker)
					return
				end
			elseif data.attacker:HasTag("player") then
				--self:LabelParticipant(data.attacker, TUNING.TRIAL_LABELS.CHEATER)
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
	
	local bear = FindEntity(self.inst, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS + 4, function(guy)
		return not guy.components.health:IsDead()
	end, {"polarbear"}, {"bear_major", "INLIMBO"})
	
	if bear == nil then
		return
	end
	
	self.trialdata.participants = {[bear] = true}
	self.trialdata.result_announced = false
	
	bear.trialdata = self.trialdata
	bear:AddTag("trial_participator")
	if bear.components.minigame_participator == nil then
		bear:AddComponent("minigame_participator") -- Prevents other followers from bothering us
	end
	if bear.sg then
		if bear.StopPolarPlowing then
			bear:StopPolarPlowing()
		end
		bear.sg:GoToState("abandon")
	end
	
	if bear.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
		bear.components.timer:SetTimeLeft("rageover", 0)
	else
		bear:SetEnraged(false)
	end
	if bear.components.health then
		bear.components.health:SetPercent(1)
	end
	if bear.components.follower and bear.components.follower.leader then
		self.trialdata_follower[bear] = {leader = bear.components.follower.leader}
		bear.components.follower:StopFollowing()
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
	
	return
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
	
	for follower, data in pairs(self.trialdata_follower) do
		Generic_Participant_RestoreLeader(self, follower, data.leader)
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
	Generic_PlayerRewards(player, 1)
	
	if player.components.timer then
		if player.components.timer:TimerExists("polarbear_loyaltyboost") then
			player.components.timer:SetTimeLeft("polarbear_loyaltyboost", TUNING.POLARBEAR_LOYALTYBOOST_DURATION)
		else
			player.components.timer:StartTimer("polarbear_loyaltyboost", TUNING.POLARBEAR_LOYALTYBOOST_DURATION)
		end
	end
	
	if self.trialdata.result_announced then
		return
	end
	
	self.trialdata.result_announced = true
	self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_WON1[math.random(#STRINGS.POLARBEARKING_TRIAL_WON1)])
	
	self.inst:DoTaskInTime(3, function()
		self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_GOT_LOYALTY[math.random(#STRINGS.POLARBEARKING_TRIAL_GOT_LOYALTY)])
	end)
end

local function LoseFistFightTrial(self, player)
	if self.trialdata.result_announced then
		return
	end
	
	self.trialdata.result_announced = true
	self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_LOST_DEAD1[math.random(#STRINGS.POLARBEARKING_TRIAL_LOST_DEAD1)])
end

--  [ Duo Fight ] (previously endurance but idk I think it's too basic, maybe they should be perma enraged ?)

local DuoFight_Player_OnHealthDelta
--local DuoFight_Bear_OnAttacked
local DuoFight_Bear_OnHealthDelta

local function StartDuoFightTrail(self)
	Generic_Participant_OnRemove = function(inst)
		self:DisqualifyParticipant(inst)
	end
	
	DuoFight_Player_OnHealthDelta = function(inst, data)
		if data.newpercent <= 0.1 then
			self:DisqualifyParticipant(inst)
		end
	end
	
	--[[DuoFight_Bear_OnAttacked = function(inst, data)
		if data.attacker then
			if self.trialdata.players_left[data.attacker] == nil then
				if data.attacker:HasTag("player") then
					--self:LabelParticipant(data.attacker, TUNING.TRIAL_LABELS.CHEATER)
				end
				
				self:EndTrial("interruption")
			end
		end
	end]]
	
	DuoFight_Bear_OnHealthDelta = function(inst, data)
		if data.newpercent <= 0.1 then
			inst:DoTaskInTime(0, function() -- Delay the check 1 tick because "attacked" gets called after
				self:DisqualifyParticipant(inst)
			end)
		end
	end
	
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local bears = TheSim:FindEntities(x, y, z, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS + 4, {"polarbear"}, {"bear_major", "INLIMBO"})
	
	if #bears < 2 then
		return
	end
	
	self.trialdata.participants = {}
	self.trialdata.result_announced = false
	
	for i, bear in ipairs(bears) do
		if i >= 3 then
			break
		end
		
		self.trialdata.participants[bear] = true
		
		bear.trialdata = self.trialdata
		bear:AddTag("trial_participator")
		if bear.components.minigame_participator == nil then
			bear:AddComponent("minigame_participator") -- Prevents other followers from bothering us
		end
		if bear.sg then
			if bear.StopPolarPlowing then
				bear:StopPolarPlowing()
			end
			bear.sg:GoToState("abandon")
		end
		
		if bear.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
			bear.components.timer:SetTimeLeft("rageover", 0)
		else
			bear:SetEnraged(false)
		end
		if bear.components.health then
			bear.components.health:SetPercent(1)
		end
		if bear.components.follower and bear.components.follower.leader then
			self.trialdata_follower[bear] = {leader = bear.components.follower.leader}
			bear.components.follower:StopFollowing()
		end
		
		--bear:ListenForEvent("attacked", DuoFight_Bear_OnAttacked)
		bear:ListenForEvent("healthdelta", DuoFight_Bear_OnHealthDelta)
		bear:ListenForEvent("onremove", Generic_Participant_OnRemove)
		bear.components.combat:DropTarget()
		bear.components.combat:TryRetarget()
	end
	
	for player, _ in pairs(self.trialdata.player_participants) do
		player:ListenForEvent("healthdelta", DuoFight_Player_OnHealthDelta)
		player:ListenForEvent("onremove", Generic_Participant_OnRemove)
	end
	
	return
end

local function EndDuoFightTrail(self, reason)
	for player, _ in pairs(self.trialdata.player_participants) do
		player:RemoveEventCallback("healthdelta", DuoFight_Player_OnHealthDelta)
		player:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
		player.trialdata = nil
	end
	
	for participant, _ in pairs(self.trialdata.participants) do
		--participant:RemoveEventCallback("attacked", DuoFight_Bear_OnAttacked)
		participant:RemoveEventCallback("healthdelta", DuoFight_Bear_OnHealthDelta)
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
	
	for follower, data in pairs(self.trialdata_follower) do
		Generic_Participant_RestoreLeader(self, follower, data.leader)
	end
end

local function OnDisqualifyDuoFightTrial(self, participant)
	if self.trialdata.players_left[participant] then
		participant:RemoveEventCallback("healthdelta", DuoFight_Player_OnHealthDelta)
		participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
		
		participant.trialdata = nil
	elseif self.trialdata.participants[participant] then
		--participant:RemoveEventCallback("attacked", DuoFight_Bear_OnAttacked)
		participant:RemoveEventCallback("healthdelta", DuoFight_Bear_OnHealthDelta)
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

local function DuoGetRewards(self, player) -- TODO: this is very temp and probably too random / not enough rewarding (but also can be spammed so... what else)
	local items = {}
	
	table.insert(items, SpawnPrefab("polarbearfur"))
	table.insert(items, SpawnPrefab(math.random() <= 0.5 and "meat" or "smallmeat"))
	table.insert(items, SpawnPrefab(math.random() <= 0.5 and "fishmeat" or "fishmeat_small"))
	
	if math.random() <= 0.5 then
		table.insert(items, SpawnPrefab(math.random() <= 0.5 and "meat" or "smallmeat"))
	end
	if math.random() <= 0.5 then
		table.insert(items, SpawnPrefab(math.random() <= 0.5 and "fishmeat" or "fishmeat_small"))
	end
	if math.random() <= 0.5 then
		table.insert(items, SpawnPrefab("hambat"))
	end
	if math.random() <= 0.33 then
		local r = math.random()
		table.insert(items, SpawnPrefab((r <= 0.33 and "oceanfishinglure_spoon_red")
			or (r <= 0.66 and "oceanfishinglure_spoon_green")
			or "oceanfishinglure_spoon_blue"))
	end
	
	if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and math.random() < 0.33 then
		table.insert(items, SpawnPrefab(GetRandomPolarWinterOrnament()))
	end
	
	if player and player.components.builder and not player.components.builder:KnowsRecipe("polarheadstick") and player.components.builder:CanLearn("polarheadstick") and
		not (player.components.timer and player.components.timer:TimerExists("polarheadstick_reward_cooldown")) then
		
		if player.components.timer then
			player.components.timer:StartTimer("polarheadstick_reward_cooldown", TUNING.TOTAL_DAY_TIME)
		end
		table.insert(items, SpawnPrefab("polarheadstick_blueprint"))
	end
	
	return items
end

local function WinDuoFightTrial(self, player)
	Generic_PlayerRewards(player, 2)
	
	if self.trialdata.result_announced then
		return
	end
	
	self.trialdata.result_announced = true
	self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_WON2[math.random(#STRINGS.POLARBEARKING_TRIAL_WON2)])
	
	self.inst:DoTaskInTime(3, function()
		self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_GOT_ITEM[math.random(#STRINGS.POLARBEARKING_TRIAL_GOT_ITEM)])
		
		local function launchitem(item, angle)
			local speed = math.random() * 4 + 2
			angle = (angle + math.random() * 60 - 30) * DEGREES
			
			item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
		end
		
		local angle
		local x, y, z = self.inst.Transform:GetWorldPosition()
		if player and player:IsValid() then
			angle = 180 - player:GetAngleToPoint(x, y, z)
		else
			local down = TheCamera:GetDownVec()
			angle = math.atan2(down.z, down.x) / DEGREES
		end
		
		local items = DuoGetRewards(self, player)
		local take_time = GetTime() + TUNING.POLARBEAR_IGNORE_TREASURE_TIME
		
		for i, item in ipairs(items) do
			item.Transform:SetPosition(x, y + 4, z)
			item._tooth_trade_taketime = take_time
			
			launchitem(item, angle)
		end
	end)
end

local function LoseDuoFightTrial(self, player)
	if self.trialdata.result_announced then
		return
	end
	
	self.trialdata.result_announced = true
	self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_LOST_DEAD2[math.random(#STRINGS.POLARBEARKING_TRIAL_LOST_DEAD2)])
end

--  [ All Out Rumble ]

local AllOutRumble_Player_OnHealthDelta
local AllOutRumble_Bear_OnHealthDelta

local function SpawnRumbleWave(self)
	if self.trialdata == nil then
		return
	end
	
	if #self.trialdata.bears_queue == 0 then
		self:EndTrial("win")
		return
	end
	
	local wave_size = 1
	if self.trialdata.wave_index >= 3 then
		wave_size = 2
	end
	
	self.trialdata.active_count = 0
	
	for i = 1, wave_size do
		local bear = table.remove(self.trialdata.bears_queue, 1)
		if bear == nil then
			break
		end
		
		self.trialdata.participants[bear] = true
		self.trialdata.active_count = self.trialdata.active_count + 1
		
		bear.trialdata = self.trialdata
		bear:AddTag("trial_participator")
		if bear.components.minigame_participator == nil then
			bear:AddComponent("minigame_participator")
		end
		if bear.sg then
			if bear.StopPolarPlowing then
				bear:StopPolarPlowing()
			end
			bear.sg:GoToState("abandon")
		end
		
		if bear.components.follower and bear.components.follower.leader then
			self.trialdata_follower[bear] = {leader = bear.components.follower.leader}
			bear.components.follower:StopFollowing()
		end
		
		bear.components.health:SetPercent(1)
		bear.components.combat:DropTarget()
		bear.components.combat:TryRetarget()
		
		bear:ListenForEvent("healthdelta", AllOutRumble_Bear_OnHealthDelta)
		bear:ListenForEvent("onremove", Generic_Participant_OnRemove)
	end
end

local function StartAllOutRumbleTrial(self)
	Generic_Participant_OnRemove = function(inst)
		self:DisqualifyParticipant(inst)
	end
	
	AllOutRumble_Player_OnHealthDelta = function(inst, data)
		if data.newpercent <= 0.1 then
			self:DisqualifyParticipant(inst)
			--self:LabelParticipant(inst, TUNING.TRIAL_LABELS.LOSER)
		end
	end
	
	AllOutRumble_Bear_OnHealthDelta = function(inst, data)
		if data.newpercent <= 0.33 then
			inst:DoTaskInTime(0, function()
				self:DisqualifyParticipant(inst)
			end)
		end
	end
	
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local bears = TheSim:FindEntities(x, y, z, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS + 4, {"polarbear"}, {"bear_major", "INLIMBO"})
	
	if #bears < 7 then
		return
	end
	
	self.trialdata.participants = {}
	self.trialdata.bears_queue = {}
	self.trialdata.result_announced = false
	self.trialdata.wave_index = 0
	
	for i = 1, 7 do
		table.insert(self.trialdata.bears_queue, bears[i])
	end
	
	for player, _ in pairs(self.trialdata.player_participants) do
		player:ListenForEvent("healthdelta", AllOutRumble_Player_OnHealthDelta)
		player:ListenForEvent("onremove", Generic_Participant_OnRemove)
	end
	
	SpawnRumbleWave(self)
end

local function EndAllOutRumbleTrail(self, reason)
	for player, _ in pairs(self.trialdata.player_participants) do
		player:RemoveEventCallback("healthdelta", AllOutRumble_Player_OnHealthDelta)
		player:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
		player.trialdata = nil
	end
	
	for participant, _ in pairs(self.trialdata.participants) do
		participant:RemoveEventCallback("healthdelta", AllOutRumble_Bear_OnHealthDelta)
		participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
		
		participant.trialdata = nil
		
		participant.components.health:SetInvincible(true)
		participant:DoTaskInTime(2, function(inst) inst.components.health:SetInvincible(false) end)
		
		participant.components.combat:DropTarget()
	end
	
	for follower, data in pairs(self.trialdata_follower) do
		Generic_Participant_RestoreLeader(self, follower, data.leader)
	end
end

local function OnDisqualifyAllOutRumbleTrial(self, participant)
	if self.trialdata.players_left[participant] then
		participant:RemoveEventCallback("healthdelta", AllOutRumble_Player_OnHealthDelta)
		participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
		return
	end
	
	if self.trialdata.participants[participant] then
		self.trialdata.participants[participant] = nil
		self.trialdata.active_count = self.trialdata.active_count - 1
		self.trialdata.wave_index = self.trialdata.wave_index + 1
		
		participant:RemoveEventCallback("healthdelta", AllOutRumble_Bear_OnHealthDelta)
		participant:RemoveEventCallback("onremove", Generic_Participant_OnRemove)
		participant.components.combat:DropTarget()
		
		if participant.components.timer:TimerExists("rageover") then -- Calm them down if they're enraged
			participant.components.timer:SetTimeLeft("rageover", 0)
		else
			participant:SetEnraged(false)
		end
		
		if self.trialdata.active_count <= 0 then
			SpawnRumbleWave(self)
		end
	end
end

local function WinAllOutRumbleTrial(self, player)
	Generic_PlayerRewards(player, 3)
	
	player:AddDebuff("buff_ursamajor", "buff_ursamajor")
	
	if self.trialdata.result_announced then
		return
	end
	
	self.trialdata.result_announced = true
	self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_WON2[math.random(#STRINGS.POLARBEARKING_TRIAL_WON2)])
	
	self.inst:DoTaskInTime(3, function()
		self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_GOT_BUFF[math.random(#STRINGS.POLARBEARKING_TRIAL_GOT_BUFF)])
	end)
end

local function LoseAllOutRumbleTrial(self, player)
	if self.trialdata.result_announced then
		return
	end
	
	self.trialdata.result_announced = true
	self.inst.components.talker:Say(STRINGS.POLARBEARKING_TRIAL_LOST_DEAD2[math.random(#STRINGS.POLARBEARKING_TRIAL_LOST_DEAD2)])
end

--  [ Trials data ]

-- this may expand in the future
-- trial data template:
-- trial_name = {
--	 name - trial name, should be kept the same as the key and the prefab for the recipe
--	 radius - radius of the trial in in-game units
--	 solo - solo trials allow only the "crafter" to participate, non-solo trials automatically detect and include players in 12 units radius
--	 combat_trial - special check for polar bear retargeting, special combat quotes and brain behaviour
--	 audience_valid - polar bears will swarm around but just outside of the trial radius and spectate with special quotes
--	 canstarttrial - function validating environment conditions for a trial to start, special for each trial, separate from TrialHolder.canstarttrial
--   talkerstartstring - flavorful text for Ursa to say before the trial starts for real
--	 disqualify_fn - function that runs whenever a participant is disqualified (using TrialHolder:DisqualifyParticipant())
--					 the main use is to revert the participant to its original state after leaving the trial, e.g, removing event callbacks
--	 start_fn - function that runs when a trial successfully begins (inside TrialHolder:DoStartTrial())
--				use it to set up important variables/event listeners/entity state for non-player participants
--				this function should first and foremost collect its non-player participants
--				player participants are collected automatically inside TrialHolder:DoStartTrial() so you can still prepare them if need be
--	 end_fn - function that runs when the trial ends for any reason
--			  use it to revert all participants to their original states just like in disqualify_fn, this can either be unnecessary,
--			  if the trial ends with just 1 player winning effectively making it into disqualify_fn, or crucial if the trial is interrupted
--			  or ends with players losing (this could leave multiple non-player participants in the trial)
--			  this function should loop through every participant still in the trial and revert them to their original states
--	 player_win_fn - function that runs whenever a player wins a trial, this will only happen when the trial ends in a victory and therefor
--					 will always run for each player still present in the trial when it ends
--	 player_lose_fn - function that runs whenever a player loses a trial, this can happen during a trial and will not necessarily end it
--					  as there may be more players still present in it
--}

local trials = {
	trial_fist_fight = {
		name = "trial_fist_fight",
		radius = 10,
		solo = true,
		combat_trial = true,
		audience_valid = true,
		
		canstarttrial = Generic_CanStartCombatTrial,
		talkerstartstring = STRINGS.POLARBEARKING_TRIAL_START1,
		
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
		
		canstarttrial = Generic_CanStartCombatTrial,
		talkerstartstring = STRINGS.POLARBEARKING_TRIAL_START2,
		
		disqualify_fn = OnDisqualifyDuoFightTrial,
		start_fn = StartDuoFightTrail,
		end_fn = EndDuoFightTrail,
		player_win_fn = WinDuoFightTrial,
		player_lose_fn = LoseDuoFightTrial
	},
	trial_all_out_rumble = {
		name = "trial_all_out_rumble",
		radius = 18,
		combat_trial = true,
		audience_valid = true,
		
		canstarttrial = Generic_CanStartCombatTrial,
		talkerstartstring = STRINGS.POLARBEARKING_TRIAL_START3,
		
		start_fn = StartAllOutRumbleTrial,
		disqualify_fn = OnDisqualifyAllOutRumbleTrial,
		end_fn = EndAllOutRumbleTrail,
		player_win_fn = WinAllOutRumbleTrial,
		player_lose_fn = LoseAllOutRumbleTrial
	},
	--[[trial_hide_and_hunt = {
		 name = "trial_hide_and_hunt",
		 radius = 60
	}]]
}

return trials