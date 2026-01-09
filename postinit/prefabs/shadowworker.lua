local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local MARKER_DIST = 6
local MARKER_TAGS = {"plow_action_marker"}
local NUM_MARKERS = 6

local function OnPolarInit(inst, iswinter, ...)
	if IsInPolar(inst) then
		local x, y, z = inst.Transform:GetWorldPosition()
		local dtheta = TWOPI / NUM_MARKERS
		
		for theta = math.random() * dtheta, TWOPI, dtheta do
			local x1 = x + MARKER_DIST * math.cos(theta)
			local z1 = z + MARKER_DIST * math.sin(theta)
			
			if TheWorld.Map:IsPolarSnowAtPoint(x1, 0, z1, true) and not TheWorld.Map:IsPolarSnowBlocked(x1, 0, z1, -1)
				and #TheSim:FindEntities(x1, y, z1, MARKER_DIST - 1, MARKER_TAGS) == 0 then
				
				local marker = SpawnPrefab("snowwave_workermarker")
				marker.Transform:SetPosition(x1, y, z1)
			end
		end
	end
end

ENV.AddPrefabPostInit("shadowworker", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:DoTaskInTime(0, OnPolarInit)
end)