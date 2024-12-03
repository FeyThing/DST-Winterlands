NUM_POLARTRINKETS = 2

local POLAR_NAUGHTY_VALUE = {
	moose_polar = 4,
	polarbear = 3,
	polarfox = 6,
}

for k, v in pairs(POLAR_NAUGHTY_VALUE) do
	NAUGHTY_VALUE[k] = v
end

FUELTYPE.DRYICE = "DRYICE"

MATERIALS.DRYICE = "dryice"

OCEAN_DEPTH.POLAR = 5

TECH_INGREDIENT.POLARSNOW = "polarsnow_material"