local ICICLE_TAGS = {"bigicicle"}

local function TriggerTrap(inst, scenariorunner)
	local x, y, z = inst.Transform:GetWorldPosition()
	local icicles = TheSim:FindEntities(x, y, z, 10, ICICLE_TAGS)
	
	for i, icicle in ipairs(icicles) do
		local dist = math.sqrt(icicle:GetDistanceSqToPoint(x, y, z))
		local break_time = 0.5 * (dist / 12)
		
		icicle:DoTaskInTime(break_time, function()
			if icicle:IsValid() and icicle.StartBreaking then
				icicle:StartBreaking()
			end
		end)
	end
	
	if scenariorunner then
		scenariorunner:ClearScenario()
	end
end

local function OnLoad(inst, scenariorunner)
	inst.scene_putininventoryfn = function(inst, owner)
		TriggerTrap(inst, scenariorunner)
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