local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local SentientAxe = require("components/sentientaxe")
	
	local OldMakeConversation = SentientAxe.MakeConversation
	SentientAxe.MakeConversation = function(self, ...)
		local container = self.inst.components.inventoryitem and self.inst.components.inventoryitem:GetContainer() or nil
		local possessedaxe = self.inst.components.possessedaxe
		
		if self:ShouldMakeConversation() and possessedaxe and container and container.inst:HasTag("fleapack") and container:HasItemWithTag("flea", 1) then
			possessedaxe:Drop()
			
			self:Say(STRINGS.LUCY.container_has_fleas)
			self:ScheduleConversation()
		else
			OldMakeConversation(self, ...)
		end
	end