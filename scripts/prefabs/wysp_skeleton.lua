local function OnNewObjectFn(inst, obj)
	inst:ListenForEvent("onremove", function(obj)
		table.removearrayvalue(inst.components.objectspawner.objects, obj)
	end, obj)
end

local TRYSPAWN_CANT_TAGS = {"INLIMBO"}

local function TrySpawn(inst)
	if #inst.components.objectspawner.objects <= 0 then
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 1, nil, TRYSPAWN_CANT_TAGS)
		
		for i, v in ipairs(ents) do
			if v.components.workable and v.components.workable:GetWorkAction() ~= ACTIONS.NET then
				v.components.workable:Destroy(v)
			end
		end
		
		local skeleton = inst.components.objectspawner:SpawnObject("skeleton")
		skeleton.Transform:SetPosition(x, y, z)
		skeleton.AnimState:PlayAnimation("idle6")
		skeleton.animnum = 6
	end
	
	inst.reset_wysp_quest = false
end

local function OnSave(inst, data)
	data.reset_wysp_quest = inst.reset_wysp_quest
end

local function OnLoad(inst, data)
	if data and data.reset_wysp_quest ~= nil then
		inst.reset_wysp_quest = data.reset_wysp_quest
	end
end

local function OnLoadPostPass(inst)
	if inst.reset_wysp_quest then
		TrySpawn(inst)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	
	inst:AddTag("CLASSIFIED")
	
	inst.reset_wysp_quest = true
	
	inst:AddComponent("objectspawner")
	inst.components.objectspawner.onnewobjectfn = OnNewObjectFn
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass
	
	return inst
end

return Prefab("wysp_skeleton_marker", fn)