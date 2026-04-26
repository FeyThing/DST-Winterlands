local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	[ 		Containers		]	--
	
	local containers = require("containers")
	local params = containers.params

--	Necklace "Shop"

	params.polaramulet_station =  {
		widget = {
			slotpos = {
				Vector3(-(64 + 12), 0, 0),
				Vector3(0, 0, 0),
				Vector3(64 + 12, 0, 0),
			},
			slotbg = {
					{image = "houndstooth_ammo_slot.tex", atlas = "images/hud2.xml"},
					{image = "houndstooth_ammo_slot.tex", atlas = "images/hud2.xml"},
					{image = "houndstooth_ammo_slot.tex", atlas = "images/hud2.xml"},
				},
			buttoninfo = {
				text = STRINGS.ACTIONS.POLARAMULET_CRAFT,
				position = Vector3(0, -65, 0),
			},
			animbank = "ui_chest_3x1",
			animbuild = "ui_chest_3x1",
			pos = Vector3(200, 0, 0),
			side_align_tip = 100,
		},
		type = "cooker",
		acceptsstacks = false,
		excludefromcrafting = true,
	}
	
	function params.polaramulet_station.itemtestfn(container, item, slot)
		return POLARAMULET_PARTS[item.prefab] ~= nil and not item:HasTag("lightbattery") -- TODO: this will need more work but it should definitively be added
	end
	
	function params.polaramulet_station.widget.buttoninfo.fn(inst, doer)
		if inst.components.container ~= nil then
			BufferedAction(doer, inst, ACTIONS.POLARAMULET_CRAFT):Do()
		elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
			SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.POLARAMULET_CRAFT.code, inst, ACTIONS.POLARAMULET_CRAFT.mod_name)
		end
	end
	
	function params.polaramulet_station.widget.buttoninfo.validfn(inst)
		return inst.replica.container and inst.replica.container:IsFull()
	end
	
--	Itchhiker Pack
	
	params.polarflea_sack = {
		widget = {
			slotpos = {},
			animbank = "ui_polarfleasack_2x5",
			animbuild = "ui_polarfleasack_2x5",
			pos = Vector3(-5, -90, 0),
		},
		issidewidget = true,
		type = "pack",
		openlimit = 1,
	}
	
	for y = 0, 4 do
		table.insert(params.polarflea_sack.widget.slotpos, Vector3(-162, -75 * y + 135, 0))
		table.insert(params.polarflea_sack.widget.slotpos, Vector3(-162 + 75, -75 * y + 135, 0))
	end
	
	function params.polarflea_sack.priorityfn(container, item, slot)
		return item:HasTag("flea")
	end
	
	function params.polarflea_sack.widget.bganim_visualfn(bganim, container, doer)
		--TODO: Visual differance between standard/upgraded backpack
		--		also...fleas running around backpack ui :>
	end
	
--	Sparse Winter Tree
	
	params.winter_tree_sparse = params.winter_tree
	
--	[ 		Screens			]	--

local AddClassPostConstruct = ENV.AddClassPostConstruct

local Image = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Text = require("widgets/text")
local UIAnim = require("widgets/uianim")
local UIAnimButton = require("widgets/uianimbutton")
local Widget = require("widgets/widget")

--	Blizzard

local i = 0
for key, val in pairs(STORM_TYPES) do
	i = i + 1
end

STORM_TYPES.POLARSTORM = i

local PolarOver = require("widgets/polarover")
local PolarDustOver = require("widgets/polardustover")
local WandaTimeFreezeOver = require("widgets/wandatimefreezeover")
local PlayerHud = require("screens/playerhud")

local old_PlayerHud_CreateOverlays = PlayerHud.CreateOverlays
PlayerHud.CreateOverlays = function(self, owner, ...)
	old_PlayerHud_CreateOverlays(self, owner, ...)
	
	self.polardustover = self.storm_overlays:AddChild(PolarDustOver(owner))
	self.polarover = self.overlayroot:AddChild(PolarOver(owner, self.polardustover))
	self.wandatimefreezeover = self.overlayroot:AddChild(WandaTimeFreezeOver(owner))
end

--	Polar Wetness

local MoistureMeter = require("widgets/moisturemeter")
local WX78MoistureMeter = require("widgets/wx78moisturemeter")

local PolarMoistureOverlay = require("widgets/polarmoistureoverlay")
	
	local MoistureOnUpdate = MoistureMeter.OnUpdate
	function MoistureMeter:OnUpdate(dt, ...)
		MoistureOnUpdate(self, dt, ...)
		
		if self.polarmoistureoverlay == nil then
			self.polarmoistureoverlay = self.circleframe:AddChild(PolarMoistureOverlay(self.owner, self))
		end
	end
	
	local WX78MoistureOnUpdate = WX78MoistureMeter.OnUpdate
	function WX78MoistureMeter:OnUpdate(dt, ...)
		WX78MoistureOnUpdate(self, dt, ...)
		
		if self.polarmoistureoverlay == nil then
			self.polarmoistureoverlay = self.circleframe:AddChild(PolarMoistureOverlay(self.owner, self))
		end
	end
	
--	Combined Status' world temperature badge should show polar difference

AddClassPostConstruct("widgets/statusdisplays", function(self)
	self.inst:DoTaskInTime(1, function()
		local oldupdatetemp
		
		if self.worldtempbadge and self.inst and self.inst.worldstatewatching then
			self.worldtempbadge_polar = false
			
			for i, fn in ipairs(self.inst.worldstatewatching["temperature"] or {}) do
				oldupdatetemp = PolarUpvalue(fn, "updatetemp")
				
				if oldupdatetemp then
					local function updatetemp(val, ...)
						local x, y, z = ThePlayer.Transform:GetWorldPosition()
						local in_polar = GetClosestPolarTileToPoint(x, 0, z, 32)
						
						if in_polar ~= self.worldtempbadge_polar then
							if self.worldtempbadge.head then
								self.worldtempbadge.head:SetTexture("images/"..(in_polar and "rain_polar" or "rain")..".xml", "rain.tex")
							end
							
							self.worldtempbadge_polar = in_polar
						end
						
						val = TheWorld and GetPolarTemperature(val, x, z) or val
						oldupdatetemp(val, ...)
					end
					PolarUpvalue(fn, "updatetemp", updatetemp)
					
					break
				end
			end
			
			if oldupdatetemp then
				
			end
		end
	end)
end)

--	Show Chilly Compass above inv

local HudCompass_Polar = require "widgets/hudcompass_polar"

AddClassPostConstruct("widgets/inventorybar", function(self, owner)
	self.hudcompass_polar = self.root:AddChild(HudCompass_Polar(owner, true))
	self.hudcompass_polar:MoveToBack()
	self.hudcompass_polar:SetScale(1.75, 1.75)
	self.hudcompass_polar:SetMaster()
	
	--	TODO: 	I know this is the intended spot, but we might want to take this somewhere else later,
	--			cause most of the more inventory equip/slots mods screw this one up...
	local OldRebuild = self.Rebuild
	function self:Rebuild(...)
		local test = OldRebuild(self, ...)
		
		if self.hudcompass and self.hudcompass_polar then
			self.hudcompass_polar:SetPosition(self.hudcompass:GetPosition())
		end
		
		return test
	end
end)

--	Show stuff on necklace + Dryice chesspiece material

local AMULET_PARTS = {
	"left",
	"middle",
	"right",
}

AddClassPostConstruct("widgets/itemtile", function(self, invitem)
	function self:SetAmuletParts()
		local img = self.image:AddChild(UIAnim())
		img:GetAnimState():SetBank("polar_amulet_ui")
		img:GetAnimState():SetBuild("torso_polar_amulet") -- Shouldn't matter
		img:GetAnimState():PlayAnimation("idle")
		img:SetScale(1, 0.8)
		img:SetClickable(false)
		
		for i, v in ipairs(AMULET_PARTS) do
			local item = invitem.amulet_parts[v]:value()
			
			local build = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].build
			local sym = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].symbol
			local ornament = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].ornament
			
			if build then
				img:GetAnimState():OverrideSymbol((ornament and "ornament_" or "teeth_")..v, build, sym or "swap_"..item)
			end
		end
		
		self.amulet_parts = img
	end
	
	if invitem.amulet_parts and not self.amulet_parts then
		self:SetAmuletParts()
	end
	
	if invitem.prefab and invitem.prefab:sub(1, 11) == "chesspiece_" and invitem.prefab:sub(-7) == "_dryice" then
		self.image:SetTint(0.73, 0.8, 0.92, 0.6)
	end
end)

--	Arctic Fools' Fish on Self Inspect

AddClassPostConstruct("screens/playerinfopopupscreen", function(self, owner, player_name, data)
	local target = data and data.userid and LookupPlayerInstByUserID(data.userid)
	
	if self.root and self.root.bg and target and target:HasTag("arcticfooled") then
		if target == ThePlayer then
			ThePlayer._has_seen_arctic_fish = true
		end
		
		local btn = self.root.bg:AddChild(UIAnimButton("arctic_fool_fish", "arctic_fool_fish", "idle", "walk", "idle", "run", "run"))
		btn:SetScale(2, 2)
		
		btn:SetLoop("idle", true)
		btn:SetLoop("walk", true)
		btn:SetLoop("run", true)
		
		self.arcticfool_label = btn:AddChild(Text(UIFONT, 45))
		self.arcticfool_label:SetString(STRINGS.UI.ARCTIC_FOOL_FISH_BUTTON)
		self.arcticfool_label:SetPosition(0, 80, 0)
		self.arcticfool_label:Hide()
		
		btn:SetOnGainFocus(function()
			btn.animstate:SetAddColour(0.15, 0.15, 0.15, 0.15)
			self.arcticfool_label:Show()
		end)
		btn:SetOnLoseFocus(function()
			btn.animstate:SetAddColour(0, 0, 0, 0)
			self.arcticfool_label:Hide()
		end)
		btn:SetOnClick(function()
			TheFrontEnd:GetSound():PlaySound("polarsounds/arctic_fools/stick_fish")
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			
			if target and target:HasTag("arcticfooled") and target == ThePlayer then
				ThePlayer._has_seen_arctic_fish = nil
				
				if not TheWorld.ismastersim then
					SendModRPCToServer(GetModRPC("Winterlands", "UnstickArticFoolFish"))
				elseif ThePlayer.RemoveArcticFoolFish then
					ThePlayer:RemoveArcticFoolFish()
				end
				TheFrontEnd:PopScreen()
			end
		end)
		
		self.arcticfool_btn = btn
	end
	
	local OldOnControl = self.OnControl
	function self:OnControl(control, down, ...)
		if control == CONTROL_MOVE_UP then
			if self.arcticfool_btn and not self.arcticfool_btn.focus then
				self.arcticfool_btn:SetFocus()
				return true
			end
		end
		
		if OldOnControl then
			return OldOnControl(self, control, down, ...)
		end
	end
end)

--	Show mob quantities with Ursa Trials (TODO: Support any entity type detection, not just bears)

--	Also quick touch up on Bear Rug's sewing kit ingredient slot, to display % used
--	NOTE: Keep an eye out for future game updates if these type of systems becomes officially supported (it might just...)

local POLARBEAR_TRIALS_QUANTITY = nil
local SEWINGKIT_DURABILITY = nil

local BEAR_TAGS = {"bear", "_combat"}
local BEAR_NOT_TAGS = {"bear_major", "INLIMBO", "isdead"}

local function GetPolarBears()
	local x, y, z = ThePlayer.Transform:GetWorldPosition()
	local bears = TheSim:FindEntities(x, y, z, TUNING.TRIALS_INGREDIANT_ACCESS_RADIUS, BEAR_TAGS, BEAR_NOT_TAGS)
	local angries = 0
	
	for _, bear in ipairs(bears) do
		if bear:HasTag("hostile") then
			angries = angries + 1
		end
	end
	
	return #bears - angries
end

local function GetPolarBearsUpdate()
	if ThePlayer then -- Updates nearby bears availability while trial recipe is shown
		ThePlayer:PushEvent("refreshcrafting")
	end
end

local IngredientUI = require("widgets/ingredientui")
	
	local OldIngredientUI_ctor = IngredientUI._ctor
	function IngredientUI:_ctor(atlas, image, quantity, on_hand, has_enough, name, owner, recipe_type, quant_text_scale, ingredient_recipe)
		if recipe_type == "polarbear_material" and quantity == nil and ThePlayer then
			on_hand = GetPolarBears()
			quantity = POLARBEAR_TRIALS_QUANTITY or 1 -- Tech ingredients don't show / transfer quantity required to ing slot
		end
		
		if SEWINGKIT_DURABILITY then
			on_hand = 1 / TUNING.SEWINGKIT_USES
			quantity = 1 / TUNING.SEWINGKIT_USES
			recipe_type = CHARACTER_INGREDIENT.MAX_HEALTH
			
			SEWINGKIT_DURABILITY = nil
		end
		
		return OldIngredientUI_ctor(self, atlas, image, quantity, on_hand, has_enough, name, owner, recipe_type, quant_text_scale, ingredient_recipe)
	end
	
local CraftingMenuIngredients = require("widgets/redux/craftingmenu_ingredients")
	
	local OldSetRecipe = CraftingMenuIngredients.SetRecipe
	function CraftingMenuIngredients:SetRecipe(recipe, ...)
		if recipe then
			for i, ing in ipairs(recipe.tech_ingredients) do
				if ing.type == "polarbear_material" then
					POLARBEAR_TRIALS_QUANTITY = ing.amount or 1
					
					if self.inst and self._bearupdate == nil then
						self._bearupdate = self.inst:DoPeriodicTask(0.25, GetPolarBearsUpdate)
					end
					
					break
				end
			end
			
			if recipe.name == "polarbear_rug" then
				for i, v in ipairs(recipe.ingredients) do
					if v.type == "sewing_kit" then
						SEWINGKIT_DURABILITY = true
						break
					end
				end
			end
		end
		
		return OldSetRecipe(self, recipe, ...)
	end
	
local RecipePopup = require("widgets/recipepopup")
	
	local OldSetRecipe_RecipePopUp = RecipePopup.SetRecipe
	function RecipePopup:SetRecipe(recipe, ...)
		if recipe then
			for i, ing in ipairs(recipe.tech_ingredients) do
				if ing.type == "polarbear_material" then
					POLARBEAR_TRIALS_QUANTITY = ing.amount or 1
					
					if self.inst and self._bearupdate == nil then
						self._bearupdate = self.inst:DoPeriodicTask(0.1, GetPolarBearsUpdate)
					end
					
					break
				end
			end
			
			if recipe.name == "polarbear_rug" then
				for i, v in ipairs(recipe.ingredients) do
					if v.type == "sewing_kit" then
						SEWINGKIT_DURABILITY = true
						break
					end
				end
			end
		end
		
		return OldSetRecipe_RecipePopUp(self, recipe, ...)
	end
	
--	WX-78 Circuits

AddClassPostConstruct("widgets/upgrademodulesdisplay", function(self)
	local GetModuleDefinitionFromNetID = require("wx78_moduledefs").GetModuleDefinitionFromNetID
	local OldOnModuleAdded = self.OnModuleAdded
	function self:OnModuleAdded(moduledefinition_index, ...)
		OldOnModuleAdded(self, moduledefinition_index, ...)
		local module_def = GetModuleDefinitionFromNetID(moduledefinition_index)
		if module_def == nil then
			return
		end
		
		local modname = module_def.name
		if modname == "naughty" then
			local new_chip = self.chip_objectpool[self.chip_poolindex - 1]
			new_chip:GetAnimState():SetBuild("polarstatus_wx")
			new_chip:GetAnimState():OverrideSymbol("movespeed2_chip", "polarstatus_wx", modname.."_chip")
		end
	end
end)

--[[Advent Calendar, now disabled, twas fun !

local PolarCalendarScreen = require("screens/polarcalendarscreen")
local PauseScreen = require("screens/redux/pausescreen")

local TEMPLATES = require("widgets/redux/templates")

local old_PauseScreen_BuildMenu = PauseScreen.BuildMenu
PauseScreen.BuildMenu = function(self, ...)
	local _TEMPLATES = TEMPLATES -- Required reference for Insight mod, somewhy
	old_PauseScreen_BuildMenu(self, ...)

	local calendar_btn = self.menu:AddItem("Advent Calendar", function()
		TheFrontEnd:PushScreen(PolarCalendarScreen(self.owner))
	end)

	calendar_btn:SetTextures("images/button_winter_carny_xlong.xml", "button_winter_carny_xlong_normal.tex", "button_winter_carny_xlong_hover.tex", "button_winter_carny_xlong_disabled.tex", "button_winter_carny_xlong_down.tex")
	calendar_btn.image:SetScale(0.7) -- This is how it's done in Menu:AddItem()
	calendar_btn:SetScale(0.7)

	table.remove(self.menu.items, #self.menu.items) -- Repositioning the button
	table.insert(self.menu.items, 6, calendar_btn)

	local pos = Vector3(0, 0, 0)
	for _, item in ipairs(self.menu.items) do
		item:SetPosition(pos)
		pos = pos + Vector3(0, self.menu.offset, 0)
	end

	local button_h = 50
	local buttons = self.menu.items
	local height = button_h * #buttons + 30	-- consoles are shorter since they don't have the '
	height = math.clamp(height, 90, 500)
	self.bg:SetSize(190, height)
	self.bg.body:SetRegionSize(190, height)

	local y_pos = (button_h * (#buttons - 1) / 2)
	self.menu:SetPosition(0, y_pos, 0)
end]]