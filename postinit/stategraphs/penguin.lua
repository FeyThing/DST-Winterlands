local ENV = env
GLOBAL.setfenv(1, GLOBAL)

require("stategraphs/commonstates")

local function IsProperEmperor(inst)
	return TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.emperor == inst
end

local HOSTILE_TAGS = {"hostile", "monster"} -- Non-hostile-players snowball targets
local HOSTILE_NOT_TAGS = {"INLIMBO", "isdead", "player", "penguin_emperor"}

local PENGUIN_GUARDS_TAGS = {"penguin_guard"}
local PENGUIN_GUARDS_NOT_TAGS = {"isdead"}

local COLLISION_RADIUS = 1.2
local BOUNCE_ANGLE_VARIANCE = 20

local BOUNCE_OFF_TAGS = {"wall", "polarcastletower", "structure", "_inventoryitem", "_combat"}
local BOUNCE_OFF_NOT_TAGS = {"INLIMBO", "isdead"}

local BOUNCE_STRUCTURE_RETRY_TIME = 0.25
local BOUNCE_TARGET_RETRY_TIME = 0.1

local function SpinGetAngle(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local cpt = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.ice_castle_pos or inst:GetPosition()
	
    local dx = cpt.x - x
    local dz = cpt.z - z
	
    local angle = math.atan2(-dz, dx) * RADIANS
    angle = angle + math.random(-BOUNCE_ANGLE_VARIANCE, BOUNCE_ANGLE_VARIANCE)
	
    return angle % 360
end

local function SpinOnUpdate(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local rot = inst.Transform:GetRotation()
	
	local ents = TheSim:FindEntities(
		x + math.cos(rot * DEGREES) * COLLISION_RADIUS,
		y,
		z + -math.sin(rot * DEGREES) * COLLISION_RADIUS,
		1.2, nil, BOUNCE_OFF_NOT_TAGS, BOUNCE_OFF_TAGS)
		
	if #ents > 0 then
		local t = GetTime()
		local target = ents[1]
		local collide_retry_time = target:HasTag("locomotor") and BOUNCE_TARGET_RETRY_TIME or BOUNCE_STRUCTURE_RETRY_TIME
		
		if target ~= inst and (inst._collided_times[target] == nil or t - inst._collided_times[target] > collide_retry_time) then
			local bounce = false
			
			if target.components.inventoryitem and not target.components.health then
				if target.components.heavyobstaclephysics then
					bounce = true
					target.components.heavyobstaclephysics:ForceDropPhysics()
					inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
				end
				target.components.inventoryitem:DoDropPhysics(x, y, z, true)
			end
			
			if target.components.workable then
				bounce = true
				target.components.workable:WorkedBy(inst, target:HasTag("icecastlepart") and 0 or 1)
			end
			
			if target.components.combat and target.components.health and not target.components.health:IsDead() and
				not target:HasTag("wall") and (not target:HasTag("penguin") or target:HasTag("player")) then
				
				local dmg = inst.components.combat:CalcDamage(target, nil, TUNING.EMPEROR_PENGUIN_DAMAGE_SPINMOD)
				target.components.combat:GetAttacked(inst, dmg)
			end
			
			if bounce then
				inst.Transform:SetRotation(SpinGetAngle(inst))
			end
			
			inst._collided_times[target] = t
		end
	end
end

local function GetSummonGuardNums(inst)
	local health_percent = inst.components.health and inst.components.health:GetPercent() or 1
	local health_phase = 0
	
	for i = 1, #TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT do
		if health_percent <= TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[i] then
			health_phase = health_phase + 1
		end
	end
	
	return TUNING.EMPEROR_PENGUIN_SUMMONS_NUM[health_phase]
end

local events = {
	CommonHandlers.OnSink(), -- Useful for Emperor only (TODO: seems c_spawned emperor can get stuck sinking over and over when escaping)
	CommonHandlers.OnFallInVoid(),
	
	--[[EventHandler("emperor_entertower", function(inst)
		if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("emperor_entertower")
		end
	end),]]
	EventHandler("emperor_spin", function(inst)
		if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("emperor_spin")
		end
	end),
	EventHandler("guard_panting", function(inst)
		if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("guard_panting")
		end
	end),
	EventHandler("ploof", function(inst, data)
		if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			if data and data.pt then
				inst.sg:GoToState("ploof", data.pt)
			end
		end
	end),
}

local function DoPloof(inst)
	if not inst:IsValid() then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	if not TheWorld.Map:IsLandTileAtPoint(x, 0, z) then
		if inst:HasTag("penguin_emperor") and inst.components.lootdropper then
			inst.components.lootdropper:SpawnLootPrefab("emperor_penguinhat")
		end
		
		SpawnPrefab("splash_sink").Transform:SetPosition(x, y, z)
		inst:Remove()
	else
		inst.Physics:ClearCollisionMask()
		inst.Physics:SetCollisionMask(
			COLLISION.WORLD,
			COLLISION.OBSTACLES,
			COLLISION.SMALLOBSTACLES,
			COLLISION.CHARACTERS,
			COLLISION.GIANTS
		)
		
		return true
	end
end

local states = { -- PRO TIP: KillAllSounds on any new state, slide loop tends to not stop playing :/
	State{
		name = "ploof",
		tags = {"busy", "nointerrupt", "temp_invincible"},
		
		onenter = function(inst, pt)
			if inst._extraegg and inst.DoExtraEgg then
				inst:DoExtraEgg()
			end
			
			inst.AnimState:PlayAnimation("slide_bounce")
			inst.SoundEmitter:KillAllSounds()
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
		end,
		
		onexit = function(inst)
			DoPloof(inst)
		end,
		
		events = {
			EventHandler("animover", function(inst)
				local landed = DoPloof(inst)
				
				if landed then
					inst.sg:GoToState("run_stop")
				end
			end)
		},
	},
	
	State{
		name = "guard_panting",
		tags = {"busy", "caninterrupt", "canrotate", "panting"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("pant_pre")
			inst.AnimState:PushAnimation("pant_loop")
			inst.SoundEmitter:KillAllSounds()
			inst.Physics:Stop()
			inst.sg:SetTimeout(FRAMES * 16 + (FRAMES * 34 * math.random(4, 6)))
		end,
		
		ontimeout = function(inst)
			inst.AnimState:PlayAnimation("pant_pst")
		end,
		
		onexit = function(inst)
			inst.recovering_stamina = nil
		end,
		
		events = {
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("pant_pst") then
					inst.sg:GoToState("idle")
				end
			end)
		},
	},
	
	--	Emperor
	State{
		name = "emperor_entertower",
		tags = {"busy", "nointerrupt", "noattack", "towered"},
		
		onenter = function(inst, doexit)
			inst.Physics:Stop()
			inst.SoundEmitter:KillAllSounds()
			inst.SoundEmitter:PlaySound(inst._soundpath.."idle")
			
			if doexit then
				inst.AnimState:PlayAnimation("tower_pst")
			else
				inst.AnimState:PlayAnimation("slide_bounce")
				inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
			end
			
			inst.entity:SetCanSleep(false)
			inst.sg.statemem.exiting_tower = doexit
		end,
		
		timeline = {
			TimeEvent(10 * FRAMES, function(inst)
				if inst.DynamicShadow then
					inst.DynamicShadow:Enable(false)
				end
				
				inst:Hide()
				if inst._juggle_tower then
					inst.Physics:SetActive(false)
					
					if inst.sg.statemem.exiting_tower then
						if inst._juggle_tower.tower_emperor then
							inst._juggle_tower.tower_emperor:set(nil)
						end
						if inst.emperor_tower then
							inst.emperor_tower:set(nil)
						end
						if inst._juggle_tower.components.locomotor then
							inst._juggle_tower:RemoveComponent("locomotor")
						end
						
						if TheWorld.ismastersim then
							if inst._juggle_tower.components.highlightchild then
								inst._juggle_tower.components.highlightchild:SetOwner(nil)
							end
							if inst.components.highlightchild then
								inst.components.highlightchild:SetOwner(nil)
							end
						end
						
						inst.entity:SetParent(nil)
						if inst.Follower then
							inst.Follower:StopFollowing()
						end
						
						if inst._tower_exit_pos then
							inst.Transform:SetPosition(inst._tower_exit_pos:Get())
							inst._tower_exit_pos = nil
						end
					else
						-- Highlight and locomotor is to help aiming at emperor using Telestaff
						if inst._juggle_tower.tower_emperor then
							inst._juggle_tower.tower_emperor:set(inst)
						end
						if inst.emperor_tower then
							inst.emperor_tower:set(inst._juggle_tower)
						end
						if inst._juggle_tower.components.locomotor == nil then
							inst._juggle_tower:AddComponent("locomotor")
						end
						
						if TheWorld.ismastersim then
							if inst._juggle_tower.components.highlightchild then
								inst._juggle_tower.components.highlightchild:SetOwner(inst)
							end
							if inst.components.highlightchild then
								inst.components.highlightchild:SetOwner(inst._juggle_tower)
							end
						end
						--
						inst._tower_exit_pos = inst:GetPosition()
						
						inst.entity:SetParent(inst._juggle_tower.entity)
						inst.entity:AddFollower()
						inst.Follower:FollowSymbol(inst._juggle_tower.GUID, "flagpole", 0, 15, 0, nil, true) -- If needs ownsrotation, then use tower position to get facing angle
					end
				end
			end),
			TimeEvent(20 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")
			end),
			TimeEvent(45 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
				inst.AnimState:PlayAnimation("tower_pre")
				inst.AnimState:PushAnimation("idle_loop")
				if inst.DynamicShadow then
					inst.DynamicShadow:Enable(true)
				end
				
				inst:Show()
			end),
			TimeEvent(60 * FRAMES, function(inst)
				inst.sg:GoToState("idle")
			end),
		},
		
		onexit = function(inst)
			inst:ClearBufferedAction()
			inst:Show()
			if inst.DynamicShadow then
				inst.DynamicShadow:Enable(true)
			end
			
			if inst.sg.statemem.exiting_tower then
				inst._juggle_tower = nil
				inst._tower_exit_pos = nil
				inst.wants_to_juggle = nil
				inst.Physics:SetActive(true)
			end
			
			inst.entity:SetCanSleep(true)
		end,
	},
	
	State{
		name = "emperor_juggle",
		tags = {"busy", "canrotate", "juggling", "nointerrupt", "noattack", "towered"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("juggle_pre")
			inst.AnimState:PushAnimation("juggle_loop")
			inst.SoundEmitter:KillAllSounds()
			inst.Physics:Stop()
			
			inst.sg.statemem.throw_index = 1
			inst.sg.statemem.next_throw_time = 0
		end,
		
		onupdate = function(inst)
			local time = inst.sg.timeinstate
			
			if inst._juggle_tower and (time < 40 * FRAMES or inst.wants_to_call_guards) then
				return
			end
			
			local x, y, z = inst.Transform:GetWorldPosition()
			
			if time >= inst.sg.statemem.next_throw_time then
				local pattern = TUNING.EMPEROR_PENGUIN_SNOWBALL_TYPE_THROWS
				local index = inst.sg.statemem.throw_index
				local size = pattern[index]
				
				index = index + 1
				if index > #pattern then
					index = 1
				end
				inst.sg.statemem.throw_index = index
				
				local targets = {}
				if inst.attackerUSERIDs then
					for userid, _ in pairs(inst.attackerUSERIDs) do
						local player = UserToPlayer(userid)
						if player and player:IsValid() and not player:HasTag("playerghost") and player.entity:IsVisible()
							and inst:IsNear(player, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE) then
							
							table.insert(targets, player)
						end
					end
				end
				
				local ents = TheSim:FindEntities(x, y, z, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE, nil, HOSTILE_NOT_TAGS, HOSTILE_TAGS)
				for i, enemy in ipairs(ents) do
					if not (enemy:HasTag("penguin") and not enemy:HasTag("player")) and enemy.components.combat then
						table.insert(targets, enemy)
					end
				end
				
				if #targets > 0 then
					local target = targets[math.random(#targets)]
					local snowball = SpawnPrefab("winters_fists_snowball")
					
					if snowball then
						snowball.Transform:SetPosition(x, y + 1.5, z)
						
						if snowball.SetSize then
							snowball:SetSize(size)
						end
						if snowball.ThrowAt then
							snowball:ThrowAt(target:GetPosition(), inst)
						elseif snowball.components.complexprojectile then
							snowball.components.complexprojectile:SetLaunchOffset(Vector3(0, 1.5, 0))
							snowball.components.complexprojectile:Launch(target:GetPosition(), inst)
						end
					end
				end
				
				inst.sg.statemem.next_throw_time = time + TUNING.EMPEROR_PENGUIN_SNOWBALL_SPAWNPERIOD
			end
			
			--
			
			local guards = TheSim:FindEntities(x, 0, z, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE * 1.5, PENGUIN_GUARDS_TAGS, PENGUIN_GUARDS_NOT_TAGS)
			inst.sg.statemem.guards_min = GetSummonGuardNums(inst)
			
			if #guards <= inst.sg.statemem.guards_min * (1 - TUNING.EMPEROR_PENGUIN_SUMMONS_KILL_PERCENT) then
				inst.wants_to_juggle = nil
				inst.sg:GoToState("emperor_stopjuggle")
			end
		end,
	},
	
	State{
		name = "emperor_stopjuggle",
		tags = {"busy", "canrotate", "nointerrupt", "towered"},
		
		onenter = function(inst, leftcastle)
			inst.AnimState:PlayAnimation("juggle_pst")
			inst.SoundEmitter:PlaySound(inst._soundpath.."taunt")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("emperor_entertower", true)
			end)
		},
	},
	
	State{
		name = "emperor_spin",
		tags = {"busy", "canrotate", "nointerrupt"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("emperor_spin_pre")
			inst.AnimState:PushAnimation("emperor_spin_loop", false)
			inst.AnimState:PushAnimation("emperor_spin_fast_loop")
			inst.SoundEmitter:KillAllSounds()
			inst.Physics:Stop()
			
			inst.Physics:ClearCollisionMask()
			inst.Physics:SetCollisionMask(
				COLLISION.WORLD,
				COLLISION.OBSTACLES
			)
			
			inst.sg.statemem.last_spin_waw = GetTime()
			
			inst._collided_times = {}
			if inst.components.timer and not inst.components.timer:TimerExists("keepspinning") then
				inst.components.timer:StartTimer("keepspinning", TUNING.EMPEROR_PENGUIN_SPIN_DURATION)
			end
		end,
		
		onupdate = function(inst)
			local incastle = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(inst)
			
			local t = GetTime()
			local last_spin_waw = inst.sg.statemem.last_spin_waw or t
			if t > last_spin_waw + 0.33 then
				inst.SoundEmitter:PlaySound(inst._soundpath.."taunt")
				inst.sg.statemem.last_spin_waw = t
			end
			
			if not inst.wants_to_spin or not incastle then
				inst.Physics:SetMotorVelOverride(0, 0, 0)
				
				inst.wants_to_spin = nil
				inst.sg:GoToState("emperor_stopspin", not incastle)
			elseif inst.sg.statemem.spinning then
				if inst.components.locomotor then
					local i = inst.AnimState:IsCurrentAnimation("emperor_spin_fast_loop") and 2 or 1
					--inst.components.locomotor:SetExternalSpeedMultiplier(inst, "spin", TUNING.EMPEROR_PENGUIN_SPIN_SPEEDMULT[i])
					--inst.components.locomotor:RunForward(true)
					
					inst.Physics:SetMotorVelOverride(8.5 * TUNING.EMPEROR_PENGUIN_SPIN_SPEEDMULT[i], 0, 0)
				end
				
				SpinOnUpdate(inst)
			end
		end,
		
		timeline = {
			TimeEvent(24 * FRAMES, function(inst)
				inst.sg:AddStateTag("noattack")
				inst.sg:AddStateTag("running")
				
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin", "spinLoop")
				
				inst.sg.statemem.spinning = true
			end),
		},
		
		onexit = function(inst)
			inst.Physics:ClearCollisionMask()
			inst.Physics:SetCollisionMask(
				COLLISION.WORLD,
				COLLISION.OBSTACLES,
				COLLISION.CHARACTERS,
				COLLISION.GIANTS
			)
			
			inst._collided_times = {}
		end,
	},
	
	State{
		name = "emperor_stopspin",
		tags = {"busy", "canrotate", "nointerrupt", "running"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("emperor_panic", true)
			inst.SoundEmitter:KillSound("spinLoop")
			inst.SoundEmitter:PlaySound("dontstarve/movement/iceslab_slipping")
			inst.Physics:SetMotorVelOverride(5, 0, 0)
			
			if inst.components.locomotor then
				inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "spin")
			end
			if inst.components.timer then
				if inst.components.timer:TimerExists("spincooldown") then
					inst.components.timer:StopTimer("spincooldown")
				end
				inst.components.timer:StartTimer("spincooldown", TUNING.EMPEROR_PENGUIN_SPIN_COOLDOWN)
			end
			
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() * 2)
		end,
		
		ontimeout = function(inst)
			inst.Physics:Stop()
			inst.sg:GoToState("idle")
		end,
	},
	
	State{
		name = "summon_guards",
		tags = {"busy", "canrotate"},
		
		onenter = function(inst, skip_anim, num_override)
			inst.sg.statemem.skip_anim = skip_anim
			inst.sg.statemem.num_guards = num_override
			
			if not skip_anim then
				inst.AnimState:OverrideSymbol("swap_object", "gnarwail_horn", "swap_gnarwailhorn")
				inst.AnimState:PlayAnimation("call_guards")
				inst.SoundEmitter:KillAllSounds()
				--TODO inst.SoundEmitter:PlaySound(pocket rummage sound)
				inst.Physics:Stop()
			end
			
			inst.sg.statemem.num_guards = num_override
		end,
		
		onupdate = function(inst)
			if TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated and TheWorld.components.emperorpenguinspawner.emperor == inst then
				inst.sg.statemem.num_guards = 0
				inst.sg:GoToState("idle")
			end
		end,
		
		onexit = function(inst)
			inst.AnimState:ClearOverrideSymbol("swap_object")
			if TheWorld.components.emperorpenguinspawner then
				local x, y, z = inst.Transform:GetWorldPosition()
				local num_guards = #TheSim:FindEntities(x, y, z, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE * 1.5, PENGUIN_GUARDS_TAGS, PENGUIN_GUARDS_NOT_TAGS)
				
				TheWorld.components.emperorpenguinspawner:SpawnGuards(inst.sg.statemem.num_guards or (GetSummonGuardNums(inst) - num_guards))
			end
			
			inst.wants_to_call_guards = nil
		end,
		
		timeline = {
			TimeEvent(2 * FRAMES, function(inst)
				if not inst.sg.statemem.skip_anim then
					inst.SoundEmitter:PlaySound(inst._soundpath.."taunt")
				end
			end),
			TimeEvent(40 * FRAMES, function(inst)
				if not inst.sg.statemem.skip_anim then
					inst.SoundEmitter:PlaySound("hookline/creatures/gnarwail/horn")
				end
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		},
	},
	
	State{
		name = "emperor_panic_walk",
		tags = {"moving", "canrotate"},
		
		onenter = function(inst)
			inst.SoundEmitter:KillSound("slide")
			inst.AnimState:PlayAnimation("emperor_panic")
			inst.components.locomotor:WalkForward()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("emperor_panic_walk")
			end),
		},
	},
	
	--	Guards
	
	State{
		name = "exittower_guard",
		tags = {"busy", "hidden", "invisible", "noattack"},
		
		onenter = function(inst)
			inst:Hide()
			if inst.DynamicShadow then
				inst.DynamicShadow:Enable(false)
			end
			
			inst.sg:SetTimeout(math.random() * 2)
		end,
		
		onexit = function(inst)
			inst:Show()
			if inst.DynamicShadow then
				inst.DynamicShadow:Enable(true)
			end
			
			inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("run_stop")
		end,
	},
}

CommonStates.AddSinkAndWashAshoreStates(states)
CommonStates.AddVoidFallStates(states)

ENV.AddStategraphPostInit("penguin", function(sg)
	for _, event in pairs(events) do
		sg.events[event.name] = event
	end
	
	for _, state in pairs(states) do
		sg.states[state.name] = state
	end
	
	--	Emperor go in tower
	
	local oldgohome = sg.actionhandlers[ACTIONS.GOHOME] and sg.actionhandlers[ACTIONS.GOHOME].deststate
	sg.actionhandlers[ACTIONS.GOHOME] = ActionHandler(ACTIONS.GOHOME, function(inst, action, ...)
		if action.target and action.target:HasTag("polarcastletower") then
			return "emperor_entertower"
		end
		
		if oldgohome then
			return oldgohome(inst, action, ...)
		end
	end)
	
	--	Emperor & guards can't be stunlocked
	
	local oldattacked_event = sg.events["attacked"].fn
	sg.events["attacked"].fn = function(inst, ...)
		if (inst:HasTag("penguin_emperor") or inst:HasTag("penguin_guard")) and inst.sg:HasAnyStateTag("attack", "moving") then
			return
		elseif oldattacked_event then
			return oldattacked_event(inst, ...)
		end
	end
	
	-- Guards take breaks from chases
	
	local oldlocomote_event = sg.events["locomote"].fn
	sg.events["locomote"].fn = function(inst, ...)
		if inst.recovering_stamina or inst.entity:GetParent() then
			return
		elseif oldlocomote_event then
			return oldlocomote_event(inst, ...)
		end
	end
	
	--	Fix spawning-in shadow, remove non polar penguin on spawn in the Winterlands !
	
	local oldappear_enter = sg.states["appear"].onenter
	sg.states["appear"].onenter = function(inst, ...)
		local x, y, z = inst.Transform:GetWorldPosition()
		if inst.prefab == "penguin" and GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil then
			inst:Remove()
			return
		end
		
		if inst.DynamicShadow then
			inst.DynamicShadow:Enable(false)
		end
		
		oldappear_enter(inst, ...)
	end
	
	local oldappear_exit = sg.states["appear"].onexit
	sg.states["appear"].onexit = function(inst, ...)
		if inst.DynamicShadow then
			inst.DynamicShadow:Enable(true)
		end
		
		if oldappear_exit then
			oldappear_exit(inst, ...)
		end
	end
	
	--	Guards stuff
	
	local death_timeline = sg.states["death"].timeline or {}
	table.insert(death_timeline, TimeEvent(8 * FRAMES, function(inst)
		if inst:HasTag("penguin_guard") then
			inst.SoundEmitter:PlaySound("polarsounds/emperor_guard/death_metal")
		end
	end))
end)