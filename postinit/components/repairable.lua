local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Repairable = require("components/repairable")
	
	local OldRepair = Repairable.Repair
	function Repairable:Repair(doer, repair_item, ...)
		local repair_item_repairer = repair_item and repair_item.components.repairer
		local icing_on_top = repair_item_repairer and repair_item_repairer.repairmaterial == MATERIALS.DRYICE and self.repairmaterial == MATERIALS.ICE
		
		self.repairmaterial = icing_on_top and MATERIALS.DRYICE or self.repairmaterial
		local test = OldRepair(self, doer, repair_item, ...)
		self.repairmaterial = icing_on_top and MATERIALS.ICE or self.repairmaterial
		
		return test
	end