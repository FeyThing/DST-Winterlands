chestfunctions = require("scenarios/chestfunctions")

local function RandomPerishPercent(item)
	if item.components.perishable then
		item.components.perishable:SetPercent(GetRandomMinMax(0.75, 1))
	end
end

local function OnCreate(inst, scenariorunner)
	local loot = {
		{
			item = {"fishmeat", "fishmeat_small"},
			count = math.random(2, 4),
			initfn = RandomPerishPercent,
		},
		{
			item = {"fishmeat", "fishmeat_small"},
			chance = 0.5,
			count = math.random(1, 3),
			initfn = RandomPerishPercent,
		},
		{
			item = "monstermeat",
			chance = 0.5,
			count = math.random(2, 5),
			initfn = RandomPerishPercent,
		},
		{
			item = "heatrock",
			chance = 0.5,
		},
		{
			item = {"bird_egg", "rottenegg"},
			count = math.random(3, 4),
			chance = 0.5,
			initfn = RandomPerishPercent,
		},
		{
			item = "ice",
			count = math.random(10, 20),
		},
		{
			item = "polar_dryice",
			count = math.random(1, 3),
			chance = 0.5,
		},
	}
	
	shuffleArray(loot)
	
	chestfunctions.AddChestItems(inst, loot)
end

return {
	OnCreate = OnCreate
}