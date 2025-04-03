local function CreateFxFollowFrame(back_id, sym, build, scale)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("arctic_fool_fish")
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
	if sym then
		inst.AnimState:OverrideSymbol("fish01", build, sym)
	end
	if scale then
		inst.AnimState:SetScale(scale, scale)
	end
	
	inst:AddComponent("colourtweener")
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	
	return inst
end

--

local ArcticFoolFish = Class(function(self, inst)
	self.inst = inst
	
	self.fish_build = nil
	self.fish_sym = nil
	
	self.pranker_id = nil
	self.target = nil
end)

function ArcticFoolFish:GetFishStyle(target)
	local sym, build = "fish0"..math.random(2), "arctic_fool_fish" -- TODO: add more variety 
	
	return sym, build
end

function ArcticFoolFish:GetStickyData(target)
	if ARCTIC_FOOLS_MOBS[target.prefab] then
		return ARCTIC_FOOLS_MOBS[target.prefab]
	end
	
	for i, data in ipairs(ARCTIC_FOOLS_TAGS) do
		if target:HasTag(data.tag) and (data.nottags == nil or not target:HasAnyTag(data.nottags)) then
			return ARCTIC_FOOLS_TAGS[i]
		end
	end
end

function ArcticFoolFish:CanStickOnBack(target, pranker)
	if target:HasTag("arcticfooled") then
		return false
	end
	
	return self:GetStickyData(target) ~= nil
end

function ArcticFoolFish:ApplyFish(target)
	local data = self:GetStickyData(target) or {}
	data.offset = data.offset or {0, 0, 0}
	
	local sym, build
	if self.fish_build == nil then
		sym, build = self:GetFishStyle(target)
		
		self.fish_build = build
		self.fish_sym = sym
	else
		sym, build = self.fish_sym, self.fish_build
	end
	
	if self.inst.fx == nil then
		self.inst.fx = {}
	end
	
	for i, up_i in ipairs(data.ups) do
		local fx = CreateFxFollowFrame(up_i, sym, build, data.scale)
		fx.entity:SetParent(target.entity)
		
		fx.Follower:FollowSymbol(target.GUID, data.sym, data.offset[1], data.offset[2], data.offset[3], false, nil, up_i)
		fx.components.highlightchild:SetOwner(target)
		
		table.insert(self.inst.fx, fx)
	end
end

function ArcticFoolFish:StickOnBack(target, pranker)
	if target == nil or not target:IsValid() then
		return
	end
	
	local fish = SpawnPrefab("arctic_fool_fish_back")
	if self.inst.components.stackable then
		self.inst.components.stackable:Get():Remove()
	else
		self.inst:Remove()
	end
	
	--[[TODO: If we can re-replicate the entity then we don't really need the _back fish (and the above), just keep using the same one
	if self.inst.components.stackable then
		fish = self.inst.components.stackable:Get()
	end
	
	fish:AddTag("arcticfoolfish")
	if fish.components.inventoryitem then
		fish.components.inventoryitem.canbepickedup = false
	end
	
	if pranker and pranker.components.inventory then
		pranker.components.inventory:RemoveItem(fish)
	end
	fish:RemoveFromScene()]]
	
	local fish_component = fish.components.arcticfoolfish
	fish_component.pranker_id = pranker and (pranker.userid or pranker.GUID)
	fish_component.target = target
	
	if pranker and pranker._usearcticfoolfish then
		if not TheWorld.ismastersim then
			pranker._usearcticfoolfish:push()
		else
			TheFrontEnd:GetSound():PlaySound("polarsounds/arctic_fools/stick_fish")
		end
	end
	
	--
	
	target:ListenForEvent("attacked", function(src, data)
		local attacker = data and data.attacker
		if attacker and attacker.components.health and attacker.userid ~= fish_component.pranker_id then
			fish_component:AmusePranker()
		end
	end)
	
	target:ListenForEvent("death", function(src)
		fish_component:UnstickFromBack(target)
		fish:Remove()
	end)
	
	target:ListenForEvent("enterlimbo", function(src)
		fish_component:UnstickFromBack(target)
		fish:Remove()
	end)
	
	target:ListenForEvent("onremove", function(src)
		fish_component:UnstickFromBack(target)
		fish:Remove()
	end)
	
	--
	
	target:AddTag("arcticfooled")
	
	if fish.AttachToOwner then
		fish:AttachToOwner(target)
	end
	
	target:PushEvent("arcticfooled", {fish = fish, pranker = pranker})
	
	if TheWorld.components.arcticfoolfishsavedata then
		TheWorld.components.arcticfoolfishsavedata:UpdateArcticFoolFish(fish, target, true)
	end
	
	return fish
end

function ArcticFoolFish:UnstickFromBack(target)
	if target.components.sanity then
		target.components.sanity:DoDelta(TUNING.ARCTIC_FOOL_FISH_PRANKED_SANITY)
	end
	
	if TheWorld.components.arcticfoolfishsavedata then
		TheWorld.components.arcticfoolfishsavedata:UpdateArcticFoolFish(self.inst, target)
	end
	
	target:RemoveTag("arcticfooled")
end

function ArcticFoolFish:AmusePranker()
	local dist = TUNING.ARCTIC_FOOL_FISH_PRANKER_MAX_DIST
	
	for i, v in ipairs(AllPlayers) do
		if v.userid == self.pranker_id and self.target and self.target:IsValid() and v:GetDistanceSqToInst(self.target) < dist * dist then
			if v.components.timer == nil then
				v:AddComponent("timer")
			end
			
			if v.components.sanity and not v.components.timer:TimerExists("watchedarcticfool") then
				v.components.sanity:DoDelta(TUNING.ARCTIC_FOOL_FISH_PRANKER_SANITY)
				
				v.components.timer:StartTimer("watchedarcticfool", TUNING.ARCTIC_FOOL_FISH_PRANKER_COOLDOWN)
			end
		end
	end
end

return ArcticFoolFish