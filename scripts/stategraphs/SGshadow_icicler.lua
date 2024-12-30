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

local function FinishExtendedSound(inst, soundid)
	inst.SoundEmitter:KillSound("sound_"..tostring(soundid))
	inst.sg.mem.soundcache[soundid] = nil
	if inst.sg.statemem.readytoremove and next(inst.sg.mem.soundcache) == nil then
		inst:Remove()
	end
end

local function PlayExtendedSound(inst, soundname)
	if inst.sg.mem.soundcache == nil then
		inst.sg.mem.soundcache = {}
		inst.sg.mem.soundid = 0
	else
		inst.sg.mem.soundid = inst.sg.mem.soundid + 1
	end
	inst.sg.mem.soundcache[inst.sg.mem.soundid] = true
	inst.SoundEmitter:PlaySound(inst.sounds[soundname], "sound_"..tostring(inst.sg.mem.soundid))
	inst:DoTaskInTime(5, FinishExtendedSound, inst.sg.mem.soundid)
end

local function OnAnimOverRemoveAfterSounds(inst)
	if inst.sg.mem.soundcache == nil or next(inst.sg.mem.soundcache) == nil then
		inst:Remove()
	else
		inst:Hide()
		inst.sg.statemem.readytoremove = true
	end
end

local function TryDropTarget(inst)
	if inst.ShouldKeepTarget then
		local target = inst.components.combat.target
		if target and not inst:ShouldKeepTarget(target) then
			inst.components.combat:DropTarget()
			return true
		end
	end
end

local function TryDespawn(inst)
	if inst.sg.mem.forcedespawn or (inst.wantstodespawn and not inst.components.combat:HasTarget()) then
		inst.sg:GoToState("disappear")
		return true
	end
end

local states = {
	State{
		name = "idle",
		tags = {"idle", "canrotate"},
		
		onenter = function(inst)
			local dropped = TryDropTarget(inst)
			if TryDespawn(inst) then
				return
			elseif dropped then
				inst.sg:GoToState("taunt")
				return
			end
			
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
			PlayExtendedSound(inst, "attack_grunt")
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
			TimeEvent(11 * FRAMES, function(inst)
				PlayExtendedSound(inst, "attack")
				
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
				if math.random() < 0.333 then
					TryDropTarget(inst)
					inst.forceretarget = true
					
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
			PlayExtendedSound(inst, "taunt")
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
			PlayExtendedSound(inst, "death")
			inst.Physics:Stop()
			
			RemovePhysicsColliders(inst)
			inst.components.lootdropper:DropLoot(inst:GetPosition())
			
			inst.persists = false
			inst:AddTag("NOCLICK")
		end,
		
		onexit = function(inst)
			inst:RemoveTag("NOCLICK")
		end,
		
		events = {
			EventHandler("animover", OnAnimOverRemoveAfterSounds),
		},
	},
	
	State{
		name = "appear",
		tags = {"busy"},
		
		onenter = function(inst)
			TryDropTarget(inst)
			inst.AnimState:PlayAnimation("appear")
			PlayExtendedSound(inst, "appear")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "disappear",
		tags = {"busy", "noattack"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("disappear")
			PlayExtendedSound(inst, "disappear")
			inst.Physics:Stop()
			
			inst.persists = false
			inst:AddTag("NOCLICK")
		end,
		
		onexit = function(inst)
			inst:RemoveTag("NOCLICK")
		end,
		
		events = {
			EventHandler("animover", OnAnimOverRemoveAfterSounds),
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

CommonStates.AddWalkStates(states, {
	walktimeline = {
		TimeEvent(0, function(inst)
			local dropped = TryDropTarget(inst)
			if TryDespawn(inst) then
				return
			elseif dropped then
				inst.sg:GoToState("taunt")
			end
		end),
		TimeEvent(17 * FRAMES, function(inst)
			inst.Physics:Stop()
		end),
    }
})

return StateGraph("shadow_icicler", states, events, "appear", actionhandlers)