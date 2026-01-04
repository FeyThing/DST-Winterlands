local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local MOB_HEADS = {
	pighead = {tags = {"pig", "pigtype"}},
	mermhead = {tags = {"merm"}},
}

for prefab, data in pairs(MOB_HEADS) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("mobhead_combat")
		
		inst.mobhead_combat_mods = {
			armormult = TUNING.MOBHEADS_COMBAT_ARMOR_MULT,
			damagemult = TUNING.MOBHEADS_COMBAT_DAMAGE_MULT,
			stacking = TUNING.MOBHEADS_COMBAT_BUFF_STACKING,
			tags = data.tags,
			not_tags = data.nottags,
		}
		
		if not TheWorld.ismastersim then
			return
		end
		
		inst.face_left = math.random() > 0.5
		local scale = inst.face_left and 1 or -1
		inst.AnimState:SetScale(scale, 1)
	end)
end