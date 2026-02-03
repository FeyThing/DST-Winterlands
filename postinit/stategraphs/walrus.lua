local ENV = env
GLOBAL.setfenv(1, GLOBAL)

require("stategraphs/commonstates")
require("stategraphs/commonstates_polar")

local function PlayCreatureSound(inst, sound, creature)
	local creature = creature or inst.soundgroup or inst.prefab
	inst.SoundEmitter:PlaySound("dontstarve/creatures/"..creature.."/"..sound)
end

local ALLY_TAGS = {"walrus", "hound"}
local ALLY_NOT_TAGS = {"isdead"}

local function DoWalrusBoost(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 12, nil, ALLY_NOT_TAGS, ALLY_TAGS)
	
	inst.sg.statemem.wasboosted = inst.sg.statemem.wasboosted or {}
	for i, v in ipairs(ents) do
		if v ~= inst and not v:HasTag("walrus_support") and not inst.sg.statemem.wasboosted[v] and inst.sg:HasStateTag("walrusboosting") then
			inst.sg.statemem.wasboosted[v] = true
			
			v:DoTaskInTime(math.random() * 0.5, function()
				v:AddDebuff("buff_walrusboost", "buff_walrusboost")
			end)
		end
	end
end

local events = {
	EventHandler("dowalrusboost", function(inst)
		if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("dowalrusboost")
		end
	end),
	EventHandler("walrusboosted", function(inst)
		if inst.components.health and not inst.components.health:IsDead() and not inst._walrusboost and not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("walrusboost")
		end
	end),
}

local states = {
	State{
		name = "dowalrusboost",
		tags = {"busy", "walrusboosting"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_happy", true)
			inst.SoundEmitter:PlaySound("polarsounds/walrus/bagpipes", "walrus_bagpipe")
			PlayCreatureSound(inst, "laugh")
			
			if inst.sg.statemem.bagpipetask == nil then
				inst.sg.statemem.bagpipetask = inst:DoPeriodicTask(1, DoWalrusBoost)
			end
			inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() * math.random(5, 8))
			inst._wantstoboost = nil
		end,
		
		timeline = {
			TimeEvent(FRAMES * 20, function(inst)
				inst.sg:RemoveStateTag("busy")
			end),
		},
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,
		
		onexit = function(inst)
			inst.SoundEmitter:KillSound("walrus_bagpipe")
			
			if inst.components.timer:TimerExists("walrusboosting_prep") then
				inst.components.timer:SetTimeLeft("walrusboosting_prep", TUNING.POLAR_WALRUSBOOST_COOLDOWN + math.random())
			else
				inst.components.timer:StartTimer("walrusboosting_prep", TUNING.POLAR_WALRUSBOOST_COOLDOWN + math.random())
			end
			if inst.sg.statemem.bagpipetask then
				inst.sg.statemem.bagpipetask:Cancel()
				inst.sg.statemem.bagpipetask = nil
			end
		end,
	},
	
	State{
		name = "walrusboost",
		tags = {"busy", "noattack"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("walrusboost")
			PlayCreatureSound(inst, "laugh")
			
			inst._walrusboost = true
		end,
		
		timeline = {
			TimeEvent(FRAMES * 13, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/clap")
			end),
			TimeEvent(FRAMES * 18, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/clap")
			end),
			TimeEvent(FRAMES * 21, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/clap")
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("taunt_newtarget")
			end)
		},
	},
	
	State{
		name = "blowdart_boosted",
		tags = {"attack"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk_dart")
			if inst.components.combat.target and inst.components.combat.target:IsValid() then
				inst:FacePoint(inst.components.combat.target:GetPosition())
			end
			inst.components.combat:StartAttack()
			inst:RemoveDebuff("buff_walrusboost")
		end,
		
		timeline = {
			TimeEvent(17 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot") end),
			TimeEvent(20 * FRAMES, function(inst) inst.components.combat:DoAttack() end),
			TimeEvent(23 * FRAMES, function(inst)
				inst.AnimState:PlayAnimation("atk_dart")
				inst.AnimState:SetFrame(inst.AnimState:GetCurrentAnimationNumFrames() * 0.4)
			end),
			TimeEvent(26 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot") end),
			TimeEvent(29 * FRAMES, function(inst) inst.components.combat:DoAttack() end),
			TimeEvent(32 * FRAMES, function(inst)
				inst.AnimState:PlayAnimation("atk_dart")
				inst.AnimState:SetFrame(inst.AnimState:GetCurrentAnimationNumFrames() * 0.4)
			end),
			TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot") end),
			TimeEvent(39 * FRAMES, function(inst) inst.components.combat:DoAttack() end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		},
	},
}

CommonStates.AddSimpleActionState(states, "deploy_beartrap", "pig_pickup", 6 * FRAMES, {"busy"})

ENV.AddStategraphPostInit("walrus", function(sg)
	CommonStates.AddWalrusBeartrapHandlers(states, events, {
		anims = {trapped_playanim = "hit", trapped_pushanim = "idle_scared"},
	})
	
	for _, event in pairs(events) do
		sg.events[event.name] = event
	end
	
	for _, state in pairs(states) do
		sg.states[state.name] = state
	end
	
	--	actions
	
	local olddeploy = sg.actionhandlers[ACTIONS.DEPLOY] and sg.actionhandlers[ACTIONS.DEPLOY].deststate
	sg.actionhandlers[ACTIONS.DEPLOY] = ActionHandler(ACTIONS.DEPLOY, function(inst, action, ...)
		if action.invobject and action.invobject:HasTag("walrus_beartrap") then
			return "deploy_beartrap"
		end
		
		if olddeploy then
			return olddeploy(inst, action, ...)
		end
	end)
	
	--	events
	
	local oldattack = sg.events["doattack"].fn
	sg.events["doattack"].fn = function(inst, ...)
		if inst.prefab == "girl_walrus" then
			if not (inst.sg:HasStateTag("electrocute") or inst.components.health and inst.components.health:IsDead()) then
				inst.sg:GoToState("attack")
			end
		elseif oldattack then
			oldattack(inst, ...)
		end
	end
	
	--	states
	
	local oldblowdart = sg.states["blowdart"].onenter
	sg.states["blowdart"].onenter = function(inst, ...)
		if inst._walrusboost then
			inst.sg:GoToState("blowdart_boosted")
			return
		end
		
		oldblowdart(inst, ...)
	end
	
	local oldtaunt_attack = sg.states["taunt_attack"].onenter
	sg.states["taunt_attack"].onenter = function(inst, ...)
		oldtaunt_attack(inst, ...) -- Why ? Walrus bank uses the wrong head side when playing 'abandon' anim upward and this is VERY noticeable here (also with arms)
		if inst.prefab == "girl_walrus" then
			inst.AnimState:PlayAnimation("idle_angry")
		end
	end
	
	local oldtaunt_newtarget = sg.states["taunt_newtarget"].onenter
	sg.states["taunt_newtarget"].onenter = function(inst, ...)
		oldtaunt_newtarget(inst, ...)
		if inst.prefab == "girl_walrus" then
			inst.AnimState:PlayAnimation("idle_angry")
		end
	end
end)