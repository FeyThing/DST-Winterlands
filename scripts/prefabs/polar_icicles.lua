local assets = {
	Asset("ANIM", "anim/icicle_roof.zip"),
	Asset("ANIM", "anim/icicle_rock.zip"),
}

SetSharedLootTable("polar_icicle", {
	{"ice", 1},
})

local BREAK_IGNORE_TAGS = {"INLIMBO", "icicleimmune", "flight"}
local BREAK_SAFETY_TAGS = {"icicleimmune"}
local CAVEPILLAR_TAGS = {"icecaveshelter"}

local ICICLE_STAGES = {"small", "med", "large"}
local ICICLE_ROCK_TAGS = {"rockicicle"}

local function DoBreak(inst)
	local anim = ICICLE_STAGES[inst.stage]
	local pt = inst:GetPosition()
	
	if inst.AnimState:IsCurrentAnimation("fall_"..anim) then
		local ploof = not TheWorld.Map:IsPassableAtPoint(pt.x, 0, pt.z)
		if not ploof then
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
		end
		
		if FindEntity(inst, 4, nil, BREAK_SAFETY_TAGS) then
			inst.AnimState:PlayAnimation("fx_"..anim, false)
			inst.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")
			return
		elseif not ploof then
			inst.AnimState:PlayAnimation("fx_"..anim, false)
		end
		
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 4, nil, BREAK_IGNORE_TAGS)
		for i, v in ipairs(ents) do
			if v ~= inst then
				local r = v.Physics and v.Physics:GetRadius() or 0
				local hit_rad = r >= 0.75 and (2 + r) or 2
				
				if v:GetDistanceSqToPoint(pt.x, pt.y, pt.z) <= hit_rad * hit_rad then
					v:PushEvent("iciclesmashed", {icicle = inst})
					
					if v.components.workable and v.components.workable:CanBeWorked() then
						v.components.workable:WorkedBy(inst, 5)
					elseif v.components.pickable and v.components.pickable:CanBePicked() then
						v.components.pickable:Pick(TheWorld)
					end
					
					if v.components.oceanfishable then
						local projectile = v.components.oceanfishable:MakeProjectile()
						local ae_cp = projectile and projectile.components.complexprojectile
						
						if ae_cp then
							ae_cp:SetHorizontalSpeed(16)
							ae_cp:SetGravity(-30)
							ae_cp:SetLaunchOffset(Vector3(0, 0.5, 0))
							ae_cp:SetTargetOffset(Vector3(0, 0.5, 0))
							
							local v_pt = v:GetPosition()
							local launch_position = v_pt + (v_pt - pt):Normalize() * 4
							ae_cp:Launch(launch_position, projectile, ae_cp.owningweapon)
						end
					elseif v.components.combat and v.components.health and not v.components.health:IsDead() then
						v.components.combat:GetAttacked(inst, TUNING.POLAR_ICICLE_DAMAGE[string.upper(ICICLE_STAGES[inst.stage])])
					end
					
					if v.components.inventoryitem and (v:HasTag("quakedebris") or v.prefab == "ice") then
						local vx, vy, vz = v.Transform:GetWorldPosition()
						SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, vy, vz)
						
						v:Remove()
					end
				end
			end
		end
		
		local icicles = TheSim:FindEntities(pt.x, pt.y, pt.z, 200, ICICLE_ROCK_TAGS)
		if #icicles >= TUNING.POLAR_WORLD_MAXICICLES then
			for i, v in ipairs(icicles) do
				if v:IsAsleep() then
					v:Remove()
					break
				end
			end
		end
		
		if ploof then
			SpawnPrefab("splash_sink").Transform:SetPosition(pt.x, 0, pt.z)
			inst:Remove()
			
			return
		end
		
		local rock = SpawnPrefab("polar_icicle_rock")
		local numworks = TUNING.POLAR_ICICLE_MINE - inst.stage
		rock.Transform:SetPosition(pt.x, pt.y, pt.z)
		if numworks > 0 and rock.components.workable then
			rock.components.workable:WorkedBy(inst, numworks)
		end
		
		if FindEntity(inst, 6, nil, CAVEPILLAR_TAGS) ~= nil then
			return
		end
		
		if TheWorld.components.polarice_manager and TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z) == WORLD_TILES.POLAR_ICE then
			local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(pt.x, pt.y, pt.z)
			TheWorld.components.polarice_manager:StartDestroyingIceAtTile(tx, ty, false)
			
			if rock and rock:IsValid() then
				rock.Transform:SetPosition(TheWorld.Map:GetTileCenterPoint(tx, ty))
			end
		end
	elseif inst.AnimState:IsCurrentAnimation("fx_"..anim) then
		inst:Remove()
	end
end

local function StartBreaking(inst)
	local anim = ICICLE_STAGES[inst.stage]
	inst.AnimState:PlayAnimation("fall_"..anim, false)
	inst.SoundEmitter:PlaySound("polarsounds/icicle/shake")
	
	inst:ListenForEvent("animover", inst.DoBreak)
end

local function DoGrow(inst)
	if inst.stage < #ICICLE_STAGES then
		local oldanim = ICICLE_STAGES[inst.stage]
		inst.AnimState:PlayAnimation("grow_"..oldanim, false)
		inst.SoundEmitter:PlaySound("polarsounds/icicle/shake")
		inst.DynamicShadow:SetSize(0.5 + inst.stage, 1)
		
		inst.stage = math.min(#ICICLE_STAGES, inst.stage + 1)
		local newanim = ICICLE_STAGES[inst.stage]
		inst.AnimState:PushAnimation("idle_"..newanim, false)
		
		if not inst.components.timer:TimerExists("ignore_icicle") then
			inst:RemoveTag("NOCLICK")
			inst.components.timer:StartTimer("ignore_icicle", 3)
		end
	end
end

local function GetGrowTime(inst, breaking)
	return TUNING.POLAR_ICICLE_GROWTIME + (TUNING.POLAR_ICICLE_GROWTIME_VARIANCE * math.random())
end

local function OnSave(inst, data)
	data.stage = inst.stage
	data.wait_to_grow = inst.wait_to_grow
end

local function OnLoad(inst, data)
	if data then
		inst.stage = data.stage
		inst.wait_to_grow = data.wait_to_grow
	end
end

local function SetBlueGemTrap(inst)
	if math.random() < 0.15 then
		inst:Remove()
		return
	end
	
	local rdm = math.random()
	local prefab = rdm < 0.01 and "bluegem_overcharged" or rdm < 0.85 and "bluegem" or nil
	
	if prefab then
		local gem = SpawnPrefab(prefab)
		
		gem.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if not gem.components.scenariorunner then
			gem:AddComponent("scenariorunner")
			gem.components.scenariorunner:SetScript("bluegem_shards")
			gem.components.scenariorunner:Run()
		end
	end
	
	inst.wait_to_grow = true
	for i = 1, 2 do
		if math.random() < 0.5 then
			inst:DoGrow()
		end
	end
end

local function OnInit(inst)
	inst.AnimState:PlayAnimation("idle_"..ICICLE_STAGES[inst.stage])
	inst.DynamicShadow:SetSize(0.5 + inst.stage, 1)
	
	if not inst.components.timer:TimerExists("grow_icicle") then
		inst.components.timer:StartTimer("grow_icicle", inst:GetGrowTime())
	end
end

local function IsValidVictim(victim)
	return victim and victim.components.health and victim.components.combat and not ((victim:HasTag("prey") and not victim:HasTag("hostile"))
		or victim:HasAnyTag(NON_LIFEFORM_TARGET_TAGS)
		or victim:HasTag("companion"))
end

local function OnKilled(inst, data)
	local victim = data and data.victim
	
	if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and inst.components.lootdropper
		and inst.IsValidVictim(victim) and math.random() <= TUNING.POLAR_ICICLE_ORNAMENT_CHANCE then
		
		local ornament = GetRandomPolarWinterOrnament()
		inst.components.lootdropper:SpawnLootPrefab(ornament)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "grow_icicle" then
		local break_early = math.random() <= TUNING.POLAR_ICICLE_BREAK_CHANCE
		if break_early and not inst.wait_to_grow then
			inst:StartBreaking()
		else
			if not inst.wait_to_grow then
				inst:DoGrow()
			end
			local maxed = inst.stage >= #ICICLE_STAGES
			local timer = maxed and "break_icicle" or "grow_icicle"
			
			if not inst.components.timer:TimerExists(timer) then
				inst.components.timer:StartTimer(timer, inst:GetGrowTime(maxed))
			end
		end
	elseif data.name == "break_icicle" then
		inst:StartBreaking()
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
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("timer")
	
	inst.IsValidVictim = IsValidVictim
	inst.DoBreak = DoBreak
	inst.DoGrow = DoGrow
	inst.StartBreaking = StartBreaking
	inst.GetGrowTime = GetGrowTime
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	local scale = math.random() > 0.5 and 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	inst:DoTaskInTime(0, OnInit)
	
	inst:ListenForEvent("killed", OnKilled)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	return inst
end

local function trap()
	local inst = fn()
	
	inst:SetPrefabName("polar_icicle")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:DoTaskInTime(0, SetBlueGemTrap)
	
	return inst
end


--

local WORK_MAX = TUNING.POLAR_ICICLE_MINE

local function UpdateAnim(inst)
	local workleft = inst.components.workable and inst.components.workable.workleft or WORK_MAX
	local anim = workleft >= WORK_MAX and "full" or workleft >= WORK_MAX / 2 and "med" or "low"
	
	if anim == "low" then
		RemovePhysicsColliders(inst)
	else
		MakeObstaclePhysics(inst, 0.3)
	end
	
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

local ICEPROTUBERANCE_TAGS = {"structure", "wall", "protuberancespawnblocker"}

local function OnPolarFreeze(inst, forming)
	if not forming and IsInPolar(inst) then
		local x, y, z = inst.Transform:GetWorldPosition()
		
		local ents = TheSim:FindEntities(x, y, z, 20, nil, nil, ICEPROTUBERANCE_TAGS)
		if #ents == 0 then
			SpawnPrefab("rock_polar_spawner").Transform:SetPosition(x, y, z)
		end
		
		SpawnPrefab("ice_splash").Transform:SetPosition(x, y, z)
		inst:Remove()
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
	inst:AddTag("frozen")
	
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
	
	inst.OnPolarFreeze = OnPolarFreeze
	
	local scale = math.random() > 0.5 and 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	inst:DoTaskInTime(0, UpdateAnim)
	
	return inst
end

return Prefab("polar_icicle", fn, assets),
	Prefab("polar_icicle_trap", trap, assets),
	Prefab("polar_icicle_rock", rock, assets)