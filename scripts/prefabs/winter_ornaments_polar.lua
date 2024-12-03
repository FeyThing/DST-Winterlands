local BLINK_PERIOD = 1.2

local LIGHT_DATA = {
	{colour = Vector3(1, 0.1, 0.1)},
}

function GetAllPolarWinterOrnamentPrefabs()
	local decor = {
		"winter_ornament_boss_icicle_blue",
		"winter_ornament_boss_icicle_white",
	}
	
	return decor
end

local function UpdateLight(inst, data)
	if data and data.name == "blink" then
		inst.ornamentlighton = not inst.ornamentlighton
		local owner = inst.components.inventoryitem:GetGrandOwner()
		
		if owner then
			owner:PushEvent("updatelight", inst)
		else
			inst.Light:Enable(inst.ornamentlighton)
			inst.AnimState:PlayAnimation(inst.winter_ornamentid .. (inst.ornamentlighton and "_on" or "_off"))
		end
		if not inst.components.timer:TimerExists("blink") then
			inst.components.timer:StartTimer("blink", BLINK_PERIOD)
		end
	end
end

local function OnDropped(inst)
	inst.ornamentlighton = false
	UpdateLight(inst, {name = "blink"})
	inst.components.fueled:StartConsuming()
end

local function OnPickUp(inst, by)
	if by and by:HasTag("winter_tree") then
		if not inst.components.timer:TimerExists("blink") then
			inst.ornamentlighton = false
			UpdateLight(inst, {name = "blink"})
		end
		inst.components.fueled:StartConsuming()
	else
		inst.ornamentlighton = false
		inst.Light:Enable(false)
		inst.components.timer:StopTimer("blink")
		
		if by and by:HasTag("lamp") then
			inst.components.fueled:StartConsuming()
		else
			inst.components.fueled:StopConsuming()
		end
	end
end

local function OnEntityWake(inst)
	if inst.components.timer:IsPaused("blink") then
		inst.components.timer:ResumeTimer("blink")
	elseif inst.components.fueled.consuming then
		UpdateLight(inst, {name = "blink"})
	end
end

local function OnEntitySleep(inst)
	inst.components.timer:PauseTimer("blink")
end

local function OnDepleted(inst)
	inst.ornamentlighton = false
	local owner = inst.components.inventoryitem:GetGrandOwner()
	
	if owner then
		owner:PushEvent("updatelight", inst)
	end
	
	inst.Light:Enable(false)
	inst.AnimState:PlayAnimation(inst.winter_ornamentid.."_off")
	inst.components.timer:StopTimer("blink")
	inst.components.fueled:StopConsuming()
	inst.components.inventoryitem:SetOnDroppedFn(nil)
	inst.components.inventoryitem:SetOnPutInInventoryFn(nil)
	inst.OnEntitySleep = nil
	inst.OnEntityWake = nil
	inst.OnSave = nil
	
	if inst.components.fuel then
		inst:RemoveComponent("fuel")
	end
end

local function OnSave(inst, data)
	data.ornamentlighton = inst.ornamentlighton
end

local function OnLoad(inst, data)
	if inst.components.fueled:IsEmpty() then
		OnDepleted(inst)
	elseif data then
		inst.ornamentlighton = data.ornamentlighton
	end
end

local function MakeOrnament(ornamentid, overridename, lightdata, float_scale)
	local build = "winter_ornaments_polar"
	
	local assets = {
		Asset("ANIM", "anim/"..build..".zip"),
	}
	
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst, 0.1)
		
		inst.AnimState:SetBank(build)
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation(tostring(ornamentid))
		
		inst:AddTag("winter_ornament")
		inst:AddTag("molebait")
		inst:AddTag("cattoy")
		
		inst.winter_ornamentid = ornamentid
		inst.winter_ornament_build = build
		
		inst:SetPrefabNameOverride(overridename)
		
		if lightdata then
			inst.entity:AddLight()
			inst.Light:SetFalloff(0.7)
			inst.Light:SetIntensity(0.5)
			inst.Light:SetRadius(0.5)
			inst.Light:SetColour(lightdata.colour.x, lightdata.colour.y, lightdata.colour.z)
			inst.Light:Enable(false)
			
			inst:AddTag("lightbattery")
			
			inst.AnimState:PlayAnimation(tostring(ornamentid).."_on")
		else
			inst.AnimState:PlayAnimation(tostring(ornamentid))
		end
		
		MakeInventoryFloatable(inst)
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")
		
		if float_scale ~= nil then
			inst.components.floater:SetScale(float_scale)
		end
		
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = lightdata ~= nil and 3 or 2
		
		if lightdata then
			inst:AddComponent("fueled")
			inst.components.fueled.fueltype = FUELTYPE.USAGE
			inst.components.fueled.no_sewing = true
			inst.components.fueled:InitializeFuelLevel(160 * TUNING.TOTAL_DAY_TIME)
			inst.components.fueled:SetDepletedFn(OnDepleted)
			inst.components.fueled:StartConsuming()
			
			inst:AddComponent("timer")
			inst:ListenForEvent("timerdone", UpdateLight)
			
			inst:AddComponent("fuel")
			inst.components.fuel.fuelvalue = TUNING.MED_LARGE_FUEL
			inst.components.fuel.fueltype = FUELTYPE.CAVE
			
			inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
			inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickUp)
			
			inst.OnEntitySleep = OnEntitySleep
			inst.OnEntityWake = OnEntityWake
			inst.OnSave = OnSave
			inst.OnLoad = OnLoad
			
			inst.ornamentlighton = math.random() < 0.5
			inst.components.timer:StartTimer("blink", math.random() * BLINK_PERIOD)
		else
			inst:AddComponent("stackable")
			inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		end
		
		MakeHauntableLaunch(inst)
		
		return inst
	end
	
	return Prefab("winter_ornament_"..tostring(ornamentid), fn, assets)
end

local ornament = {}

table.insert(ornament, MakeOrnament("polar_icicle_blue", "winter_ornamentpolar"))
table.insert(ornament, MakeOrnament("polar_icicle_white", "winter_ornamentpolar"))

return unpack(ornament)