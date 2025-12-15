require("stategraphs/commonstates")

local CHARGE_TAGS = {"_combat"}
local CHARGE_NOT_TAGS = {"flea", "INLIMBO", "playerghost"}

local KNOCK_TAGS = {"character", "monster"}
local KNOCK_NOT_TAGS = {"DECOR", "FX", "INLIMBO", "playerghost"}

local function DoNearbyKnock(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 2.5, nil, KNOCK_NOT_TAGS, KNOCK_TAGS)
	
	if inst.sg.statemem.knocktargets == nil then
		inst.sg.statemem.knocktargets = {}
	end
	
	for i, v in ipairs(ents) do
		if not inst.sg.statemem.knocktargets[v] then
			if v.sg and not (v.sg:HasStateTag("knockback") or v.sg:HasStateTag("nointerrupt")) then
				v:PushEvent("knockback", {knocker = inst, radius = 1, strengthmult = 1, forcelanded = true})
			end
			inst.sg.statemem.knocktargets[v] = true
		end
	end
end

local function SpewBaby(inst, dir)
	local x, y, z = inst.Transform:GetWorldPosition()
	local rot = inst.Transform:GetRotation()
	
	if dir ~= "left" and dir ~= "right" then
		dir = inst.lastspewdir == "right" and "left" or "right"
	end
	inst.lastspewdir = dir
	
	local side_offset = (dir == "left") and 90 or -90
	local baby_rot = rot + side_offset + math.random(-15, 15)
	
	local rad = baby_rot * DEGREES
	local ox = math.cos(rad) * (0.5 + math.random() * 0.5)
	local oz = -math.sin(rad) * (0.5 + math.random() * 0.5)
	local pt = Vector3(x + ox, y + 1.5, z + oz)
	
	local baby = SpawnPrefab("polarflea")
	baby.Transform:SetPosition(pt:Get())
	baby.Transform:SetRotation(baby_rot)
	baby.Transform:SetScale(TUNING.POLARFLEA_BABY_SCALE, TUNING.POLARFLEA_BABY_SCALE, TUNING.POLARFLEA_BABY_SCALE)
	baby.AnimState:OverrideSymbol("shell", "polar_flea", "shell_mini")
	baby.babyflea = true
	
	if baby.components.follower then
		baby.components.follower:SetLeader(inst)
	end
	
	baby:PushEvent("fleahostkick", {host = inst, pt = pt})
	
	return baby
end

local actionhandlers = {}

local events = {
	EventHandler("attacked", function(inst, data)
		if inst.components.health and not inst.components.health:IsDead() then
			if CommonHandlers.TryElectrocuteOnAttacked(inst, data) then
				return
			elseif not inst.sg:HasStateTag("busy") or inst.sg:HasAnyStateTag("caninterrupt", "frozen") then
				if not CommonHandlers.HitRecoveryDelay(inst) then
					inst.sg:GoToState("hit")
				end
			end
		end
	end),
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	EventHandler("doattack", function(inst, data)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("electrocute") and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			inst.sg:GoToState("charge", data.target)
		end
	end),
	EventHandler("fleathrowback", function(inst, data)
		data = data or {}
		data.start = true
		
		inst.sg:GoToState("shake", data)
	end),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnLocomote(false, true),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnElectrocute(),
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
		name = "charge",
		tags = {"attack", "busy", "canrotate"},
		
		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("charge_pre")
			inst.AnimState:PushAnimation("charge_loop")
			inst.Physics:Stop()
			
			inst.sg.statemem.target = target
			inst.components.combat:StartAttack()
			inst.components.locomotor.runspeed = TUNING.POLARFLEA_MOTHER_CHARGE_SPEED
			inst.components.locomotor.walkspeed = TUNING.POLARFLEA_MOTHER_CHARGE_SPEED
			
			inst.sg.statemem._steptask = inst:DoPeriodicTask(0.1, function()
				inst.SoundEmitter:PlaySound("polarsounds/motherflea/step")
			end, 20 * FRAMES)
			inst.sg:SetTimeout(1.4 + math.random() * 0.2)
		end,
		
		timeline = {
			TimeEvent(11 * FRAMES, function (inst)
				inst.SoundEmitter:PlaySound("polarsounds/snowflea/attack")
				inst.SoundEmitter:PlaySound("polarsounds/motherflea/step")
			end),
			TimeEvent(21 * FRAMES, function(inst)
				inst.sg.statemem.bitetargets = {}
				inst.SoundEmitter:PlaySound("polarsounds/motherflea/step")
			end),
		},
		
		onupdate = function(inst)
			if inst.sg.statemem.bitetargets then
				inst.components.locomotor:RunForward(true)
				
				local x, y, z = inst.Transform:GetWorldPosition()
				local angle = inst.Transform:GetRotation()
				
				local theta = angle * DEGREES
				local cos_theta = math.cos(theta)
				local sin_theta = math.sin(theta)
				
				x = x + 1 * cos_theta
				z = z - 1 * sin_theta
				
				local ents = TheSim:FindEntities(x, y, z, 1.1, nil, CHARGE_NOT_TAGS, CHARGE_TAGS)
				for i, v in ipairs(ents) do
					if not inst.sg.statemem.bitetargets[v] and v.components.combat and v.components.health and not v.components.health:IsDead() then
						v.components.combat:GetAttacked(inst, TUNING.POLARFLEA_MOTHER_DAMAGE)
						inst.sg.statemem.bitetargets[v] = true
					end
				end
				
				DoNearbyKnock(inst)
			end
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("charge_stop")
		end,
		
		onexit = function(inst, target)
			if inst.sg.statemem._steptask then
				inst.sg.statemem._steptask:Cancel()
				inst.sg.statemem._steptask = nil
			end
		end,
	},
	
	State{
		name = "charge_stop",
		tags = {"attack", "busy", "canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("charge_pst")
			inst.SoundEmitter:PlaySound("polarsounds/motherflea/brakes")
			inst.Physics:SetMotorVel(5, 0, 0)
			
			inst.components.locomotor:Stop()
			
			inst.components.combat:RestartCooldown()
			inst.components.locomotor.runspeed = TUNING.POLARFLEA_MOTHER_RUN_SPEED
			inst.components.locomotor.walkspeed = TUNING.POLARFLEA_MOTHER_WALK_SPEED
		end,
		
		timeline = {
			TimeEvent(3 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/hit") end),
			TimeEvent(9 * FRAMES, function(inst) inst.Physics:SetMotorVel(0, 0, 0) end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState(math.random() < 0.33 and "taunt" or "idle")
			end),
		},
	},
	
	State{
		name = "hit",
		tags = {"busy", "hit"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("polarsounds/motherflea/hit")
			inst.Physics:Stop()
			
			CommonHandlers.UpdateHitRecoveryDelay(inst)
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
			TimeEvent(9 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/taunt") end),
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
			inst.SoundEmitter:PlaySound("polarsounds/motherflea/hit")
			inst.Physics:Stop()
			
			RemovePhysicsColliders(inst)
		end,
		
		timeline = {
			TimeEvent(3 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/squish", nil, 0.4) end),
			TimeEvent(12 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/squish", nil, 0.6) end),
			TimeEvent(23 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/squish", nil, 0.8) end),
			TimeEvent(33 * FRAMES, function(inst)
				if inst.components.lootdropper then
					inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
				end
				SpewBaby(inst)
				SpewBaby(inst)
				SpewBaby(inst)
				if math.random() < 0.5 then
					SpewBaby(inst)
				end
				inst.SoundEmitter:PlaySound("polarsounds/motherflea/pop")
			end),
			TimeEvent(26 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/snowflea/murder") end),
		},
	},
	
	State{
		name = "shake",
		tags = {"busy", "canrotate", "spawnfleas"},
		
		onenter = function(inst, data)
			inst.AnimState:PlayAnimation("shake")
			inst.Physics:Stop()
			
			local numshakes = data and data.numshakes or nil
			inst._wantstospawnfleas = nil
			inst.sg.statemem.numshakes = numshakes or 3
			inst.sg.statemem.started = data and data.start
		end,
		
		timeline = {
			TimeEvent(5 * FRAMES, function(inst)
				if not inst.sg.statemem.started then
					inst.SoundEmitter:PlaySound("polarsounds/motherflea/taunt")
				end
			end),
			TimeEvent(7 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("polarsounds/motherflea/squish")
				DoNearbyKnock(inst)
			end),
			TimeEvent(8 * FRAMES, function(inst)
				if not inst.sg.statemem.started then
					inst.SoundEmitter:PlaySound("polarsounds/motherflea/squish")
					SpewBaby(inst)
				end
			end),
			TimeEvent(14 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("polarsounds/motherflea/squish")
				DoNearbyKnock(inst)
			end),
			TimeEvent(15 * FRAMES, function(inst)
				if not inst.sg.statemem.started then
					inst.SoundEmitter:PlaySound("polarsounds/motherflea/squish")
					SpewBaby(inst)
				end
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				if inst.sg.statemem.numshakes and inst.sg.statemem.numshakes > 1 then
					inst.sg:GoToState("shake", {numshakes = inst.sg.statemem.numshakes - 1})
				else
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "emerge",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("unborrow")
			inst.Physics:Stop()
		end,
		
		timeline = {
			TimeEvent(2 * FRAMES, DoNearbyKnock),
			TimeEvent(12 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/snowflea/blblbl") end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "walk_start",
		tags = {"moving", "canrotate"},
		
		onenter = function(inst) 
			inst.AnimState:PlayAnimation("walk_pre")
			
			inst.components.locomotor:RunForward()
		end,
		
		timeline = {
			TimeEvent(3 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step") end),
		},
		
		events = {
			EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
		},
	 },
	 
	 State{
		name = "walk",
		tags = {"moving", "canrotate"},
		
		onenter = function(inst) 
			inst.AnimState:PlayAnimation("walk_loop")
			
			inst.components.locomotor:RunForward()
		end,
		
		timeline = {
			TimeEvent(5 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step") end),
			TimeEvent(9 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step", nil, 0.2) end),
			TimeEvent(15 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step") end),
			TimeEvent(19 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step", nil, 0.8) end),
			TimeEvent(25 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step") end),
			TimeEvent(31 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step", nil, 0.6) end),
			TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step") end),
			TimeEvent(40 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step", nil, 0.4) end),
		},
		
		onexit = function(inst)
			inst.SoundEmitter:KillSound("walk_LP")
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("walk")
			end),
		},
	},
	
	State{
		name = "walk_stop",
		tags = {"idle", "canrotate"},
		
		onenter = function(inst)
			inst.AnimState:PushAnimation("walk_pst")
			
			inst.components.locomotor:StopMoving()
		end,
		
		timeline = {
			TimeEvent(2 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("polarsounds/motherflea/step") end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
}

CommonStates.AddSleepStates(states)
CommonStates.AddFrozenStates(states)
CommonStates.AddElectrocuteStates(states)

return StateGraph("polarflea_mother", states, events, "idle", actionhandlers)