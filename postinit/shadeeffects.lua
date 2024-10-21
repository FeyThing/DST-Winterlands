local ENV = env
GLOBAL.setfenv(1, GLOBAL)

if TheNet:IsDedicated() then
	local nullfunc = function() end
	
	SpawnIceCavePillarShade = nullfunc
	DespawnIceCavePillarShade = nullfunc
	ShadeRendererEnabled = nil
	
	return
end

ShadeTypes.IceCavePillarShade = ShadeRenderer:CreateShadeType()


ShadeRenderer:SetShadeMaxRotation(ShadeTypes.IceCavePillarShade, 0) 

ShadeRenderer:SetShadeRotationSpeed(ShadeTypes.IceCavePillarShade, 0) 

ShadeRenderer:SetShadeMaxTranslation(ShadeTypes.IceCavePillarShade, 0) 

ShadeRenderer:SetShadeTranslationSpeed(ShadeTypes.IceCavePillarShade, 0) 

ShadeRenderer:SetShadeTexture(ShadeTypes.IceCavePillarShade, resolvefilepath("images/icecavepillar.tex"))


function SpawnIceCavePillarShade(x, z)
	return ShadeRenderer:SpawnShade(ShadeTypes.IceCavePillarShade, x, z, math.random() * 360, TUNING.CANOPY_SCALE)
end

function DespawnIceCavePillarShade(id)
	ShadeRenderer:RemoveShade(ShadeTypes.IceCavePillarShade, id)
end

local OldShadeEffectUpdate = ShadeEffectUpdate

function ShadeEffectUpdate(dt, ...)
	local r, g, b = TheSim:GetAmbientColour()
	
	ShadeRenderer:SetShadeStrength(ShadeTypes.IceCavePillarShade, Lerp(0.3, 0.5, ((r + g + b) / 3) / 255)) 
	return OldShadeEffectUpdate(dt, ...)
end