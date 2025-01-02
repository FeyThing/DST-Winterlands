local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Explosive = require("components/explosive")
	
	local ICICLE_TAGS = {"bigicicle"}
	
	local OldOnBurnt = Explosive.OnBurnt
	function Explosive:OnBurnt(...)
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
		
		if not self.inst._ignore_polarice then
			if TheWorld.components.polarice_manager then
				for dx = -1, 1 do
					for dy = -1, 1 do
						TheWorld.components.polarice_manager:StartDestroyingIceAtTile(tx + dx, ty + dy, false)
					end
				end
			end
		end
		
		if not self.inst._ignore_polaricicle then
			local icicles = TheSim:FindEntities(x, y, z, self.explosiverange * 25, ICICLE_TAGS)
			for i, icicle in ipairs(icicles) do
				local dist = math.sqrt(icicle:GetDistanceSqToPoint(x, y, z))
				local break_time = 0.5 * (dist / 12)
				
				icicle:DoTaskInTime(break_time, function()
					if icicle:IsValid() and icicle.DoGrow then
						icicle:DoGrow(true)
					end
				end)
			end
		end
		
		OldOnBurnt(self, ...)
	end