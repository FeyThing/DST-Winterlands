--	TODO: maybe instead of always random position, we get 5 or so and always pick between these ?

return Class(function(self, inst)
	assert(TheWorld.ismastersim, "Polar wormholes should not exist on client")
	self.inst = inst
	
	local BORDER_SCALE = 0.85
	
	local FIND_WORMHHOLE_POS_ATTEMPS = 40
	
	local WORMHOLE_BLOCK_RADIUS = 5
	local WORMHOLE_BLOCK_NOT_TAGS = {"CLASSIFIED", "FX", "INLIMBO"}
	
	local _wormholes = {}
	local _spawntask
	
	local wormhole_in_polar = false
	local _next_wormhole_pt
	
	local function HasSpaceForWormhole(pt)
		_next_wormhole_pt = nil
		
		pt.x, pt.y, pt.z = TheWorld.Map:GetTileCenterPoint(pt.x, pt.y, pt.z)
		pt.x = pt.x + (TILE_SCALE / 2)
		pt.z = pt.z + (TILE_SCALE / 2)
		
		if #TheSim:FindEntities(pt.x, 0, pt.z, WORMHOLE_BLOCK_RADIUS, nil, WORMHOLE_BLOCK_NOT_TAGS) == 0 and FindClosestPlayerInRange(pt.x, 0, pt.z, 20) == nil
			and ((not wormhole_in_polar and not IsInPolarAtPoint(pt.x, 0, pt.z) and TheWorld.Map:FindVisualNodeAtPoint(pt.x, 0, pt.z, "not_mainland") == nil)
			or (wormhole_in_polar and IsInPolarAtPoint(pt.x, 0, pt.z))) then
			
			local neighbors = {
				{x = -1, z = -1},
				{x = -1, z = 1},
				{x = 1, z = -1},
				{x = 1, z = 1}
			}
			
			local tiles = {}
			for i, dir in ipairs(neighbors) do
				local tile = TheWorld.Map:GetTileAtPoint(pt.x + dir.x * TILE_SCALE, 0, pt.z + dir.z * TILE_SCALE)
				
				if TERRAFORM_IMMUNE[tile] or GROUND_ISTEMPTILE[tile] then
					return false
				end
				
				table.insert(tiles, tile)
			end
			
			local tile_1 = tiles[1]
			for _, tile in ipairs(tiles) do
				if tile ~= tile_1 then
					return false
				end
			end
			
			_next_wormhole_pt = pt
			return true
		end
		
		return false
	end
	
	local function GetWormholePos(index)
		index = index or (_wormholes[1] == nil and 1) or (_wormholes[2] == nil and 2) or nil
		
		if index == nil then
			return
		end
		
		local radius = TheWorld.Map:GetSize() * 2 * BORDER_SCALE
		local attempts = 0
		local pt
		
		while attempts < FIND_WORMHHOLE_POS_ATTEMPS and pt == nil do
			wormhole_in_polar = index == 1
			
			pt = FindWalkableOffset(Vector3(0, 0, 0), math.random() * TWOPI, math.random(radius), 20, false, false, HasSpaceForWormhole)
			
			attempts = attempts + 1
		end
		
		if pt then
			pt = _next_wormhole_pt
		end
		
		return pt
	end
	
	local function OnWormholeRemoved(wormhole)
		_wormholes = {}
		
		inst:RemoveEventCallback("onremove", OnWormholeRemoved, wormhole)
	end
	
	local function RegisterWormhole(inst, wormhole)
		table.insert(_wormholes, wormhole)
		
		inst:ListenForEvent("onremove", OnWormholeRemoved, wormhole)
	end
	
	local function RespawnWormholes(inst)
		for i, sickhole in ipairs(_wormholes) do
			if sickhole:IsValid() then
				sickhole:Remove()
			end
		end
		
		_wormholes = {}
		local wormholes_pt = {}
		
		for i = 1, 2 do
			wormholes_pt[i] = GetWormholePos(i) or nil
		end
		
		if #wormholes_pt == 2 then
			for i, pt in ipairs(wormholes_pt) do
				local sickhole = SpawnPrefab("wormhole_limited_1")
				
				if sickhole then
					sickhole.Transform:SetPosition(pt:Get())
					
					RegisterWormhole(self.inst, sickhole)
				end
			end
			
			for i, sickhole in ipairs(_wormholes) do
				if sickhole.components.teleporter then
					local otherhole = _wormholes[i == 1 and 2 or 1]
					
					if otherhole and otherhole:IsValid() then
						sickhole.components.teleporter:Target(otherhole)
					end
				end
			end
			
			print("Polar Wormholes: spawned both sickholes!")
		else
			print("Polar Wormholes: couldn't spawn both sickholes, got "..#wormholes_pt)
		end
	end
	
	local function OnDayComplete(inst, delay)
		if TUNING.POLAR_WORMHOLE_ENABLED and #_wormholes < 2 then
			_spawntask = inst:DoTaskInTime(delay, RespawnWormholes)
		end
	end
	
	function self:OnPostInit()
		inst:WatchWorldState("cycles", OnDayComplete)
		OnDayComplete(inst, 0)
	end
	
	function self:OnSave()
		local data, ents = {}, {}
		
		if next(_wormholes) then
			data.wormholes = {}
			
			for i, wormhole in pairs(_wormholes) do
				table.insert(data.wormholes, wormhole.GUID)
				table.insert(ents, wormhole.GUID)
			end
		end
		
		if next(data) == nil then
			return nil, nil
		end
		
		return data, ents
	end
	
	function self:LoadPostPass(newents, savedata)
		if savedata.wormholes then
			for i, guid in ipairs(savedata.wormholes) do
				if newents[guid] then
					local wormhole = newents[guid].entity
					
					RegisterWormhole(self.inst, wormhole)
				end
			end
		end
	end
	
	function self:DebugGetWormholes()
		return _wormholes
	end
	
	function self:DebugRespawn()
		RespawnWormholes()
	end
end)