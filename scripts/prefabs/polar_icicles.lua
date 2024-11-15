local assets = {
	Asset("ANIM", "anim/icicle_roof.zip"),
	Asset("ANIM", "anim/icicle_rock.zip"),
}

SetSharedLootTable("polar_icicle", {
	{"ice", 1},
	{"ice", 0.5},
})

local BREAK_IGNORE_TAGS = {"INLIMBO", "icicleimmune"}

local ICICLE_STAGES = {"small", "med", "large"}
local ICICLE_ROCK_TAGS = {"rockicicle"}

local function DoBreak(inst)
	local anim = ICICLE_STAGES[inst.stage]
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if inst.AnimState:IsCurrentAnimation("fall_"..anim) then
		inst.AnimState:PlayAnimation("fx_"..anim, false)
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
		
		local ents = TheSim:FindEntities(x, y, z, 2, nil, BREAK_IGNORE_TAGS)
		for i, v in ipairs(ents) do
			if v ~= inst then
				if v.components.combat and v.components.health and not v.components.health:IsDead() then
					v.components.combat:GetAttacked(inst, TUNING.POLAR_ICICLE_DAMAGE)
				elseif v.components.workable and v.components.workable:CanBeWorked() then
					v.components.workable:WorkedBy(inst, 5)
				end
			end
		end
		
		local icicles = TheSim:FindEntities(x, y, z, 100, ICICLE_ROCK_TAGS)
		if #icicles >= TUNING.POLAR_WORLD_MAXICICLES then
			for i, v in ipairs(icicles) do
				if v:IsAsleep() then
					v:Remove()
					break
				end
			end
		end
		
		local rock = SpawnPrefab("polar_icicle_rock")
		local numworks = TUNING.POLAR_ICICLE_MINE - inst.stage
		rock.Transform:SetPosition(x, y, z)
		if numworks > 0 and rock.components.workable then
			rock.components.workable:WorkedBy(inst, numworks)
		end

		if FindEntity(inst, 6, nil, { "icecaveshelter" }) ~= nil then
			return
		end

		local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
		TheWorld.components.polarice_manager:QueueDestroyIceAtTile(tx, ty, true, true)
	elseif inst.AnimState:IsCurrentAnimation("fx_"..anim) then
		inst:Remove()
	end
end

local function DoGrow(inst, breaking)
	if not breaking then
		inst.stage = math.min(#ICICLE_STAGES, inst.stage + 1)
	end
	
	local anim = ICICLE_STAGES[inst.stage]
	inst.AnimState:PlayAnimation("shake_"..anim, false)
	inst.SoundEmitter:PlaySound("polarsounds/icicle/shake")
	
	inst.DynamicShadow:SetSize(0.5 + inst.stage, 1)
	
	if breaking then
		for i = 1, math.random(2, 4) do
			inst.AnimState:PushAnimation("shake_"..anim, false)
		end
		inst.AnimState:PushAnimation("fall_"..anim, false)
		
		inst:ListenForEvent("animqueueover", inst.DoBreak)
	else
		inst.AnimState:PushAnimation("idle_"..anim, false)
	end
	
	if not inst.components.timer:TimerExists("ignore_icicle") and not breaking then
		inst:RemoveTag("NOCLICK")
		inst.components.timer:StartTimer("ignore_icicle", 3)
	end
end

local function GetGrowTime(inst, breaking)
	return TUNING.POLAR_ICICLE_GROWTIME + (TUNING.POLAR_ICICLE_GROWTIME_VARIANCE * math.random())
end

local function OnSave(inst, data)
	data.stage = inst.stage
end

local function OnLoad(inst, data)
	if data then
		inst.stage = data.stage
	end
end

local function OnInit(inst)
	inst.AnimState:PlayAnimation("idle_"..ICICLE_STAGES[inst.stage])
	inst.DynamicShadow:SetSize(0.5 + inst.stage, 1)
	
	if not inst.components.timer:TimerExists("grow_icicle") then
		inst.components.timer:StartTimer("grow_icicle", inst:GetGrowTime())
	end
end

local function OnTimerDone(inst, data)
	if data.name == "grow_icicle" then
		local break_early = math.random() <= TUNING.POLAR_ICICLE_BREAK_CHANCE
		inst:DoGrow(break_early)
		
		if not break_early then
			local maxed = inst.stage >= #ICICLE_STAGES
			local timer = maxed and "break_icicle" or "grow_icicle"
			
			if not inst.components.timer:TimerExists(timer) then
				inst.components.timer:StartTimer(timer, inst:GetGrowTime(maxed))
			end
		end
	elseif data.name == "break_icicle" then
		inst:DoGrow(true)
	elseif data.name == "ignore_icicle" then
		inst:AddTag("NOCLICK")
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("icicle_roof")
	inst.AnimState:SetBuild("icicle_roof")
	inst.AnimState:PlayAnimation("idle_small")
	
	inst.DynamicShadow:SetSize(1.5, 1)
	
	inst:AddTag("bigicicle")
	inst:AddTag("birdblocker")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.stage = 1
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("timer")
	
	inst.DoBreak = DoBreak
	inst.DoGrow = DoGrow
	inst.GetGrowTime = GetGrowTime
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	local scale = math.random() > 0.5 and 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	inst:DoTaskInTime(0, OnInit)
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	return inst
end

--

local WORK_MAX = TUNING.POLAR_ICICLE_MINE

local function UpdateAnim(inst)
	local workleft = inst.components.workable and inst.components.workable.workleft or WORK_MAX
	local anim = workleft >= WORK_MAX and "full" or workleft >= WORK_MAX / 2 and "med" or "low"
	
	inst.AnimState:PlayAnimation(anim)
end

local function OnWork(inst, worker, workleft)
	if workleft <= 0 then
		inst.components.lootdropper:DropLoot()
		
		inst:Remove()
	else
		UpdateAnim(inst)
	end
end

local function rock()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("icicle_rock")
	inst.AnimState:SetBuild("icicle_rock")
	inst.AnimState:PlayAnimation("full")
	inst.AnimState:SetFinalOffset(-2)
	
	inst:AddTag("rockicicle")
	
	MakeObstaclePhysics(inst, 0.3)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("polar_icicle")
	inst.components.lootdropper.max_speed = 2
	inst.components.lootdropper.min_speed = 1
	inst.components.lootdropper.y_speed = 10
	inst.components.lootdropper.y_speed_variance = 5
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.POLAR_ICICLE_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable.savestate = true
	
	local scale = math.random() > 0.5 and 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	inst:DoTaskInTime(0, UpdateAnim)
	
	return inst
end

return Prefab("polar_icicle", fn, assets),
	Prefab("polar_icicle_rock", rock, assets)