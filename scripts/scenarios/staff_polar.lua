local function TriggerTrap(inst, scenariorunner, data)
	local player = data and data.player
	
	if player and player.components.sanity then
		local x, y, z = player.Transform:GetWorldPosition()
		player.components.sanity:SetPercent(0)
		
		local dtheta = TWOPI / 4
		local thetaoffset = math.random() * TWOPI
		
		for theta = math.random() * dtheta, TWOPI, dtheta do
			local x1 = x + 8 * math.cos(theta)
			local z1 = z + 8 * math.sin(theta)
			
			inst:DoTaskInTime(math.random() * 0.5, function()
				local shadow = SpawnPrefab("shadow_icicler")
				shadow.Transform:SetPosition(x1, y, z1)
			end)
		end
	end
	
	if scenariorunner then
		scenariorunner:ClearScenario()
	end
end

local function OnLoad(inst, scenariorunner)
	inst.AnimState:SetFinalOffset(-3)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.WORLD)
	
	inst.scene_putininventoryfn = function(inst, owner)
		TriggerTrap(inst, scenariorunner, {player = owner and owner.components.inventoryitem and owner.components.inventoryitem:GetGrandOwner() or owner})
	end
	
	inst:ListenForEvent("onputininventory", inst.scene_putininventoryfn)
end

local function OnDestroy(inst)
	if inst.scene_putininventoryfn then
		inst:RemoveEventCallback("onputininventory", inst.scene_putininventoryfn)
		inst.scene_putininventoryfn = nil
	end
end

return {
	OnLoad = OnLoad,
	OnDestroy = OnDestroy,
}