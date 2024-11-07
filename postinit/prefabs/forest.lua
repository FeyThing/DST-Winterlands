local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddPrefabPostInit("forest", function(inst)
	if not inst.ismastersim then
		return
	end
	
	inst:AddComponent("polarpenguinspawner")
end)