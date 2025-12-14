local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local gnomes = {"trinket_4", "trinket_13"}

for i, v in ipairs(gnomes) do
	ENV.AddPrefabPostInit(v, function(inst)
		inst:AddTag("snowhidden")
	end)
end