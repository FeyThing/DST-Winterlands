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
	
	local PENGUIN_GUARDS_TAGS = {"penguin_guard"}
	local PENGUIN_GUARDS_NOT_TAGS = {"INLIMBO", "isdead"}
	
	local function OnCastleProvoked(ent, data)
		if self.ice_castle_pos and self.ice_castle_parts and self.emperor and not self.defeated and data and ent.prefab ~= "rock_ice" then
			local attacker = data.attacker or data.worker or data.owner
			
			local x, y, z = self.ice_castle_pos:Get()
			local num_guards = #TheSim:FindEntities(x, y, z, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE, PENGUIN_GUARDS_TAGS, PENGUIN_GUARDS_NOT_TAGS)
			
			-- We seed some guard if castle is currently helpless
			local need_support = ent:HasTag("wall") and attacker and not self:IsInstInsideCastle(attacker)
				and num_guards < 1 and self._provoke_support == nil
			
			if need_support then
				self._provoke_support = self.inst:DoTaskInTime(0.2 + math.random() * 0.3, function()
					self:SpawnGuards(math.random(1, 2))
				end)
			end
			if attacker and self.emperor.components.combat then
				if self.emperor.attackerUSERIDs and attacker.userid then
					self.emperor.attackerUSERIDs[attacker.userid] = true
				end
				
				self.emperor.components.combat:SuggestTarget(attacker)
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
	
	local function RevealCastleOnMap(castle_floor)
		if castle_floor and castle_floor:IsValid() and castle_floor.components.mapspotrevealer then
			local pt = self.ice_castle_pos or castle_floor:GetPosition()
			
			for i, player in ipairs(AllPlayers) do
				if player:GetDistanceSqToPoint(pt:Get()) < TUNING.EMPEROR_PENGUIN_CASTLE_REVEAL_MAP_IN_RANGE then
					castle_floor.components.mapspotrevealer:RevealMap(player)
				end
			end
		end
	end
	
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
		
		--TODO: Not used because this auto opens the map, which could be risky here. But ideally we want to the map for nearby players !
		--RevealCastleOnMap(castle_floor)
		
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
			emperor.persists = false
			
			if emperor.components.knownlocations then
				emperor.components.knownlocations:RememberLocation("rookery", pt)
			end
			
			if emperor.sg then
				emperor.sg:GoToState("summon_guards", true)
			end
			
			self.emperor = emperor
		end
	end
	
	local CASTLE_TOWER_TAGS = {"polarcastletower"}
	
	function self:SpawnGuards(num, instant)
		if self._provoke_support then
			self._provoke_support:Cancel()
			self._provoke_support = nil
		end
		
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
				if penguin.sg and not instant then
					penguin.sg:GoToState("exittower_guard")
				else
					tower.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
				end
				
				table.insert(self.ice_castle_parts, penguin)
			end
		end
	end
	
	--	Building castle rules...
	
	local CASTLE_AVOID_TAGS = {"antlion_sinkhole_blocker", "birdblocker", "blocker", "playerowned", "structure", "wall", "character"}
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
		
		local chance = daysleft >= 12 and 0.1
			or daysleft >= 10 and 0.25
			or daysleft >= 8 and 0.5
			or 1
			
		return chance * TUNING.SPAWN_EMPEROR_PENGUIN_MOD
	end
	
	function self:TrySpawnCastleAtColony(colony)
		if self.ice_castle_pos or not TUNING.SPAWN_EMPEROR_PENGUIN then
			return
		end
		
		local chance = GetSpawnChanceForColony(colony)
		if math.random() <= chance then
			local pt, valid = self:GetValidCastlePos(colony:GetPosition())
			
			if valid then
				local spawned = self:SpawnCastle(pt)
				if spawned then
					self:SpawnEmperor()
				end
				
				return spawned
			end
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
	--	NOTE: emperor savedata is now entirely in this component, he will not persist into the world, because he already doesn't if saved atop a tower (parented entity)
	
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
			data.attackerUSERIDs = self.emperor.attackerUSERIDs
			data.callguards = self.emperor.wants_to_call_guards
			data.gojuggle = self.emperor.wants_to_juggle
			
			data.healthphase_regenlock = self.emperor.healthphase_regenlock
			data.healthtrigger_cutdmg = self.emperor.healthtrigger_cutdmg
			data.healthtrigger_phase = self.emperor.healthtrigger_phase
			
			--table.insert(ents, self.emperor.GUID)
			--data.emperor = self.emperor.GUID
			
			data.emperor_savedata = self.emperor:GetSaveRecord()
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
			
			if savedata.emperor then -- Old, keeping for old saves
				if newents[savedata.emperor] then
					local emperor = newents[savedata.emperor].entity
					
					if emperor and emperor:IsValid() then
						self.emperor = emperor
						emperor.persists = false
					end
				end
			end
			if savedata.emperor_savedata and not savedata.defeated then -- New method
				local emperor = SpawnSaveRecord(savedata.emperor_savedata)
				
				if emperor then
					self.emperor = emperor
					emperor.persists = false
					emperor:ForceQuitTowerState()
					
					if self.ice_castle_pos then
						emperor.Transform:SetPosition(self.ice_castle_pos:Get())
					end
					
					emperor.wants_to_call_guard = savedata.callguards or emperor.wants_to_call_guard
					emperor.wants_to_juggle = savedata.gojuggle or emperor.wants_to_juggle
					
					emperor.healthphase_regenlock = savedata.healthphase_regenlock or emperor.healthphase_regenlock
					emperor.healthtrigger_cutdmg = savedata.healthtrigger_cutdmg or emperor.healthtrigger_cutdmg
					emperor.healthtrigger_phase = savedata.healthtrigger_phase or emperor.healthtrigger_phase
					
					if savedata.attackerUSERIDs and next(savedata.attackerUSERIDs) then
						emperor.attackerUSERIDs = savedata.attackerUSERIDs
						emperor:AddTag("hostile")
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
	local CASTLE_SKIP_DESTROY_TAGS = {"playerowned", "structure"}
	local CASTLE_NOT_SKIP_DESTROY_TAGS = {"INLIMBO", "icecastlepart"}
	
	local function OnSeasonTick(inst, data)
		local curseason = POLARRIFY_MOD_SEASONS[TheWorld.state.season] or "autumn"
		
		local pt = self.ice_castle_pos
		if not pt then
			return
		end
		
		local castle_floor = TheSim:FindEntities(pt.x, pt.y, pt.z, 8, CASTLE_TAGS)[1]
		if not (castle_floor and castle_floor:IsAsleep()) then
			if castle_floor then
				castle_floor._time_asleep = nil
			end
			
			return
		end
		
		local t = GetTime()
		castle_floor._time_asleep = castle_floor._time_asleep or t
		
		if t - castle_floor._time_asleep < TUNING.EMPEROR_PENGUIN_CASTLE_DEFEATED_DESPAWN_TIME then
			return
		end
		
		if (not self.defeated and (curseason ~= SEASONS.WINTER or TheWorld.state.remainingdaysinseason <= 3))
			or (self.defeated and curseason ~= SEASONS.WINTER) then
			
			local structure = FindEntity(castle_floor, 12, nil, nil, CASTLE_NOT_SKIP_DESTROY_TAGS, CASTLE_SKIP_DESTROY_TAGS)
			self:DespawnCastle(self.defeated and structure ~= nil)
		end
	end
	
	inst:ListenForEvent("emperorpenguin_defeated", OnDefeated)
	inst:ListenForEvent("emperorpenguin_dropsketch", OnDropSketch)
	inst:ListenForEvent("seasontick", OnSeasonTick)
end)