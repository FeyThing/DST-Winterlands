local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	Our builders for Creature Heads use unique prefabs for each skin, it's required as they are constructionsite and the ingredients are dependant of the prefab name
--	(and we do this because initial crafting recipe cost cannot be skin dependant, and we avoid recipe clutter too...)
--	Doing this however cause problems with the Clean Sweeper as we cannot cycle skins properly as our cached skins resets, so we must clear the skin prefab as such.

local OldspellCB
local function spellCB(tool, target, pos, caster, ...)
	if target and target.reskin_prefabswap then
		target.prefab = target.reskin_prefabswap
	end
	
	if OldspellCB then
		return OldspellCB(tool, target, pos, caster, ...)
	end
end

ENV.AddPrefabPostInit("reskin_tool", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.spellcaster then
		if OldspellCB == nil then
			OldspellCB = inst.components.spellcaster.spell
		end
		
		inst.components.spellcaster:SetSpellFn(spellCB)
	end
end)