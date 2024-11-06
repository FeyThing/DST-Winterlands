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

local POLARPLOW = PolarAction("POLARPLOW", {distance = 1, priority = 1})
	POLARPLOW.fn = function(act)
		local shovel = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local act_pos = act:GetActionPoint()
		
		if shovel and shovel.components.polarplower then
			if shovel.components.polarplower:CanPlow(act.target, act_pos) then
				return shovel.components.polarplower:DoPlow(act.target, act_pos)
			end
			
			return false
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

--

local COMPONENT_ACTIONS = PolarUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")

local oldrepairer = COMPONENT_ACTIONS.USEITEM.repairer
	COMPONENT_ACTIONS.USEITEM.repairer = function(inst, doer, target, actions, ...)
		if inst:HasTag("freshen_"..MATERIALS.DRYICE) and target:HasTag("repairable_"..MATERIALS.ICE) then
			table.insert(actions, ACTIONS.REPAIR)
		elseif oldrepairer then
			oldrepairer(inst, doer, target, actions, ...)
		end
	end

--

local function AddToSGAC(action, state)
	ENV.AddStategraphActionHandler("wilson", ActionHandler(ACTIONS[action], state))
	ENV.AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS[action], state))
end

local actionhandlers = {
	POLARPLOW = "dig_start",
}

for action, state in pairs(actionhandlers) do
	AddToSGAC(action, state)
end