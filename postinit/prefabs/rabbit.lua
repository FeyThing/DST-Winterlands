local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function BecomePolarRabbit(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 32) and (inst.components.timer == nil or not inst.components.timer:TimerExists("forcenightmare")) then
		inst.AnimState:SetBuild("rabbit_winter_build")
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName("rabbit_winter")
		end
		
		return true
	end
end

local OldOnIsWinter
local function OnIsWinter(inst, iswinter, ...)
	local is_polar = inst:BecomePolarRabbit()
	
	if not is_polar and OldOnIsWinter then
		OldOnIsWinter(inst, iswinter, ...)
	end
end

ENV.AddPrefabPostInit("rabbit", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.OnEntityWake and OldOnIsWinter == nil then
		OldOnIsWinter = PolarUpvalue(inst.OnEntityWake, "OnIsWinter")
		
		if OldOnIsWinter then
			PolarUpvalue(inst.OnEntityWake, "OnIsWinter", OnIsWinter)
		end
	end
	
	inst.BecomePolarRabbit = BecomePolarRabbit
	
	inst:DoTaskInTime(0, inst.BecomePolarRabbit)
end)