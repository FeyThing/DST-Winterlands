local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--[[	OOOOOOLD ! Turns out preserver rate is mutually exclusive from how other tag-based container rates are applied (like "fridge"),
		these won't stack together. Keeping this here still, in the event the effects become cumulative, someday... it could happen

local Preserver = require("components/preserver")
	
	function Preserver:GetIcePackMult(item)
		local mult = 1
		
		local function ApplyIcePacks(items)
			for i, v in ipairs(items) do
				if v:HasTag("icepack") and v.preserver_mult then
					if item == nil or v ~= item then
						mult = mult * v.preserver_mult
					end
				end
			end
		end
		
		if self.inst.components.inventory then
			ApplyIcePacks(self.inst.components.inventory:FindItems(function(v)
				return v:HasTag("icepack")
			end))
		elseif self.inst.components.container then
			ApplyIcePacks(self.inst.components.container:FindItems(function(v)
				return v:HasTag("icepack")
			end))
		end
		
		return mult
	end
	
	local OldGetPerishRateMultiplier = Preserver.GetPerishRateMultiplier
	function Preserver:GetPerishRateMultiplier(item, ...)
		local rate = OldGetPerishRateMultiplier(self, item, ...)
		local pack_rate = self:GetIcePackMult(item)
		
		return rate * pack_rate
	end]]
	
local Perishable = require("components/perishable")
	
	local function GetIcePackMult(owner, item)
		local mult = 1
		
		local function ApplyIcePacks(items)
			for i, v in ipairs(items) do
				if v ~= item and v:HasTag("icepack") and v.preserver_mult then -- Icepacks don't preserve themselves, but each others do
					mult = mult * v.preserver_mult
				end
			end
		end
		
		if owner.components.container then
			ApplyIcePacks(owner.components.container:FindItems(function(v)
				return v:HasTag("icepack")
			end))
		elseif owner.components.inventory then
			ApplyIcePacks(owner.components.inventory:FindItems(function(v)
				return v:HasTag("icepack")
			end))
		end
		
		return mult
	end
	
	local OldUpdate = PolarUpvalue(Perishable.StartPerishing, "Update")
	
	local function Update(inst, dt, ...)
		local self = inst.components.perishable
		
		if self then
			local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
			local pack_rate = owner and GetIcePackMult(owner, inst) or nil
			
			if pack_rate then
				local prev = self._icepack_rate or 1
				local base = self.localPerishMultiplyer / prev
				
				self._icepack_rate = pack_rate
				self.localPerishMultiplyer = base * pack_rate
			end
		end
		
		return OldUpdate and OldUpdate(inst, dt, ...)
	end
	
	PolarUpvalue(Perishable.StartPerishing, "Update", Update)