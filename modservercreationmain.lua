local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function LoadPolarFEAssets()
	ENV.FrontEndAssets = {
		Asset("IMAGE", "images/worldgen_polar.tex"),
		Asset("ATLAS", "images/worldgen_polar.xml"),
		
		Asset("ATLAS", "images/fx.xml"),
		Asset("IMAGE", "images/fx.tex"),
		Asset("SHADER", "shaders/uifade.ksh"),
		
		Asset("SOUNDPACKAGE", "sound/polarsounds.fev"),
		Asset("SOUND", "sound/polarsounds.fsb"),
	}
	
	ENV.ReloadFrontEndAssets()
end

LoadPolarFEAssets()

ENV.modimport("init/init_tuning")

--	Reset retrofit, should have run the previous time

require("polar_util")
ChangePolarConfigs("biome_retrofit", 0)

--	Freeze player laptop on activation, just a bit :evil:

local ServerCreationScreen = TheFrontEnd:GetActiveScreen()
local IceOver_Polar_FE = require("widgets/iceover_polar_fe")
local modname_polar = ENV.modname

if tostring(ServerCreationScreen) == "ServerCreationScreen" and ServerCreationScreen.world_tabs then
	staticScheduler:ExecuteInTime(0, function()
		LoadPolarFEAssets()
		
		local freeze_sounds = {
			"dontstarve/winter/freeze_1st",
			"dontstarve/winter/freeze_2nd",
			--"dontstarve/winter/freeze_3rd",
			--"dontstarve/winter/freeze_4th",
		}
		
		local winter_sounds = {
			"dontstarve/creatures/together/deer/bell",
		}
		
		local play_sounds = {}
		
		--[[if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
			for i, v in ipairs(winter_sounds) do
				table.insert(play_sounds, v)
			end
		end]]
		
		if #play_sounds == 0 then
			play_sounds = freeze_sounds
		end
		
		TheFrontEnd:GetSound():PlaySound(play_sounds[math.random(#play_sounds)])
		if IceOver_Polar_FE ~= nil and TheGlobalInstance.iceover_polar == nil then
			TheGlobalInstance.iceover_polar = ServerCreationScreen:AddChild(IceOver_Polar_FE(ServerCreationScreen))
		end
	end)
	
	if TheGlobalInstance.iceover_polar_unloader == nil then
		local OldModUnloadFrontEndAssets = ModUnloadFrontEndAssets
		function ModUnloadFrontEndAssets(modname, ...)
			if TheGlobalInstance.iceover_polar and modname == modname_polar then
				TheGlobalInstance.iceover_polar:Kill()
				TheGlobalInstance.iceover_polar = nil
			end
			
			if OldModUnloadFrontEndAssets then
				OldModUnloadFrontEndAssets(modname, ...)
			end
		end
		
		TheGlobalInstance.iceover_polar_unloader = true
	end
end