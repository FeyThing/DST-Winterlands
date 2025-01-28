local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Submersible = require("components/submersible")
	
	local OldCheckNearbyTiles = PolarUpvalue(Submersible.Submerge, "CheckNearbyTiles")
	local function CheckNearbyTiles(x, y, z, ...)
		local data
		
		if OldCheckNearbyTiles then
			data = OldCheckNearbyTiles(x, y, z, ...)
			local noticepoints = {}
			
			if data.landpoints then
				for i, pos in ipairs(data.landpoints) do
					if TheWorld.Map:GetTileAtPoint(pos.x, 0, pos.z) ~= WORLD_TILES.POLAR_ICE then
						table.insert(noticepoints, {x = pos.x, z = pos.z})
					end
				end
			end
			
			data.landpoints = noticepoints
			if not data.area_free and #noticepoints == 0 then
				data.area_free = true
			end
		end
		
		return data
	end
	
	PolarUpvalue(Submersible.Submerge, "CheckNearbyTiles", CheckNearbyTiles)