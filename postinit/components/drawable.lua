local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Drawable = require("components/drawable")
	
	local OldOnDrawn = Drawable.OnDrawn
	function Drawable:OnDrawn(imagename, imagesource, atlasname, bgimagename, bgatlasname, ...)
		local dryice_chesspiece_source = imagesource and imagesource.prefab or imagename
		local dryice_chesspiece_image = (dryice_chesspiece_source and dryice_chesspiece_source:sub(1, 11) == "chesspiece_" and dryice_chesspiece_source:sub(-7) == "_dryice")
			and dryice_chesspiece_source:gsub("_dryice$", "_moonglass") or nil
		
		imagename = dryice_chesspiece_image or imagename
		OldOnDrawn(self, imagename, imagesource, atlasname, bgimagename, bgatlasname, ...)
		
		if dryice_chesspiece_image then
			self.imagename = dryice_chesspiece_source
			
			self.inst.AnimState:SetSymbolHue("SWAP_SIGN", 0.15)
			self.inst.AnimState:SetSymbolSaturation("SWAP_SIGN", 0.48)
			self.inst.AnimState:SetSymbolBrightness("SWAP_SIGN", 1.23)
		end
	end