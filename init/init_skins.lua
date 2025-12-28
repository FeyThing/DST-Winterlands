local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.ModdedCurios = {
	ms_loading_polarfox = {
		type = "loading",
		skin_tags = {},
		rarity = "ModMade",
		assets = {
			Asset("ATLAS", "images/bg_loading_ms_loading_polarfox.xml"),
			Asset("IMAGE", "images/bg_loading_ms_loading_polarfox.tex"),
			Asset("DYNAMIC_ANIM", "anim/dynamic/ms_loading_polarfox.zip"),
			Asset("PKGREF", "anim/dynamic/ms_loading_polarfox.dyn"),
		},
	},
}


--	Skin Blacklist, for stuff that shouldn't show in belongings / crafting wheel

local POLAR_DISPLAY_BLACKLIST = {
	"ms_dragonflychest_upgraded_polarice",
	"ms_treasurechest_upgraded_polarice",
}

for i, skin in ipairs(POLAR_DISPLAY_BLACKLIST) do
	ITEM_DISPLAY_BLACKLIST[skin] = true
end

--	High Snow Angel Emote

local SNOW_ANGEL_TAGS = {"fx", "highsnowangel"}

AddModUserCommand("Winterlands", "snowangel", {
	aliases = {"angel", "highsnow", "snow"},
	prettyname = function(command) return string.format(STRINGS.UI.BUILTINCOMMANDS.EMOTES.PRETTYNAMEFMT, FirstToUpper(command.name)) end,
	desc = function() return STRINGS.UI.BUILTINCOMMANDS.EMOTES.DESC end,
	permission = COMMAND_PERMISSION.USER,
	params = {},
	emote = true,
	slash = true,
	usermenu = false,
	servermenu = false,
	vote = false,
	serverfn = function(params, caller)
		local player = UserToPlayer(caller.userid)
		
		if player then
			player:PushEvent("emote", {
				anim = {"emote_snowangel", "emote_snowangel_loop"},
				soundoverride = "pose",
				loop = true,
				fx = false,
				sounddelay = 0.3,
				
				insnowonly = true,
				insnowfn = function(inst)
					local fx = SpawnPrefab("snowman_debris_fx")
					fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
					fx.AnimState:SetScale(math.random() < 0.5 and 1 or -1, math.random() < 0.5 and 1 or -1)
					fx.AnimState:SetFinalOffset(-2)
					
					if inst.components.polarwalker then
						inst.components.polarwalker.snowdepth = 0
					end
					
					inst.SoundEmitter:PlaySound("dontstarve/movement/run_snow")
					SpawnPolarSnowBlocker(inst:GetPosition(), TUNING.SNOW_PLOW_RANGES.SNOW_EMOTE or 1, TUNING.POLARPLOW_BLOCKER_DURATION, inst)
				end,
				insnowfnperiod = 0.76,
				insnowfn2 = function(inst)
					local x, y, z = inst.Transform:GetWorldPosition()
					local angels = #TheSim:FindEntities(x, y, z, 1, SNOW_ANGEL_TAGS)
					
					if angels < 16 then
						local angel = SpawnPrefab("polar_snow_angel")
						if angel._cam_owner then
							angel._cam_owner:set(inst)
						end
						
						angel.Transform:SetPosition(x, y, z)
						angel:SetAngelPose({doer = inst, frame = inst.AnimState:GetCurrentAnimationFrame(), hide_body = angels > 1})
					end
				end,
				insnowfnperiod2 = 0.03,
				insnowfnfirstperiod2 = 0.8,
			})
		end
	end,
})

--	In case Modded Skin API whitelisting breaks once more

local IsWhiteListedMod = PolarUpvalue(Sim.ReskinEntity, "IsWhiteListedMod")
local function IsSillyListedMod(...)
	local _IsWhiteListedMod = IsWhiteListedMod
	return true
end

PolarUpvalue(Sim.ReskinEntity, "IsWhiteListedMod", IsSillyListedMod)