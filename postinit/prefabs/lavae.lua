local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local polar_brain = require "brains/lavaepolarbrain"

local function KeepTargetFn(inst, target)
	local leader = inst.components.follower and inst.components.follower.leader
	local owner = leader and leader.components.inventoryitem and leader.components.inventoryitem:GetGrandOwner() or nil
	
	if owner == nil or not owner:IsValid() or not target:IsNear(owner, 10) then
		return false
	end
	
	--local cur = target.components.combat and target.components.combat.target
	return true-- owner and target.components.combat and (owner.components.combat.target == target or cur and (cur:HasTag("lavae") or cur == owner))
end

local function OnStarving(inst)
	if inst._polaramuletbuffed and inst.SetPolarAmuletFed then
		inst:SetPolarAmuletFed(false)
	end
end

local function BonusDamageFn(inst, target, damage, weapon)
	local amulet = inst.components.follower and inst.components.follower:GetLeader()
	local parts = (amulet and amulet.GetAmuletParts) and amulet:GetAmuletParts()
	local houndstooth = parts and #parts["houndstooth"] or 0
	
	return houndstooth > 0 and (TUNING.POLARAMULET.LAVAE_TOOTH.HOUNDSTOOTH_DAMAGE * houndstooth) or 0
end

local function OnAttackOther(inst, data)
	local target = data and data.target
	
	-- Only burn if fed, unless we have icy / watery teeth linked
	inst:DoTaskInTime(0.1, function()
		if target and target:IsValid() and inst._polaramuletbuffed then
			local amulet = inst.components.follower and inst.components.follower:GetLeader()
			local parts = (amulet and amulet.GetAmuletParts) and amulet:GetAmuletParts()
			
			local gnarwail_horn = parts and #parts["gnarwail_horn"] or 0
			local polarwargstooth = parts and #parts["polarwargstooth"] or 0
			
			if gnarwail_horn == 0 and polarwargstooth == 0 and target.components.burnable then
				target.components.burnable:Ignite(true, inst)
			end
			if polarwargstooth > 0 and target.components.freezable then
				target.components.freezable:AddColdness(TUNING.POLARAMULET.LAVAE_TOOTH.POLARWARGSTOOTH_FREEZINESS * polarwargstooth)
			end
		end
	end)
end

local function GetStatus(inst)
	local hunger = inst.components.hunger and inst.components.hunger:GetPercent() or 1
	
	return hunger > 0.33 and "GENERIC" or hunger > 0 and "CONTENT" or "HUNGRY"
end

local function AddColdnessRedirect(inst, coldness)
	if inst.components.hunger and inst._polaramuletbuffed and coldness >= 1 then
		inst.components.hunger:SetPercent(0)
	end
	
	return true
end

local function OnMinHealth(inst)
	if inst.components.hunger and inst._polaramuletbuffed then
		inst.components.hunger:SetPercent(0)
	end
end

local function OnEat(inst, food)
	--local foodvalue = (food and food.components.edible) and food.components.edible:GetHunger(inst) or 0
	local hunger = inst.components.hunger
	
	if hunger then -- and foodvalue > 0 then
		local amulet = inst.components.follower and inst.components.follower:GetLeader()
		local parts = (amulet and amulet.GetAmuletParts) and amulet:GetAmuletParts()
		
		local polarwargstooth = parts and #parts["polarwargstooth"] or 0
		
		hunger:SetPercent(1)
	end
	
	if not inst._polaramuletbuffed and inst.SetPolarAmuletFed and hunger and hunger:GetPercent() > 0 then
		inst:SetPolarAmuletFed(true)
	end
end

local function LinkToPolarAmulet(inst, amulet)
	amulet = amulet or inst.components.follower and inst.components.follower:GetLeader()
	local parts = (amulet and amulet.GetAmuletParts) and amulet:GetAmuletParts()
	
	if parts == nil then
		return
	end
	
	local gnarwail_horn = #parts["gnarwail_horn"]
	local polarwargstooth = #parts["polarwargstooth"]
	
	inst:SetPolarAmuletFed(false, true)
	
	if inst.components.combat then
		inst.components.combat:SetRange(TUNING.LAVAE_ATTACK_RANGE, TUNING.LAVAE_HIT_RANGE)
		inst.components.combat:SetAttackPeriod(TUNING.LAVAE_ATTACK_PERIOD)
		inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
		inst.components.combat.bonusdamagefn = BonusDamageFn
	end
	
	if inst.components.health then
		inst.components.health:SetMinHealth(1)
		inst.components.health.nofadeout = true
	end
	
	if inst.components.heater then
		inst.components.heater:SetThermics(polarwargstooth == 0, polarwargstooth > 0)
	end
	
	if inst.components.hunger then
		inst.components.hunger:SetOverrideStarveFn(OnStarving)
		inst.components.hunger:SetRate(TUNING.POLARAMULET.LAVAE_TOOTH.STARVED_RATE * 1 - (TUNING.POLARAMULET.LAVAE_TOOTH.POLARWARGSTOOTH_STARVE_RATE_MULT * polarwargstooth))
		inst.components.hunger:SetPercent(0)
	end
	
	if inst.components.inspectable then
		inst.components.inspectable.getstatus = GetStatus
	end
	
	if gnarwail_horn > 0 and inst.components.locomotor then
		inst.components.locomotor:SetExternalSpeedMultiplier(inst, "polaramulet_gnarwail", 1 + (TUNING.POLARAMULET.LAVAE_TOOTH.GNARWAIL_HORN_SPEED_MULT * gnarwail_horn))
	end
	
	if gnarwail_horn > 0 or polarwargstooth > 0 then
		if inst.components.propagator and inst.components.propagator.spreading then
			inst.components.propagator:StopSpreading()
		end
	end
	
	if polarwargstooth > 0 then
		inst.AnimState:SetHue(0.5)
		if inst.Light then
			inst.Light:SetColour(12 / 255, 121 / 255, 235 / 255)
		end
	end
	
	if inst.components.freezable then
		inst.components.freezable:SetRedirectFn(AddColdnessRedirect)
	end
	
	inst:ListenForEvent("minhealth", OnMinHealth)
	inst:ListenForEvent("oneat", OnEat)
	
	inst:SetBrain(polar_brain)
end

local function SetPolarAmuletFed(inst, buffed, noanim)
	local amulet = inst.components.follower and inst.components.follower:GetLeader()
	local parts = (amulet and amulet.GetAmuletParts) and amulet:GetAmuletParts()
	
	if parts == nil then
		return
	end
	
	local walrus_tusk = #parts["walrus_tusk"]
	
	if buffed ~= inst._polaramuletbuffed then
		if buffed then
			inst:RemoveTag("notarget")
			inst:ListenForEvent("onattackother", OnAttackOther)
		else
			inst:AddTag("notarget")
			inst:RemoveEventCallback("onattackother", OnAttackOther)
		end
	end
	
	if inst.components.combat then
		inst.components.combat:SetDefaultDamage(buffed and TUNING.POLARAMULET.LAVAE_TOOTH.LAVAE_DAMAGE or TUNING.POLARAMULET.LAVAE_TOOTH.STARVED_DAMAGE)
	end
	
	if inst.components.health then
		inst.components.health:SetMaxHealth(TUNING.POLARAMULET.LAVAE_TOOTH.LAVAE_HEALTH + (TUNING.POLARAMULET.LAVAE_TOOTH.WALRUS_TUSK_HEALTH * walrus_tusk))
		inst.components.health:SetInvincible(not buffed)
	end
	
	inst._polaramuletbuffed = buffed
	inst.wantstopolarbuff = not noanim
end

ENV.AddPrefabPostInit("lavae_pet", function(inst)
	inst:AddTag("blizzardprotection")
	inst:AddTag("snowblocker")
	
	inst.blizzardprotect_rad = TUNING.POLAR_STORM_PROTECTION.FIRE
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "lavae_pet._snowblockrange")
	inst._snowblockrange:set(6)
	
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("snowwavemelter")
	inst.components.snowwavemelter.melt_range = 6
	inst.components.snowwavemelter:StartMelting()
	
	inst.LinkToPolarAmulet = LinkToPolarAmulet
	inst.SetPolarAmuletFed = SetPolarAmuletFed
end)

--

local OldonPreBuilt
local function onPreBuilt(inst, builder, materials, recipe, ...)
	if OldonPreBuilt then
		OldonPreBuilt(inst, builder, materials, recipe, ...)
	end
	
	if builder and recipe.name == "polar_lavae_tooth" and inst.components.petleash and inst.components.petleash:GetNumPets() < inst.components.petleash:GetMaxPets() then
		inst.components.petleash:SpawnPetAt(builder.Transform:GetWorldPosition())
	end
end

ENV.AddPrefabPostInit("lavae_tooth", function(inst)
	inst:AddTag("blizzardprotection")
	inst:AddTag("snowblocker")
	
	inst.blizzardprotect_rad = TUNING.POLAR_STORM_PROTECTION.FIRE
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "lavae_pet._snowblockrange")
	inst._snowblockrange:set(6)
	
	if not TheWorld.ismastersim then
		return
	end
	
	if OldonPreBuilt == nil then
		OldonPreBuilt = inst.onPreBuilt
	end
	inst.onPreBuilt = onPreBuilt
end)