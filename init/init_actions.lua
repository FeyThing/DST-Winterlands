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

--	Components, SGs

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