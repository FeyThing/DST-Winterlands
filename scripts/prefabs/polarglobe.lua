local assets = {
	Asset("ANIM", "anim/polarglobe.zip"),
}

local function OnGlobeShake(inst)
	if not TheWorld.state.iswinter then
		inst.season_data.in_use = true
		inst.season_data.season = TheWorld.state.season
		inst.season_data.elapsed = TheWorld.state.elapseddaysinseason
		
		for i, v in ipairs(AllPlayers) do
			v:ShakeCamera(CAMERASHAKE.FULL, 2, 0.08, 3)
			if inst:GetDistanceSqToInst(v) >= 25 then
				v:PushEvent("knockback", {knocker = v, radius = 100})
			end
			
			v:DoTaskInTime(1 + math.random(), function()
				if v.components.talker then
					v.components.talker:Say(GetString(v, "ANNOUNCE_POLARGLOBE"))
				end
			end)
		end
		
		TheWorld:PushEvent("ms_setseason", "winter")
		TheWorld:PushEvent("ms_advanceseason")
		for i = 1, inst.season_data.elapsed do
			TheWorld:PushEvent("ms_advanceseason")
		end
		TheWorld:PushEvent("ms_forceprecipitation", true)
		
		if inst.components.fueled then
			inst.components.fueled:SetPercent(0)
			inst.components.fueled.accepting = true
		end
	end
	
	inst:DoTaskInTime(0, function()
		if inst.components.machine then
			inst.components.machine:TurnOff()
		end
	end)
end

local function OnTakeFuel(inst)
	if inst.components.machine and inst.components.fueled:IsFull() then
		inst.components.fueled.accepting = false
	end
end

local function TurnOn(inst)
	inst:OnGlobeShake()
end

local function TurnOff(inst)
	if inst.components.fueled then
		inst.components.fueled.accepting = not inst.components.fueled:IsFull()
	end
end

local function GetStatus(inst)
	return inst.season_data.in_use and "INUSE" or (inst.components.fueled and not inst.components.fueled:IsFull()) and "REFUEL" or nil
end

local function CalcSanityAura(inst, observer)
	return inst.season_data.in_use and -TUNING.SANITYAURA_TINY or TUNING.SANITYAURA_TINY
end

local function OnSave(inst, data)
	data.season_data = inst.season_data
end

local function OnLoad(inst, data)
	if data and data.season_data then
		inst.season_data = data.season_data
	end
end

local function OnSeasonTick(inst, data)
	if not TheWorld.state.iswinter and data and inst.season_data.in_use and data.season ~= inst.season_data.season then
		TheWorld:PushEvent("ms_setseason", inst.season_data.season)
		for i = 1, inst.season_data.elapsed do
			if TheWorld.state.remainingdaysinseason > 1 then
				TheWorld:PushEvent("ms_advanceseason")
			end
		end
		
		inst.season_data.in_use = nil
		
		if inst.components.machine then
			inst.components.machine:TurnOff()
		end
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.MiniMapEntity:SetIcon("polarglobe.png")
	
	inst.AnimState:SetBank("polarglobe")
	inst.AnimState:SetBuild("polarglobe")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("irreplaceable")
	inst:AddTag("snowglobe")
	
	MakeInventoryFloatable(inst, "med", 0.5)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.season_data = {}
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.DRYICE
	inst.components.fueled:InitializeFuelLevel(1)
	inst.components.fueled:SetTakeFuelFn(OnTakeFuel)
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.cooldowntime = 0
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = CalcSanityAura
	
	MakeHauntableLaunch(inst) -- TODO: use on haunt
	
	inst.OnGlobeShake = OnGlobeShake
	inst.OnSeasonTick = OnSeasonTick
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("seasontick", function(src, data) inst:OnSeasonTick(data) end, TheWorld)
	
	return inst
end

return Prefab("polarglobe", fn, assets, prefabs)