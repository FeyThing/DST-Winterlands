local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	Leafy trees should not have High Snow around them, update this if new ones or common modded trees are being added !
--	TODO: Canopy shade protection might be a good idea too, but it should happen overtime

--	[[		Generic	Data	]]	--

local TREE_SNOWMELTER_DATA = {
	-- Vanilla
	evergreen = {
		prefabs = {"evergreen", "evergreen_sparse", "leif", "leif_sparse"},
		snowblock = {2, 3, 3, 0},
		
		oninit = function(inst)
			if IsInPolar(inst) then
				inst.AnimState:SetSymbolSaturation("pieces", 3)
			end
		end,
	},
	
	deciduoustree = {
		prefabs = {"deciduoustree"},
		snowblock = {1, 2, 2, 0},
	},

	moon_tree = {
		prefabs = {"moon_tree"},
		snowblock = {2, 2, 4},
	},

	palmconetree = {
		prefabs = {"palmconetree"},
		snowblock = {1, 2, 3},
	},

	ancienttree_nightvision = {
		prefabs = {"ancienttree_nightvision"},
		snowblock = {4},
	},

	ancienttree_gem = {
		prefabs = {"ancienttree_gem"},
		snowblock = {4},
	},

	-- Mods
	
	jungletree = {
		prefabs = {"jungletree"},
		snowblock = {2, 3, 4},
	},

	palmtree = {
		prefabs = {"palmtree", "treeguard"},
		snowblock = {1, 2, 3},
	},
	
	clawpalmtree = {
		prefabs = {"clawpalmtree"},
		snowblock = {1, 2, 3},
	},
	
	rainforesttree = {
		prefabs = {"rainforesttree"},
		snowblock = {2, 3, 4},
	},
	
	teatree = {
		prefabs = {"teatree", "teatree_piko_nest"},
		snowblock = {1, 2, 2},
	},
	
	cherry_tree = {
		prefabs = {"cherry_tree", "cherry_tree_white"},
		snowblock = {2, 3, 4},
	},
}

--

local function Tree_CanMeltSnow(inst)
	if inst.sg and inst.sg:HasStateTag("sleeping") then
		return true -- Tree Guards
	end
	
	return inst:HasTag("shelter") and not inst:HasTag("burnt") and not inst:HasTag("stump")
end

local function Tree_GetMeltSnowRangeFn(inst)
	if inst.components.growable and inst.snowblockranges then
		return inst.snowblockranges[inst.components.growable.stage] or 0
	end
	
	return inst.snowblockranges and inst.snowblockranges[#inst.snowblockranges] or 0
end

local function Tree_SetSnowMelter(inst, snowblockranges)
	if inst.components.snowwavemelter == nil then
		inst.snowblockranges = snowblockranges
		
		inst:AddComponent("snowwavemelter")
		inst.components.snowwavemelter.canmeltfn = Tree_CanMeltSnow
		inst.components.snowwavemelter.melt_range = Tree_GetMeltSnowRangeFn
		inst.components.snowwavemelter.melt_rate = 1 -- math.random(30, 60)
		inst.components.snowwavemelter:StartMelting()
	end
end

--	[[		Postinits		]]	--

for i, data in pairs(TREE_SNOWMELTER_DATA) do
	for j, prefab in ipairs(data.prefabs) do
		ENV.AddPrefabPostInit(prefab, function(inst)
			if not TheWorld.ismastersim then
				return
			end
			
			Tree_SetSnowMelter(inst, data.snowblock)
			
			if data.oninit then
				inst:DoTaskInTime(0, data.oninit)
			end
		end)
	end
end

--

local function AcornSapling_OnInit(inst)
	if IsInPolar(inst) then
		inst.growprefab = "deciduoustree_polar"
	end
end

ENV.AddPrefabPostInit("acorn_sapling", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:DoTaskInTime(0, AcornSapling_OnInit)
end)

--	[[	Winter Trees	]]	-- These are a bit complicated to generalise so just block snow and that's it.
--	Also birchnut trees keep their leave because of magic, shut up.

local WINTERTREES = {
	"winter_treestand",
	"winter_tree",
	"winter_deciduoustree",
	"winter_palmconetree",
	"winter_twiggytree",
	"winter_jungletree",
	"winter_palmtree",
	"winter_clawpalmtree",
	"winter_rainforesttree",
	"winter_cherry_tree",
	"winter_cherry_tree_white",
}

for i, prefab in ipairs(WINTERTREES) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("snowblocker")
		inst._snowblockrange = net_smallbyte(inst.GUID, prefab.."._snowblockrange")
		inst._snowblockrange:set(4)
	end)
end