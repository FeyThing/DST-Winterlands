local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	Adding a tag to some specific prefabs that are problematic when replicated on the Timefreeze Watch afterimage FX

local noafterimagecopy_prefabs = {
	"alterguardianhat",
	
--	Added in original prefab scripts

	--"polar_amulet",
}

for i, v in ipairs(noafterimagecopy_prefabs) do
	ENV.AddPrefabPostInit(v, function(inst)
		inst:AddTag("noafterimagecopy")
	end)
end