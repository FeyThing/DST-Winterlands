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
	CommonHandlers.OnSink(),
	CommonHandlers.OnSleepEx(),
	CommonHandlers.OnWakeEx(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnDeath(),
	
	EventHandler("locomote", function(inst)
		if inst:ChargeRam() then
			inst.sg:GoToState("ram_taunt")
			return
		end
		
		if (inst._wantstotaunt and inst.components.combat and inst.components.combat.target ~= nil)
			or not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") then
			
			return
		end
		
		local is_moving = inst.sg:HasStateTag("moving")
		local is_running = inst.sg:HasStateTag("running")
		local should_move = inst.components.locomotor:WantsToMoveForward()
		local should_run = inst.components.locomotor:WantsToRun()
			
		if not should_move then
			if not inst.sg:HasStateTag("idle") then
				if not inst.sg:HasStateTag("running") then
					inst.sg:GoToState("idle")
				elseif is_moving then
					inst.sg:GoToState(is_running and "run_stop" or "walk_stop")
				else
					inst.sg:GoToState("idle")
				end
			end
		else
			if not inst.sg:HasStateTag("moving") then
				inst.sg:GoToState(should_run and "run_start" or "walk_start")
			end
		end
	end),
	EventHandler("attacked", function(inst)
		if (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("caninterrupt")) and not inst.components.health:IsDead() then
			--if not inst.components.combat:InCooldown() then
				inst.sg:GoToState("hit")
			--end
		end
	end),
	EventHandler("doattack", function(inst, data)
		if not inst._wantstotaunt and not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
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
			inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("idle_loop")
			
			local has_target = inst.components.combat and inst.components.combat.target ~= nil
			if inst.sg.mem.wantstogrowantler then
				inst.sg:GoToState("growantler")
			elseif inst._wantstotaunt and has_target then
				inst.sg:GoToState("taunt")
			elseif not has_target and math.random() < 0.15 then
				inst.sg:GoToState(math.random() < 0.5 and "idle_dig" or "idle_alert")
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
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("atk_magic_pre")
			inst.AnimState:PushAnimation("atk_magic_loop") 
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/huff")
			inst.components.locomotor:StopMoving()
			
			inst.charge_pos = inst:GetPosition()
			
			local target = inst.components.combat and inst.components.combat.target
			if target and inst:HasTag("spectermoose") and inst.DoCast then
				inst.sg.mem.casttarget = target
				inst.sg.statemem.fx = SpawnPrefab("deer_ice_charge")
				inst.sg.statemem.fx.entity:SetParent(inst.entity)
				inst.sg.statemem.fx.entity:AddFollower()
				inst.sg.statemem.fx.Follower:FollowSymbol(inst.GUID, "swap_antler_red", 0, 0, 0)
			end
			
			inst.sg:SetTimeout(TUNING.POLAR_MOOSE_ATTACK_PERIOD)
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,
		
		onexit = function(inst)
			if inst.sg.statemem.fx and inst.sg.statemem.fx:IsValid() then
				inst.sg.statemem.fx:KillFX()
			end
		end,
		
		timeline = {
			TimeEvent(1, function(inst)
				if inst.sg.mem.casttarget and inst.sg.mem.casttarget:IsValid() then
					inst:DoCast(inst.sg.mem.casttarget)
				end
			end),
			TimeEvent(1.2, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/scratch") end),
			TimeEvent(1.9, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/scratch") end),
			TimeEvent(2.4, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/scratch") end),
			TimeEvent(2.5, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/scratch") end),
		},
	},
	
	State{
		name = "taunt",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("taunt")
			inst.components.locomotor:StopMoving()
			inst._wantstotaunt = nil
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
		
		onexit = function(inst)
			inst:ShowAntler()
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
					
					inst.sg:GoToState("growantler_pst")
				end
			end),
		},
	},
	
	State{
		name = "growantler_pst",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("unshackle_pst")
			inst.components.locomotor:StopMoving()
		end,
		
		timeline = {
			TimeEvent(30 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
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
			inst._charging_ram = nil
			
			local x, y, z = inst.Transform:GetWorldPosition()
			--local rotation = inst.Transform:GetRotation() * DEGREES
			
			--x = x + KNOCK_RANGE_PADDING * math.cos(rotation)
			--z = z - KNOCK_RANGE_PADDING * math.sin(rotation)
			
			local range = inst.components.combat.hitrange
			local ents = TheSim:FindEntities(x, y, z, range, KNOCK_TARGET_TAGS, KNOCK_TARGET_NOT_TAGS)
			
			for i, v in ipairs(ents) do
				if v ~= inst and inst.components.combat:CanTarget(v) and v:IsValid() and not v:IsInLimbo() and not (v.components.health and v.components.health:IsDead()) then
					v:PushEvent("knockback", {knocker = inst, radius = TUNING.POLAR_MOOSE_KNOCK_RAD, strengthmult = inst.hasantler and 2 or 1, forcelanded = not inst.hasantler})
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
				local loot = inst:HasTag("spectermoose") and "moose_polar_antler" or "boneshard"
				local pt = inst:GetPosition()
				pt.y = 1
				
				inst:SetAntlered(nil, false)
				for i = 1, 2 do
					inst.components.lootdropper:SpawnLootPrefab(loot, pt)
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