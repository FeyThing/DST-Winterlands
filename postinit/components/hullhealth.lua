local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local HullHealth = require("components/hullhealth")

local old_OnCollide = HullHealth.OnCollide
HullHealth.OnCollide = function(self, data, ...)
	old_OnCollide(self, data, ...)
	
	local absolute_hit_normal_overlap_percentage = math.abs(data.hit_dot_velocity)
	local damage_alignment = absolute_hit_normal_overlap_percentage / (data.speed_damage_factor or 1)
	
	if damage_alignment > 0.258 then -- math.cos(75deg)
		local hit_adjacent_speed = self.inst.components.boatphysics:GetVelocity() * absolute_hit_normal_overlap_percentage
		if hit_adjacent_speed > 2 then
			local dist = (TILE_SCALE + self.inst.components.walkableplatform.platform_radius) / 2
			local normal = -Vector3(data.world_normal_on_b_x, data.world_normal_on_b_y, data.world_normal_on_b_z):Normalize()
			local tpos = Vector3(data.world_position_on_a_x, data.world_position_on_a_y, data.world_position_on_a_z)
			tpos = tpos + normal * dist
			
			local hit_tile = TheWorld.Map:GetTileAtPoint(tpos:Get())
			if hit_tile == WORLD_TILES.POLAR_ICE then
				local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(tpos:Get())
				TheWorld.components.polarice_manager:DestroyIceAtTile(tx, ty, false)
			end
		end
	end
end