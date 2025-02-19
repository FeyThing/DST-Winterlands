local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Kramped = require("components/kramped")
local OldKramped_ctor = Kramped._ctor

Kramped._ctor = function(self, ...)
	OldKramped_ctor(self, ...)
	
	local _activeplayers = PolarUpvalue(self.GetDebugString, "_activeplayers")
	
	local OnKilledOther
	local OnNaughtyAction
	
	if self.inst.event_listening and self.inst.event_listening["ms_playerjoined"] then
		for i, v in ipairs(self.inst.event_listening["ms_playerjoined"][TheWorld]) do
			OnKilledOther = PolarUpvalue(v, "OnKilledOther")
			if OnKilledOther then
				OnNaughtyAction = PolarUpvalue(OnKilledOther, "OnNaughtyAction")
				break
			end
		end
	end
	
	function self:AddFromWX_NaughtyModule(how_naughty, player, ...)
		if OnNaughtyAction and _activeplayers and player and player:IsValid() then
			OnNaughtyAction(how_naughty, _activeplayers[player], ...)
		end
	end
end