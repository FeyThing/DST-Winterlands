local WIDTH, HEIGHT

return Class(function(self, inst)
    assert(inst.ismastersim, "Snowstorm Manager should not exist on the client!")
    
	-- [ Public fields ] --
	self.inst = inst

	-- [ Private fields ] --
	local _map = inst.Map
	local _snowstormgrid
	local _gradient_indeces = {  } -- Indeces for the next iteration of the gradient

	local wasloaded = false

	-- [ Functions ] --
	local function SetStormLevel(index, level)
		if 0 <= index and index < WIDTH*HEIGHT then
			_snowstormgrid:SetDataAtIndex(index, math.clamp(level, 0, 1))
		end
	end

	local function GenerateSnowStormGradient(depth, maxdepth)
		assert(depth > 0, "Snowstorm gradient depth must be positive!")

		local new_gradient_indeces = {  }
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _snowstormgrid:GetXYFromIndex(i)

			for x = -1, 1 do
				for y = -1, 1 do
					local level = _snowstormgrid:GetDataAtPoint(ox + x, oy + y) or 0
					if level == 0 then
						_snowstormgrid:SetDataAtPoint(ox + x, oy + y, depth / maxdepth) -- Linear falloff based on how far from the main island tile we are
						table.insert(new_gradient_indeces, _snowstormgrid:GetIndex(ox + x, oy + y))
					end
				end
			end
		end

		_gradient_indeces = new_gradient_indeces

		depth = depth - 1
		if depth > 0 and next(_gradient_indeces) ~= nil then
			GenerateSnowStormGradient(depth, maxdepth)
		end
	end

	-- [ Initialization ] --
	local function InitializeDataGrids()
		if _snowstormgrid then return end

		WIDTH, HEIGHT = _map:GetSize()
		_snowstormgrid = DataGrid(WIDTH, HEIGHT) -- This grid contains the snowstorm information

		inst:RemoveEventCallback("worldmapsetsize", InitializeDataGrids)
	end

	inst:ListenForEvent("worldmapsetsize", InitializeDataGrids)

    -- [ Methods ] --
	function self:GetAtPoint(x, y, z)
		return _snowstormgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end

	-- [ Saving/Loading ] --
	function self:OnSave()
		return ZipAndEncodeSaveData(_snowstormgrid:Save())
	end

	function self:OnLoad(data)
		if data then
			data = DecodeAndUnzipSaveData(data)
			_snowstormgrid:Load(data)
			wasloaded = true
        elseif not wasloaded then -- If no saved data is being loaded, generate the default grid
			for x = 0, WIDTH - 1 do
				for y = 0, HEIGHT - 1 do
					local index = _snowstormgrid:GetIndex(x, y)
					local tile = _map:GetTile(x, y)
					local level = 0
	
					if tile == WORLD_TILES.POLAR_ICE or
					tile == WORLD_TILES.POLAR_SNOW or
					tile == WORLD_TILES.POLAR_CAVES then
						level = 1
						table.insert(_gradient_indeces, index)
					end
					
					--[[ADM: I would suggest to change the above to this when you're ready for it. We (or other mods) could be tempted to have other classic turfs onto the island ^
							 if you want to fetch it from further away, remove 0 or a specific larger range :)
							 
					local _x, _y, _z = TheWorld.Map:GetTileCenterPoint(x, y)
					if IsInPolarAtPoint(_x, _y, _z, 0) then
						level = 1
						table.insert(_gradient_indeces, index)
					end]]
	
					SetStormLevel(index, level)
				end
			end

			GenerateSnowStormGradient(5, 5)
		end
	end
end)
