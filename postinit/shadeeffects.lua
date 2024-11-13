local ENV = env
GLOBAL.setfenv(1, GLOBAL)

if TheNet:IsDedicated() then
	local nullfunc = function() end
	
	SpawnPolarCaveShade = nullfunc
	DespawnPolarCaveShade = nullfunc
	ShadeRendererEnabled = nil
	
	return
end

ShadeTypes.PolarCaveShade = ShadeRenderer:CreateShadeType()

ShadeRenderer:SetShadeMaxRotation(ShadeTypes.PolarCaveShade, 0) 

ShadeRenderer:SetShadeRotationSpeed(ShadeTypes.PolarCaveShade, 0) 

ShadeRenderer:SetShadeMaxTranslation(ShadeTypes.PolarCaveShade, 0) 

ShadeRenderer:SetShadeTranslationSpeed(ShadeTypes.PolarCaveShade, 0) 

ShadeRenderer:SetShadeTexture(ShadeTypes.PolarCaveShade, resolvefilepath("images/polarpillar.tex"))

function SpawnPolarCaveShade(x, z)
	return ShadeRenderer:SpawnShade(ShadeTypes.PolarCaveShade, x, z, math.random() * 360, TUNING.SHADE_POLAR_SCALE)
end

function DespawnPolarCaveShade(id)
	ShadeRenderer:RemoveShade(ShadeTypes.PolarCaveShade, id)
end

local OldShadeEffectUpdate = ShadeEffectUpdate
function ShadeEffectUpdate(dt, ...)
	local r, g, b = TheSim:GetAmbientColour()
	ShadeRenderer:SetShadeStrength(ShadeTypes.PolarCaveShade, Lerp(0.3, 0.5, ((r + g + b) / 3) / 255))
	
	return OldShadeEffectUpdate(dt, ...)
end