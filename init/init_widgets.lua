local ENV = env
GLOBAL.setfenv(1, GLOBAL)

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
local PolarMoistureOverlay = require("widgets/polarmoistureoverlay")
	
	local MoistureOnUpdate = MoistureMeter.OnUpdate
	function MoistureMeter:OnUpdate(dt, ...)
		MoistureOnUpdate(self, dt, ...)
		
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
						
						val = in_polar and TheWorld and GetPolarTemperature(val, x, z) or val
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