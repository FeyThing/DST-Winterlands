local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddPrefabPostInit = ENV.AddPrefabPostInit

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
			if not (TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst)) then
				local birb = SpawnPrefab(current_tile == WORLD_TILES.OCEAN_POLAR and "puffin" or "robin_winter")
				birb.Transform:SetPosition(x, y, z)
				birb.sg:HasStateTag("glide")
			end
			
			inst:Remove()
		end
	end
end

local function OnPolarstormChanged(inst, active)
	if active and TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst) then
		if inst._leavestormtask == nil then
			inst._leavestormtask = inst:DoPeriodicTask(1 + math.random() * 3, function()
				if inst.sg and not inst.sg:HasStateTag("flight") then
					inst:PushEvent("flyaway")
				end
			end)
		end
	elseif inst._leavestormtask then
		inst._leavestormtask:Cancel()
		inst._leavestormtask = nil
	end
end

for i, v in ipairs(BIRDS) do
	AddPrefabPostInit(v, function(inst)
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
		else
			inst.onpolarstormchanged = function(src, data)
				if data and data.stormtype == STORM_TYPES.POLARSTORM then
					OnPolarstormChanged(inst, data.setting)
				end
			end
			
			inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
		end
	end)
end

--

local OldOnRead
local function OnRead(inst, reader, ...)
	if reader and TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(reader) then
		return false
	end
	
	if OldOnRead then
		return OldOnRead(inst, reader, ...)
	end
end

AddPrefabPostInit("book_birds", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book then
		if OldOnRead == nil then
			OldOnRead = inst.components.book.onread
		end
		
		inst.components.book:SetOnRead(OnRead)
	end
end)