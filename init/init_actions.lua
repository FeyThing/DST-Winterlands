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

--	Actions

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
	
local TURNONSTR = ACTIONS.TURNON.stroverridefn
	ACTIONS.TURNON.stroverridefn = function(act, ...)
		local target = act.invobject or act.target
		if target and target:HasTag("snowglobe") then
			return STRINGS.ACTIONS.SNOWGLOBE
		end
		
		if TURNONSTR then
			return TURNONSTR(act, ...)
		end
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

--

local COMPONENT_ACTIONS = PolarUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")

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
		if inst:HasTag("freshen_"..MATERIALS.DRYICE) and target:HasTag("repairable_"..MATERIALS.ICE) then
			table.insert(actions, ACTIONS.REPAIR)
		elseif oldrepairer then
			oldrepairer(inst, doer, target, actions, ...)
		end
	end
	
local oldstorytellingprop = COMPONENT_ACTIONS.SCENE.storytellingprop -- To keep action order the same with Walter, can't use portable_campfire tag or it can't be used by others
	COMPONENT_ACTIONS.SCENE.storytellingprop = function(inst, doer, actions, right, ...)
		local wantsleft = inst:HasTag("portable_brazier") and doer:HasTag("portable_campfire_user")
		if inst:HasTag("storytellingprop") and doer:HasTag("storyteller") and wantsleft then
			if not right then
				table.insert(actions, ACTIONS.TELLSTORY)
			end
		elseif oldstorytellingprop then
			oldstorytellingprop(inst, doer, actions, right, ...)
		end
	end
	
local oldportablestructure = COMPONENT_ACTIONS.SCENE.portablestructure -- Waltuh
	COMPONENT_ACTIONS.SCENE.portablestructure = function(inst, doer, actions, right, ...)
		if right and inst:HasTag("campfire") and inst:HasTag("portable_brazier") and doer:HasTag("portable_campfire_user")
			and (not inst.candismantle or inst.candismantle(inst)) then
			
			table.insert(actions, ACTIONS.DISMANTLE)
			return
		elseif oldportablestructure then
			oldportablestructure(inst, doer, actions, right, ...)
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
}

for action, state in pairs(actionhandlers) do
	AddToSGAC(action, state)
end