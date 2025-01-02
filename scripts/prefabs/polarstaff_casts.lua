local assets = {
	Asset("ANIM", "anim/icicle_staff.zip")
}

local aura_assets = {
	Asset("ANIM", "anim/deer_ice_circle.zip"),
}

local prefabs = {
	"iciclestaff_icicle_break_fx"
}

local function Break(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:IsOceanAtPoint(x, 0, z) then
		SpawnPrefab("splash_sink").Transform:SetPosition(x, 0, z)
	else
		SpawnPrefab("iciclestaff_icicle_break_fx").Transform:SetPosition(x, 0, z)
	end
	
	inst:Remove()
end

local MUST_TAGS = {"_combat"}
local CANT_TAGS = {"INLIMBO", "playerghost", "flight", "icicleimmune"}

local function DoDamage(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, 0, z, 4, MUST_TAGS, CANT_TAGS)
	for i, ent in ipairs(ents) do
		if ent:IsValid() then
			local r = ent.Physics and ent.Physics:GetRadius() or 0
			local hit_rad = r >= 0.75 and (2 + r) or 2
			
			if ent:GetDistanceSqToPoint(x, y, z) <= hit_rad * hit_rad then
				if ent:HasTag("player") and not TheNet:GetPVPEnabled() and ent ~= inst.owner then
					-- continue
				else
					ent.components.combat:GetAttacked(inst, TUNING.ICICLESTAFF_DAMAGE)
				end
			end
		end
	end
	
	Break(inst)
end


local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.AnimState:SetBank("icicle_staff")
	inst.AnimState:SetBuild("icicle_staff")
	inst.AnimState:PlayAnimation("fall")
	
	inst.AnimState:SetScale(0.5, 0.65)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.owner = nil
	
	inst:ListenForEvent("animover", DoDamage)
	inst:DoTaskInTime(0.5, inst.Remove)
	
	return inst
end

local function aura()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("deer_ice_circle")
	inst.AnimState:SetBuild("deer_ice_circle")
	inst.AnimState:PlayAnimation("pre")
	inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:SetScale(2, 2)
	
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("colourtweener")
	
	inst.persists = false
	
	inst:DoTaskInTime(3, function()
		inst.components.colourtweener:StartTween({1, 1, 1, 0.5}, 2)
	end)
	
	inst:DoTaskInTime(5, function()
		inst.AnimState:PlayAnimation("pst")
	end)
	
	return inst
end

return Prefab("polar_icicle_staff", fn, assets, prefabs),
	Prefab("polar_frostaura", aura, aura_assets)