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
			inst.sg:GoToState("attack", data.target)
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
		name = "attack",
		tags = {"attack", "busy"},
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk", false)
			inst.AnimState:PushAnimation("atk_pst", false)
			inst.Physics:Stop()
			
			inst.sg.statemem.target = target
			inst.components.combat:StartAttack()
		end,
		
		timeline = {
			TimeEvent(16 * FRAMES, function(inst)
				inst.components.combat:DoAttack(inst.sg.statemem.target)
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
				local x0, y0, z0 = inst.Transform:GetWorldPosition()
				
				for k = 1, 4 do
					local x = x0 + math.random() * 20 - 10
					local z = z0 + math.random() * 20 - 10
					
					if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
						inst.Physics:Teleport(x, 0, z)
						break
					end
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