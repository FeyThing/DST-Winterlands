local WIDTH, HEIGHT

local OUTTER_GRADIENT_DEPTH = 8
local INNER_GRADIENT_STEP = 1 / (OUTTER_GRADIENT_DEPTH + 1)

-- TODO: We could upgrade dynamically the batch sizes and period based of how long summer lasts and how many snow tiles there are
--		 so that the full Winterlands always melt / return within the same interval

local TILES_BATCH_PERIOD = 16
local TILES_PER_BATCH = 50

return Class(function(self, inst)
	assert(inst.ismastersim, "Polarsnow Manager should not exist on the client!")
	
	-- [ Public fields ] --
	
	self.inst = inst
	
	self.swap_tiles = {
		layouts = {
			["Polar Lands"] 				= WORLD_TILES.POLAR_GRASS, -- Retrofitted Winterlands fallback
		},
		rooms = {
			["PolarIsland_BG"] 				= WORLD_TILES.POLAR_GRASS,
			["PolarIsland_BigLake"] 		= WORLD_TILES.POLAR_GRASS,
			["PolarIsland_DeciduousLakes"] 	= WORLD_TILES.DECIDUOUS,
		},
		tasks = {
			["Polar Caves"] 				= WORLD_TILES.ROCKY,
			["Polar Deciduous Lands"] 		= WORLD_TILES.FOREST,
			["Polar Floe"] 					= WORLD_TILES.ROCKY,
			["Polar Gnomes"] 				= WORLD_TILES.FOREST,
			["Polar Icerink"] 				= WORLD_TILES.SAVANNA,
			["Polar Lands"] 				= WORLD_TILES.FOREST,
			["Polar Quarry"] 				= WORLD_TILES.POLAR_GRASS,
			["Polar Village"] 				= WORLD_TILES.GRASS,
		},
	}
	
	-- [ Private fields ] --
	
	local _map = inst.Map
	local undertile = inst.components.undertile
	
	local _snowgrid
	local _gradient_indeces = {} -- Indeces for the next iteration of the gradient
	local _max_depth = 1
	
	local _snowtiles
	local _tileindex = 1
	local _tiletask
	
	-- [ Functions ] --
	
	local function SetSnowLevel(index, level)
		if 0 <= index and index < WIDTH * HEIGHT then
			_snowgrid:SetDataAtIndex(index, level)
		end
	end
	
	local function GenerateOutterGradient(depth)
		assert(depth > 0, "Snow gradient depth must be positive!")
		
		local gradient_indeces = {}
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _snowgrid:GetXYFromIndex(i)
			
			for x = -1, 1 do
				for y = -1, 1 do
					local nx, ny = ox + x, oy + y
					
					if self:GetDataAtTile(nx, ny) == 0 then
						local index = _snowgrid:GetIndex(nx, ny)
						local level = depth / (OUTTER_GRADIENT_DEPTH + 1) -- Linear falloff based on how far we are from the Winterlands border
						
						SetSnowLevel(index, level)
						table.insert(gradient_indeces, index)
					end
				end
			end
		end
		
		_gradient_indeces = gradient_indeces
		depth = depth - 1
		
		if depth > 0 and next(_gradient_indeces) ~= nil then
			GenerateOutterGradient(depth)
		end
	end
	
	local function GenerateInnerGradient()
		local gradient_indeces = {}
		
		for i = 0, WIDTH * HEIGHT - 1 do
			if _snowgrid:GetDataAtIndex(i) == 1 then
				table.insert(gradient_indeces, i)
			end
		end
		
		local growth_step = 1
		while true do
			local next_indeces = {}
			local target_level = 1 + (growth_step * INNER_GRADIENT_STEP)
			
			for _, i in ipairs(gradient_indeces) do
				local ox, oy = _snowgrid:GetXYFromIndex(i)
				local target_min = math.huge
				
				for x = -1, 1 do
					for y = -1, 1 do
						local nx, ny = ox + x, oy + y
						local level = self:GetDataAtTile(nx, ny)
						
						target_min = math.min(target_min, level)
					end
				end
				
				local previous_target = 1 + ((growth_step - 1) * INNER_GRADIENT_STEP)
				
				if target_min >= previous_target then
					SetSnowLevel(i, target_level)
					table.insert(next_indeces, i)
					
					_max_depth = target_level
				end
			end
			
			if next(next_indeces) == nil then
				break
			end
			
			gradient_indeces = next_indeces
			growth_step = growth_step + 1
		end
	end
	
	local function GetSwapTile(id)
		local gen_data = ConvertTopologyIdToData(id)
		local swap_tile
		
		if gen_data.layout_id and self.swap_tiles.layouts[gen_data.layout_id] then
			swap_tile = self.swap_tiles.layouts[gen_data.layout_id]
		elseif gen_data.room_id and self.swap_tiles.rooms[gen_data.room_id] then
			swap_tile = self.swap_tiles.rooms[gen_data.room_id]
		elseif gen_data.task_id and self.swap_tiles.tasks[gen_data.task_id] then
			swap_tile = self.swap_tiles.tasks[gen_data.task_id]
		end
		
		return swap_tile
	end
	
	local function SortSnowTiles(saved_tiles, skip_shuffle)
		_snowtiles = saved_tiles or {}
		
		if #_snowtiles == 0 then
			local temp_tiles = {}
			
			for i = 0, WIDTH * HEIGHT - 1 do
				local level = _snowgrid:GetDataAtIndex(i)
				
				if level and level > 0 then
					local tx, ty = _snowgrid:GetXYFromIndex(i)
					local current_tile = _map:GetTile(tx, ty)
					
					if current_tile == WORLD_TILES.POLAR_SNOW or (saved_tiles and table.contains(saved_tiles)) then
						table.insert(temp_tiles, {index = i, level = level})
					end
				end
			end
			
			for i, tile in ipairs(temp_tiles) do
				table.insert(_snowtiles, tile.index)
			end
		end
		
		--table.sort(_snowtiles, function(a, b) return a.level < b.level end)
		-- ^ Cool but doesn't feel very organic :(
		
		if not skip_shuffle then
			shuffleArray(_snowtiles)
			_tileindex = 1
		end
	end
	
	local function TestSwapTile(tx, ty, current_tile)
		local can_swap = self:IsTileMelting(tx, ty)
		local new_tile = undertile and undertile:GetTileUnderneath(tx, ty)
			or GetSwapTile(_map:GetTopologyIDAtPoint(_map:GetTileCenterPoint(tx, ty)))
		
		return can_swap, new_tile
	end
	
	-- [ Initialization ] --
	
	local function InitializeDataGrids(_, grid)
		if _snowgrid then
			return
		end
		
		WIDTH, HEIGHT = _map:GetSize()
		_snowgrid = DataGrid(WIDTH, HEIGHT)
		
		for i, ispolar in pairs(grid) do
			if ispolar then
				table.insert(_gradient_indeces, i)
				SetSnowLevel(i, 1)
			end
		end
		
		GenerateOutterGradient(OUTTER_GRADIENT_DEPTH)
		GenerateInnerGradient()
		SortSnowTiles(_snowtiles, _snowtiles ~= nil)
		
		self:StartUpdates()
		
		inst:RemoveEventCallback("winterlands_initialized", InitializeDataGrids)
	end
	
	inst:ListenForEvent("winterlands_initialized", InitializeDataGrids)
	
	-- [ Methods ] --
	
	function self:GetDataAtPoint(x, y, z)
		return _snowgrid and _snowgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end
	
	function self:GetDataAtTile(tx, ty)
		return _snowgrid and _snowgrid:GetDataAtPoint(tx, ty) or 0
	end
	
	function self:GetMaxDepth()
		return _max_depth
	end
	
	function self:IsTileMelting(tx, ty)
		local level = self:GetDataAtTile(tx, ty)
		if not level or inst.state.temperature <= TUNING.POLAR_SNOW_MELT_TEMP then
			return false
		end
		
		local ratio = math.clamp((inst.state.temperature - TUNING.POLAR_SNOW_MELT_TEMP) / (TUNING.POLAR_SNOW_MELT_TEMP_MAX - TUNING.POLAR_SNOW_MELT_TEMP), 0, 1)
		
		return level <= ratio * self:GetMaxDepth()
	end
	
	function self:IsOriginalSnowTile(tx, ty)
		local index = _snowgrid and _snowgrid:GetIndex(tx, ty)
		
		return index and _snowtiles and table.contains(_snowtiles, index)
	end
	
	-- Updates
	
	function self:StartUpdates()
		if _tiletask == nil then
			_tiletask = inst:DoPeriodicTask(TILES_BATCH_PERIOD, function() self:UpdateSnowTiles() end)
		end
	end	
	
	function self:StopUpdates()
		if _tiletask then
			_tiletask:Cancel()
			_tiletask = nil
		end
	end
	
	function self:UpdateSnowTiles(batchsize)
		if #_snowtiles == 0 then
			return
		end
		
		local batched = 0
		local start_index = _tileindex
		
		while batched < (batchsize or TILES_PER_BATCH) do
			if _tileindex > #_snowtiles then
				SortSnowTiles(_snowtiles)
			end
			if _tileindex == start_index and batched > 0 then
				break
			end
			
			local i = _snowtiles[_tileindex]
			local tx, ty = _snowgrid:GetXYFromIndex(i)
			
			if tx and ty then
				local current_tile = _map:GetTile(tx, ty)
				local can_swap, new_tile = TestSwapTile(tx, ty, current_tile)
				
				if can_swap and new_tile then
					if current_tile == WORLD_TILES.POLAR_SNOW then
						_map:SetTile(tx, ty, new_tile)
					end
				elseif not can_swap and current_tile ~= WORLD_TILES.POLAR_SNOW then
					local can_revert = not GROUND_FLOORING[current_tile] and not GROUND_ISTEMPTILE[current_tile]
					
					if can_revert then
						_map:SetTile(tx, ty, WORLD_TILES.POLAR_SNOW)
						
						if undertile then
							undertile:SetTileUnderneath(tx, ty, current_tile)
						end
						
						local block_range = TUNING.SNOW_PLOW_RANGES.FROSTFALL or 0
						local duration = GetPolarPlowDuration(inst, nil, "frostfall")
						if duration > 0 and block_range > 0 then
							local pt = Vector3(_map:GetTileCenterPoint(tx, ty))
							SpawnPolarSnowBlocker(pt, block_range, duration, inst)
						end
					end
				end
			end
			
			_tileindex = _tileindex + 1
			batched = batched + 1
		end
	end
	
	-- [ Save / Load ] --
	
	function self:OnSave()
		return {
			snowtiles = _snowtiles,
			tileindex = _tileindex
		}
	end
	
	function self:OnLoad(data)
		if data == nil then
			return
		end
		
		_snowtiles = data.snowtiles or _snowtiles
		_tileindex = data.tileindex or _tileindex
	end
	
	function self:LongUpdate(dt)
		inst:DoTaskInTime(0, function() -- Temperature has yet to update
			local missed = math.min(#_snowtiles, math.floor(dt / TILES_BATCH_PERIOD))
			
			if _tiletask and missed > 0 then
				self:UpdateSnowTiles(TILES_PER_BATCH * missed)
			end
		end)
	end
end)