local easing = require("easing")

local assets = {
	Asset("ANIM", "anim/snowball.zip")
}

local SNOWBALL_SIZE_DATA = {
	{gravity = -46, 	y_offset = 1, 		speed = 20},
	{gravity = -33, 	y_offset = 1.25, 	speed = 12},
	{gravity = -196, 	y_offset = 1.5, 	speed = 7},
}

local ROLL_MAX_SCALE = 2
local ROLL_MAX_SCALE_TIME = 2

local HIT_TAGS = {"_combat", "pickable", "_inventoryitem"}
local HIT_NOT_TAGS = {"INLIMBO", "isdead", "notarget", "heavy"}

local HARVEST_TAGS = {"_combat", "pickable", "_inventoryitem"}
local HARVEST_NOT_TAGS = {"INLIMBO", "isdead", "heavy", "playerghost", "structure", "wall", "notarget"}
local HARVEST_START_RAD = 1
local HARVEST_ROLL_RAD = 2
local HARVEST_SPEED = 12

local KNOCKBACK_TAGS = {"_combat"} -- Knockback is disabled currently
local KNOCKBACK_NOT_TAGS = {"INLIMBO", "isdead", "playerghost", "structure", "wall", "notarget"}
local KNOCKBACK_RAD = 2
local KNOCKBACK_SPEED = 12

--

local function DoRelease(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if target.sg and target.sg:HasStateTag("devoured") then
		target.sg.currentstate:HandleEvent(target.sg, "spitout", {spitter = inst, radius = inst:GetPhysicsRadius(0) + 3, strengthmult = 1})
	else
		target:ReturnToScene()
		target.Transform:SetPosition(x, y, z)
		
		if target.components.combat then
			local attacker = inst.components.complexprojectile and inst.components.complexprojectile.attacker or nil
			
			if target.components.freezable then
				target.components.freezable:AddColdness(target.components.freezable.resistance * TUNING.WINTERS_FISTS_SNOWBALL_GIANT_COLDNESSPERCENT)
			end
			if not TheWorld.Map:IsPassableAtPoint(x, 0, z) then
				if target.components.drownable and target.components.locomotor then
					target.components.locomotor:CheckDrownable()
				elseif not target:HasTag("flying") then
					target.components.health:Kill()
				end
			else
				if attacker then
					target.components.combat:SuggestTarget(inst.components.complexprojectile.attacker)
				end
				if inst._collided then
					target.components.combat:GetAttacked(attacker or inst, TUNING.WINTERS_FISTS_DAMAGE_SNOWBALL)
				end
			end
		end
	end
	if target.components.grogginess then
		target.components.grogginess:AddGrogginess(TUNING.WINTERS_FISTS_SNOWBALL_GIANT_GROGGINESS, TUNING.WINTERS_FISTS_SNOWBALL_GIANT_KO_TIME)
	end
	
	--inst.transported[target] = nil
	
	--inst:KnockbackEnts()
end

local function ReleaseTarget(inst, target)
	if target and target:IsValid() and inst.transported[target] then
		inst:DoRelease(target)
		inst.transported[target] = nil
		
	elseif target == nil then
		for transported, v in pairs(inst.transported) do
			if transported:IsValid() then
				inst:DoRelease(transported)
			end
		end
		
		inst.transported = {}
	end
end

local function TransportTarget(inst, target)
	if target and not inst.transported[target] and target:IsValid() and target.components.health and not target.components.health:IsDead() then
		inst.transported[target] = true
		
		if target:HasTag("player") then
			if target.sg then
				target.sg:GoToState("idle") -- Normally can't be transported on nointerrupt states
				target.sg:HandleEvent("devoured", {attacker = inst})
			end
		else
			target:RemoveFromScene()
		end
	end
end

--

local function KnockbackEnts(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, KNOCKBACK_RAD, nil, KNOCKBACK_NOT_TAGS, KNOCKBACK_TAGS)
	local attacker = inst.components.complexprojectile and inst.components.complexprojectile.attacker or nil
	
	for i, ent in ipairs(ents) do
		if attacker and ent ~= inst and ent.Physics and ent:IsValid() and ent.entity:IsVisible() and
			(ent ~= attacker and (not (ent:HasTag("player") and attacker:HasTag("player")) or TheNet:GetPVPEnabled())) then
			
			local ex, ey, ez = ent.Transform:GetWorldPosition()
			local dx = ex - x
			local dz = ez - z
			local dist_sq = dx * dx + dz * dz
			
			if dist_sq > 0 and dist_sq <= KNOCKBACK_RAD * KNOCKBACK_RAD then
				local dist = math.sqrt(dist_sq)
				local strength = KNOCKBACK_SPEED -- * (1 - dist / KNOCKBACK_RAD)
				
				if ent:HasTag("epic") then
					strength = strength / 3
				elseif ent:HasTag("largecreature") then
					strength = strength / 2
				end
				
				if ent.sg and not (ent.sg:HasStateTag("knockback") or ent.sg:HasStateTag("nointerrupt")) then
					ent:PushEvent("knockback", {knocker = inst, radius = 1, strengthmult = 1, forcelanded = false})
				end
				
				if not ent:HasTag("player") then
					local nx, nz = dx / dist, dz / dist
					local vx, vz = nx * strength, nz * strength
					ent.Physics:SetMotorVelOverride(vx, 0, vz)
					
					ent:DoTaskInTime(0.25, function()
						if ent:IsValid() and ent.Physics then
							ent.Physics:SetMotorVelOverride(0, 0, 0)
						end
					end)
				end
			end
		end
	end
end

local function RollingTask(inst)
	local progress = math.min(inst:GetTimeAlive() / ROLL_MAX_SCALE_TIME, 1)
	local scale = 1 + (ROLL_MAX_SCALE - 1) * progress
	inst.Transform:SetScale(scale, scale, scale)
	
	local HARVEST_RAD = HARVEST_START_RAD + (HARVEST_ROLL_RAD * progress)
	if inst.components.wateryprotection then
		inst.components.wateryprotection:SpreadProtection(inst, HARVEST_RAD) -- Only puts off fire, small / med applies cold
	end
	if inst.components.snowwavemelter then
		inst.components.snowwavemelter.melt_range = math.ceil(HARVEST_RAD + 1)
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, HARVEST_RAD, nil, HARVEST_NOT_TAGS, HARVEST_TAGS)
	local attacker = inst.components.complexprojectile and inst.components.complexprojectile.attacker or nil
	
	local bbx1, bby1, bbx2, bby2 = inst.AnimState:GetVisualBB()
	local inst_bby = bby2 - bby1
	
	for i, ent in ipairs(ents) do
		if attacker and ent ~= inst and not inst.attacked[ent] and not inst.transported[ent] and ent:IsValid() and ent.entity:IsVisible() and
			(ent ~= attacker and (not (ent:HasTag("player") and attacker:HasTag("player")) or TheNet:GetPVPEnabled())) then
			inst.attacked[ent] = true
			
			--local bbx3, bby3, bbx4, bby4 = ent.AnimState:GetVisualBB()
			--local ent_bby = bby4 - bby3
			
			local is_dead = ent.components.health and ent.components.health:IsDead()
			local is_smaller = not ent:HasTag("epic") and not ent:HasTag("largecreature") and -- (ent_bby * 0.6) <= inst_bby
				not (ent.sg and ent.sg:HasStateTag("nointerrupt"))
			
			if ent.components.combat then
				ent.components.combat:GetAttacked(attacker or inst, TUNING.WINTERS_FISTS_DAMAGE + (is_smaller and 0 or TUNING.WINTERS_FISTS_DAMAGE_SNOWBALL))
			end
			if ent.components.freezable and not is_smaller then
				ent.components.freezable:AddColdness(TUNING.WINTERS_FISTS_SNOWBALL_COLDNESS)
			end
			
			if ent.components.health and not is_dead and is_smaller then
				inst:TransportTarget(ent)
			elseif ent.components.pickable and ent.components.pickable:CanBePicked() then
				ent.components.pickable:Pick(inst)
			elseif inst.components.inventory and not is_dead and ent.components.inventoryitem and ent.entity:GetParent() == nil then
				inst.components.inventory:GiveItem(ent)
			end
			
			if not is_smaller then
				SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
				inst:Remove()
			end
		end
	end
	
	local ispassable = TheWorld.Map:IsPassableAtPoint(x, 0, z)
	if not ispassable or inst:GetTimeAlive() >= TUNING.WINTERS_FISTS_SNOWBALL_GIANT_MAXTIME then
		SpawnPrefab(not ispassable and "splash_green" or "splash_snow_fx").Transform:SetPosition(x, 0, z)
		inst:Remove()
	end
end

local function OnHit(inst, attacker, target)
	if inst.components.wateryprotection then
		inst.components.wateryprotection:SpreadProtection(inst)
	end
	
	if inst._collided or target or inst.size < #SNOWBALL_SIZE_DATA then
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, HARVEST_START_RAD, nil, HIT_NOT_TAGS, HIT_TAGS)
		local attacker = inst.components.complexprojectile and inst.components.complexprojectile.attacker or nil
		
		--[[if inst.size == 2 then
			inst:KnockbackEnts()
		end]]
		
		if target and target:IsValid() and not table.contains(ents, target) and not target:HasAnyTag(HIT_NOT_TAGS) then
			table.insert(ents, target)
		end
		for i, ent in ipairs(ents) do
			if ent ~= inst and attacker and ent ~= attacker and ent:IsValid() and (not (ent:HasTag("player") and attacker:HasTag("player")) or TheNet:GetPVPEnabled()) then
				if ent.components.combat and inst.size <= 2 then
					local damage = inst.size <= 1 and TUNING.WINTERS_FISTS_DAMAGE_SMALLBALL or TUNING.WINTERS_FISTS_DAMAGE_MEDBALL
					ent.components.combat:GetAttacked(attacker or inst, ent:HasTag("dryice") and 0 or damage)
				end
				if ent.components.workable and inst.size > 1 then
					local workdone = inst.size > 2 and TUNING.WINTERS_FISTS_SNOWBALL_GIANT_WORKS or TUNING.WINTERS_FISTS_SNOWBALL_MED_WORKS
					ent.components.workable:WorkedBy(inst, ent:HasTag("dryice") and 0 or workdone)
				end
			end
		end
		
		SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:Remove()
	else
		inst.Physics:SetMotorVel(SNOWBALL_SIZE_DATA[inst.size].speed * 0.8, 0, 0)
		
		if inst._rolltask == nil then
			inst._rolltask = inst:DoPeriodicTask(0.1, inst.RollingTask)
		end
		if inst._fxtask == nil then
			inst._fxtask = inst:DoPeriodicTask(0.23, function()
				SpawnPrefab("winters_fists_snowball_roll_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
			end)
		end
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mole/move", "move")
	end
end

local function OnCollide(inst, other)
	if other and other:IsValid() and inst:IsValid() and other ~= inst.components.complexprojectile.attacker then
		inst._collided = other
		inst.components.complexprojectile:Hit(other)
	end
end

local function OnSave(inst, data)
	if inst.components.complexprojectile and inst.components.complexprojectile.attacker then
		data.has_attacker = inst.components.complexprojectile.attacker ~= nil
	end
end

local function OnLoad(inst, data)
	if data and data.has_attacker then
		inst:DoTaskInTime(0.1, function()
			if inst.components.inventory then
				inst.components.inventory:DropEverything()
			end
			
			inst:Remove()
		end)
	end
end

local function SetSize(inst, size)
	inst.size = math.clamp(size or 1, 1, #SNOWBALL_SIZE_DATA)
	
	inst.components.complexprojectile:SetGravity(SNOWBALL_SIZE_DATA[inst.size].gravity)
	inst.components.complexprojectile:SetLaunchOffset(Vector3(0, SNOWBALL_SIZE_DATA[inst.size].y_offset, 0))
	inst.components.complexprojectile:SetHorizontalSpeed(SNOWBALL_SIZE_DATA[inst.size].speed)
	
	if inst.size <= 2 and inst.components.wateryprotection then
		inst.components.wateryprotection.addcoldness = TUNING.WINTERS_FISTS_SNOWBALL_COLDNESS * inst.size
	end
	if inst.size == 2 then
		inst.AnimState:PlayAnimation("small_to_med")
		inst.AnimState:PushAnimation("roll_med_loop", true)
	elseif inst.size >= 3 then
		inst.AnimState:PlayAnimation("small_to_med")
		inst.AnimState:PushAnimation("med_to_large", false)
		inst.AnimState:PushAnimation("roll_large_loop", true)
		
		if inst.components.snowwavemelter == nil then
			inst:AddComponent("snowwavemelter") -- Basically take the snow with you on the roll !
		end
		inst.components.snowwavemelter.melt_range = math.ceil(HARVEST_START_RAD + 1)
		inst.components.snowwavemelter:StartMelting()
	end
end

local function ThrowAt(inst, targetpos, owner)
	local nocollidetime = (owner and owner.prefab == "emperor_penguin") and 1 or 0.25
	
	inst.persists = true
	inst.Physics:SetCylinder(0, 0) -- We don't want the snowball to crash instantly on nearby colliders !
	inst:DoTaskInTime(nocollidetime, function() inst.Physics:SetCylinder(1, 1) end)
	inst.Physics:SetCollisionCallback(inst.OnCollide)
	
	inst.components.complexprojectile:Launch(targetpos, owner, inst)
	if inst.components.wateryprotection and owner:HasTag("player") then
		inst.components.wateryprotection:AddIgnoreTag("player")
	end
end

local function OnRemoved(inst)
	inst:ReleaseTarget()
	
	if inst.components.inventory then
		inst.components.inventory:DropEverything()
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local phys = inst.entity:AddPhysics()
	phys:SetMass(100)
	phys:SetFriction(0)
	phys:SetDamping(5)
	phys:SetCylinder(1, 1)
	phys:SetCollisionGroup(COLLISION.CHARACTERS)
	phys:SetCollisionMask(
		COLLISION.GROUND,
		COLLISION.OBSTACLES,
		COLLISION.SMALLOBSTACLES,
		COLLISION.GIANTS
	)
	
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("snowball")
	inst.AnimState:SetBuild("snowball")
	inst.AnimState:PlayAnimation("roll_small_loop", true)
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	inst:AddTag("projectile")
	inst:AddTag("complexprojectile")
	inst:AddTag("snowballing")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.attacked = {}
	inst.transported = {}
	
	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetOnHit(OnHit)
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("wateryprotection")
	inst.components.wateryprotection.extinguishheatpercent = TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT
	--inst.components.wateryprotection.temperaturereduction = TUNING.FIRESUPPRESSOR_TEMP_REDUCTION
	inst.components.wateryprotection.witherprotectiontime = TUNING.FIRESUPPRESSOR_PROTECTION_TIME
	--inst.components.wateryprotection.addcoldness = TUNING.FIRESUPPRESSOR_ADD_COLDNESS
	
	inst.DoRelease = DoRelease
	inst.KnockbackEnts = KnockbackEnts
	inst.OnCollide = OnCollide
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.ReleaseTarget = ReleaseTarget
	inst.RollingTask = RollingTask
	inst.SetSize = SetSize
	inst.ThrowAt = ThrowAt
	inst.TransportTarget = TransportTarget
	
	inst.persists = false
	
	inst:ListenForEvent("onremove", OnRemoved)
	
	return inst
end

return Prefab("winters_fists_snowball", fn, assets)