require("stategraphs/commonstates")

local function DoFootstep(inst, volume)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/footstep", nil, volume)
	PlayFootstep(inst, volume)
end

local function DoFootstepRun(inst, volume)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/footstep_run", nil, volume)
	PlayFootstep(inst, volume)
end

local events = {
	CommonHandlers.OnLocomote(true, true),
	CommonHandlers.OnSink(),
	CommonHandlers.OnSleepEx(),
	CommonHandlers.OnWakeEx(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnDeath(),
	
	EventHandler("attacked", function(inst)
		if (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("caninterrupt")) and not inst.components.health:IsDead() then
			if not inst.components.combat:InCooldown() then
				inst.sg:GoToState("hit")
			end
		end
	end),
	EventHandler("doattack", function(inst, data)
		if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
			inst.sg:GoToState("attack", data and data.target or nil)
		end
	end),
	EventHandler("growantler", function(inst)
		if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
			inst.sg:GoToState("growantler")
		else
			inst.sg.mem.wantstogrowantler = true
		end
	end),
}

local states = {
	State{
		name = "idle",
		tags = {"idle", "canrotate"},
		
		onenter = function(inst, playanim)
			if inst.sg.mem.wantstogrowantler then
				inst.sg:GoToState("growantler")
			elseif inst.components.combat and inst.components.combat.target and inst.components.combat:InCooldown() and inst.hasantler then
				inst.sg:GoToState("ram_taunt")
			elseif not (inst.components.combat and inst.components.combat.target) and math.random() < 0.15 then
				local rdm = math.random()
				inst.sg:GoToState(rdm < 0.7 and "idle_dig" or rdm < 0.9 and "idle_alert" or "idle_grazing")
			else
				inst.AnimState:PlayAnimation("idle_loop")
				inst.components.locomotor:StopMoving()
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "idle_alert",
		tags = {"canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("alert_pre")
			inst.AnimState:PushAnimation("alert_idle", true)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/curious")
			inst.components.locomotor:StopMoving()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "idle_grazing",
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("eat")
			inst.components.locomotor:StopMoving()
		end,
		
		timeline = {
			TimeEvent(7 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/eat")
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "idle_dig",
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("dig")
			inst.components.locomotor:StopMoving()
		end,
		
		timeline = {
			TimeEvent(35 * FRAMES, PlayFootstep),
			TimeEvent(55 * FRAMES, PlayFootstep),
			TimeEvent(68 * FRAMES, PlayFootstep),
			TimeEvent(80 * FRAMES, PlayFootstep),
		},
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "ram_taunt",
		tags = {"busy", "caninterrupt"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("atk_magic_pre")
			inst.AnimState:PushAnimation("atk_magic_loop", false)
			inst.AnimState:PushAnimation("atk_magic_loop", false)
			inst.AnimState:PushAnimation("atk_magic_loop", false)
			--inst.AnimState:PushAnimation("atk_magic_pst", false)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/huff")
			inst.components.locomotor:StopMoving()
			
			inst.charge_pos = inst:GetPosition()
		end,
		
		timeline = {
			TimeEvent(1.2, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/scratch") end),
			TimeEvent(1.9, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/scratch") end),
			TimeEvent(2.4, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/scratch") end),
			TimeEvent(2.5, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/scratch") end),
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
		name = "taunt",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("taunt")
			inst.components.locomotor:StopMoving()
		end,
		
		timeline = {
			TimeEvent(2 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/taunt")
			end),
			TimeEvent(35 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/swish")
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "growantler",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("unshackle")
			inst.components.locomotor:StopMoving()
			
			inst.sg.mem.wantstogrowantler = nil
		end,
		
		timeline = {
			TimeEvent(12 * FRAMES, DoFootstep),
			TimeEvent(13 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					local fx = SpawnPrefab("deer_growantler_fx")
					fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
					fx.Transform:SetRotation(inst.Transform:GetRotation())
					
					inst.sg:GoToState("unshackle_pst")
				end
			end),
		},
		
		onexit = function(inst)
			inst:ShowAntler()
		end,
	},
	
	State{
		name = "knockoffantler",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("hit_2")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/hit")
			inst.components.locomotor:StopMoving()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
}

CommonStates.AddWalkStates(states, {
	walktimeline = {
		TimeEvent(0, DoFootstep),
		TimeEvent(7 * FRAMES, DoFootstep),
		TimeEvent(9 * FRAMES, DoFootstep),
		TimeEvent(17 * FRAMES, DoFootstep),
	},
	endtimeline = {
		TimeEvent(3 * FRAMES, function(inst)
			DoFootstep(inst, 0.5)
		end),
	},
})

CommonStates.AddRunStates(states, {
	starttimeline = {
		TimeEvent(8 * FRAMES, DoFootstepRun),
	},
	runtimeline = {
		TimeEvent(0, DoFootstepRun),
		TimeEvent(14 * FRAMES, DoFootstepRun),
	},
	endtimeline = {
		TimeEvent(2 * FRAMES, DoFootstep),
		TimeEvent(4 * FRAMES, DoFootstep),
	},
})

local KNOCK_RANGE_PADDING = 2
local KNOCK_TARGET_TAGS = {"_combat"}
local KNOCK_TARGET_NOT_TAGS = {"INLIMBO", "flight", "invisible", "notarget", "noattack"}

CommonStates.AddCombatStates(states, {
	attacktimeline = {
		TimeEvent(3 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/swish")
		end),
		TimeEvent(5 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/taunt")
		end),
		TimeEvent(12 * FRAMES, function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target)
			
			local x, y, z = inst.Transform:GetWorldPosition()
			--local rotation = inst.Transform:GetRotation() * DEGREES
			
			--x = x + KNOCK_RANGE_PADDING * math.cos(rotation)
			--z = z - KNOCK_RANGE_PADDING * math.sin(rotation)
			
			local range = inst.components.combat.hitrange
			local ents = TheSim:FindEntities(x, y, z, range, KNOCK_TARGET_TAGS, KNOCK_TARGET_NOT_TAGS)
			
			for i, v in ipairs(ents) do
				if v ~= inst and inst.components.combat:CanTarget(v) and v:IsValid() and not v:IsInLimbo() and not (v.components.health and v.components.health:IsDead()) then
					v:PushEvent("knockback", {knocker = inst, radius = 2, strengthmult = inst.hasantler and 2 or 1, forcelanded = not inst.hasantler})
				end
			end
		end),
		TimeEvent(23 * FRAMES, DoFootstep),
		TimeEvent(25 * FRAMES, DoFootstepRun),
		TimeEvent(28 * FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
		end)
	},
	hittimeline = {
		TimeEvent(12 * FRAMES, DoFootstep),
	},
	deathtimeline = {
		TimeEvent(5 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bodyfall_2")
		end),
		TimeEvent(20 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/hit")
		end),
		TimeEvent(23 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bodyfall_2")
			if inst.hasantler then
				local pt = inst:GetPosition()
				pt.y = 1
				
				inst:SetAntlered(nil, false)
				for i = 1, math.random(2) do
					inst.components.lootdropper:SpawnLootPrefab("boneshard", pt)
				end
			end
		end),
	},
},
{
	hit = "hit",
})

CommonStates.AddFrozenStates(states)

CommonStates.AddSleepExStates(states, {
	starttimeline = {
		TimeEvent(9 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bodyfall")
		end),
	},
})

CommonStates.AddSinkAndWashAshoreStates(states)

return StateGraph("moose_polar", states, events, "idle")