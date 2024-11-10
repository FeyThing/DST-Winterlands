local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local penguin_prefabs = {
	"penguin",
	"penguin_ice",
	"penguinherd",
	"mutated_penguin",
	"rock_ice",
}

for i, v in ipairs(penguin_prefabs) do
	local function OnPolarInit(inst)
		if IsInPolar(inst) and (inst.prefab ~= "rock_ice" or inst.remove_on_dryup) then
			inst:Hide()
			inst:DoTaskInTime(0.1, inst.Remove)
		end
	end
	
	ENV.AddPrefabPostInit(v, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:DoTaskInTime(0, OnPolarInit)
	end)
end