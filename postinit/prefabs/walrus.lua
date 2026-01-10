local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local walruses = {"walrus", "little_walrus"}

local function OnTurnOn(inst)
	local target = inst.components.combat.target
	
	if target == nil and inst.sg and not inst.sg:HasStateTag("busy") and inst.components.timer and not inst.components.timer:TimerExists("walrustrade_greet") then
		inst.components.timer:StartTimer("walrustrade_greet", 30)
		
		if inst.components.locomotor then
			inst.components.locomotor:Stop()
		end
		
		inst.sg:GoToState("funny_idle")
		inst.AnimState:PlayAnimation("idle_creepy")
	end
end

local function OnTurnOff(inst)
	
end

local function OnActivate(inst, doer, recipe)
	local trades_data = POLARWALRUS_TRADEDATA[inst.prefab]
	
	if recipe == nil or trades_data == nil or inst.components.craftingstation == nil then
		return
	end
	
	local target = inst.components.combat.target
	
	if target == nil and inst.sg and not inst.sg:HasStateTag("busy") then
		inst.sg:GoToState("funny_idle")
	end
	
	local product_counts = {}
	
	for i, data in ipairs(trades_data) do
		product_counts[data.product] = (product_counts[data.product] or 0) + 1
		
		if data.product == recipe.product then
			local recipe_name = string.format(inst.prefab.."_trade_%s%d", data.product, product_counts[data.product])
			
			if not trades_data[i].nosharedstock or recipe.name == recipe_name then
				local old = inst.components.craftingstation:GetRecipeCraftingLimit(recipe_name) or 0
				local new = math.max(0, old - (recipe.numtogive or 1) + (recipe.name == recipe_name and 1 or 0))
				
				inst.components.craftingstation:SetRecipeCraftingLimit(recipe_name, new)
				if new <= 0 then
					inst.components.craftingstation:ForgetRecipe(recipe_name)
				end
			end
		end
	end
end

local function OnTimerDone(inst, data)
	if data.name == "walrustrade_refresh" then
		inst:PolarTradesRefresh()
		inst.components.timer:StartTimer("walrustrade_refresh", math.random(TUNING.WALRUSTRADES_REFRESH_TIMES.min, TUNING.WALRUSTRADES_REFRESH_TIMES.max))
	end
end

local function PolarTradesRefresh(inst)
	local trades_data = POLARWALRUS_TRADEDATA[inst.prefab]
	
	if trades_data == nil or inst.components.craftingstation == nil then
		return
	end
	
	local product_done = {}
	
	for i, recipe_data in ipairs(trades_data) do
		if not product_done[recipe_data.product] then
			product_done[recipe_data.product] = true
			
			local product_available = math.random() <= (recipe_data.chance or TUNING.WALRUSTRADES_RECIPE_BASE_CHANCE)
			local product_stock = product_available and 1 or nil
			
			if product_available and recipe_data.limits then
				product_stock = math.random(recipe_data.limits.min, recipe_data.limits.max)
			end
			
			local count = 1
			for j, data in ipairs(trades_data) do
				if data.product == recipe_data.product then
					local recipe_name = string.format(inst.prefab.."_trade_%s%d", recipe_data.product, count)
					count = count + 1
					
					if product_stock and product_stock > 0 then
						inst.components.craftingstation:LearnItem(recipe_name, recipe_name)
						if data.limits and not data.nosharedstock then
							inst.components.craftingstation:SetRecipeCraftingLimit(recipe_name, product_stock)
						end
					else
						inst.components.craftingstation:SetRecipeCraftingLimit(recipe_name, 0)
						inst.components.craftingstation:ForgetRecipe(recipe_name)
					end
				end
			end
		end
	end
end

local function PolarInit(inst)
	if inst.components.timer and not inst.components.timer:TimerExists("walrustrade_refresh") then
		inst:PolarTradesRefresh(true)
		inst.components.timer:StartTimer("walrustrade_refresh", math.random(TUNING.WALRUSTRADES_REFRESH_TIMES.min, TUNING.WALRUSTRADES_REFRESH_TIMES.max))
	end
end

for i, prefab in ipairs(walruses) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("prototyper")
		
		if not TheWorld.ismastersim then
			return
		end
		
		if inst.components.craftingstation == nil then
			inst:AddComponent("craftingstation")
		end
		
		if inst.components.prototyper == nil then
			inst:AddComponent("prototyper")
			inst.components.prototyper.onturnon = OnTurnOn
			inst.components.prototyper.onturnoff = OnTurnOff
			inst.components.prototyper.onactivate = OnActivate
			inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.WANDERINGWALRUSSHOP
			inst.components.prototyper.restrictedtag = "walruspal"
		end
		
		if inst.components.timer == nil then
			inst:AddComponent("timer")
		end
		
		inst.PolarTradesRefresh = PolarTradesRefresh
		
		inst:ListenForEvent("timerdone", OnTimerDone)
		
		inst:DoTaskInTime(0, PolarInit)
	end)
end