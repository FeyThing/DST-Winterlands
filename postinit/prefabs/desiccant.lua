local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local DESICCANTS = {"desiccant", "desiccantboosted"}

local function DoPolarSnowRate(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
	if owner == nil then
		return
	end
	
	local x, y, z = owner.Transform:GetWorldPosition()
	local in_snow = TheWorld.Map:IsPolarSnowAtPoint(x, y, z, true) and not TheWorld.Map:IsPolarSnowBlocked(x, y, z)
	
	-- Frozen Wetness is blocked when carrying not fully wet desiccant, but it gets wet faster itself
	if in_snow and inst.components.inventoryitemmoisture and not HasPolarDebuffImmunity(owner, nil, true) then
		local delta = inst.prefab == "desiccantboosted" and TUNING.DESICCANTBOOSTED_POLARSNOW_DELTA or TUNING.DESICCANT_POLARSNOW_DELTA
		inst.components.inventoryitemmoisture:DoDelta(delta)
	end
end

for i, prefab in ipairs(DESICCANTS) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		local rate = prefab == "desiccantboosted" and TUNING.DESICCANTBOOSTED_POLARSNOW_RATE or TUNING.DESICCANT_POLARSNOW_RATE
		inst._polarsnowtask = inst:DoPeriodicTask(rate, DoPolarSnowRate)
	end)
end