-- LukaS: This is a universal component holding tiles that belong to the winter island
-- Holds information for both the server and the client

local WIDTH, HEIGHT

return Class(function(self, inst)
	-- [ Public fields ] --
	self.inst = inst

	-- [ Private fields ] --
	local _map = inst.Map
	local _winterlands_grid
    
	-- [ Initialization ] --
	local function InitializeDataGrids()
		if _winterlands_grid then return end

		WIDTH, HEIGHT = _map:GetSize()
		_winterlands_grid = DataGrid(WIDTH, HEIGHT)

		inst:RemoveEventCallback("worldmapsetsize", InitializeDataGrids)
	end

	inst:ListenForEvent("worldmapsetsize", InitializeDataGrids)

    -- [ Methods ] --
    function self:GetGrid()
        return _winterlands_grid
    end

    function self:IsWinterlandsAtTile(tx, ty)
        return _winterlands_grid:GetDataAtPoint(tx, ty)
    end

    function self:IsWinterlandsAtPoint(x, y, z)
        local tx, ty = _map:GetTileCoordsAtPoint(x, y, z)
        return _winterlands_grid:GetDataAtPoint(tx, ty)
    end

	function self:Initialize()
		for x = 0, WIDTH - 1 do
			for y = 0, HEIGHT - 1 do
				local index = _winterlands_grid:GetIndex(x, y)
				local tx, ty, tz = _map:GetTileCenterPoint(x, y)

				if IsInPolarAtPoint(tx, ty, tz) then
					_winterlands_grid:SetDataAtIndex(index, true)
				end
			end
		end

		inst:PushEvent("winterlands_initialized", _winterlands_grid.grid)
	end
end)