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
            
            Asset("PKGREF", "anim/dynamic/ms_loading_polarfox.dyn")
        },
    },
}

local IsWhiteListedMod = PolarUpvalue(Sim.ReskinEntity, "IsWhiteListedMod")
local function IsSillyListedMod(...)
	local _IsWhiteListedMod = IsWhiteListedMod
	return true
end

PolarUpvalue(Sim.ReskinEntity, "IsWhiteListedMod", IsSillyListedMod)