local WIDTH, HEIGHT
local MAX_GRADIENT_DEPTH = 8

return Class(function(self, inst)
    assert(inst.ismastersim, "Polarsnow Manager should not exist on the client!")
    
	-- [ Public fields ] --
	self.inst = inst

	-- [ Private fields ] --
	local _map = inst.Map
	local _snowgrid
	local _gradient_indeces = {  } -- Indeces for the next iteration of the gradient

	-- [ Functions ] --
	local function SetSnowLevel(index, level)
		if 0 <= index and index < WIDTH*HEIGHT then
			_snowgrid:SetDataAtIndex(index, math.clamp(level, 0, 1))
		end
	end

	local function GenerateSnowGradient(depth)
		assert(depth > 0, "Snow gradient depth must be positive!")

		local new_gradient_indeces = {  }
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _snowgrid:GetXYFromIndex(i)

			for x = -1, 1 do
				for y = -1, 1 do
					local nx, ny = ox + x, oy + y
					local level = self:GetDataAtTile(nx, ny)
					if level == 0 then
						SetSnowLevel(_snowgrid:GetIndex(nx, ny), depth / (MAX_GRADIENT_DEPTH + 1)) -- Linear falloff based on how far from the main island tile we are
						table.insert(new_gradient_indeces, _snowgrid:GetIndex(nx, ny))
					end
				end
			end
		end

		_gradient_indeces = new_gradient_indeces

		depth = depth - 1
		if depth > 0 and next(_gradient_indeces) ~= nil then
			GenerateSnowGradient(depth)
		end
	end

	-- [ Initialization ] --
	local function InitializeDataGrids()
		if _snowgrid then return end

		WIDTH, HEIGHT = _map:GetSize()
		_snowgrid = DataGrid(WIDTH, HEIGHT)

		local polartiles = inst.components.winterlands_manager:GetGrid().grid
		for i, ispolar in pairs(polartiles) do
			if ispolar then
				table.insert(_gradient_indeces, i)
				SetSnowLevel(i, 1)
			end
		end

		GenerateSnowGradient(MAX_GRADIENT_DEPTH)

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
end)
