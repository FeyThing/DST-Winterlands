local WIDTH, HEIGHT
local MAX_GRADIENT_DEPTH = 8

return Class(function(self, inst)
    assert(inst.ismastersim, "Snowstorm Manager should not exist on the client!")
    
	-- [ Public fields ] --
	self.inst = inst

	-- [ Private fields ] --
	local _map = inst.Map
	local _snowstormgrid
	local _gradient_indeces = {  } -- Indeces for the next iteration of the gradient

	-- [ Functions ] --
	local function SetStormLevel(index, level)
		if 0 <= index and index < WIDTH*HEIGHT then
			_snowstormgrid:SetDataAtIndex(index, math.clamp(level, 0, 1))
		end
	end

	local function GenerateSnowStormGradient(depth)
		assert(depth > 0, "Snowstorm gradient depth must be positive!")

		local new_gradient_indeces = {  }
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _snowstormgrid:GetXYFromIndex(i)

			for x = -1, 1 do
				for y = -1, 1 do
					local nx, ny = ox + x, oy + y
					local level = self:GetDataAtTile(nx, ny)
					if level == 0 then
						SetStormLevel(_snowstormgrid:GetIndex(nx, ny), depth / (MAX_GRADIENT_DEPTH + 1)) -- Linear falloff based on how far from the main island tile we are
						table.insert(new_gradient_indeces, _snowstormgrid:GetIndex(nx, ny))
					end
				end
			end
		end

		_gradient_indeces = new_gradient_indeces

		depth = depth - 1
		if depth > 0 and next(_gradient_indeces) ~= nil then
			GenerateSnowStormGradient(depth)
		end
	end

	-- [ Initialization ] --
	local function InitializeDataGrids()
		if _snowstormgrid then return end

		WIDTH, HEIGHT = _map:GetSize()
		_snowstormgrid = DataGrid(WIDTH, HEIGHT)

		local polartiles = inst.components.winterlands_manager:GetGrid().grid
		for i, ispolar in pairs(polartiles) do
			if ispolar then
				table.insert(_gradient_indeces, i)
				SetStormLevel(i, 1)
			end
		end

		GenerateSnowStormGradient(MAX_GRADIENT_DEPTH)

		inst:RemoveEventCallback("winterlands_initialized", InitializeDataGrids)
	end

	inst:ListenForEvent("winterlands_initialized", InitializeDataGrids)

    -- [ Methods ] --
	function self:GetDataAtPoint(x, y, z)
		return _snowstormgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end

	function self:GetDataAtTile(tx, ty)
		return _snowstormgrid:GetDataAtPoint(tx, ty) or 0
	end
end)
