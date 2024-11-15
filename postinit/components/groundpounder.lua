local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local GroundPounder = require("components/groundpounder")
	
	local ICICLE_TAGS = {"bigicicle"}
	
	local OldGroundPound = GroundPounder.GroundPound
	function GroundPounder:GroundPound(...)
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local icicles = TheSim:FindEntities(x, y, z, self.radiusStepDistance * 25, ICICLE_TAGS)
		
		for i, icicle in ipairs(icicles) do
			local dist = math.sqrt(self.inst:GetDistanceSqToInst(icicle))
			local break_time = 0.5 * (dist / 12)
			
			icicle:DoTaskInTime(break_time, function()
				if icicle:IsValid() and icicle.DoGrow then
					icicle:DoGrow(true)
				end
			end)
		end
		
		OldGroundPound(self, ...)
	end