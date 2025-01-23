chestfunctions = require("scenarios/chestfunctions")

local function RandomPerishPercent(item)
	if item.components.perishable then
		item.components.perishable:SetPercent(GetRandomMinMax(0.5, 1))
	end
end

local function OnCreate(inst, scenariorunner)
	local loot = {
		{
			item = "tophat",
		},
		{
			item = "pigskin",
			count = 3,
		},
		{
			item = "log",
			chance = 0.5,
			count = math.random(1, 2),
		},
		{
			item = "seeds",
			count = math.random(4, 8),
			--initfn = RandomPerishPercent,
		},
		{
			item = "twigs",
			count = math.random(4, 6),
		},
		{
			item = "mole",
			--initfn = RandomPerishPercent,
		},
		{
			item = "mole",
			chance = 0.5,
			--initfn = RandomPerishPercent,
		},
	}
	
	chestfunctions.AddChestItems(inst, loot)
end

return {
	OnCreate = OnCreate,
}