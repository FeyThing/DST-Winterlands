local ENV = env
GLOBAL.setfenv(1, GLOBAL)

require("stategraphs/commonstates_polar")

local function DoHurtSound(inst)
	if inst.hurtsoundoverride then
		inst.SoundEmitter:PlaySound(inst.hurtsoundoverride, nil, inst.hurtsoundvolume)
	elseif not inst:HasTag("mime") then
		inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/hurt", nil, inst.hurtsoundvolume)
	end
end

local events = {
	EventHandler("gotpolarflea", function(inst, data)
		local flea = data and data.flea
		
		if flea and not data.given and flea.components.inventoryitem and flea.components.inventoryitem.owner == inst then -- Only if jumping into inv pocket directly
			inst.sg:GoToState("hit")
		end
	end),
}

local states = {
	State{
		name = "polarcast",
		tags = {"doing", "busy", "canrotate"},
		
		onenter = function(inst)
			if inst.components.playercontroller then
				inst.components.playercontroller:Enable(false)
			end
			
			inst.AnimState:PlayAnimation("polarcast")
			inst.components.locomotor:Stop()
		end,
		
		timeline = {
			TimeEvent(13 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
			TimeEvent(20 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
				if inst.components.playercontroller then
					inst.components.playercontroller:Enable(true)
				end
			end)
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		},
		
		onexit = function(inst)
			if inst.components.playercontroller then
				inst.components.playercontroller:Enable(true)
			end
		end,
	},
	
	State{
		name = "winterfistcast",
		tags = {"doing", "busy", "canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("winterfist_small")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
			inst.components.locomotor:Stop()
		end,
		
		timeline = {
			TimeEvent(5 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
			TimeEvent(7 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
			end)
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		},
	},
	
	State{
		name = "start_polarnecklace",
		tags = {"doing", "nodangle"},
		
		onenter = function(inst, resume_item)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("build_pre")
			inst.AnimState:PushAnimation("build_loop")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
		end,
		
		onexit = function(inst)
			inst.SoundEmitter:KillSound("make")
		end,
		
		events = {
			EventHandler("animqueueover", function(inst)
				inst.sg:GoToState("idle")
			end),
			EventHandler("finish_polarnecklace", function(inst)
				inst.AnimState:PlayAnimation("build_pst")
				inst.SoundEmitter:KillSound("make")
			end),
		},
	},
	
	State{
		name = "polarspawn",
		tags = {"busy", "noattack", "nopredict", "nodangle", "notalking"},
		
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			
			inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
			inst.AnimState:PlayAnimation("frozen")
			
			inst.components.inventory:Hide()
			inst:PushEvent("ms_closepopups")
			if inst.components.playercontroller then
				inst.components.playercontroller:EnableMapControls(false)
			end
		end,
		
		timeline = {
			TimeEvent(3, function(inst)
				inst.AnimState:PlayAnimation("frozen_loop_pst", true)
				inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
			end),
			TimeEvent(5.5, function(inst)
				if inst.components.freezable then
					inst.components.freezable:SpawnShatterFX()
				end
				inst.sg:GoToState("hit", true)
			end)
		},
		
		onexit = function(inst)
			inst.AnimState:ClearOverrideSymbol("swap_frozen")
			inst.SoundEmitter:KillSound("thawing")
			
			inst.components.inventory:Show()
			if inst.components.playercontroller then
				inst.components.playercontroller:EnableMapControls(true)
			end
		end,
	},
	
	State{
		name = "enter_bagpipe",
		tags = {"playing", "idle"},
		
		onenter = function(inst, pushanim)
			inst.components.locomotor:Stop()
			
			if pushanim then
				inst.AnimState:PushAnimation("idle_onemanband1_pre", false)
			else
				inst.AnimState:PlayAnimation("idle_onemanband1_pre")
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("idle_onemanband1_pre") then
					inst.sg:GoToState("play_bagpipe")
				end
			end),
		},
	},
	
	State{
		name = "play_bagpipe",
		tags = {"playing", "idle"},
		
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("idle_onemanband1_loop")
		end,
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState(math.random() <= 0.15 and "play_bagpipe_stomp" or "play_bagpipe")
				end
			end),
		},
	},
	
	State{
		name = "play_bagpipe_stomp",
		tags = {"playing", "idle"},
		
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("idle_onemanband1_pst")
			inst.AnimState:PushAnimation("idle_onemanband2_pre")
			inst.AnimState:PushAnimation("idle_onemanband2_loop")
			inst.AnimState:PushAnimation("idle_onemanband2_pst", false)
		end,
		
		events = {
			EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
}

ENV.AddStategraphPostInit("wilson", function(sg)
	CommonStates.AddWalrusBeartrapHandlers(states, events, {
		ontrappedfn = function(inst, trap)
			inst:ClearBufferedAction()
			
			--inst:ShowHUD(false)
			inst:ShowCrafting(false)
			inst:SetCameraZoomed(true)
			
			DoHurtSound(inst)
		end,
		onexitfn = function(inst, trap)
			--inst:ShowHUD(true)
			inst:ShowCrafting(true)
			inst:SetCameraZoomed(false)
		end,
	}, true)
	
	for _, state in pairs(states) do
		sg.states[state.name] = state
	end
	
	for _, event in pairs(events) do
		sg.events[event.name] = event
	end
	
	--	actions
	
	local oldACTIVATE = sg.actionhandlers[ACTIONS.ACTIVATE].deststate
	sg.actionhandlers[ACTIONS.ACTIVATE].deststate = function(inst, action, ...)
		if action.target and action.target:HasTag("dirtpile") and inst:GetDebuff("buff_huntmoar") then
			return "domediumaction"
		end
		
		return oldACTIVATE(inst, action, ...)
	end
	
	local oldCASTSPELL = sg.actionhandlers[ACTIONS.CASTSPELL].deststate
	sg.actionhandlers[ACTIONS.CASTSPELL].deststate = function(inst, action, ...)
		if action.invobject then
			if action.invobject:HasTag("polarstaff") then
				return (inst.components.rider and inst.components.rider:IsRiding()) and "quickcastspell" or "polarcast"
			elseif action.invobject:HasTag("wintersfists") then
				return "winterfistcast"
			end
		end
		
		return oldCASTSPELL(inst, action, ...)
	end
	
	--	events
	
	local oldattacked_event = sg.events["attacked"].fn
	sg.events["attacked"].fn = function(inst, data, ...)
		if inst:HasTag("frozenstats") then
			return
		end
		
		if oldattacked_event then
			oldattacked_event(inst, data, ...)
		end
	end
	local oldemote_event = sg.events["emote"].fn
	sg.events["emote"].fn = function(inst, data, ...)
		if data and data.insnowonly then
			local tile, tileinfo = inst:GetCurrentTileType()
			local in_snow = tile and (tile == WORLD_TILES.POLAR_SNOW or (tileinfo and not tileinfo.nogroundoverlays and TheWorld.state.snowlevel and TheWorld.state.snowlevel > 0.5))
			
			if not in_snow then
				return
			end
		end
		
		if oldemote_event then
			oldemote_event(inst, data, ...)
		end
	end
	
	--	states
	
	local oldattack = sg.states["attack"].onenter
	sg.states["attack"].onenter = function(inst, ...)
		oldattack(inst, ...)
		
		local equip = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if equip and equip:HasTag("antlerstick") then
			inst.SoundEmitter:PlaySound("polarsounds/antler_tree/swoop", nil, nil, true)
		end
	end
	
	local oldemote_enter = sg.states["emote"].onenter
	sg.states["emote"].onenter = function(inst, data, ...)
		if data and data.insnowonly then
			inst.sg.statemem.emoteinsnow = true
			inst.DynamicShadow:Enable(false)
			
			if data.insnowfn and inst.sg.statemem.emoteinsnowtask == nil then
				inst.sg.statemem.emoteinsnowtask = inst:DoPeriodicTask(data.insnowfnperiod or 1, data.insnowfn, data.insnowfnfirstperiod or nil)
			end
			if data.insnowfn2 and inst.sg.statemem.emoteinsnowtask2 == nil then
				inst.sg.statemem.emoteinsnowtask2 = inst:DoPeriodicTask(data.insnowfnperiod2 or 1, data.insnowfn2, data.insnowfnfirstperiod2 or nil)
			end
		end
		
		if oldemote_enter then
			oldemote_enter(inst, data, ...)
		end
	end
	
	local oldemote_exit = sg.states["emote"].onexit
	sg.states["emote"].onexit = function(inst, ...)
		if inst.sg.statemem.emoteinsnow then
			inst.DynamicShadow:Enable(true)
		end
		if inst.sg.statemem.emoteinsnowtask then
			inst.sg.statemem.emoteinsnowtask:Cancel()
			inst.sg.statemem.emoteinsnowtask = nil
		end
		if inst.sg.statemem.emoteinsnowtask2 then
			inst.sg.statemem.emoteinsnowtask2:Cancel()
			inst.sg.statemem.emoteinsnowtask2 = nil
		end
		
		if oldemote_exit then
			oldemote_exit(inst, ...)
		end
	end
	
	local oldenter_onemanband = sg.states["enter_onemanband"].onenter
	sg.states["enter_onemanband"].onenter = function(inst, pushanim, ...)
		local equippedArmor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		if equippedArmor and equippedArmor:HasTag("walrusbagpipe") then
			inst.sg:GoToState("enter_bagpipe", pushanim)
			return
		end
		
		oldenter_onemanband(inst, pushanim, ...)
	end
	
	local oldfunnyidle = sg.states["funnyidle"].onenter
	sg.states["funnyidle"].onenter = function(inst, ...)
		local fleas = inst.components.inventory and inst.components.inventory:GetItemsWithTag("flea") or {}
		local itchy_chance = 0
		
		for i, v in ipairs(fleas) do
			if v.components.inventoryitem and v.components.inventoryitem.owner == inst then -- Only in inv, ignore fleas in backpack
				if itchy_chance == 0 then
					itchy_chance = TUNING.POLARFLEA_FUNNYIDLE_CHANCE.min
				else
					itchy_chance = itchy_chance + TUNING.POLARFLEA_FUNNYIDLE_CHANCE.added
					if itchy_chance >= 1 then
						break
					end
				end
			end
		end
		
		if math.random() <= itchy_chance then
			inst.AnimState:PlayAnimation("flea_itchy")
			inst.SoundEmitter:PlaySound("polarsounds/wilson/flea_itch")
		else
			oldfunnyidle(inst, ...)
		end
	end
	
	local oldhide = sg.states["hide"].onenter
	sg.states["hide"].onenter = function(inst, ...)
		oldhide(inst, ...)
		
		local hat = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local skin_name = hat and hat:GetSkinName()
		
		if skin_name == "ms_bushhat_polar" then
			inst.SoundEmitter:KillAllSounds()
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
			
			local pct = TheWorld.state.seasonprogress
			local stage = "tall"
			
			local threshold1 = 0.4
			local threshold2 = 0.65
			local threshold3 = 0.9
			
			if TheWorld.state.iswinter or IsInPolar(inst) then
				stage = "tall"
			elseif TheWorld.state.isspring then
				stage = (pct < threshold1 and "tall")
					or (pct < threshold2 and "medium")
					or "short"
			elseif TheWorld.state.issummer then
				stage = "short"
			elseif TheWorld.state.isautumn then
				stage = (pct < threshold2 and "short")
					or (pct < threshold3 and "medium")
					or "tall"
			end
			
			local sym_override = stage == "tall" and "swap_hat"
				or stage == "medium" and "swap_hat_med"
				or "swap_hat_low"
			
			inst.AnimState:OverrideItemSkinSymbol("swap_hat", GetBuildForItem(skin_name), sym_override, hat.GUID, hat.AnimState:GetBuild())
		end
	end
end)

--

local states_client = {
	State{
		name = "polarcast",
		tags = {"doing", "busy", "canrotate"},
		server_states = {"polarcast"},
		
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("polarcast")
			
			inst:PerformPreviewBufferedAction()
			inst.sg:SetTimeout(2)
		end,
		
		onupdate = function(inst)
			if inst.sg:ServerStateMatches() then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle")
			end
		end,
		
		ontimeout = function(inst)
			inst:ClearBufferedAction()
			inst.sg:GoToState("idle")
		end
	},
	
	State{
		name = "winterfistcast",
		tags = {"doing", "busy", "canrotate"},
		server_states = {"winterfistcast"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("winterfist_small")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
			inst.components.locomotor:Stop()
			
			inst:PerformPreviewBufferedAction()
			inst.sg:SetTimeout(2)
		end,
		
		onupdate = function(inst)
			if inst.sg:ServerStateMatches() then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle")
			end
		end,
		
		ontimeout = function(inst)
			inst:ClearBufferedAction()
			inst.sg:GoToState("idle")
		end
	},
	
	State{
		name = "start_polarnecklace",
		tags = {"doing", "nodangle"},
		server_states = {"start_polarnecklace"},
		
		onenter = function(inst, resume_item)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("build_pre")
			inst.AnimState:PushAnimation("build_loop")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
			
			inst.sg:SetTimeout(TIMEOUT)
		end,
		
		onupdate = function(inst)
			if inst.sg:ServerStateMatches() then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle")
			end
		end,
		
		ontimeout = function(inst)
			inst:ClearBufferedAction()
			inst.sg:GoToState("idle")
		end
	},
	
	State{
		name = "polarspawn",
		tags = {"busy", "noattack", "nopredict", "nodangle"},
		
		onenter = function(inst)
			inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
			inst.AnimState:PlayAnimation("frozen")
			
			inst.entity:SetIsPredictingMovement(false)
			inst.entity:FlattenMovementPrediction()
			inst.sg:SetTimeout(2)
		end,
		
		onupdate = function(inst)
			if inst.sg:ServerStateMatches() and inst.entity:FlattenMovementPrediction() then
				inst.sg:GoToState("idle", "noanim")
			end
		end,

		ontimeout = function(inst)
			inst.sg:GoToState("idle", "noanim")
		end,
	},
}

ENV.AddStategraphPostInit("wilson_client", function(sg)
	for _, state in pairs(states_client) do
		sg.states[state.name] = state
	end
	
	--	actions
	
	local old_CASTSPELL_fn = sg.actionhandlers[ACTIONS.CASTSPELL].deststate
	sg.actionhandlers[ACTIONS.CASTSPELL].deststate = function(inst, action, ...)
		if action.invobject:HasTag("polarstaff") then
			return (inst.components.rider and inst.components.rider:IsRiding()) and "quickcastspell" or "polarcast"
		elseif action.invobject:HasTag("wintersfists") then
			return "winterfistcast"
		end
		
		return old_CASTSPELL_fn(inst, action, ...)
	end
end)