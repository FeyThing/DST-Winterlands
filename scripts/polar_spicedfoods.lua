local spicedfoods = {}
local polarfoods = require("polar_preparedfoods")

GenerateSpicedFoods(polarfoods)

local spices = require("spicedfoods")

for k, data in pairs(spices) do
	for name, v in pairs(polarfoods) do
		if data.basename == name then
			spicedfoods[k] = data
		end
	end
end

return spicedfoods