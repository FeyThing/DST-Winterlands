local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldOnPreBuilt
local function OnPreBuilt(inst, builder, materials, recipe, ...)
	if builder and recipe and recipe.tech_ingredients then
		for i, v in ipairs(recipe.tech_ingredients) do
			if v.type == "polarsnow_material" then
				local block_range = TUNING.SNOW_PLOW_RANGES.USED or 0
				
				if block_range > 0 then
					local x, y, z = builder.Transform:GetWorldPosition()
					local blocker = SpawnPrefab("snowwave_blocker")
					blocker.Transform:SetPosition(x, y, z)
					
					if blocker.SetSnowBlockRange then
						blocker:SetSnowBlockRange(block_range)
					end
				end
				
				break
			end
		end
	end
	
	if OldOnPreBuilt then
		OldOnPreBuilt(inst, builder, materials, recipe, ...)
	end
end

ENV.AddPrefabPostInit("snowball_item", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.onPreBuilt and OldOnPreBuilt == nil then
		OldOnPreBuilt = inst.onPreBuilt
	end
	
	inst.onPreBuilt = OnPreBuilt
end)

--

local DetachRollingFx
local _GetNextSize
local SNOW_TO_GROW
local _SnowballTooBigWarning

local Old_GrowSnowballSize
local function _GrowSnowballSize(inst, doer, ...)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:IsPolarSnowAtPoint(x, 0, z, true) and inst.components.snowmandecoratable
		and DetachRollingFx and SNOW_TO_GROW and _SnowballTooBigWarning then
		
		if inst._nosnowtask then
			inst._nosnowtask:Cancel()
			inst._nosnowtask = nil
		end
		
		local oldsize = inst.components.snowmandecoratable:GetSize()
		if oldsize == "large" then
			inst._pushingtask:Cancel()
			inst._pushingtask = inst:DoPeriodicTask(8, _SnowballTooBigWarning, 0.8, doer)
		else
			inst.snowaccum = inst.snowaccum + 1
			
			if inst.snowaccum >= (SNOW_TO_GROW[oldsize] or 0) then
				local newsize = _GetNextSize(oldsize)
				if oldsize ~= newsize then
					inst:SetSize(newsize, true)
					inst.snowaccum = 0
				end
				if newsize == "large" then
					inst._pushingtask:Cancel()
					inst._pushingtask = inst:DoPeriodicTask(8, _SnowballTooBigWarning, 1.6, doer)
				end
			end
		end
		if inst._rollingfx == nil then
			inst._rollingfx = SpawnPrefab("snowball_rolling_fx")
			inst._rollingfx.entity:SetParent(inst.entity)
			inst._rollingfx.AnimState:MakeFacingDirty()
			inst._rollingfx:ListenForEvent("onremove", DetachRollingFx, inst)
			inst._rollingfx:ListenForEvent("enterlimbo", DetachRollingFx, inst)
		end
		
	elseif Old_GrowSnowballSize then
		Old_GrowSnowballSize(inst, doer, ...)
	end
end

ENV.AddPrefabPostInit("snowman", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if Old_GrowSnowballSize == nil and inst.components.pushable then
		Old_GrowSnowballSize = PolarUpvalue(inst.components.pushable.onstartpushingfn, "_GrowSnowballSize")
		
		DetachRollingFx = PolarUpvalue(Old_GrowSnowballSize, "DetachRollingFx")
		_GetNextSize = PolarUpvalue(Old_GrowSnowballSize, "_GetNextSize")
		SNOW_TO_GROW = PolarUpvalue(Old_GrowSnowballSize, "SNOW_TO_GROW")
		_SnowballTooBigWarning = PolarUpvalue(Old_GrowSnowballSize, "_SnowballTooBigWarning")
		
		PolarUpvalue(inst.components.pushable.onstartpushingfn, "_GrowSnowballSize", _GrowSnowballSize)
	end
end)