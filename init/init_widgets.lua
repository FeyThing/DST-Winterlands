local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	[ 		Screens			]	--

local Image = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Text = require("widgets/text")
local UIAnim = require("widgets/uianim")
local Widget = require("widgets/widget")

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