chestfunctions = require("scenarios/chestfunctions")

local mole_bundle = {
	{"flint", 	0.3},
	{"flint", 	0.2},
	{"flint", 	0.1},
	{"mole", 	1},
	{"mole", 	0.8},
	{"mole", 	0.4},
}

local function BundleMoles(item)
	local bundle_items = {}
	
	for k, v in pairs(mole_bundle) do
		if math.random() < v[2] then
			local amt = bundle_items[v[1]] or 0
			bundle_items[v[1]] = amt + 1
		end
	end
	
	local i = 1
	local items = {}
	for k, v in pairs(bundle_items) do
		items[i] = SpawnPrefab(k)
		
		if v > 1 then
			if items[i].components.stackable then
				items[i].components.stackable:SetStackSize(v)
			else
				for j = 2, v do
					i = i + 1
					items[i] = SpawnPrefab(k)
				end
			end
		end
		
		if i > 4 then
			break
		else
			i = i + 1
		end
	end
	
	if item.components.unwrappable then
		item.components.unwrappable:WrapItems(items)
	end
end

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
			item = "bundle",
			initfn = BundleMoles,
		},
		{
			item = "seeds",
			count = math.random(4, 8),
			initfn = RandomPerishPercent,
		},
		{
			item = "twigs",
			count = math.random(4, 6),
		},
		--[[{
			item = "mole",
			initfn = RandomPerishPercent,
		},
		{
			item = "mole",
			chance = 0.5,
			initfn = RandomPerishPercent,
		},]]
	}
	
	chestfunctions.AddChestItems(inst, loot)
end

return {
	OnCreate = OnCreate,
}