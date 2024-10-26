local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddAction = ENV.AddAction
local AddComponentAction = ENV.AddComponentAction
local AddStategraphActionHandler = ENV.AddStategraphActionHandler

local function JellyAction(name, act)
	local action = Action(act)
	action.id = name
	action.str = STRINGS.ACTIONS[name]
	AddAction(action)
	
	return action
end

--	Actions
	
	local MOONJELLIFY = JellyAction("MOONJELLIFY", {priority = 6})
	MOONJELLIFY.fn = function(act)
		return act.invobject.components.moonjellyfier:Use(act.target or act.doer)
	end
	
	MOONJELLIFY.strfn = function(act)
		return act.invobject:HasTag("moonjellycleaner") and "REMOVE" or nil
	end
	
--	Components, SGs
	
	AddComponentAction("USEITEM", "moonjellyfier", function(inst, doer, target, actions)
		if inst:HasTag("moonjellyfier") and (target:HasTag(FUELTYPE.BURNABLE.."_fueled") or target:HasTag(FUELTYPE.WORMLIGHT.."_fueled")) then
			table.insert(actions, inst:GetIsWet() and ACTIONS.ADDWETFUEL or ACTIONS.ADDFUEL)
			return
		end
		
		if not target:HasTag("moonjellyfier") and (target:HasTag("moonjellyfiable") and not inst:HasTag("moonjellycleaner")
			or target:HasTag("moonjellyfied") and inst:HasTag("moonjellycleaner")) then
			table.insert(actions, ACTIONS.MOONJELLIFY)
		end
	end)
	
	AddComponentAction("INVENTORY", "moonjellyfier", function(inst, doer, actions)
		if inst:HasTag("moonjellycleaner") and doer:HasTag("moonjellyfied") then
			-- Just so Wurt can still use Pure Horror to cast spell, instead of removing jelly first
			for k, v in pairs(SPELLTYPES) do
				if inst:HasTag(v.."_spellcaster") and doer:HasTag(v.."_spelluser") then
					return
				end
			end
			
			table.insert(actions, ACTIONS.MOONJELLIFY)
		end
	end)
	
	AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MOONJELLIFY, "dolongaction"))
	AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.MOONJELLIFY, "dolongaction"))