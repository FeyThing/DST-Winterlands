require("stategraphs/commonstates")

local actionhandlers = {
	ActionHandler(ACTIONS.GOHOME, "action"),
}

local events = {
	EventHandler("attacked", function(inst)
		if not (inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("hit") or inst.sg:HasStateTag("noattack") or inst.components.health:IsDead()) then
			inst.sg:GoToState("hit")
		end
	end),
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	EventHandler("doattack", function(inst, data)
		if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
			inst.sg:GoToState("cast", data.target)
		end
	end),
	CommonHandlers.OnLocomote(false, true),
}

local states = {
	State{
		name = "idle",
		tags = {"idle", "canrotate"},
		
		onenter = function(inst)
			if not inst.AnimState:IsCurrentAnimation("idle_loop") then
				inst.AnimState:PlayAnimation("idle_loop", true)
			end
			
			inst.components.locomotor:StopMoving()
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,
	},
	
	State{
		name = "cast",
		tags = {"attack", "busy"},
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk", false)
			inst.AnimState:PushAnimation("atk_pst", false)
			inst.Physics:Stop()
			
			if target and target:IsValid() then
				inst.sg.statemem.target = target
				inst.sg.statemem.targetpos = target:GetPosition()
			end
			
			inst.components.combat:StartAttack()
		end,
		
		onupdate = function(inst)
			local target = inst.sg.statemem.target
			
			if target and target:IsValid() then
				local pos = inst.sg.statemem.targetpos
				pos.x, pos.y, pos.z = inst.sg.statemem.target.Transform:GetWorldPosition()
			else
				inst.sg.statemem.target = nil
			end
			
			inst:ForceFacePoint(inst.sg.statemem.targetpos)
		end,
		
		timeline = {
			TimeEvent(16 * FRAMES, function(inst)
				local pos = inst.sg.statemem.targetpos
				
				if pos then
					local spike = SpawnPrefab("shadow_icicler_spike")
					spike.Physics:Teleport(pos.x, pos.y + TUNING.SHADOW_ICICLER_SPIKE_HEIGHT.min, pos.z)
					spike.components.complexprojectile:Launch(pos, inst)
					
					local dtheta = TWOPI / math.random(TUNING.SHADOW_ICICLER_SPIKE_AMT.min, TUNING.SHADOW_ICICLER_SPIKE_AMT.max)
					for theta = math.random() * dtheta, TWOPI, dtheta do
						local height = GetRandomMinMax(TUNING.SHADOW_ICICLER_SPIKE_HEIGHT.min, TUNING.SHADOW_ICICLER_SPIKE_HEIGHT.max)
						local range = GetRandomMinMax(TUNING.SHADOW_ICICLER_SPIKE_RING_RANGE.min, TUNING.SHADOW_ICICLER_SPIKE_RING_RANGE.max)
						
						local x = pos.x + range * math.cos(theta)
						local z = pos.z + range * math.sin(theta)
						
						inst:DoTaskInTime(math.random(), function()
							local _spike = SpawnPrefab("shadow_icicler_spike")
							_spike.Physics:Teleport(x, pos.y, z)
							_spike.components.complexprojectile:Launch(Vector3(x, pos.y + height, z), inst)
						end)
					end
				end
			end),
		},
		
		events = {
			EventHandler("animqueueover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "hit",
		tags = {"busy", "hit"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("disappear")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				local pt = inst:GetPosition()
				local offset = FindWalkableOffset(pt, TWOPI * math.random(), TUNING.SHADOW_ICICLER_ATTACK_RANGE, 8, true, true, nil, true, true)
				
				if offset then
					inst.Physics:Teleport((pt + offset):Get())
				end
				
				inst.sg:GoToState("appear")
			end),
		},
	},
	
	State{
		name = "taunt",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("taunt")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "appear",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("appear")
			inst.Physics:Stop()
		end,
		
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
			inst.AnimState:PlayAnimation("disappear")
			inst.Physics:Stop()
			
			RemovePhysicsColliders(inst)
			inst.components.lootdropper:DropLoot(inst:GetPosition())
			
			inst.persists = false
			inst:AddTag("NOCLICK")
		end,
	},
	
	State{
		name = "disappear",
		tags = {"busy", "noattack"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("disappear")
			inst.Physics:Stop()
			
			inst.persists = false
			inst:AddTag("NOCLICK")
		end,
		
		onexit = function(inst)
			inst:RemoveTag("NOCLICK")
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "action",
		
		onenter = function(inst, playanim)
			inst.Physics:Stop()
			inst:PerformBufferedAction()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
}

CommonStates.AddWalkStates(states)

return StateGraph("shadow_icicler", states, events, "appear", actionhandlers)