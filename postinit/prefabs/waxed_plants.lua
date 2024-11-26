local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- Inventory atlas fix

local plants = {
	"dug_grass_polar_waxed",
}

for i, v in ipairs(plants) do
	ENV.AddPrefabPostInit(v, function(inst)
		if inst.components.inventoryitem then
			inst.components.inventoryitem.atlasname = POLAR_ATLAS
		end
	end)
end