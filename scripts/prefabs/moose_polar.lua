local assets_normal = {
	Asset("ANIM", "anim/moose_polar.zip"),
	Asset("ANIM", "anim/moose_polar_eye.zip"),
	
	Asset("ANIM", "anim/deer_basic.zip"),
	Asset("ANIM", "anim/deer_action.zip"),
}

local assets_specter = {
	Asset("ANIM", "anim/moose_specter.zip"),
	Asset("ANIM", "anim/moose_specter_eye.zip"),
	
	Asset("ANIM", "anim/deer_basic.zip"),
	Asset("ANIM", "anim/deer_action.zip"),
}

local prefabs = {
	"meat",
	"moose_polar_antler",
}

local brain = require("brains/moose_polarbrain")

SetSharedLootTable("moose_polar", {
	{"meat", 	1},
	{"meat", 	1},
	{"meat", 	0.5},
	{"meat", 	0.5},
})

local function RetargetFn(inst)
	if not inst.hasantler then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	return FindClosestPlayerInRange(x, y, z, TUNING.POLAR_MOOSE_ANTLER_TARGET_RANGE, true)
end

local function KeepTargetFn(inst, target)
	return target:IsValid() and inst:IsNear(target, 30)
end

local function ShareTargetFn(dude)
	return dude:HasTag("moose") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 12, ShareTargetFn, 3)
end

local function GetStatus(inst)
	return (inst:HasTag("spectermoose") and "SPECTER")
		or (inst.hasantler and "ANTLER")
		or nil
end

--

local function ValidShedAntlerTarget(inst, other)
	local pt = inst.charge_pos
	
	return inst.hasantler and other ~= nil and other:IsValid()
		and other:HasTag("tree") and not other:HasTag("stump")
		and other.components.workable and other.components.workable:CanBeWorked()
		and (pt == nil or other:GetDistanceSqToPoint(pt.x, pt.y, pt.z) > TUNING.POLAR_MOOSE_SHED_MIN_DIST)
end

local function OnShedAntler(inst, other)
	if ValidShedAntlerTarget(inst, other) then
		if not inst:HasTag("spectermoose") then
			if other:HasTag("antlertree") then
				inst:SetAntlered(false, false)
			end
			if not (inst.components.health:IsDead() or inst.sg:HasStateTag("busy")) then
				inst.sg:GoToState("knockoffantler")
			end
		end
		
		inst.charge_pos = inst:GetPosition()
		
		SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
		other.components.workable:WorkedBy(inst, TUNING.POLAR_MOOSE_SHED_WORK)
	end
end

local function OnCollide(inst, other)
	if ValidShedAntlerTarget(inst, other) and Vector3(inst.Physics:GetVelocity()):LengthSq() >= TUNING.POLAR_MOOSE_SHED_MIN_VEL then
		inst:DoTaskInTime(2 * FRAMES, OnShedAntler, other)
	end
end

--

local function DoCast(inst, target)
	if target == nil or inst.castfx == nil then
		return
	end
	
	local x, y, z = target.Transform:GetWorldPosition()
	local spell = SpawnPrefab(inst.castfx)
	
	spell.Transform:SetPosition(x, 0, z)
	spell:DoTaskInTime(inst.castduration, spell.KillFX)
end

local function ShowAntler(inst)
	if inst.hasantler then
		inst.AnimState:Show("swap_antler")
		inst.AnimState:OverrideSymbol("swap_antler_red", "moose_"..(inst:HasTag("spectermoose") and "specter" or "polar"), "swap_antler1")
	else
		inst.AnimState:Hide("swap_antler")
	end
end

local function SetAntlered(inst, antler, animate)
	inst.hasantler = antler
	inst.Physics:SetCollisionCallback(antler and OnCollide or nil)
	
	if not inst.hasantler and inst.components.timer and not inst.components.timer:TimerExists("regrowantler") then
		inst.components.timer:StartTimer("regrowantler", TUNING.POLAR_MOOSE_ANTLER_GROWTIME)
	end
	if inst.components.combat then
		inst.components.combat:SetDefaultDamage(antler and TUNING.POLAR_MOOSE_DAMAGE or TUNING.POLAR_MOOSE_DAMAGE_NOANTLER)
		inst.components.combat:SetRange(TUNING.POLAR_MOOSE_ATTACK_RANGE, antler and TUNING.POLAR_MOOSE_ANTLER_HIT_RANGE or TUNING.POLAR_MOOSE_HIT_RANGE)
	end
	
	if animate then
		inst:PushEvent("growantler")
	else
		inst:ShowAntler()
	end
end

local function OnSave(inst, data)
	data.hasantler = inst.hasantler
end

local function OnLoad(inst, data)
	if data then
		if data.hasantler ~= nil then
			inst:SetAntlered(data.hasantler)
		end
	end
end

local function OnTimerDone(inst, data)
	if data.name == "regrowantler" then
		inst:SetAntlered(true, true)
	end
end

local function MakeMoose(name, assets)
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddDynamicShadow()
		inst.entity:AddNetwork()
		
		inst.Transform:SetSixFaced()
		
		inst.DynamicShadow:SetSize(1.75, 0.75)
		
		MakeCharacterPhysics(inst, 200, 0.5)
		
		local scale = 1.2
		inst.AnimState:SetBank("deer")
		inst.AnimState:SetBuild("moose_"..name)
		inst.AnimState:PlayAnimation("idle_loop", true)
		inst.AnimState:OverrideSymbol("swap_neck_collar", "moose_"..name, "swap_neck")
		inst.AnimState:OverrideSymbol("swap_antler_red", "moose_"..name, "swap_antler1")
		inst.AnimState:Hide("CHAIN")
		
		if name == "specter" then
			inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
			scale = 1.4
		end
		inst.AnimState:SetScale(scale, scale)
		
		inst:AddTag("animal")
		inst:AddTag("deergemresistance")
		inst:AddTag("moose")
		inst:AddTag(name.."moose")
		inst:AddTag("saltlicker")
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.Physics:SetCollisionCallback(OnCollide)
		
		inst:AddComponent("combat")
		inst.components.combat:SetDefaultDamage(TUNING.POLAR_MOOSE_DAMAGE)
		inst.components.combat:SetAttackPeriod(TUNING.POLAR_MOOSE_ATTACK_PERIOD)
		inst.components.combat:SetRange(TUNING.POLAR_MOOSE_ATTACK_RANGE, TUNING.POLAR_MOOSE_ANTLER_HIT_RANGE)
		inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
		inst.components.combat:SetRetargetFunction(6, RetargetFn)
		inst.components.combat:SetHurtSound("dontstarve/creatures/together/deer/hit")
		inst.components.combat.hiteffectsymbol = "deer_torso"
		
		inst:AddComponent("drownable")
		
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(TUNING.POLAR_MOOSE_HEALTH)
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("knownlocations")
		
		inst:AddComponent("locomotor")
		inst.components.locomotor.walkspeed = TUNING.POLAR_MOOSE_WALK_SPEED
		inst.components.locomotor.runspeed = TUNING.POLAR_MOOSE_RUN_SPEED
		
		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetChanceLootTable("moose_polar")
		
		inst:AddComponent("timer")
		
		inst:AddComponent("saltlicker")
		inst.components.saltlicker:SetUp(TUNING.SALTLICK_DEER_USES)
		
		inst:AddComponent("sleeper")
		inst.components.sleeper:SetResistance(4)
		
		inst.hasantler = true
		
		if name == "specter" then
			
			inst:AddComponent("sanityaura")
			inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
			
			inst.castfx = "deer_ice_circle"
			inst.castduration = 6
			inst.castcd = TUNING.DEER_ICE_CAST_CD
			
			inst.DoCast = DoCast
		else
			inst.components.inspectable.getstatus = GetStatus
			
			MakeHauntablePanic(inst)
			MakeMediumBurnableCharacter(inst, "deer_torso")
			MakeMediumFreezableCharacter(inst, "deer_torso")
		end
		
		inst.OnSave = OnSave
		inst.OnLoad = OnLoad
		inst.SetAntlered = SetAntlered
		inst.ShowAntler = ShowAntler
		
		inst:SetBrain(brain)
		inst:SetStateGraph("SGmoose_polar")
		
		if inst._eye then
			inst._eye:Remove()
		end
		inst._eye = SpawnPrefab("moose_polar_eye")
		inst._eye:AttachToOwner(inst)
		
		inst:ListenForEvent("attacked", OnAttacked)
		inst:ListenForEvent("timerdone", OnTimerDone)
		
		return inst
	end
	
	return Prefab("moose_"..name, fn, assets, prefabs)
end

--

local function CreateFxFollowFrame(i)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("moose_polar_eye")
	inst.AnimState:SetBuild("moose_polar_eye")
	inst.AnimState:PlayAnimation("idle"..tostring(i), true)
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	
	return inst
end

local function fx_OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx) do
		v:Remove()
	end
end

local function fx_ColourChanged(inst, r, g, b, a)
	for i, v in ipairs(inst.fx) do
		v.AnimState:SetAddColour(r, g, b, a)
	end
end

local function fx_OnUpdate(inst)
	local owner = inst.entity:GetParent()
	local isclosed = owner and owner:HasTag("sleeping") or owner:HasTag("isdead")
	
	if inst._specterbuild == nil and owner then
		inst._specterbuild = owner:HasTag("spectermoose")
		
		if inst._specterbuild then
			for i, v in ipairs(inst.fx) do
				v.AnimState:SetBuild("moose_specter_eye")
			end
		end
	end
	if isclosed ~= inst.wasclosed then
		for i, v in ipairs(inst.fx) do
			v.AnimState:PlayAnimation((isclosed and "close" or "idle")..tostring(i))
		end
		
		inst.wasclosed = isclosed
	end
end

local function fx_SpawnFxForOwner(inst, owner)
	inst.fx = {}
	local frame
	for i = 1, 10 do
		local fx = CreateFxFollowFrame(i, owner and owner.prefab)
		fx.entity:SetParent(owner.entity)
		fx.Follower:FollowSymbol(owner.GUID, "deer_head", nil, nil, nil, true, nil, i - 1)
		fx.components.highlightchild:SetOwner(owner)
		table.insert(inst.fx, fx)
	end
	
	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddOnUpdateFn(fx_OnUpdate)
	
	inst.components.colouraddersync:SetColourChangedFn(fx_ColourChanged)
	inst.OnRemoveEntity = fx_OnRemoveEntity
end

local function fx_OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	if owner then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	if owner.components.colouradder ~= nil then
		owner.components.colouradder:AttachChild(inst)
	end
	if not TheNet:IsDedicated() then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function eyefx()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst:AddComponent("colouraddersync")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = fx_OnEntityReplicated
		
		return inst
	end
	
	inst.AttachToOwner = AttachToOwner
	
	inst.persists = false
	
	return inst
end

return MakeMoose("polar", assets_normal),
	MakeMoose("specter", assets_specter),
	Prefab("moose_polar_eye", eyefx)