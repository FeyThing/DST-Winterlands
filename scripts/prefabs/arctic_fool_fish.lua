local assets = {
	Asset("ANIM", "anim/arctic_fool_fish.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("arctic_fool_fish")
	inst.AnimState:SetBuild("arctic_fool_fish")
	inst.AnimState:PlayAnimation("item")
	
	inst:AddComponent("arcticfoolfish")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
	
	MakeHauntableLaunch(inst)
	
	return inst
end

--

local function ColourChanged(inst, r, g, b, a)
	if inst.fx then
		for i, v in ipairs(inst.fx) do
			v.AnimState:SetAddColour(r, g, b, a)
		end
	end
end

local function OnRemoveEntity(inst)
	if inst.fx then
		for i, v in ipairs(inst.fx) do
			v:Remove()
		end
	end
end

local function OnUpdate(inst)
	local owner = inst.entity:GetParent()
	
	if owner and owner:IsValid() then
		local move_anim = owner.AnimState:IsCurrentAnimation("run_loop") and "run" or owner:HasTag("moving") and "walk" or nil
		local wrong_side = inst.face_up_only and owner.AnimState:GetCurrentFacing() ~= FACING_UP or nil -- TODO: Maybe some mobs could also allow up-sides ?
		
		if move_anim ~= inst.move_anim then
			inst.move_anim = move_anim
			
			for i, v in ipairs(inst.fx) do
				v.AnimState:PlayAnimation(inst.move_anim or "idle", true)
			end
		end
		
		if wrong_side ~= inst.wrong_side then
			inst.wrong_side = wrong_side
			
			for i, v in ipairs(inst.fx) do
				if wrong_side then
					v:Hide()
				else
					v:Show()
				end
			end
		end
	end
end

local function SpawnFishForOwner(inst, owner)
	if inst.components.arcticfoolfish and inst:HasTag("arcticfoolfish") then
		inst.components.arcticfoolfish:ApplyFish(owner)
		
		local data = inst.components.arcticfoolfish:GetStickyData(owner)
		inst.face_up_only = data and data.face_up_only or nil
	end
	
	if owner:HasTag("locomotor") or inst.face_up_only then
		inst:AddComponent("updatelooper")
		inst.components.updatelooper:AddOnUpdateFn(OnUpdate)
	end
	
	inst.components.colouraddersync:SetColourChangedFn(ColourChanged)
	inst.OnRemoveEntity = OnRemoveEntity
end

local function OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	
	if owner then
		SpawnFishForOwner(inst, owner)
	end
end

local function AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	if owner.components.colouradder then
		owner.components.colouradder:AttachChild(inst)
	end
	
	if not TheNet:IsDedicated() then
		SpawnFishForOwner(inst, owner)
	end
	
	if inst._pranktask == nil then
		inst._pranktask = inst:DoPeriodicTask(TUNING.ARCTIC_FOOL_FISH_PRANK_PERIOD, inst.PrankEm)
	end
end

local function OnRemoved(inst)
	local target = inst.components.arcticfoolfish and inst.components.arcticfoolfish.target
	if target and target:IsValid() then
		target:RemoveTag("arcticfooled")
	end
	
	if inst.fx then
		for i, v in ipairs(inst.fx) do
			v:Remove()
		end
	end
end

local PRANK_TAGS = {"_combat"}
local PRANK_NOT_TAGS = {"INLIMBO", "companion", "player"}

local function PrankEm(inst)
	local owner = inst.entity:GetParent()
	
	if owner and owner:IsValid() and owner.components.combat and owner.components.health and not owner.components.health:IsDead() and not owner:HasTag("playerghost") then
		local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.ARCTIC_FOOL_FISH_PRANK_RANGE, PRANK_TAGS, PRANK_NOT_TAGS)
		
		for i, v in ipairs(ents) do
			if v ~= owner and v.components.combat and v.components.combat.target == nil and math.random() < TUNING.ARCTIC_FOOL_FISH_PRANK_CHANCE
				and not (v.components.timer and v.components.timer:TimerExists("arcticfooled_cooldown"))
				and not (v.components.follower and v.components.follower.leader == owner) then
				
				v.components.combat:SuggestTarget(owner)
			end
		end
	end
end

local function back()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("arcticfoolfish")
	inst:AddTag("FX")
	
	inst:AddComponent("arcticfoolfish")
	
	inst:AddComponent("colouraddersync")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = OnEntityReplicated
		
		return inst
	end
	
	inst.persists = false
	
	inst.AttachToOwner = AttachToOwner
	inst.PrankEm = PrankEm
	
	inst:ListenForEvent("onremove", OnRemoved)
	
	return inst
end

return Prefab("arctic_fool_fish", fn, assets),
	Prefab("arctic_fool_fish_back", back, assets)