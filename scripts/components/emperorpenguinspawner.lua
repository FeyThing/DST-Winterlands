local CASTLE_DEFS = require("emperorpenguinspawner_defs")

local CASTLE_OUTDOOR_RADIUS = TUNING.EMPEROR_PENGUIN_CASTLE_RANGE * TUNING.EMPEROR_PENGUIN_CASTLE_RANGE

return Class(function(self, inst)
	assert(TheWorld.ismastersim, "Emperor Penguin spawner should not exist on client")
	self.inst = inst
	
	self.emperor = nil
	self.defeated = false
	self.times_beat = 0
	
	self.ice_castle_parts = {}
	self.ice_castle_pos = nil
	self.ice_towers = {}
	
	self.sketch_tower_rotation = {
		"chesspiece_emperor_penguin_fruity_sketch",
		"chesspiece_emperor_penguin_juggle_sketch",
		"chesspiece_emperor_penguin_magestic_sketch",
		"chesspiece_emperor_penguin_spin_sketch",
	}
	self.next_sketch_drop = math.random(#self.sketch_tower_rotation)
	
	--	Castle content management
	
	local function OnCastleProvoked(ent, data)
		if self.ice_castle_parts and self.emperor and not self.defeated and data and ent.prefab ~= "rock_ice" then
			local attacker = data.attacker or data.worker or data.owner
			local combat = self.emperor.components.combat
			
			if attacker and combat and combat.target == nil then
				combat:SuggestTarget(attacker)
			end
		end
	end
	
	function self:ProvokeCastle(src, attacker)
		if self.ice_castle_pos and src and src:GetDistanceSqToPoint(self.ice_castle_pos:Get()) <= CASTLE_OUTDOOR_RADIUS then
			OnCastleProvoked(src, {attacker = attacker})
		end
	end
	
	local function OnItemRemoved(ent, data)
		if data and data.owner and ent:HasTag("heavy") then
			OnCastleProvoked(ent, data)
		end
		
		self:OnItemRemoved(ent)
	end
	
	function self:OnItemRemoved(ent, noremove)
		if ent.components.combat then
			inst:RemoveEventCallback("attacked", OnCastleProvoked, ent)
		end
		if ent.components.equippable then
			inst:RemoveEventCallback("equipped", OnItemRemoved, ent) -- Stealing chesspiece !
		end
		if ent.components.inventoryitem then
			inst:RemoveEventCallback("onpickup", OnItemRemoved, ent)
		end
		if ent.components.workable then
			inst:RemoveEventCallback("worked", OnCastleProvoked, ent)
		end
		inst:RemoveEventCallback("onremove", OnItemRemoved, ent)
		ent:RemoveTag("icecastlepart")
		
		if not noremove then
			for i, v in ipairs(self.ice_castle_parts) do
				if v == ent then
					table.remove(self.ice_castle_parts, i)
					break
				end
			end
		end
	end
	
	function self:OnItemSpawned(ent, fromload)
		ent:AddTag("icecastlepart")
		if ent.components.combat then
			inst:ListenForEvent("attacked", OnCastleProvoked, ent)
		end
		if ent.components.equippable then
			inst:ListenForEvent("equipped", OnItemRemoved, ent)
		end
		if ent.components.inventoryitem then
			inst:ListenForEvent("onpickup", OnItemRemoved, ent)
		end
		if ent.components.workable then
			inst:ListenForEvent("worked", OnCastleProvoked, ent)
		end
		inst:ListenForEvent("onremove", OnItemRemoved, ent)
		
		if ent.prefab == "tower_polar" then
			table.insert(self.ice_towers, ent)
		end
		table.insert(self.ice_castle_parts, ent)
	end
	
	--	Create castle + populace
	
	local function SpawnCastleEnt(num, pt_ent, center_pos)
		local part_def = CASTLE_DEFS.PARTS[tostring(num)]
		
		if part_def then
			inst:DoTaskInTime(part_def.spawnlast and 0.1 or 0, function()
				local ent = part_def.fn(num, pt_ent, center_pos)
				
				if ent then
					self:OnItemSpawned(ent)
				end
			end)
		end
	end
	
	function self:SpawnCastle(_pt, layout_name)
		if #self.ice_castle_parts > 0 then
			self:DespawnCastle()
		end
		
		local layout = CASTLE_DEFS.LAYOUTS[layout_name or "basic"]
		local pt_x, pt_y = TheWorld.Map:GetTileCoordsAtPoint(_pt:Get())
		local center_pos = Vector3(TheWorld.Map:GetTileCenterPoint(pt_x, pt_y))
		self.ice_castle_pos = center_pos
		
		local rows = 17
		local i = 0
		local x_pt = 8.5
		local z_pt = 7.5
		local x = center_pos.x + x_pt
		local z = center_pos.z + z_pt
		
		local castle_floor = SpawnPrefab("penguin_castle_ice")
		castle_floor.Transform:SetPosition(center_pos:Get())
		
		table.insert(self.ice_castle_parts, castle_floor)
		
		while i < #layout do
			local j = 1
			while j <= rows and i + j <= #layout do
				local num = layout[i + j]
				x = x - 1
				
				SpawnCastleEnt(num, Vector3(x, center_pos.y, z), center_pos)
				
				j = j + 1
			end
			
			x = center_pos.x + x_pt
			z = z - 1
			i = i + rows
		end
		
		return true
	end
	
	function self:DespawnCastle(forget_only)
		for i, v in ipairs(self.ice_castle_parts) do
			if v:IsValid() then
				self:OnItemRemoved(v, true)
				if not forget_only and (v.prefab ~= "rock_ice" or v.remove_on_dryup) then
					v:Remove()
				end
			end
		end
		
		self.defeated = false
		self.ice_castle_parts = {}
		self.ice_castle_pos = nil
		self.ice_towers = {}
		self.towers_pos = nil
		
		if self.emperor and self.emperor:IsValid() then
			self.emperor:Remove()
			self.emperor = nil
		end
		
		return true
	end
	
	function self:SpawnEmperor()
		local pt = self.ice_castle_pos
		
		if self.emperor and self.emperor:IsValid() then
			self.emperor:Remove()
		end
		
		if pt then
			local emperor = SpawnPrefab("emperor_penguin")
			emperor.Transform:SetPosition(pt:Get())
			
			if emperor.components.knownlocations then
				emperor.components.knownlocations:RememberLocation("rookery", pt)
			end
			
			self.emperor = emperor
		end
	end
	
	local CASTLE_TOWER_TAGS = {"polarcastletower"}
	
	function self:SpawnGuards(num)
		local pt = self.ice_castle_pos
		
		if num and num > 0 and pt and #self.ice_towers > 0 then
			for i = 1, num do
				local tower = self.ice_towers[math.random(#self.ice_towers)]
				local x, y, z = tower.Transform:GetWorldPosition()
				
				local angle_rad = tower.Transform:GetRotation() * DEGREES
				local offset = Vector3(x + math.cos(angle_rad), 0, z + -math.sin(angle_rad))
				
				local penguin = SpawnPrefab("emperor_penguin_guard")
				penguin.Transform:SetPosition(offset:Get())
				
				if penguin.components.knownlocations then
					penguin.components.knownlocations:RememberLocation("rookery", offset)
				end
				if penguin.components.combat and self.emperor and self.emperor.components.combat and self.emperor.components.combat.target then
					penguin.components.combat:SetTarget(self.emperor.components.combat.target)
				end
				if penguin.sg then
					penguin.sg:GoToState("exittower_guard")
				end
				
				table.insert(self.ice_castle_parts, penguin)
			end
		end
	end
	
	--	Building castle rules...
	
	local CASTLE_AVOID_TAGS = {"blocker", "structure", "wall", "character"}
	local CASTLE_AVOID_NOT_TAGS = {"icecastlepart", "penguinicepart", "INLIMBO", "player"}
	
	function self:GetValidCastlePos(pt)
		local valid = false
		
		print("Finding area for Emperor Icecastle!")
		if TheWorld.has_ocean and TheWorld.Map:IsSurroundedByLand(pt.x, pt.y, pt.z, 9) then
			local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 15, nil, CASTLE_AVOID_NOT_TAGS, CASTLE_AVOID_TAGS)
			
			if #ents == 0 then
				valid = true
			else
				print("	Too important entities around... such as :", ents[1])
			end
		else
			print("	Not enough space... (or incompatible world)")
		end
		
		return pt, valid
	end
	
	local function GetSpawnChanceForColony(colony)
		local daysleft = TheWorld.state.remainingdaysinseason
		
		if self.ice_castle_pos or not TheWorld.state.iswinter or daysleft <= 3 then
			return 0
		end
		
		if colony then
			local t = GetTime()
			
			if (colony:GetTimeAlive() < TUNING.EMPEROR_PENGUIN_CASTLE_COLONY_MIN_AGE) or
				colony._icecastle_buildcooldown and t - colony._icecastle_buildcooldown < TUNING.EMPEROR_PENGUIN_CASTLE_COLONY_MIN_COOLDOWN then
				colony._icecastle_buildcooldown = t
				
				return 0
			end
		end
		
		return daysleft >= 12 and 0.1
			or daysleft >= 10 and 0.25
			or daysleft >= 8 and 0.5
			or 1
	end
	
	function self:TrySpawnCastleAtColony(colony)
		if self.ice_castle_pos then
			return
		end
		
		local pt, valid = self:GetValidCastlePos(colony:GetPosition())
		local chance = GetSpawnChanceForColony(colony)
		
		if valid and math.random() <= chance then
			local spawned = self:SpawnCastle(pt)
			if spawned then
				self:SpawnEmperor()
			end
			
			return spawned
		end
	end
	
	--	Combat utils
	
	local function GetTowersPos()
		if self.towers_pos == nil then
			local cx, cz = 0, 0
			local tower_positions = {}
			
			for _, v in ipairs(self.ice_towers) do
				local pt = v:GetPosition()
				cx = cx + pt.x
				cz = cz + pt.z
				
				table.insert(tower_positions, pt)
			end
			
			if #tower_positions < 4 then
				return
			end
			
			cx = cx / 4
			cz = cz / 4
			
			-- Offset a little bhind towers, or we're out when hugging walls
			local positions = {}
			local offset = 0.25
			
			for _, pt in ipairs(tower_positions) do
				local dx = pt.x - cx
				local dz = pt.z - cz
				local len = math.sqrt(dx * dx + dz * dz)
				
				if len > 0 then
					dx = dx / len
					dz = dz / len
				end
				
				table.insert(positions, Vector3(pt.x + dx * offset, 0, pt.z + dz * offset))
			end
			
			table.sort(positions, function(a, b)
				local angle_a = math.atan2(a.z - cz, a.x - cx)
				local angle_b = math.atan2(b.z - cz, b.x - cx)
				
				return angle_a < angle_b
			end)
			
			self.towers_pos = positions
		end
		
		return self.towers_pos
	end
	
	function self:IsInstInsideCastle(ent)
		local x, y, z = ent.Transform:GetWorldPosition()
		
		if self.towers_pos == nil then
			self.towers_pos = GetTowersPos()
			
			if not self.towers_pos or self.towers_pos[4] == nil then
				return false, false
			end
		end
		
		local px, pz = x, z
		local function sign(x1, z1, x2, z2, x3, z3)
			return (x1 - x3) * (z2 - z3) - (x2 - x3) * (z1 - z3)
		end
		
		local b1 = sign(px, pz, self.towers_pos[1].x, self.towers_pos[1].z, self.towers_pos[2].x, self.towers_pos[2].z) < 0
		local b2 = sign(px, pz, self.towers_pos[2].x, self.towers_pos[2].z, self.towers_pos[3].x, self.towers_pos[3].z) < 0
		local b3 = sign(px, pz, self.towers_pos[3].x, self.towers_pos[3].z, self.towers_pos[4].x, self.towers_pos[4].z) < 0
		local b4 = sign(px, pz, self.towers_pos[4].x, self.towers_pos[4].z, self.towers_pos[1].x, self.towers_pos[1].z) < 0
		
		return (b1 == b2) and (b2 == b3) and (b3 == b4), true
	end
	
	--	Saved data, Events
	
	function self:OnSave()
		local data = {
			parts = {},
			
			defeated = self.defeated,
			dropped_recipecard = self.dropped_recipecard,
			ice_castle_pos = self.ice_castle_pos,
			next_sketch_drop = self.next_sketch_drop,
			times_beat = self.times_beat,
		}
		local ents = {}
		
		for i, v in pairs(self.ice_castle_parts) do
			if v and v:IsValid() then
				table.insert(ents, v.GUID)
				table.insert(data.parts, v.GUID)
			end
		end
		if self.emperor and self.emperor:IsValid() then
			table.insert(ents, self.emperor.GUID)
			data.emperor = self.emperor.GUID
		end
		
		return data, ents
	end
	
	function self:OnLoad(data)
		if data then
			self.defeated = data.defeated or false
			self.dropped_recipecard = data.dropped_recipecard or nil
			self.next_sketch_drop = data.next_sketch_drop or self.next_sketch_drop
			self.times_beat = data.times_beat or self.times_beat
			
			if data.ice_castle_pos then
				self.ice_castle_pos = Vector3(data.ice_castle_pos.x, data.ice_castle_pos.y, data.ice_castle_pos.z)
			end
		end
	end
	
	function self:LoadPostPass(newents, savedata)
		if savedata then
			if savedata.parts then
				for i, guid in ipairs(savedata.parts) do
					if newents[guid] then
						local ent = newents[guid].entity
						
						if ent and ent:IsValid() then
							self:OnItemSpawned(ent, true)
						end
					end
				end
			end
			if savedata.emperor then
				if newents[savedata.emperor] then
					local emperor = newents[savedata.emperor].entity
					
					if emperor and emperor:IsValid() then
						self.emperor = emperor
					end
				end
			end
		end
	end
	
	function self:GetDebugString()
		local pt = self.ice_castle_pos or {}
		
		return string.format(
			"Castle Pos: (%.2f, %.2f, %.2f) | Defeated: %s | Emperor: %s",
			pt.x or 0,
			pt.y or 0,
			pt.z or 0,
			tostring(self.defeated),
			tostring(self.emperor)
		)
	end
	
	local function OnDefeated(src, data)
		local emperor = data and data.emperor
		
		if emperor and emperor == self.emperor then
			self.defeated = true
			self.emperor = nil
			
			self.times_beat = self.times_beat + 1
		end
	end
	
	local function OnDropSketch(src, data)
		local pt = data and data.pos
		
		if pt then
			local sketch = SpawnPrefab(self.sketch_tower_rotation[self.next_sketch_drop])
			sketch.components.inventoryitem:DoDropPhysics(pt.x, pt.y, pt.z, true)
			
			self.next_sketch_drop = self.next_sketch_drop >= #self.sketch_tower_rotation and 1 or self.next_sketch_drop + 1
		end
	end
	
	local CASTLE_TAGS = {"polarcastlefloor"}
	local CASTLE_SKIP_DESTROY_TAGS = {"structure"}
	local CASTLE_NOT_SKIP_DESTROY_TAGS = {"INLIMBO", "icecastlepart"}
	
	local function OnSeasonTick(inst, data)
		local curseason = POLARRIFY_MOD_SEASONS[TheWorld.state.season] or "autumn"
		
		if curseason ~= SEASONS.WINTER or TheWorld.state.remainingdaysinseason < 3 then
			local pt = self.ice_castle_pos
			
			if pt then
				local castle_floor = TheSim:FindEntities(pt.x, pt.y, pt.z, 8, CASTLE_TAGS)[1]
				
				-- If players left the castle for a little while but built in it, leave it behind !
				if castle_floor and castle_floor:IsAsleep() then
					local t = GetTime()
					local structure = FindEntity(castle_floor, 12, nil, nil, CASTLE_NOT_SKIP_DESTROY_TAGS, CASTLE_SKIP_DESTROY_TAGS)
					
					if castle_floor._time_asleep == nil then
						castle_floor._time_asleep = t
					elseif t - castle_floor._time_asleep > TUNING.TOTAL_DAY_TIME * 0.8 then
						self:DespawnCastle(self.defeated and structure ~= nil)
					end
				end
			end
		end
	end
	
	inst:ListenForEvent("emperorpenguin_defeated", OnDefeated)
	inst:ListenForEvent("emperorpenguin_dropsketch", OnDropSketch)
	inst:ListenForEvent("seasontick", OnSeasonTick)
end)