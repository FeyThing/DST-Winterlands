require("stategraphs/commonstates")

local actionhandlers = {
	
}

local events = {
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnDeath(),
	--CommonHandlers.OnLocomote(true, true),
	CommonHandlers.OnSleepEx(),
	CommonHandlers.OnWakeEx(),
}

local states = {
	State{
		name = "idle",
		tags = {"idle"},
		
		onenter = function(inst, data)
			inst.AnimState:PlayAnimation("idle")
			inst.Physics:Stop()
			
			inst.sg.statemem.alerted = data and data.alerted and inst.wantstoalert
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
				
				inst.sg:GoToState((wantstoalert and "alert") or (inst.wantstosit and "sit") or "idle", {alerted = inst.sg.statemem.alerted})
			end),
		},
	},
	
	State{
		name = "sit",
		tags = {"busy"},
		
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
				inst.sg:GoToState((wantstosit and "sitting") or (inst.wantstoalert and "alert") or "idle")
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
				
				inst.sg:GoToState((inst.wantstoalert and "sit") or (inst.wantstosit and "sitting") or "sit")
			end),
		},
	},
	
	State{
		name = "alert",
		tags = {"alert", "busy", "canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("alert")
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
		tags = {"sniffing", "busy", "canrotate"},
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("sniff")
			inst.Physics:Stop()
			
			inst.sg.statemem.sniff_target = target
		end,
		
		onupdate = function(inst)
			local target = inst.sg.statemem.sniff_target
			if target and target:IsValid() and not target:IsInLimbo() then
				inst:ForceFacePoint(target.Transform:GetWorldPosition())
			else
				inst.sg.statemem.sniff_target = nil
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sniffed_food = inst.sg.statemem.sniff_target
				inst.sg:GoToState("idle")
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
				inst.components.lootdropper:DropLoot() -- TODO: Hide tail if dropped ?
			end
		end,
	},
}

CommonStates.AddSimpleState(states, "hit", "hit")
CommonStates.AddSleepExStates(states)

return StateGraph("polarfox", states, events, "idle", actionhandlers)