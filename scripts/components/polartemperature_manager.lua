local WIDTH, HEIGHT
local MAX_GRADIENT_DEPTH = 8

return Class(function(self, inst)
	-- [ Public fields ] --
	self.inst = inst

	-- [ Private fields ] --
	local _map = inst.Map
	local _tempgrid -- Hold values [0, 1] between farthest, closest to the island
	local _gradient_indeces = {  } -- Indeces for the next iteration of the gradient

	-- [ Functions ] --
	local function SetTempFactor(index, level)
		if 0 <= index and index < WIDTH*HEIGHT then
			_tempgrid:SetDataAtIndex(index, math.clamp(level, 0, 1))
		end
	end

	local function GenerateTempGradient(depth)
		assert(depth > 0, "Temperature gradient depth must be positive!")

		local new_gradient_indeces = {  }
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _tempgrid:GetXYFromIndex(i)

			for x = -1, 1 do
				for y = -1, 1 do
					local nx, ny = ox + x, oy + y
					local level = self:GetDataAtTile(nx, ny)
					if level == 0 then
						SetTempFactor(_tempgrid:GetIndex(nx, ny), depth / (MAX_GRADIENT_DEPTH + 1)) -- Linear falloff based on how far from the main island tile we are
						table.insert(new_gradient_indeces, _tempgrid:GetIndex(nx, ny))
					end
				end
			end
		end

		_gradient_indeces = new_gradient_indeces

		depth = depth - 1
		if depth > 0 and next(_gradient_indeces) ~= nil then
			GenerateTempGradient(depth)
		end
	end

	-- [ Initialization ] --
	local function InitializeDataGrids(_, grid)
		if _tempgrid then return end

		WIDTH, HEIGHT = _map:GetSize()
		_tempgrid = DataGrid(WIDTH, HEIGHT)

		for i, ispolar in pairs(grid) do
			if ispolar then
				table.insert(_gradient_indeces, i)
				SetTempFactor(i, 1)
			end
		end

		GenerateTempGradient(MAX_GRADIENT_DEPTH)

		inst:RemoveEventCallback("winterlands_initialized", InitializeDataGrids)
	end

	inst:ListenForEvent("winterlands_initialized", InitializeDataGrids)

    -- [ Methods ] --
	function self:GetDataAtPoint(x, y, z)
		return _tempgrid and _tempgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end

	function self:GetDataAtTile(tx, ty)
		return _tempgrid and _tempgrid:GetDataAtPoint(tx, ty) or 0
	end
end)
