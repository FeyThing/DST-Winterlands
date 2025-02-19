local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- Basically, Snowfleas shouldn't be controllable in the inventory but they need to go on the Itchhicker Pack in priority. They decide on their own.

local Container = require("components/container")
	
	local OldCanTakeItemInSlot = Container.CanTakeItemInSlot
	function Container:CanTakeItemInSlot(item, slot, ...)
		if item._try_fleapack and item:HasTag("flea") and self.inst:HasTag("fleapack") and (self.itemtestfn == nil or self:itemtestfn(item, slot)) then
			return true
		end
		
		return OldCanTakeItemInSlot(self, item, slot, ...)
	end
	
	local OldShouldPrioritizeContainer = Container.ShouldPrioritizeContainer
	function Container:ShouldPrioritizeContainer(item, ...)
		if item._try_fleapack and item:HasTag("flea") and self.inst:HasTag("fleapack") and (self.priorityfn == nil or self:priorityfn(item)) then
			return true
		end
		
		return OldShouldPrioritizeContainer(self, item, ...)
	end
	
local Inventory = require("components/inventory")
	
	local OldCanTakeItemInSlot_Inv = Inventory.CanTakeItemInSlot
	function Inventory:CanTakeItemInSlot(item, slot, ...)
		if item:HasTag("flea") then
			local owner = item.components.inventoryitem and item.components.inventoryitem.owner
			
			if owner and owner:HasTag("fleapack") then
				return false
			end
		end
		
		return OldCanTakeItemInSlot_Inv(self, item, slot, ...)
	end
	
local Inventory_Replica = require("components/inventory_replica")
	
	local OldCanTakeItemInSlot_Inv_Replica = Inventory_Replica.CanTakeItemInSlot
	function Inventory_Replica:CanTakeItemInSlot(item, slot, ...)
		if item:HasTag("flea") then
			return false
		end
		
		return OldCanTakeItemInSlot_Inv_Replica(self, item, slot, ...)
	end