local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddAction = ENV.AddAction
local AddComponentAction = ENV.AddComponentAction
local AddStategraphActionHandler = ENV.AddStategraphActionHandler

local function PolarAction(name, act)
	local action = Action(act)
	action.id = name
	action.str = STRINGS.ACTIONS[name]
	AddAction(action)
	
	return action
end

--	New Actions

local POLARPLOW = PolarAction("POLARPLOW", {distance = 4, priority = 1})
	POLARPLOW.fn = function(act)
		local shovel = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local act_pos = act:GetActionPoint()
		
		if shovel and shovel.components.polarplower then
			if shovel.components.polarplower:CanPlow(act.doer, act_pos) then
				return shovel.components.polarplower:DoPlow(act.doer, act_pos)
			end
			
			return false
		end
	end
	
local POLARAMULET_CRAFT = PolarAction("POLARAMULET_CRAFT", {mount_valid = true, priority = 1})
	POLARAMULET_CRAFT.fn = function(act)
		if act.target and act.target.MakeAmulet then
			return act.target:MakeAmulet(act.doer)
		end
	end
	
local WALRUS_BEARTRAP_REMOVE = PolarAction("WALRUS_BEARTRAP_REMOVE", {priority = 3})
	WALRUS_BEARTRAP_REMOVE.fn = function(act)
		local trap = act.target and act.target._walrus_beartrap
		
		if trap and trap:IsValid() and trap.DoTrapStruggle then
			trap:DoTrapStruggle(act.target, act.doer ~= act.target)
		end
		
		return true
	end
	
	WALRUS_BEARTRAP_REMOVE.strfn = function(act)
		local guid = act.target and act.target.GUID
		return guid and guid ~= ThePlayer.GUID and "HELP_OTHER" or nil
	end
	
local STICK_ARCTIC_FISH = PolarAction("STICK_ARCTIC_FISH", {priority = 4})
	STICK_ARCTIC_FISH.fn = function(act)
		if act.invobject and act.invobject.components.arcticfoolfish then
			if act.invobject.components.arcticfoolfish:CanStickOnBack(act.target, act.doer) then
				act.invobject.components.arcticfoolfish:StickOnBack(act.target, act.doer)
				
				return true
			end
			
			return false
		end
	end
	
	STICK_ARCTIC_FISH.strfn = function(act)
		local guid = act.target and act.target.GUID
		
		if guid then
			local num_vars = 0
			for k, v in pairs(STRINGS.ACTIONS.STICK_ARCTIC_FISH) do
				num_vars = num_vars + 1
			end
			
			local var = (guid % num_vars) + 1
			
			return var > 1 and "VAR"..var or nil
		end
	end
	
--	Patches
	
local CASTSPELLSTR = ACTIONS.CASTSPELL.strfn
	ACTIONS.CASTSPELL.strfn = function(act, ...)
		if act.invobject and act.invobject:HasTag("wintersfists") and act.target == act.doer then
			return "WINTERS_FISTS"
		end
		
		if CASTSPELLSTR then
			return CASTSPELLSTR(act, ...)
		end
	end
	
local HAUNTFN = ACTIONS.HAUNT.fn -- Ghosts can plow High Snow
	ACTIONS.HAUNT.fn = function(act, ...)
		local plow_pos = act:GetActionPoint() or act.doer:GetPosition()
		local plowed = false
		
		if plow_pos then
			local duration = GetPolarPlowDuration(act.doer, nil, "haunt")
			SpawnPolarSnowBlocker(plow_pos, TUNING.SNOW_PLOW_RANGES.GHOST_HAUNT, duration, act.doer)
			
			local fx = SpawnPrefab("polar_splash_large")
			fx.Transform:SetPosition(plow_pos.x, plow_pos.y, plow_pos.z)
			
			if act.doer and act.doer.SoundEmitter then
				act.doer.SoundEmitter:PlaySound("polarsounds/common/snow_plow")
			end
			
			plowed = true
		end
		
		return HAUNTFN(act, ...) or plowed
	end
	
local HAUNTSTR_OVERRIDE = ACTIONS.HAUNT.stroverridefn
	ACTIONS.HAUNT.stroverridefn = function(act, ...)
		local act_pos = act:GetActionPoint()
		if act_pos and TheWorld.Map:IsPolarSnowAtPoint(act_pos.x, act_pos.y, act_pos.z, true) then
			return STRINGS.ACTIONS.POLARPLOW_GHOST
		end
		
		if HAUNTSTR_OVERRIDE then
			return HAUNTSTR_OVERRIDE(act, ...)
		end
	end
	
local MURDERFN = ACTIONS.MURDER.fn -- NOTE: Wack, but vanilla has nothing that tells an entity directly that it got murdered... needed for snowfleas biting from any inv/container
	ACTIONS.MURDER.fn = function(act, ...)
		local murdered = act.invobject or act.target
		if murdered and (murdered.components.health or murdered.components.murderable) and murdered:HasTag("flea") then
			murdered:PushEvent("fleabiteback", {doer = act.doer}) -- We need this to happen before being removed from our owner
		end
		
		return MURDERFN(act, ...)
	end
	
local TURNONSTR_OVERRIDE = ACTIONS.TURNON.stroverridefn
	ACTIONS.TURNON.stroverridefn = function(act, ...)
		local target = act.invobject or act.target
		if target and target:HasTag("snowglobe") then
			return STRINGS.ACTIONS.SNOWGLOBE
		end
		
		if TURNONSTR_OVERRIDE then
			return TURNONSTR_OVERRIDE(act, ...)
		end
	end
	
local BAITFN = ACTIONS.BAIT.fn -- "Mines" can't be baited, only traps, our beartraps are a... mine, but we want to use bait action for disarming
	ACTIONS.BAIT.fn = function(act, ...)
		if act.invobject and act.target and act.target:HasTag("walrus_beartrap") and act.doer.components.inventory then
			local bait = act.doer.components.inventory:RemoveItem(act.invobject)
			
			if bait then
				bait.Transform:SetPosition(act.target.Transform:GetWorldPosition())
				if act.target.components.mine then
					act.target.components.mine:Explode(act.invobject)
				end
				
				return true
			end
		end
		
		return BAITFN(act, ...)
	end
	
local DEPLOYDIST = ACTIONS.DEPLOY.extra_arrive_dist -- Allows to place beartraps from a little bit further away
	ACTIONS.DEPLOY.extra_arrive_dist = function(doer, dest, bufferedaction, ...)
		local dist = DEPLOYDIST(doer, dest, bufferedaction, ...) or 0
		local invobject = bufferedaction and bufferedaction.invobject or nil
		if invobject and invobject:HasTag("walrus_beartrap") then
			dist = dist + 0.8
		end
		
		return dist
	end
	
--	Components, SGs

AddComponentAction("POINT", "polarplower", function(inst, doer, pos, actions, right)
	if right then
		local x, y, z = pos:Get()
		if TheWorld.Map:IsPolarSnowAtPoint(x, y, z, true) then
			table.insert(actions, ACTIONS.POLARPLOW)
		end
	end
end)

AddComponentAction("USEITEM", "arcticfoolfish", function(inst, doer, target, actions)
	if inst.components.arcticfoolfish and inst.components.arcticfoolfish:CanStickOnBack(target) then
		table.insert(actions, ACTIONS.STICK_ARCTIC_FISH)
	end
end)

--	Patches

local COMPONENT_ACTIONS = PolarUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")

local oldcombat = COMPONENT_ACTIONS.SCENE.combat
	COMPONENT_ACTIONS.SCENE.combat = function(inst, doer, actions, right, ...)
		if right and inst:HasTag("walrus_beartrapped_auto") and inst ~= doer then
			table.insert(actions, ACTIONS.WALRUS_BEARTRAP_REMOVE)
		end
		if oldcombat then
			oldcombat(inst, doer, actions, right, ...)
		end
	end
	
local oldcontainer = COMPONENT_ACTIONS.SCENE.container -- Needed for controller support
	COMPONENT_ACTIONS.SCENE.container = function(inst, doer, actions, right, ...)
		if right and inst:HasTag("snowshack") and inst.replica.container and inst.replica.container:IsFull() then
			table.insert(actions, ACTIONS.POLARAMULET_CRAFT)
		elseif oldcontainer then
			oldcontainer(inst, doer, actions, right, ...)
		end
	end
	
local oldmachine = COMPONENT_ACTIONS.INVENTORY.machine -- For unused snowglobe item
	COMPONENT_ACTIONS.INVENTORY.machine = function(inst, doer, actions, right, ...)
		if inst:HasTag("snowglobe") and not inst:HasTag("cooldown") and not inst:HasTag("fueldepleted") and inst:HasTag("enabled") then
			table.insert(actions, inst:HasTag("turnedon") and ACTIONS.TURNOFF or ACTIONS.TURNON)
		elseif oldmachine then
			oldmachine(inst, doer, actions, right, ...)
		end
	end
	
local oldrepairer = COMPONENT_ACTIONS.USEITEM.repairer -- Dryice can repair normal ice repairable, other way around won't work tho
	COMPONENT_ACTIONS.USEITEM.repairer = function(inst, doer, target, actions, ...)
		if target:HasTag("repairable_"..MATERIALS.ICE) and
			((inst:HasTag("work_"..MATERIALS.DRYICE) and target:HasTag("workrepairable"))
			or (inst:HasTag("health_"..MATERIALS.DRYICE) and target:HasTag("healthrepairable"))
			or (inst:HasTag("freshen_"..MATERIALS.DRYICE) and (target:HasTag("fresh") or target:HasTag("stale") or target:HasTag("spoiled")))
			or (inst:HasTag("finiteuses_"..MATERIALS.DRYICE) and target:HasTag("finiteusesrepairable"))) then
			
			table.insert(actions, ACTIONS.REPAIR)
		elseif oldrepairer then
			oldrepairer(inst, doer, target, actions, ...)
		end
	end
	
local oldprototyper = COMPONENT_ACTIONS.SCENE.prototyper -- Trading with Walruses should only show while buffed and out of battle
	COMPONENT_ACTIONS.SCENE.prototyper = function(inst, doer, actions, right, ...)
		if inst:HasTag("walrus") and not (doer.replica.combat and doer.replica.combat:IsAlly(inst)) then
			return
		end
		
		if oldprototyper then
			oldprototyper(inst, doer, actions, right, ...)
		end
	end
	
local function IsInSnow(owner, target)
	if owner == nil or (not owner:IsValid() or (owner.replica.rider and owner.replica.rider:IsRiding())) then
		return
	end
	
	local tile, tileinfo = owner:GetCurrentTileType()
	local in_snow = tile and (tile == WORLD_TILES.POLAR_SNOW or (tileinfo and not tileinfo.nogroundoverlays and TheWorld.state.snowlevel and TheWorld.state.snowlevel > 0.15))
	
	if in_snow or owner == target then
		return true
	end
	
	local inventory = owner.components.inventory or owner.replica.inventory
	
	return inventory and inventory:FindItem(function(item) return IsWintersFistsSnowball(item) end) ~= nil
end

local oldspellcaster = COMPONENT_ACTIONS.POINT.spellcaster -- Only throw snowballs while in snow
	COMPONENT_ACTIONS.POINT.spellcaster = function(inst, doer, pos, actions, right, target, ...)
		if inst:HasTag("castonpolarsnow") and doer and not IsInSnow(doer, target) then
			return
		end
		if oldspellcaster then
			oldspellcaster(inst, doer, pos, actions, right, target, ...)
		end
	end
	
local oldspellcaster_equipped = COMPONENT_ACTIONS.EQUIPPED.spellcaster
	COMPONENT_ACTIONS.EQUIPPED.spellcaster = function(inst, doer, target, actions, right, ...)
		if inst:HasTag("castonpolarsnow") and doer and not IsInSnow(doer, target) then
			return
		end
		if oldspellcaster_equipped then
			oldspellcaster_equipped(inst, doer, target, actions, right, ...)
		end
	end
	
local oldspellcaster_inventory = COMPONENT_ACTIONS.INVENTORY.spellcaster
	COMPONENT_ACTIONS.INVENTORY.spellcaster = function(inst, doer, actions, ...)
		if inst:HasTag("castonpolarsnow")  then
			return
		end
		if oldspellcaster_inventory then
			oldspellcaster_inventory(inst, doer, actions, ...)
		end
	end
	
local oldstorytellingprop = COMPONENT_ACTIONS.SCENE.storytellingprop -- To keep action order the same with Walter, can't use portable_campfire tag or it can't be used by others
	COMPONENT_ACTIONS.SCENE.storytellingprop = function(inst, doer, actions, right, ...)
		if inst:HasTag("portable_brazier") then
			if not right and inst:HasTag("storytellingprop") and doer:HasTag("storyteller") then
				table.insert(actions, ACTIONS.TELLSTORY)
			end
			
			return
		elseif oldstorytellingprop then
			oldstorytellingprop(inst, doer, actions, right, ...)
		end
	end
	
local oldportablestructure = COMPONENT_ACTIONS.SCENE.portablestructure -- Waltuh
	COMPONENT_ACTIONS.SCENE.portablestructure = function(inst, doer, actions, right, ...)
		if inst:HasTag("portable_brazier") then
			if right and (not inst.candismantle or inst.candismantle(inst)) then
				table.insert(actions, ACTIONS.DISMANTLE)
			end
			
			return
		elseif oldportablestructure then
			oldportablestructure(inst, doer, actions, right, ...)
		end
	end
	
local oldinventoryitem = COMPONENT_ACTIONS.USEITEM.inventoryitem
	COMPONENT_ACTIONS.USEITEM.inventoryitem = function(inst, doer, target, actions, ...)
		if target:HasTag("walrus_beartrap") and target:HasTag("canbait") then
			table.insert(actions, ACTIONS.BAIT)
		end
		if oldinventoryitem then
			oldinventoryitem(inst, doer, target, actions, ...)
		end
	end
	
--

local function AddToSGAC(action, state)
	ENV.AddStategraphActionHandler("wilson", ActionHandler(ACTIONS[action], state))
	ENV.AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS[action], state))
end

local actionhandlers = {
	POLARPLOW = "dig_start",
	POLARAMULET_CRAFT = "give",
	STICK_ARCTIC_FISH = "give",
	WALRUS_BEARTRAP_REMOVE = "dolongaction",
}

for action, state in pairs(actionhandlers) do
	AddToSGAC(action, state)
end