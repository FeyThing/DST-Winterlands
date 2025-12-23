local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local MOB_HEADS = {
	pighead = {tags = {"pig"}},
	mermhead = {tags = {"merm"}},
}

for prefab, data in pairs(MOB_HEADS) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst.face_left = math.random() > 0.5
		local scale = inst.face_left and 1 or -1
		inst.AnimState:SetScale(scale, 1)
	end)
end