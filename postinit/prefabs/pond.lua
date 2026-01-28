local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local ponds = {
	"pond",
	"pond_mos",
}

local DespawnPlants
local OldOnSnowLevel

--	Freezing adjustements
--	TODO: Might want to do a tweak somewhere to snap out of fishing when an in-use pond freezes (Yeah this is a problem in vanilla too).

local function OnSnowLevel(inst, snowlevel, ...)
	local ismined = inst.components.timer and inst.components.timer:TimerExists("polarice_plow_pond")
	local isfrozen = inst.frozen_polar and not ismined
	
	snowlevel = (ismined and 0) or (isfrozen and 1) or snowlevel
	
	if OldOnSnowLevel then
		OldOnSnowLevel(inst, snowlevel, ...)
	end
	if inst.components.workable and inst.components.fishable then
		local workable = inst.components.fishable.frozen or false
		
		inst:AddOrRemoveTag("frozen", workable) -- Mining fx
		inst.components.workable:SetWorkable(workable)
	end
end

local function OnSnowLevel_Internal(inst)
	local snowlevel = TheWorld.state.snowlevel
	
	if snowlevel <= 0 or snowlevel >= 1 then
		OnSnowLevel(inst, snowlevel)
	end
end

local OldCanSpawn
local function CanSpawn(inst, ...)
	if inst:GetTimeAlive() < 1 and IsInPolar(inst) then
		return false -- First spawn is like, instant, we just need to block the first one before frozen state is properly handled !
	end
	
	if OldCanSpawn then
		return OldCanSpawn(inst, ...)
	end
	
	return true
end

--	Mining / Plowing

local function DoPolarIcePlow(inst, doer, duration) -- Doer can be polarice_plow, not just worker
	if not inst.components.timer:TimerExists("polarice_plow_pond") then
		inst.components.timer:StartTimer("polarice_plow_pond", duration or TUNING.FROZENPOND_BREAK_ICE_TIME)
	end
	if inst.polarice_plow and inst.polarice_plow ~= doer and inst.polarice_plow:IsValid() and inst.polarice_plow.components.workable then
		inst.polarice_plow.components.workable:Destroy(TheWorld)
	end
	
	if OldOnSnowLevel then
		OldOnSnowLevel(inst, 0)
	end
	
	inst.polarice_plow = nil
end

local function OnFinished(inst, worker)
	local pt = inst:GetPosition()
	
	if inst.components.lootdropper == nil then
		inst:AddComponent("lootdropper")
	end
	for i = 1, 2 do
		inst.components.lootdropper:SpawnLootPrefab("ice", pt)
	end
	
	inst.components.workable:SetWorkLeft(TUNING.FROZENPOND_WORK)
	inst.components.workable:SetWorkable(false)
	
	inst:DoPolarIcePlow(worker, TUNING.FROZENPOND_BREAK_ICE_TIME_LESS)
end

local function OnWork(inst, worker)
	if worker and worker:IsValid() and inst:GetDistanceSqToInst(worker) <= 8 and worker.components.slipperyfeet then
		worker.components.slipperyfeet:DoDelta(math.random(TUNING.FROZENPOND_WORK_SLIPPERY_DELTA.min, TUNING.FROZENPOND_WORK_SLIPPERY_DELTA.max))
		
		local tool = worker.components.inventory and worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		
		if worker.components.slipperyfeet.slippiness >= worker.components.slipperyfeet.threshold and tool
			and worker.sg and worker.sg:HasStateTag("working") and not worker.sg:HasStateTag("noslip") then
			
			if math.random() < 0.5 then
				worker.sg:GoToState("slip_fall")
			elseif not tool:HasTag("stickygrip") and not worker:HasTag("stronggrip") then
				worker.components.inventory:Unequip(EQUIPSLOTS.HANDS, true)
				worker.components.inventory:DropItem(tool)
			end
		end
	end
end

local OldCanMouseThrough
local function CanMouseThrough(inst, ...)
	if ThePlayer and ThePlayer.components.playeractionpicker and ThePlayer.components.playercontroller then
		local lmb, rmb = ThePlayer.components.playeractionpicker:DoGetMouseActions(inst:GetPosition(), inst)
		local deployplacer = ThePlayer.components.playercontroller.deployplacer
		
		if lmb == nil and rmb == nil and deployplacer and deployplacer.prefab == "polarice_plow_item_placer" then
			return true, true
		end
	end
	
	return OldCanMouseThrough and OldCanMouseThrough(inst, ...) or false
end

--

local function PolarInit(inst)
	local inpolar = IsInPolar(inst)
	inst.frozen_polar = inpolar or nil -- This should be set just once, otherwise... lag
	
	if inst.worldstatewatching and inst.worldstatewatching["snowlevel"] then
		for i, v in ipairs(inst.worldstatewatching["snowlevel"]) do
			DespawnPlants = PolarUpvalue(v, "DespawnPlants")
			
			if DespawnPlants then
				if OldOnSnowLevel == nil then
					OldOnSnowLevel = inst.worldstatewatching["snowlevel"][i]
				end
				inst:StopWatchingWorldState("snowlevel", OldOnSnowLevel)
				inst:WatchWorldState("snowlevel", OnSnowLevel)
				
				break
			end
		end
	end
	
	inst._polartask = inst:DoPeriodicTask(FRAMES, OnSnowLevel_Internal) -- OnSnowLevel still needs to loop while snowlevel is static, for plow update
end

for i, prefab in ipairs(ponds) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("snowblocker")
		
		if OldCanMouseThrough == nil then
			OldCanMouseThrough = inst.CanMouseThrough
		end
		inst.CanMouseThrough = CanMouseThrough
		
		inst._snowblockrange = net_smallbyte(inst.GUID, prefab.."._snowblockrange")
		inst._snowblockrange:set(5)
		
		if not TheWorld.ismastersim then
			return
		end
		
		if inst.components.childspawner then
			if OldCanSpawn == nil then
				OldCanSpawn = inst.components.childspawner.canspawnfn
			end
			inst.components.childspawner.canspawnfn = CanSpawn
		end
		
		if inst.components.timer == nil then
			inst:AddComponent("timer")
		end
		
		if inst.components.workable == nil then
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.MINE)
			inst.components.workable:SetOnFinishCallback(OnFinished)
			inst.components.workable:SetOnWorkCallback(OnWork)
			inst.components.workable:SetMaxWork(TUNING.FROZENPOND_WORK)
			inst.components.workable:SetWorkLeft(TUNING.FROZENPOND_WORK)
			inst.components.workable:SetWorkable(false)
		end
		
		inst.DoPolarIcePlow = DoPolarIcePlow
		
		inst:DoTaskInTime(0.1, PolarInit)
	end)
end