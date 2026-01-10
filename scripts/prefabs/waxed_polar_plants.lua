local WAXED_PLANTS = require "prefabs/waxed_plant_common"

ASSETS = {
	Asset("SCRIPT", "scripts/prefabs/waxed_plant_common.lua")
}

-------------------------------------------------------------------------------------------------

local function Plantable_GetAnimFn(inst)
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		return "idle"
	end
	
	if (inst.components.pickable and inst.components.pickable:IsBarren()) or (inst.components.witherable and inst.components.witherable:IsWithered()) then
		return "dead"
	end
	
	return "picked"
end

local function Tree_MultColorFn()
	return 0.5 + math.random() * 0.5
end

local function Tree_Minimap_CommonPostInit(inst)
	inst.MiniMapEntity:SetPriority(-1)
end

local function TreeSapling_GetAnimFn(inst)
	return inst.prefab
end

-------------------------------------------------------------------------------------------------

local GRASS_ANIMSET = {
	idle = {anim = "idle"},
	picked = {anim = "picked"},
	dead = {anim = "idle_dead"},
}

local function Grass_MultColorFn()
	return 0.75 + math.random() * 0.25
end

-------------------------------------------------------------------------------------------------

local function CreateWaxedTreeSapling(name, _build, _anim, deployspacing)
	local animset = {[name.."_sapling"] = {anim = _anim}}
	
	return WAXED_PLANTS.CreateWaxedPlant({
		prefab = name.."_sapling",
		bank = _build,
		build = _build,
		anim = _anim,
		action = "DIG",
		animset = animset,
		getanim_fn = TreeSapling_GetAnimFn,
		assets = ASSETS,
		deployspacing = deployspacing,
	})
end

-------------------------------------------------------------------------------------------------

local DECIDPOLAR_ANIMSET_LIST = {
	"sway1_loop", "sway2_loop", "burnt", "stump"
}

local DECIDPOLAR_ANIMSET = {}

for _, anim in ipairs(DECIDPOLAR_ANIMSET_LIST) do
	local short, normal, tall = anim.."_short", anim.."_normal", anim.."_tall"
	
	if anim == "burnt" or anim == "stump" then
		local minimapicon = "tree_leafy_"..anim..".png"
		
		DECIDPOLAR_ANIMSET[short] = {anim = short, minimap = minimapicon, stump = anim == "stump"}
		DECIDPOLAR_ANIMSET[normal] = {anim = normal, minimap = minimapicon, stump = anim == "stump"}
		DECIDPOLAR_ANIMSET[tall] = {anim = tall, minimap = minimapicon, stump = anim == "stump"}
	else
		DECIDPOLAR_ANIMSET[short] = {anim = short, minimap = "tree_leafy_polar.png"}
		DECIDPOLAR_ANIMSET[normal] = {anim = normal, minimap = "tree_leafy_polar.png"}
		DECIDPOLAR_ANIMSET[tall] = {anim = tall, minimap = "tree_leafy_polar.png"}
	end
end

local function DecidPolar_GetAnimFn(inst)
	if inst:HasTag("burnt") or (inst.components.burnable and inst.components.burnable:IsBurning()) then
		return "burnt_"..inst.size
	end
	
	if inst:HasTag("stump") then
		return "stump_"..inst.size
	end
	
	return inst.AnimState:IsCurrentAnimation("sway2_loop_"..inst.size) and "sway2_loop_"..inst.size or "sway1_loop_"..inst.size
end

local function DecidPolar_CommonPostInit(inst)
	inst.MiniMapEntity:SetPriority(-1)
	
	inst.displayname = "DECIDUOUSTREE"
end

-------------------------------------------------------------------------------------------------

local ret = {
	CreateWaxedTreeSapling("antler_tree", "antler_tree_sapling", "idle_planted"),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab = "grass_polar",
		bank = "grass_tall",
		build = "grass_polar",
		minimapicon = "grass",
		anim = "idle",
		action = "DIG",
		animset = GRASS_ANIMSET,
		getanim_fn = Plantable_GetAnimFn,
		multcolor = Grass_MultColorFn,
		assets = ASSETS,
		deployspacing = DEPLOYSPACING.MEDIUM,
	}),
	
	WAXED_PLANTS.CreateWaxedPlant({
		prefab = "deciduoustree_polar",
		bank = "tree_leaf",
		build = "tree_leaf_trunk_build",
		anim = "sway1_loop_tall",
		minimapicon = "tree_leafy_polar",
		action = "CHOP",
		physics = {MakeObstaclePhysics, 0.25},
		animset = DECIDPOLAR_ANIMSET,
		getanim_fn = DecidPolar_GetAnimFn,
		common_postinit = DecidPolar_CommonPostInit,
		multcolor = Tree_MultColorFn,
		assets = ASSETS,
	}),
}

return unpack(ret)