local assets = {
	Asset("ANIM", "anim/walrus_actions.zip"),
	Asset("ANIM", "anim/walrus_attacks.zip"),
	Asset("ANIM", "anim/walrus_basic.zip"),
	Asset("ANIM", "anim/walrus_girl.zip"),
	
	Asset("SOUND", "sound/mctusky.fsb"),
}

local prefabs = {
	"goldnugget",
	"meat",
	"walrus_bagpipe",
	"walrus_trap",
	"walrus_tusk",
}

local brain = require "brains/girl_walrusbrain"

SetSharedLootTable("girl_walrus", {
	{"goldnugget", 		0.8},
	{"meat", 			1},
	{"walrus_bagpipe", 	1},
	{"walrus_trap", 	0.5},
	{"walrus_tusk", 	0.5},
})

local function ShareTargetFn(dude)
	return dude:HasTag("walrus") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 30, ShareTargetFn, 5)
end

local function OnDeath(inst)
	if inst.bagpipes then
		inst.bagpipes:Hide()
	end
end

local RETARGET_MUST_TAGS = {"_combat"}
local RETARGET_CANT_TAGS = {"hound", "walrus"}
local RETARGET_ONEOF_TAGS = {"character", "monster"}

local function Retarget(inst)
	return FindEntity(inst, TUNING.WALRUS_TARGET_DIST, function(guy)
		return inst.components.combat:CanTarget(guy)
	end, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS, RETARGET_ONEOF_TAGS)
end

local function KeepTarget(inst, target)
	return inst:IsNear(target, TUNING.WALRUS_LOSETARGET_DIST)
end

local function DoReturn(inst)
	if inst.components.homeseeker and inst.components.homeseeker.home then
		inst.components.homeseeker.home:PushEvent("onwenthome", {doer = inst})
		inst:Remove()
	end
end

local function OnTurnOn(inst)
	local target = inst.components.combat.target
	
	if target == nil and inst.sg and not inst.sg:HasStateTag("busy") and inst.components.timer and not inst.components.timer:TimerExists("walrustrade_greet") then
		inst.components.timer:StartTimer("walrustrade_greet", 30)
		inst.sg:GoToState("funny_idle")
		inst.AnimState:PlayAnimation("idle_creepy")
	end
end

local function OnTurnOff(inst)
	
end

local function OnActivate(inst, doer, recipe)
	local trades_data = POLARWALRUS_TRADEDATA[inst.prefab]
	
	if recipe == nil or trades_data == nil or inst.components.craftingstation == nil then
		return
	end
	
	local target = inst.components.combat.target
	
	if target == nil and inst.sg and not inst.sg:HasStateTag("busy") then
		inst.sg:GoToState("funny_idle")
	end
	
	local product_counts = {}
	
	for i, data in ipairs(trades_data) do
		product_counts[data.product] = (product_counts[data.product] or 0) + 1
		
		if data.product == recipe.product then
			local recipe_name = string.format(inst.prefab.."_trade_%s%d", data.product, product_counts[data.product])
			
			if not trades_data[i].nosharedstock or recipe.name == recipe_name then
				local old = inst.components.craftingstation:GetRecipeCraftingLimit(recipe_name) or 0
				local new = math.max(0, old - (recipe.numtogive or 1) + (recipe.name == recipe_name and 1 or 0))
				
				inst.components.craftingstation:SetRecipeCraftingLimit(recipe_name, new)
				if new <= 0 then
					inst.components.craftingstation:ForgetRecipe(recipe_name)
				end
			end
		end
	end
end

local function ShouldSleep(inst)
	return not (inst.components.homeseeker and inst.components.homeseeker:HasHome()) and DefaultSleepTest(inst)
end

local function OnEntitySleep(inst)
	if not TheWorld.state.isday then
		DoReturn(inst)
	end
end

local function OnSave(inst, data)
	data.flare_summoned = inst:HasTag("flare_summoned")
	data.got_traps = inst._equiptraps ~= nil
end

local function OnLoad(inst, data)
	if data then
		if data.flare_summoned then
			inst:AddTag("flare_summoned")
		end
		if data.got_traps and inst._equiptraps then
			inst._equiptraps:Cancel()
		end
	end
end

local function OnStopDay(inst)
	if inst:IsAsleep() then
		DoReturn(inst)
	end
end

local function OnNewTarget(inst, data)
	if data and data.target and inst.components.timer and not inst.components.timer:TimerExists("walrusboosting_prep") then
		inst.components.timer:StartTimer("walrusboosting_prep", TUNING.POLAR_WALRUSBOOST_PREPTIME + math.random())
	end
end

local function OnTimerDone(inst, data)
	if data.name == "walrustrade_refresh" then
		inst:PolarTradesRefresh()
		inst.components.timer:StartTimer("walrustrade_refresh", math.random(TUNING.WALRUSTRADES_REFRESH_TIMES.min, TUNING.WALRUSTRADES_REFRESH_TIMES.max))
	elseif data.name == "walrusboosting_prep" then
		inst._wantstoboost = true
	end
end

local function PolarTradesRefresh(inst)
	local trades_data = POLARWALRUS_TRADEDATA[inst.prefab]
	
	if trades_data == nil or inst.components.craftingstation == nil then
		return
	end
	
	local product_done = {}
	
	for i, recipe_data in ipairs(trades_data) do
		if not product_done[recipe_data.product] then
			product_done[recipe_data.product] = true
			
			local product_available = math.random() <= (recipe_data.chance or TUNING.WALRUSTRADES_RECIPE_BASE_CHANCE)
			local product_stock = product_available and 1 or nil
			
			if product_available and recipe_data.limits then
				product_stock = math.random(recipe_data.limits.min, recipe_data.limits.max)
			end
			
			local count = 1
			for j, data in ipairs(trades_data) do
				if data.product == recipe_data.product then
					local recipe_name = string.format(inst.prefab.."_trade_%s%d", recipe_data.product, count)
					count = count + 1
					
					if product_stock and product_stock > 0 then
						inst.components.craftingstation:LearnItem(recipe_name, recipe_name)
						if data.limits and not data.nosharedstock then
							inst.components.craftingstation:SetRecipeCraftingLimit(recipe_name, product_stock)
						end
					else
						inst.components.craftingstation:SetRecipeCraftingLimit(recipe_name, 0)
						inst.components.craftingstation:ForgetRecipe(recipe_name)
					end
				end
			end
		end
	end
end

local function OnInit(inst)
	if inst.components.timer and not inst.components.timer:TimerExists("walrustrade_refresh") then
		inst:PolarTradesRefresh(true)
		inst.components.timer:StartTimer("walrustrade_refresh", math.random(TUNING.WALRUSTRADES_REFRESH_TIMES.min, TUNING.WALRUSTRADES_REFRESH_TIMES.max))
	end
end

local function EquipTools(inst)
	for i = 1, TUNING.GIRL_WALRUS_MAX_TRAPS do
		if inst.components.inventory and #inst.components.inventory:GetItemsWithTag("walrus_beartrap") < TUNING.GIRL_WALRUS_MAX_TRAPS then
			local trap = SpawnPrefab("walrus_beartrap")
			
			if trap.components.finiteuses then
				trap.components.finiteuses:Use(math.ceil(trap.components.finiteuses:GetUses() * math.random(5, 7) * 0.1))
			end
			inst.components.inventory:GiveItem(trap)
		end
	end
	
	if inst.bagpipes == nil then
		inst.bagpipes = SpawnPrefab("walrus_bagpipe_equipped")
		inst.bagpipes:AttachToOwner(inst)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 50, 0.5)
	
	inst.DynamicShadow:SetSize(2.5, 1.5)
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1.5, 1.5, 1.5)
	
	inst.AnimState:SetBank("walrus")
	inst.AnimState:SetBuild("walrus_girl")
	inst.AnimState:SetMultColour(0.9, 0.9, 0.95, 1)
	inst.AnimState:Hide("hat")
	
	inst:AddTag("character")
	inst:AddTag("prototyper")
	inst:AddTag("walrus")
	inst:AddTag("walrus_support")
	inst:AddTag("houndfriend")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "pig_torso"
	inst.components.combat:SetRange(TUNING.GIRL_WALRUS_ATTACK_DIST)
	inst.components.combat:SetDefaultDamage(TUNING.GIRL_WALRUS_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.GIRL_WALRUS_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(1, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
	inst:AddComponent("craftingstation")
	
	inst:AddComponent("drownable")
	
	inst:AddComponent("follower")
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({FOODTYPE.MEAT}, {FOODTYPE.MEAT})
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.GIRL_WALRUS_HEALTH)
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = 6
	inst.components.locomotor.walkspeed = 2
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("girl_walrus")
	
	inst:AddComponent("prototyper")
	inst.components.prototyper.onturnon = OnTurnOn
	inst.components.prototyper.onturnoff = OnTurnOff
	inst.components.prototyper.onactivate = OnActivate
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.WANDERINGWALRUSSHOP
	inst.components.prototyper.restrictedtag = "walruspal"
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	
	inst:AddComponent("timer")
	
	MakeMediumBurnableCharacter(inst, "pig_torso")
	MakeMediumFreezableCharacter(inst, "pig_torso")
	inst.components.freezable:SetResistance(5)
	inst.components.freezable:SetDefaultWearOffTime(1)
	
	MakeHauntablePanic(inst)
	
	inst:AddComponent("leader")
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.PolarTradesRefresh = PolarTradesRefresh
	inst.soundgroup = "matusk" -- Remapped in init_assets
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("timerdone", OnTimerDone)
	inst:ListenForEvent("newcombattarget", OnNewTarget)
	inst:WatchWorldState("stopday", OnStopDay)
	
	inst:SetStateGraph("SGwalrus")
	
	inst:SetBrain(brain)
	
	inst:DoTaskInTime(0, OnInit)
	inst._equiptools = inst:DoTaskInTime(0, EquipTools)
	
	return inst
end

------------------------------

local function FacingUpdater(fx, owner)
	-- TODO: Bagpipes cause problems on sideview due to symbol order (pipes shouldn't go behind head), we would want a hackless proper looking sprite for it later
	-- For now it will show BEHIND her only on the side, it's less bad but alas rotation will be screwed up on pause or for split frames when rotating !
	local facing = owner.AnimState:GetCurrentFacing()
	fx.AnimState:SetScale(facing == 2 and -1 or 1, 1)
end

local function CreateFxFollowFrame(i)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("walrus")
	inst.AnimState:SetBuild("walrus_girl")
	inst.facing_id = ((i == 2 or i == 4 or i == 5) and 2)
		or (i == 3 and 3)
		or 1
		
	inst.AnimState:PlayAnimation("bagpipes_"..inst.facing_id, true)
	inst.AnimState:SetFinalOffset(inst.facing_id == 2 and -3 or 3)
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	
	return inst
end

local function OnBagpipesPlayDirty(inst)
	local playing = inst.bagpipesplay:value()
	
	for i, v in ipairs(inst.fx or {}) do
		v.AnimState:PlayAnimation((playing and "bagpipes_play_" or "bagpipes_")..v.facing, true)
	end
end

local function fx_OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx or {}) do
		v:Remove()
	end
end

local function fx_SpawnFxForOwner(inst, owner)
	inst.owner = owner
	inst.fx = {}
	
	for i = 1, 5 do
		local fx = CreateFxFollowFrame(i)
		
		fx.entity:SetParent(owner.entity)
		fx.Follower:FollowSymbol(owner.GUID, "pig_torso", 0, 0, 0, fx.facing_id ~= 2, nil, i - 1)
		fx.components.highlightchild:SetOwner(owner)
		
		if fx.facing_id == 2 then
			fx:DoPeriodicTask(0, FacingUpdater, nil, owner)
		end
		
		table.insert(inst.fx, fx)
	end
	
	inst.OnRemoveEntity = fx_OnRemoveEntity
end

local function fx_OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	
	if owner then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function fx_AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	
	if not TheNet:IsDedicated() then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function bagpipes()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	inst.bagpipesplay = net_bool(inst.GUID, "walrus_bagpipe_equipped.playing", "bagpipesplaydirty")
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = fx_OnEntityReplicated
		inst:ListenForEvent("bagpipesplaydirty", OnBagpipesPlayDirty)
		
		return inst
	end
	
	inst.persists = false
	
	inst.AttachToOwner = fx_AttachToOwner
	
	return inst
end

return Prefab("girl_walrus", fn, assets, prefabs),
	Prefab("walrus_bagpipe_equipped", bagpipes, assets)