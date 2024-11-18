-- This only helps to collide with things while forming the ice tiles, but in the future it would be nice to form them visually using this too

local PLATFORM_TAGS = {"walkableplatform"}

local function OnInit(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 5, PLATFORM_TAGS)
	
	for i, platform in ipairs(ents) do
		if platform.components.boatphysics then
			local px, py, pz = platform.Transform:GetWorldPosition()
			local normalx, normalz = VecUtil_Normalize(px - x, pz - z)
			
			platform.components.boatphysics:ApplyForce(normalx, normalz, 5)
		end
	end
end

local function OnTimerDone(inst, data)
	if data.name == "do_finish" then
		inst:Remove()
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("ignorewalkableplatforms")
	
	--[[MakeWaterObstaclePhysics(inst, 4, 1, 1)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.ITEMS)
	inst.Physics:CollidesWith(COLLISION.OBSTACLES)]]
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("do_finish", 0.5)
	
	inst.persists = false
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:DoTaskInTime(0, OnInit)
	
	return inst
end

return Prefab("polarice_terraformer", fn)