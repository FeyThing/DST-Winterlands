local WIDTH, HEIGHT
local MAX_GRADIENT_DEPTH = 4

local SEASON_STRENGTH_MULT = {
    autumn = 2,
    winter = 1,
    spring = 2,
    summer = 4
}

local SEASON_STRENGTH_ADDITION = {
    autumn = -1,
    winter = 0,
    spring = -1,
    summer = -3
}

return Class(function(self, inst)
    assert(inst.ismastersim, "Polar Ice Manager should not exist on the client!")
    
	-- [ Public fields ] --
	self.inst = inst

	-- [ Private fields ] --
	local _map = inst.Map
	local _icestrengthgrid -- Stores [0 - 1] values defining the base strength of ice tiles in the world
	local _gradient_indeces = {  } -- Indeces for the next iteration of the gradient

	local wasloaded = false

	-- [ Functions ] --
	local function SetIceStrength(index, level)
		if 0 <= index and index < WIDTH*HEIGHT then
			_icestrengthgrid:SetDataAtIndex(index, math.clamp(level, 0, 1))
		end
	end

	local function GenerateIceGradient(depth)
		assert(depth > 0, "Ice gradient depth must be positive!")

		local new_gradient_indeces = {  }
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _icestrengthgrid:GetXYFromIndex(i)

			for x = -1, 1 do
				for y = -1, 1 do
					local level = _icestrengthgrid:GetDataAtPoint(ox + x, oy + y) or 0
					if level == 0 then
						_icestrengthgrid:SetDataAtPoint(ox + x, oy + y, depth / MAX_GRADIENT_DEPTH + 1) -- Linear falloff based on how far from the main island tile we are
						table.insert(new_gradient_indeces, _icestrengthgrid:GetIndex(ox + x, oy + y))
					end
				end
			end
		end

		_gradient_indeces = new_gradient_indeces

		depth = depth - 1
		if depth > 0 and next(_gradient_indeces) ~= nil then
			GenerateIceGradient(depth)
		end
	end

	-- [ Initialization ] --
	local function InitializeDataGrids()
		if _icestrengthgrid then return end

		WIDTH, HEIGHT = _map:GetSize()
		_icestrengthgrid = DataGrid(WIDTH, HEIGHT) -- This grid contains the snowstorm information

		inst:RemoveEventCallback("worldmapsetsize", InitializeDataGrids)
	end

	inst:ListenForEvent("worldmapsetsize", InitializeDataGrids)

    -- [ Methods ] --
	function self:GetBaseAtPoint(x, y, z)
		return _icestrengthgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end

	function self:GetVariabledAtPoint(x, y, z)
        local val = self:GetBaseAtPoint(x, y, z)
		local season = TheWorld.state.season
		return val * SEASON_STRENGTH_MULT[season] + SEASON_STRENGTH_ADDITION[season]
	end

	-- [ Saving/Loading ] --
	function self:OnSave()
		return ZipAndEncodeSaveData(_icestrengthgrid:Save())
	end

	function self:OnLoad(data)
		if data then
			data = DecodeAndUnzipSaveData(data)
			_icestrengthgrid:Load(data)
			wasloaded = true
        elseif not wasloaded then -- If no saved data is being loaded, generate the default grid
			for x = 0, WIDTH - 1 do
				for y = 0, HEIGHT - 1 do
					local index = _icestrengthgrid:GetIndex(x, y)
					local tx, ty, tz = _map:GetTileCenterPoint(x, y)
	
					if IsInPolarAtPoint(tx, ty, tz) and _map:GetTile(x, y) ~= WORLD_TILES.POLAR_ICE then
                        SetIceStrength(index, 1) -- Solid winterlands ground tiles have max ice strength that is then expanded from using a gradient
						table.insert(_gradient_indeces, index)
					end
				end
			end

			GenerateIceGradient(MAX_GRADIENT_DEPTH)
		end
	end
end)
