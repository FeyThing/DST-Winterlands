local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local PlayerActionPicker = require("components/playeractionpicker")

function PlayerActionPicker:GetGhostPlowActions(inst, pos, right)
	if TheWorld.Map:IsPolarSnowAtPoint(pos.x, pos.y, pos.z, true) then
		return self:SortActionList({ACTIONS.HAUNT}, pos)
	end
end

function PlayerActionPicker:GetWalrusBearTrapActions(inst, pos, right)
	if inst:HasTag("walrus_beartrapped") then
		return self:SortActionList({ACTIONS.WALRUS_BEARTRAP_REMOVE}, pos) -- Not actually possible to perform because of busy trapped state, it's just for visuals here
	end
end

local OldGetRightClickActions = PlayerActionPicker.GetRightClickActions
function PlayerActionPicker:GetRightClickActions(position, target, ...)
	local actions = OldGetRightClickActions(self, position, target, ...)
	
	--	Priority actions
	local beartrap_actions = self:GetWalrusBearTrapActions(self.inst, position, true)
	if beartrap_actions and not (actions and actions[1] and actions[1].action == ACTIONS.BLINK) then
		return beartrap_actions
	end
	
	--	Non priority
	local ghostplow_actions = self:GetGhostPlowActions(self.inst, position, true)
	if IsTableEmpty(actions) then
		if ghostplow_actions then
			return ghostplow_actions
		end
	end
	
	return actions
end

local OldGetInventoryActions = PlayerActionPicker.GetInventoryActions
function PlayerActionPicker:GetInventoryActions(useitem, right, ...)
	local actions = OldGetInventoryActions(self, useitem, right, ...)
	
	-- We don't want players to be able to manually DROP snowfleas, only hold them
	if useitem and useitem:HasTag("flea") then
		for i = #actions, 1, -1 do
			if actions[i].action == ACTIONS.DROP then
				print("removed?")
				table.remove(actions, i)
			end
		end
	end
	
	return actions
end