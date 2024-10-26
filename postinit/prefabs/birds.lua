local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local BIRDS = {"robin", "crow", "canary"}

local function OnInit(inst)
	local cage = inst.components.occupier and inst.components.occupier:GetOwner()
	if cage == nil and not inst.components.inventoryitem:IsHeld() and inst.sg.currentstate.name == "glide" then
		local x, y, z = inst.Transform:GetWorldPosition()
		local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
		local current_tile = TheWorld.Map:GetTile(tile_x, tile_y)
		
		if IsInPolar(inst) or current_tile == WORLD_TILES.OCEAN_POLAR then
			local birb = SpawnPrefab("puffin")
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
		
		inst:DoTaskInTime(0, OnInit)
	end)
end