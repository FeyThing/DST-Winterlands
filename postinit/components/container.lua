local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- Basically, Snowfleas shouldn't be controllable in the inventory but they need to go on the Itchhicker Pack in priority. They decide on their own.

local Container = require("components/container")
	
	local OldGiveItem = Container.GiveItem
	function Container:GiveItem(item, slot, ...)
		if item and item:HasTag("flea") and self.inst:HasTag("fleapack") and self.inst.components.upgradeable and self.inst.components.upgradeable:GetStage() >= 2
			and item.components.stackable == nil then
			
			item:AddComponent("stackable")
			item.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
			item.skinname = nil
		end
		
		return OldGiveItem(self, item, slot, ...)
	end
	
	local OldCanTakeItemInSlot = Container.CanTakeItemInSlot
	function Container:CanTakeItemInSlot(item, slot, ...)
		if item and item:HasTag("flea") then
			return item._try_hosting and (self.itemtestfn == nil or self:itemtestfn(item, slot))
		end
		
		return OldCanTakeItemInSlot(self, item, slot, ...)
	end
	
	local OldShouldPrioritizeContainer = Container.ShouldPrioritizeContainer
	function Container:ShouldPrioritizeContainer(item, ...)
		if item and item:HasTag("flea") and item._try_hosting and self.inst:HasTag("fleapack") and (self.priorityfn == nil or self:priorityfn(item)) then
			return self:IsOpen()
		end
		
		return OldShouldPrioritizeContainer(self, item, ...)
	end
	
local Container_Replica = require("components/container_replica") -- TODO: Idk why but client tries to accept moving fleas from containers to Itchhicker Pack. Not critical but...
	
	local OldCanTakeItemInSlot_Replica = Container_Replica.CanTakeItemInSlot
	function Container_Replica:CanTakeItemInSlot(item, slot, ...)
		if item and item:HasTag("flea") then
			return false
		end
		
		return OldCanTakeItemInSlot_Replica(self, item, slot, ...)
	end
	
	local OldCanTakeItemInSlot_Replica = Container_Replica.ShouldPrioritizeContainer
	function Container_Replica:ShouldPrioritizeContainer(item, ...)
		if item and item:HasTag("flea") then
			return false
		end
		
		return OldShouldPrioritizeContainer(self, item, ...)
	end
	
local Inventory = require("components/inventory")
	
	local OldCanTakeItemInSlot_Inv = Inventory.CanTakeItemInSlot
	function Inventory:CanTakeItemInSlot(item, slot, ...)
		if item and item:HasTag("flea") then
			return item._try_hosting
		end
		
		return OldCanTakeItemInSlot_Inv(self, item, slot, ...)
	end
	
local Inventory_Replica = require("components/inventory_replica")
	
	local OldCanTakeItemInSlot_Inv_Replica = Inventory_Replica.CanTakeItemInSlot
	function Inventory_Replica:CanTakeItemInSlot(item, slot, ...)
		if item and item:HasTag("flea") then
			return false
		end
		
		return OldCanTakeItemInSlot_Inv_Replica(self, item, slot, ...)
	end