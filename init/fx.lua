local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function FinalOffset1(inst)
	inst.AnimState:SetFinalOffset(1)
end

local function FinalOffset2(inst)
	inst.AnimState:SetFinalOffset(2)
end

local function FinalOffset3(inst)
	inst.AnimState:SetFinalOffset(3)
end

local function GroundOrientation(inst)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
end

local function PolarSplashFn(inst, scale)
	inst.AnimState:SetScale(0.4 * scale, 0.6 * scale)
	inst.AnimState:SetMultColour(1, 1, 1, 0.5)
	inst.AnimState:SetFinalOffset(3)
end

local POLAR_FX = {
	{
		name = "polar_splash",
		bank = "splash",
		build = "splash_snow",
		anim = "idle",
		fn = function(inst)
			PolarSplashFn(inst, 1)
		end,
	},
	{
		name = "polar_splash_large",
		bank = "splash",
		build = "splash_snow",
		anim = "idle",
		fn = function(inst)
			PolarSplashFn(inst, 2)
		end,
	},
	{
		name = "polar_splash_epic",
		bank = "splash",
		build = "splash_snow",
		anim = "idle",
		fn = function(inst)
			PolarSplashFn(inst, 3)
		end,
	},
	{
		name = "iciclestaff_icicle_break_fx",
		bank = "mining_fx",
		build = "mining_ice_fx",
		anim = "anim",
		sound = "dontstarve/creatures/together/antlion/sfx/sand_to_glass",
		sounddelay = FRAMES * 2
	}
}

require("fx")

if package.loaded.fx then
	for k, v in pairs(POLAR_FX) do
		table.insert(package.loaded.fx, v)
		table.insert(ENV.Assets, Asset("ANIM", "anim/"..v.build..".zip"))
	end
end