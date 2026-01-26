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

local function UrsaMajorBuffFn(inst, scale)
	if inst.components.colourtweener == nil then
		inst:AddComponent("colourtweener")
	end
	
	inst.AnimState:SetMultColour(1, 0, 0, 0)
	inst.components.colourtweener:StartTween({1, 1, 1, 0.3 + math.random() * 0.6}, FRAMES * math.random(6, 11))
	
	inst.entity:AddSoundEmitter()
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/swhoosh", nil, 0.6 + math.random() * 0.2)
end

local function PolarSplashFn(inst, scale)
	inst.AnimState:SetScale(0.4 * scale, 0.6 * scale)
	inst.AnimState:SetMultColour(1, 1, 1, 0.5)
	inst.AnimState:SetFinalOffset(3)
end

local POLAR_FX = {
	{
		name = "buff_ursamajor_atk_fx",
		bank = "buff_ursamajor_fx",
		build = "buff_ursamajor_fx",
		anim = "atk",
		fourfaced = true,
		fn = UrsaMajorBuffFn,
	},
	{
		name = "buff_ursamajor_chop_fx",
		bank = "buff_ursamajor_fx",
		build = "buff_ursamajor_fx",
		anim = "chop",
		fourfaced = true,
		fn = UrsaMajorBuffFn,
	},
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
	},
	{
		name = "mole_move_polar_fx",
		bank = "mole_fx",
		build = "mole_move_fx",
		anim = "move",
		nameoverride = STRINGS.NAMES.MOLE_UNDERGROUND_POLAR,
		description = function(inst, viewer)
			return GetString(viewer, "DESCRIBE", {"MOLE", "UNDERGROUND"})
		end,
		fn = function(inst)
			inst.AnimState:OverrideSymbol("molemovefx", "dirt_to_polar_builds", "molemovefx")
		end,
	},
	{
		name = "walrus_beartrap_snapfx",
		bank = "walrus_beartrap",
		build = "walrus_beartrap",
		anim = "fx",
		fn = FinalOffset3,
	},
	{
		name = "pocketwatch_polar_fx",
		bank = "pocketwatch_polar_fx",
		build = "pocketwatch_polar_fx",
		anim = "pocketwatch_polar_fx_pre",
		animqueue = true,
		bloom = true,
		fn = function(inst)
			inst.AnimState:PushAnimation("pocketwatch_polar_fx_loop", false)
			inst.AnimState:PushAnimation("pocketwatch_polar_fx_pst", false)
			FinalOffset3(inst)
		end,
	},
	{
		name = "pocketwatch_polar_fx_mount",
		bank = "pocketwatch_polar_fx",
		build = "pocketwatch_polar_fx",
		anim = "pocketwatch_polar_fx_pre",
		animqueue = true,
		fn = function(inst)
			inst.AnimState:PushAnimation("pocketwatch_polar_fx_loop", false)
			inst.AnimState:PushAnimation("pocketwatch_polar_fx_pst", false)
			FinalOffset3(inst)
		end,
	},
	{
		name = "winters_fists_snowball_roll_fx",
		bank = "splash",
		build = "splash_snow",
		anim = "idle",
		fn = function(inst)
			local scale = 0.5 + math.random() * 0.35
			inst.AnimState:SetScale(math.random() < 0.5 and scale or -scale, scale)
			FinalOffset2(inst)
		end,
	},
}

require("fx")

if package.loaded.fx then
	for k, v in pairs(POLAR_FX) do
		table.insert(package.loaded.fx, v)
		table.insert(ENV.Assets, Asset("ANIM", "anim/"..v.build..".zip"))
	end
end