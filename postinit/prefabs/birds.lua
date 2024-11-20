local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local BIRDS = {"robin", "crow", "canary", "puffin", "robin_winter"}

local OldSpawnPrefabChooser
local function SpawnPrefabChooser(inst, ...)
	local prefab
	
	if OldSpawnPrefabChooser then
		prefab = OldSpawnPrefabChooser(inst, ...)
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil and prefab and type(prefab) == "string" and prefab:find("seed") then
		return nil
	else
		return prefab
	end
end

local function OnInit(inst)
	local cage = inst.components.occupier and inst.components.occupier:GetOwner()
	local state = inst.sg and inst.sg.currentstate.name
	
	if cage == nil and not inst.components.inventoryitem:IsHeld() and (state == "glide" or state == "delay_glide") then
		local x, y, z = inst.Transform:GetWorldPosition()
		local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
		local current_tile = TheWorld.Map:GetTile(tile_x, tile_y)
		
		if GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil or current_tile == WORLD_TILES.OCEAN_POLAR then
			local birb = SpawnPrefab(current_tile == WORLD_TILES.OCEAN_POLAR and "puffin" or "robin_winter")
			birb.Transform:SetPosition(x, y, z)
			birb.sg:HasStateTag("glide")
			
			inst:Remove()
		end
	end
end

for i, v in ipairs(BIRDS) do
	ENV.AddPrefabPostInit(v, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		local spawnerprefab = inst.components.periodicspawner and inst.components.periodicspawner.prefab
		if spawnerprefab and type(spawnerprefab) == "function" then
			if OldSpawnPrefabChooser == nil then
				OldSpawnPrefabChooser = spawnerprefab
			end
			
			inst.components.periodicspawner.prefab = SpawnPrefabChooser
		end
		
		if v ~= "robin_winter" and v ~= "puffin" then
			inst:DoTaskInTime(0, OnInit)
		end
	end)
end