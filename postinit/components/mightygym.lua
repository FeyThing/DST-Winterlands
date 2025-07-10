local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local MightyGym = require("components/mightygym")

local slot_ids = {
	"swap_item",
	"swap_item2",
}

local OldSetWeightSymbol = MightyGym.SetWeightSymbol
function MightyGym:SetWeightSymbol(weight, slot, ...)
	local test = OldSetWeightSymbol(self, weight, slot, ...)
	local sym = slot_ids[slot]
	
	if sym and weight and weight.prefab:sub(1, 11) == "chesspiece_" and weight.prefab:sub(-7) == "_dryice" then
		self.inst.AnimState:SetSymbolHue(sym, 0.15)
		self.inst.AnimState:SetSymbolSaturation(sym, 0.48)
		self.inst.AnimState:SetSymbolBrightness(sym, 1.23)
		
		self["chesspiece_dryice_"..slot] = true
	elseif sym and self["chesspiece_dryice_"..slot] then
		self.inst.AnimState:SetSymbolHue(sym, 0)
		self.inst.AnimState:SetSymbolSaturation(sym, 1)
		self.inst.AnimState:SetSymbolBrightness(sym, 1)
		
		self["chesspiece_dryice_"..slot] = nil
	end
	
	return test
end

local OldUnloadWeight = MightyGym.UnloadWeight
function MightyGym:UnloadWeight(...)
	local test = OldUnloadWeight(self, ...)
	
	local inventory = self.inst.components.inventory
	if inventory then
		for i = 1, inventory.maxslots do
			local sym = slot_ids[i]
			
			if sym and self["chesspiece_dryice_"..i] then
				self.inst.AnimState:SetSymbolHue(sym, 0)
				self.inst.AnimState:SetSymbolSaturation(sym, 1)
				self.inst.AnimState:SetSymbolBrightness(sym, 1)
				
				self["chesspiece_dryice_"..i] = nil
			end
		end
	end
	
	return test
end

local OldCharacterEnterGym = MightyGym.CharacterEnterGym
function MightyGym:CharacterEnterGym(player, ...)
	local test = OldCharacterEnterGym(self, player, ...)
	
	local inventory = self.inst.components.inventory
	if inventory and player then
		for i = 1, inventory.maxslots do
			local item = inventory:GetItemInSlot(i)
			local sym = slot_ids[i]
			
			if item and sym and self["chesspiece_dryice_"..i] then
				player.AnimState:SetSymbolHue(sym, 0.15)
				player.AnimState:SetSymbolSaturation(sym, 0.48)
				player.AnimState:SetSymbolBrightness(sym, 1.23)
			end
		end
	end
	
	return test
end

local OldCharacterExitGym = MightyGym.CharacterExitGym
function MightyGym:CharacterExitGym(player, ...)
	local test = OldCharacterExitGym(self, player, ...)
	
	local inventory = self.inst.components.inventory
	if inventory and player then
		local syms = {}
		for i = 1, inventory.maxslots do
			local item = inventory:GetItemInSlot(i)
			local sym = slot_ids[i]
			
			if sym and self["chesspiece_dryice_"..i] then
				player.AnimState:SetSymbolHue(sym, 0)
				player.AnimState:SetSymbolSaturation(sym, 1)
				player.AnimState:SetSymbolBrightness(sym, 1)
			end
		end
	end
	
	return test
end