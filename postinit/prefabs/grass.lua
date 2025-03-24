local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldOnTransplantFn
local makemorphable

local function OnTransplantFn(inst, ...)
	local _makemorphable = makemorphable -- Keeping this here for simpler mod compat
	
	if IsInPolar(inst) then
		local grass = SpawnPrefab("grass_polar")
		grass.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		if grass.components.pickable then
			grass.components.pickable:OnTransplant()
		end
		if TheWorld.components.lunarthrall_plantspawner and grass:HasTag("lunarplant_target") then
			TheWorld.components.lunarthrall_plantspawner:setHerdsOnPlantable(grass)
		end
		
		-- Funny delayed Brightshade herd task would cause a crash, don't remove too early
		inst:Hide()
		inst:DoTaskInTime(0, function()
			if inst.components.herdmember and inst.components.herdmember.task then
				inst.components.herdmember.task:Cancel()
				inst.components.herdmember.task = nil
			end
			
			inst:Remove()
		end)
	elseif OldOnTransplantFn then
		OldOnTransplantFn(inst, ...)
	end
end

ENV.AddPrefabPostInit("grass", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.pickable then
		if OldOnTransplantFn == nil then
			OldOnTransplantFn = inst.components.pickable.ontransplantfn
			makemorphable = PolarUpvalue(OldOnTransplantFn, "makemorphable")
		end
		
		inst.components.pickable.ontransplantfn = OnTransplantFn
	end
end)

--

local function DoPolarUpdate(inst)
	local inpolar = IsInPolar(inst)
	
	if (inst.inpolar or false) ~= inpolar then
		if inpolar then
			inst.AnimState:SetBank("grass_tall")
			inst.AnimState:SetBuild("grass_polar")
		else
			inst.AnimState:SetBank("grass")
			inst.AnimState:SetBuild("grass1")
		end
		
		inst.inpolar = inpolar
	end
end

ENV.AddPrefabPostInit("dug_grass_placer", function(inst)
	inst.DoPolarUpdate = DoPolarUpdate
	
	inst._polarupdate = inst:DoPeriodicTask(FRAMES, inst.DoPolarUpdate)
end)