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
	
--	Sparse Winter Tree
	
	params.winter_tree_sparse = params.winter_tree
	
--	[ 		Screens			]	--

local AddClassPostConstruct = ENV.AddClassPostConstruct

local Image = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Text = require("widgets/text")
local UIAnim = require("widgets/uianim")
local Widget = require("widgets/widget")

--	Blizzard

local i = 0
for key, val in pairs(STORM_TYPES) do
	i = i + 1
end

STORM_TYPES.POLARSTORM = i

local PolarOver = require("widgets/polarover")
local PolarDustOver = require("widgets/polardustover")
local PlayerHud = require("screens/playerhud")

local old_PlayerHud_CreateOverlays = PlayerHud.CreateOverlays
PlayerHud.CreateOverlays = function(self, owner, ...)
	old_PlayerHud_CreateOverlays(self, owner, ...)
	
	self.polardustover = self.storm_overlays:AddChild(PolarDustOver(owner))
	self.polarover = self.overlayroot:AddChild(PolarOver(owner, self.polardustover))
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

--	Show stuff on necklace

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
end)