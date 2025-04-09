local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	TODO: convert dirt into snow

ENV.AddPrefabPostInit("dirtpile", function(inst)
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "dirtpile._snowblockrange")
	inst._snowblockrange:set(3)
end)