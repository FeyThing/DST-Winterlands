local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local function MakeGrowTimes(germination_min, germination_max, full_grow_min, full_grow_max)
	local grow_time = {}
	
	grow_time.seed = {germination_min, germination_max}
	
	grow_time.sprout = {full_grow_min * 0.5, full_grow_max * 0.5}
	grow_time.small = {full_grow_min * 0.3, full_grow_max * 0.3}
	grow_time.med = {full_grow_min * 0.2, full_grow_max * 0.2}
	
	grow_time.full = 4 * TUNING.TOTAL_DAY_TIME
	grow_time.oversized = 6 * TUNING.TOTAL_DAY_TIME
	grow_time.regrow = {4 * TUNING.TOTAL_DAY_TIME, 5 * TUNING.TOTAL_DAY_TIME}
	
	return grow_time
end

local S = TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW
local M = TUNING.FARM_PLANT_CONSUME_NUTRIENT_MED
local L = TUNING.FARM_PLANT_CONSUME_NUTRIENT_HIGH

-- New Greens (or Blues, rather)

PLANT_DEFS.icelettuce = {
	build = "farm_plant_icelettuce",
	bank = "farm_plant_icelettuce",
	
	good_seasons = {autumn = true, winter = true, spring = true},
	grow_time = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME),
	moisture = {drink_rate = TUNING.FARM_PLANT_DRINK_MED, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE},
	
	max_killjoys_tolerance = TUNING.FARM_PLANT_KILLJOY_TOLERANCE,
	nutrient_consumption = {M, M, M},
	nutrient_restoration = {false, false, false},
	
	weight_data = {411.84, 531.05, 0.5},
	
	sounds = {
		grow_oversized = "farming/common/farm/asparagus/grow_oversized",
		grow_full = "farming/common/farm/grow_full",
		grow_rot = "farming/common/farm/rot",
	},
	
	prefab = "farm_plant_icelettuce",
	product = "icelettuce",
	product_oversized = "icelettuce_oversized", -- Doesn't exist
	seed = "icelettuce_seeds",
	plant_type_tag = "farm_plant_icelettuce",
	loot_oversized_rot = {"ice"},
	
	family_min_count = TUNING.FARM_PLANT_SAME_FAMILY_MIN,
	family_check_dist = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS,
	
	stage_netvar = net_tinybyte,
	plantregistryinfo = {
		{
			text = "seed",
			anim = "crop_seed",
			grow_anim = "grow_seed",
			learnseed = true,
			growing = true,
		},
		{
			text = "sprout",
			anim = "crop_sprout",
			grow_anim = "grow_sprout",
			growing = true,
		},
		{
			text = "small",
			anim = "crop_small",
			grow_anim = "grow_small",
			growing = true,
		},
		{
			text = "medium",
			anim = "crop_med",
			grow_anim = "grow_med",
			growing = true,
		},
		{
			text = "grown",
			anim = "crop_full",
			grow_anim = "grow_full",
			revealplantname = true,
			fullgrown = true,
		},
		--[[{
			text = "oversized",
			anim = "crop_oversized",
			grow_anim = "grow_oversized",
			revealplantname = true,
			fullgrown = true,
			hidden = true,
		},
		{
			text = "rotting",
			anim = "crop_rot",
			grow_anim = "grow_rot",
			stagepriority = -100,
			is_rotten = true,
			hidden = true,
		},
		{
			text = "oversized_rotting",
			anim = "crop_rot_oversized",
			grow_anim = "grow_rot_oversized",
			stagepriority = -100,
			is_rotten = true,
			hidden = true,
		},]]
	},
	plantregistrywidget = "widgets/redux/farmplantpage",
	plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget",
	pictureframeanim = {anim = "idle_shiver", time = 12 * FRAMES},
}

--

local OLD_GROWTH_STAGES
local LETTUCE_GROWTH_STAGES = {}

--	Freeze nearby tender

local OldOnTendTo
local function OnTendTo(inst, doer, ...)
	local test
	
	if OldOnTendTo then
		test = OldOnTendTo(inst, doer, ...)
	end
	
	if test and doer and doer.components.freezable and inst:GetDistanceSqToInst(doer) < 2 then
		doer.components.freezable:AddColdness(TUNING.ICELETTUCE_FREEZABLE_COLDNESS)
	end
	
	return test
end

--	Stress other plants when it's not hot outside

local FREEZEJOY_MUST_TAGS = {"farm_plant_freezejoy"}

local OldKillJoyStressTest
local function KillJoyStressTest(inst, ...)
	local test
	
	if OldKillJoyStressTest then
		test = OldKillJoyStressTest(inst, ...)
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	if not test and inst.prefab ~= "farm_plant_icelettuce" and GetTemperatureAtXZ(x, z) < TUNING.OVERHEAT_TEMP - 15 then
		local lettuce_tolerance = inst.plant_def.icelettuce_tolerance or TUNING.ICELETTUCE_KILLJOY_TOLERANCE
		return #TheSim:FindEntities(x, y, z, TUNING.FARM_PLANT_KILLJOY_RADIUS, FREEZEJOY_MUST_TAGS) > lettuce_tolerance
	end
	
	return test 
end

--	Lettuce has no overrized or rotten version

local lettuce_stage_names = {"seed", "sprout", "small", "med", "full"}
local function LettuceGrowthStagesPostInit()
	for i, stage in ipairs(OLD_GROWTH_STAGES) do
		if table.contains(lettuce_stage_names, stage.name) then
			local OldGrowFn = stage.fn
			stage.fn = function(inst, stage, stage_data, ...)
				if OldGrowFn then
					OldGrowFn(inst, stage, stage_data, ...)
				end
				
				local mist_scale = math.min(inst.components.growable.stage - 1, 3.5)
				if inst.components.polarmistemitter then
					inst.components.polarmistemitter.scale = mist_scale
					
					if mist_scale >= 1 then
						inst.components.polarmistemitter:StartMisting()
						inst:AddTag("farm_plant_freezejoy")
					else
						inst.components.polarmistemitter:StopMisting()
						inst:RemoveTag("farm_plant_freezejoy")
					end
				end
				
				inst.no_oversized = true
			end
			
			local OldPreGrowFn = stage.pregrowfn
			stage.pregrowfn = function(inst, ...)
				if OldPreGrowFn then
					OldPreGrowFn(inst, ...)
				end
				inst.no_oversized = true
			end
			
			table.insert(LETTUCE_GROWTH_STAGES, stage)
		end
	end
end

--

for k, data in pairs(PLANT_DEFS) do
	local is_lettuce = k == "icelettuce"
	
	ENV.AddPrefabPostInit(data.prefab, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		if is_lettuce then
			if inst.components.farmplanttendable then
				if OldOnTendTo == nil then
					OldOnTendTo = inst.components.farmplanttendable.ontendtofn
				end
				inst.components.farmplanttendable.ontendtofn = OnTendTo
			end
			
			if inst.components.growable then
				if OLD_GROWTH_STAGES == nil then
					OLD_GROWTH_STAGES = inst.components.growable.stages
					LettuceGrowthStagesPostInit()
				end
				
				inst.components.growable.stages = LETTUCE_GROWTH_STAGES
			end
			
			inst:AddComponent("polarmistemitter")
			inst.components.polarmistemitter.maxmist_range = 2
			
		elseif inst.components.farmplantstress then
			if OldKillJoyStressTest == nil then
				OldKillJoyStressTest = PolarUpvalue(Prefabs[data.prefab].fn, "KillJoyStressTest")
			end
			
			PolarUpvalue(Prefabs[data.prefab].fn, "KillJoyStressTest", KillJoyStressTest)
		end
	end)
end