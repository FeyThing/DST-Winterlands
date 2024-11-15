-- LukaS: This is a universal component holding tiles that belong to the winter island
-- Holds information for both the server and the client

local WIDTH, HEIGHT

return Class(function(self, inst)
	-- [ Public fields ] --
	self.inst = inst

	-- [ Private fields ] --
	local _map = inst.Map
	local _winterlands_grid

	local wasloaded = false
    
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

	-- [ Saving/Loading ] --
	function self:OnSave()
		return ZipAndEncodeSaveData(_winterlands_grid:Save())
	end

	function self:OnLoad(data)
		if data then
			data = DecodeAndUnzipSaveData(data)
			_winterlands_grid:Load(data)
			wasloaded = true
        elseif not wasloaded then -- If no saved data is being loaded, generate the default grid
			for x = 0, WIDTH - 1 do
				for y = 0, HEIGHT - 1 do
					local index = _winterlands_grid:GetIndex(x, y)
					local tx, ty, tz = _map:GetTileCenterPoint(x, y)
	
					if IsInPolarAtPoint(tx, ty, tz) then
                        _winterlands_grid:SetDataAtIndex(index, true)
					end
				end
			end

            inst:PushEvent("winterlands_initialized")
		end
	end
end)