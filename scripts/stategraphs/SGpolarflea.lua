require("stategraphs/commonstates")

local actionhandlers = {
	ActionHandler(ACTIONS.NUZZLE, "take_host_pre"),
}

local events= {
	EventHandler("attacked", function(inst)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
			inst.sg:GoToState("hit")
		end
	end),
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	EventHandler("doattack", function(inst, data)
		if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			inst.sg:GoToState("attack", data.target)
		end
	end),
	EventHandler("fleahostkick", function(inst, host)
		inst.sg:GoToState("fall", host)
	end),
	EventHandler("trapped", function(inst)
		if not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("trapped")
		end
	end),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnLocomote(true, false),
	CommonHandlers.OnFreeze(),
}

local states = {
	State{
		name = "idle",
		tags = {"idle", "canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle", true)
			inst.Physics:Stop()
		end,
	},
	
	State{
		name = "attack",
		tags = {"attack", "busy"},
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("atk")
			inst.SoundEmitter:PlaySound("polarsounds/snowflea/attack")
			inst.Physics:Stop()
			
			inst.sg.statemem.target = target
			inst.components.combat:StartAttack()
		end,
		
		timeline = {

			TimeEvent(9 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/snowflea/whip") end),
			TimeEvent(12 * FRAMES, function (inst) inst.SoundEmitter:PlaySound("polarsounds/snowflea/attack") end),
			TimeEvent(16 * FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				if math.random() < 0.333 then
					inst.components.combat:SetTarget(nil)
					inst.sg:GoToState("taunt")
				else
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "hit",
		tags = {"busy", "hit"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("polarsounds/snowflea/hit")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
	
	State{
		name = "taunt",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("taunt")
			inst.Physics:Stop()
		end,
		
		timeline = {
			TimeEvent(1 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/snowflea/blblbl") end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "death",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("death")
			inst.SoundEmitter:PlaySound("polarsounds/snowflea/death")
			inst.Physics:Stop()
			
			RemovePhysicsColliders(inst)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))			
		end,
	},
	
	State{
		name = "run_start",
		tags = {"moving", "running", "canrotate"},
		
		onenter = function(inst) 
			inst.AnimState:PlayAnimation("run_pre")
			inst.components.locomotor:RunForward()
		end,
		
		events = {
			EventHandler("animover", function(inst) inst.sg:GoToState("run") end),		
		},
	 },
	 
	 State{
		name = "run",
		tags = {"moving", "running", "canrotate"},
		
		onenter = function(inst) 
			inst.AnimState:PlayAnimation("run_loop")
			if not inst.SoundEmitter:PlayingSound("walk_LP") then
				inst.SoundEmitter:PlaySound("polarsounds/snowflea/walk_LP", "walk_LP")
			end
			
			inst.components.locomotor:RunForward()
		end,
		
		onexit = function(inst)
			inst.SoundEmitter:KillSound("walk_LP")
		end,
		
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
			inst.AnimState:PushAnimation("run_pst")
			
			inst.components.locomotor:StopMoving()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "fall",
		tags = {"busy"},
		
		onenter = function(inst, host)
			inst.AnimState:PlayAnimation("idle", true)
			inst.SoundEmitter:PlaySound("polarsounds/snowflea/spawn")
			inst.Physics:Stop()
			
			local pt = inst:GetPosition()
			pt.y = pt.y + 1.5
			
			inst.Transform:SetPosition(pt:Get())
		end,
		
		onupdate = function(inst)
			local pt = inst:GetPosition()
			
			if pt.y <= 0.1 then
				pt.y = 0
				
				inst.Physics:Stop()
				inst.Physics:Teleport(pt.x, pt.y, pt.z)
				
				inst.SoundEmitter:PlaySound("hookline_2/characters/hermit/clap")
				inst.sg:GoToState("taunt")
			else
				inst.Physics:SetMotorVelOverride(20, -50, 0)
			end
		end,
		
		onexit = function(inst)
			local pt = inst:GetPosition()
			pt.y = 0
			
			if not TheWorld.Map:IsPassableAtPoint(pt:Get()) then
				SpawnPrefab("splash_sink").Transform:SetPosition(pt:Get())
				inst:Remove()
			else
				inst.Transform:SetPosition(pt:Get())
			end
		end,
	},
	
	State {
		name = "take_host_pre",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("taunt")
			inst.AnimState:SetFrame(inst.AnimState:GetCurrentAnimationNumFrames() * 0.7)
			inst.SoundEmitter:PlaySound("polarsounds/snowflea/attack")
			
			local action = inst:GetBufferedAction()
			local target = action and action.target
			
			if target and target:IsValid() then
				inst:ForceFacePoint(target:GetPosition())
				inst.sg.statemem.target = target
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				if inst.sg.statemem.target and inst.CanBeHost and inst:CanBeHost(inst.sg.statemem.target) then
					inst.sg:GoToState("take_host", inst.sg.statemem.target)
				else
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State {
		name = "take_host",
		tags = {"busy"},
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("idle")
			if target and inst.SetHost then
				inst:SetHost(target)
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "trapped",
		tags = {"busy", "trapped"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("taunt")
			inst.SoundEmitter:PlaySound("polarsounds/snowflea/hit")
			inst.Physics:Stop()
			
			inst:ClearBufferedAction()
			inst.sg:SetTimeout(1)
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,
	},
}

CommonStates.AddSleepStates(states)
CommonStates.AddFrozenStates(states)

return StateGraph("polarflea", states, events, "idle", actionhandlers)