require("stategraphs/commonstates")

local actionhandlers = {
	ActionHandler(ACTIONS.EAT, function(inst)
		local ba = inst:GetBufferedAction()
		if ba and ba.target and inst._trusted_foods and inst._trusted_foods[ba.target] then
			local leader = inst.components.follower and inst.components.follower.leader
			
			return leader == nil and "sniff" or "eat"
		else
			return "eat"
		end
	end),
}

local events = {
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnHop(),
	CommonHandlers.OnSink(),
    CommonHandlers.OnFallInVoid(),
	CommonHandlers.OnSleepEx(),
	CommonHandlers.OnWakeEx(),
	
	EventHandler("locomote", function(inst)
		if inst.components.locomotor then
			if inst.sg:HasStateTag("sitting") and inst.wantstosit then
				inst.wantstosit = nil
				inst.sg:GoToState("sit")
				return
			end
			
			local is_idling = inst.sg:HasStateTag("idle")
			local is_moving = inst.sg:HasStateTag("moving")
			local is_running = inst.sg:HasStateTag("running")
			local should_move = inst.components.locomotor:WantsToMoveForward()
			local should_run = inst.components.locomotor:WantsToRun()
			
			if is_moving and not should_move then
				inst.sg:GoToState(is_running and "run_stop" or "walk_stop")
			elseif (is_idling and should_move) or (is_moving and should_move and is_running ~= should_run) then
				inst.sg:GoToState((should_run and "run_start") or "walk_start")
			end
		end
	end),
	EventHandler("dofoxdive", function(inst)
		if not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("foxdive_pre")
		end
	end),
}

local EXITSNOW_BLOCKER_TAGS = {"antlion_sinkhole_blocker", "birdblocker", "blocker", "character", "structure", "wall"}

local function SnowHasSpace(pt)
	return #TheSim:FindEntities(pt.x, pt.y, pt.z, 5, nil, nil, EXITSNOW_BLOCKER_TAGS) == 0 and TheWorld.Map:IsPolarSnowAtPoint(pt.x, 0, pt.z, true)
end

local states = {
	State{
		name = "idle",
		tags = {"idle"},
		
		onenter = function(inst, data)
			inst.sg.statemem.alerted = data and data.alerted and inst.wantstoalert
			
			local temperature = TheWorld.state.temperature
			if not (inst.components.follower and inst.components.follower.leader) and ((temperature and temperature >= TUNING.POLAR_SNOW_MELT_TEMP)
				or (TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst))) then
				
				inst.wantstodive_forced = true
			else
				inst.wantstodive_forced = nil
			end
			
			inst.AnimState:PlayAnimation(inst.sg.statemem.alerted and "idle_alerted" or "idle")
			inst.Physics:Stop()
		end,
		
		onupdate = function(inst)
			if inst.sg.statemem.alerted then
				local x, y, z = inst.Transform:GetWorldPosition()
				local players = FindPlayersInRange(x, y, z, 10, true)
				
				for i, player in ipairs(players) do
					if player.sg and not player.sg:HasStateTag("hidden") then
						inst:ForceFacePoint(player.Transform:GetWorldPosition())
						break
					end
				end
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				local wantstoalert = inst.wantstoalert and not inst.sg.statemem.alerted
				inst.wantstosit = math.random() < 0.1 and not (inst.sg.statemem.alerted and inst.components.follower and inst.components.follower.leader == nil)
				
				inst.sg:GoToState((wantstoalert and "_alert") or (inst.wantstosit and "sit") or "idle", {alerted = inst.sg.statemem.alerted})
			end),
		},
	},
	
	State{
		name = "sit",
		tags = {"busy", "caninterrupt", "sitting"},
		
		onenter = function(inst)
			if inst.wantstosit then
				inst.AnimState:PlayAnimation("sit_pre")
			else
				inst.AnimState:PlayAnimation("sit_pst")
			end
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				local wantstosit = not inst.wantstoalert and inst.wantstosit
				inst.sg:GoToState((wantstosit and "sitting") or (inst.wantstoalert and "_alert") or "idle")
			end),
		},
	},
	
	State{
		name = "sitting",
		tags = {"idle", "canrotate", "sitting"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("sit_loop")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.wantstosit = math.random() < 0.9 and not inst.wantstoalert
				
				local temperature = TheWorld.state.temperature
				if not (inst.components.follower and inst.components.follower.leader) and ((temperature and temperature >= TUNING.POLAR_SNOW_MELT_TEMP)
					or (TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst))) then
					inst.wantstosit = nil
					
					inst.sg:GoToState("sit")
				else
					inst.sg:GoToState((inst.wantstoalert and "sit") or (inst.wantstosit and "sitting") or "sit")
				end
			end),
		},
	},
	
	State{
		name = "_alert", -- Cannot use standard state name because of facing behaviour
		tags = {"alert", "busy", "canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("alert")
			inst.SoundEmitter:PlaySound("polarsounds/polarfox/sniff_long", nil, 0.25)
			inst.Physics:Stop()
			
			local x, y, z = inst.Transform:GetWorldPosition()
			local players = FindPlayersInRange(x, y, z, 10, true)
			
			for i, player in ipairs(players) do
				if player.sg and not player.sg:HasStateTag("hidden") then
					inst:ForceFacePoint(player.Transform:GetWorldPosition())
					break
				end
			end
		end,
		
		timeline = {
			TimeEvent(4 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive") end),
			TimeEvent(8 * FRAMES, function(inst) PlayFootstep(inst, 0.1) end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle", {alerted = true})
			end),
		},
	},
	
	State{
		name = "eat",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("eat_pre")
			
			local num_loop = math.random(3)
			for i = 1, num_loop do
				inst.AnimState:PushAnimation("eat_loop", false)
			end
			inst.AnimState:PushAnimation("eat_pst", false)
			inst.Physics:Stop()
		end,
		
		timeline = {
			TimeEvent(6 * FRAMES, function(inst)
				inst:PerformBufferedAction()
				inst.sg:AddStateTag("caninterrupt")
			end),
		},
		
		events = {
			EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "sniff",
		tags = {"sniffing", "canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("sniff")
			inst.Physics:Stop()
			
			local ba = inst:GetBufferedAction()
			if ba and ba.target then
				inst.sg.statemem.sniff_target = ba.target
			end
		end,
		
		onupdate = function(inst)
			local target = inst.sg.statemem.sniff_target
			if target and target:IsValid() and not target:IsInLimbo() and not inst.components.locomotor:WantsToRun() then
				inst:ForceFacePoint(target.Transform:GetWorldPosition())
			else
				inst._trusted_foods = nil
				
				inst:ClearBufferedAction()
				inst.sg:GoToState("_alert")
			end
		end,
		
		timeline = {
			TimeEvent(FRAMES, function(inst) PlayFootstep(inst, 0.4) end),
			TimeEvent(6 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/sniff_cut") end),
			TimeEvent(15 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/sniff_short") end),
			TimeEvent(28 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/sniff_long") end),
			TimeEvent(45 * FRAMES, function(inst) PlayFootstep(inst, 0.6) end),
			TimeEvent(53 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/sniff_low") end),
			
		},
		
		events = {
			EventHandler("animover", function(inst)
				local target = inst.sg.statemem.sniff_target
				if target and target:IsValid() and not target:IsInLimbo() then
					inst.sg:GoToState("eat")
				else
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "death",
		tags = {"busy", "nointerrupt"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("death")
			inst.Physics:Stop()
			
			if inst.tail then
				inst.tail:PlayTailAnim("still")
			end
			RemovePhysicsColliders(inst)
			
			if inst.components.lootdropper then
				inst.components.lootdropper:DropLoot()
			end
		end,
	},
	
	State{
		name = "walk_start",
		tags = {"moving", "canrotate", "foxwalk"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("walk_pre")
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("walk")
			end),
		},
	},
	
	State{
		name = "walk",
		tags = {"moving", "canrotate", "foxwalk"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("walk")
			inst.components.locomotor:WalkForward()
		end,
		
		timeline = {
			TimeEvent(FRAMES, function(inst) PlayFootstep(inst, 0.1) end),
			TimeEvent(14 * FRAMES, function(inst) PlayFootstep(inst, 0.1) end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("walk")
			end),
		},
	},
	
	State{
		name = "walk_stop",
		tags = {"canrotate", "foxwalk"},
		
		onenter = function(inst)
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("walk_pst")
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "run_start",
		tags = {"moving", "running", "canrotate"},
		
		onenter = function(inst)
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("run_pre")
		end,
		
		timeline = {
			TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive") end),
			TimeEvent(2 * FRAMES, function(inst) PlayFootstep(inst, 0.2) end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("run")
			end),
		},
	},
	
	State{
		name = "run",
		tags = {"moving", "running", "canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("run", true)
			inst.components.locomotor:RunForward()
		end,
		
		timeline = {
			TimeEvent(2 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive") end),
			TimeEvent(5 * FRAMES, function(inst) PlayFootstep(inst, 0.2) end),
			TimeEvent(6 * FRAMES, function(inst) PlayFootstep(inst, 0.1) end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("run")
			end),
		},
	},
	
	State{
		name = "run_stop",
		tags = {"idle"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("run_pst")
			inst.components.locomotor:StopMoving()
			
			inst.wantstodive = nil
			inst.divept = nil
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "foxdive_pre",
		tags = {"busy", "nointerrupt"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("jump_pre")
			inst.AnimState:PushAnimation("jump_loop", false)
			PlayFootstep(inst)
			
			inst.wantstohunt = inst.components.timer and inst.components.timer:TimerExists("huntperiod")
		end,
		
		timeline = {
			TimeEvent(4 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive")
				inst.Physics:SetMotorVelOverride(6, 0, 0)
			end),
			TimeEvent(12 * FRAMES, function(inst)
				inst.AnimState:PlayAnimation("dive_pre", false)
				inst.AnimState:PushAnimation("dive_loop", false)
				inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive_hit")
				inst.Physics:ClearMotorVelOverride()
				inst.Physics:Stop()
				
				inst.sg.statemem.dig_pos = inst:GetPosition()
			end),
			TimeEvent(16 * FRAMES, function(inst)
				local pt = inst.sg.statemem.dig_pos
				SpawnPrefab("polar_splash_large").Transform:SetPosition(pt:Get())
			end),
			TimeEvent(20 * FRAMES, function(inst)
				local pt = inst.sg.statemem.dig_pos
				SpawnPrefab("polar_splash").Transform:SetPosition(pt:Get())
			end),
			TimeEvent(24 * FRAMES, function(inst)
				local pt = inst.sg.statemem.dig_pos
				SpawnPrefab("polar_splash_large").Transform:SetPosition(pt:Get())
			end),
			TimeEvent(28 * FRAMES, function(inst)
				local pt = inst.sg.statemem.dig_pos
				SpawnPrefab("polar_splash").Transform:SetPosition(pt:Get())
			end),
		},
		
		events = {
			EventHandler("animqueueover", function(inst)
				if inst.AnimState:IsCurrentAnimation("dive_loop") then
					inst.sg:GoToState("foxdive_loop")
				end
			end),
		},
	},
	
	State{
		name = "foxdive_loop",
		tags = {"busy", "noattack", "nointerrupt"},
		
		onenter = function(inst, stay_put, hunt_stuff)
			inst:Hide()
			inst.DynamicShadow:Enable(false)
			
			inst.wantstodive = nil
			inst.wantstodive_forced = nil
			
			if not stay_put then
				local pt = inst:GetPosition()
				local dist = (inst.components.follower and inst.components.follower.leader ~= nil) and GetRandomMinMax(4, 12) or GetRandomMinMax(10, 20)
				
				local offset = FindWalkableOffset(pt, math.random() * TWOPI, dist, 12, false, true, SnowHasSpace)
				if offset then
					inst.Transform:SetPosition((pt + offset):Get())
				end
			end
			
			local ignore_blizzard = inst.components.follower and inst.components.follower.leader ~= nil
			if ignore_blizzard or not (TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst)) then
				inst.sg.statemem.exit_dive = true
			end
			
			inst.sg:SetTimeout(1 + math.random(3))
		end,
		
		ontimeout = function(inst)
			if inst.sg.statemem.exit_dive then
				inst.sg:GoToState("foxdive_pst")
			else
				inst.sg:GoToState("foxdive_loop", true)
			end
		end,
	},
	
	State{
		name = "foxdive_pst",
		tags = {"busy", "nointerrupt"},
		
		onenter = function(inst)
			inst:Show()
			inst.DynamicShadow:Enable(true)
			
			inst.AnimState:PlayAnimation("jump_pre")
			inst.AnimState:PushAnimation("jump_loop", false)
			inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive_hit")
			
			-- if inst.wantstohunt then
			-- TODO: Frost Tails should be able to hunt on their own but because they currently don't attack I'd rather not have them litter the place too much
			--		 or maybe we can make them insta-kill their prey if they aren't befriended...
			if inst.wantstohunt and inst.components.follower and inst.components.follower.leader then
				inst:HuntRandomPrey()
				inst.wantstohunt = nil
			end
			
			SpawnPrefab("polar_splash").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end,
		
		timeline = {
			TimeEvent(6 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive")
				inst.Physics:SetMotorVelOverride(6, 0, 0)
			end),
			TimeEvent(12 * FRAMES, function(inst)
				inst.AnimState:PlayAnimation("jump_pst")
				inst.Physics:ClearMotorVelOverride()
				inst.Physics:Stop()
			end),
		},
		
		events = {
			EventHandler("animqueueover", function(inst)
				if inst.AnimState:IsCurrentAnimation("jump_pst") then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
}

CommonStates.AddSimpleState(states, "hit", "hit")
CommonStates.AddSleepExStates(states, {
	sleeptimeline = {
		TimeEvent(26 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/sniff_low", nil, 0.1 + (math.random() * 0.4)) end),
	},
	waketimeline = {
		TimeEvent(11 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive") end),
	},
},
{
	onsleep = function(inst)
		if inst.tail then
			inst.tail:PlayTailAnim("still", "still")
		end
	end,
	onwake = function(inst)
		if inst.tail then
			inst.tail:PlayTailAnim("idle", (inst.components.follower and inst.components.follower.leader) and "wiggle" or "idle")
		end
	end,
})
CommonStates.AddHopStates(states, false, nil, {
	hop_pre = {
		TimeEvent(2, function(inst)
			inst.SoundEmitter:PlaySound("polarsounds/polarfox/dive")
		end),
	}
})
CommonStates.AddSinkAndWashAshoreStates(states)
CommonStates.AddVoidFallStates(states)

return StateGraph("polarfox", states, events, "idle", actionhandlers)