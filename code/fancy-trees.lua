local colorLib = require('code.colorLib')
if settings.startup["use-custom-map-colors-fancy-trees"].value then
	for name,object in pairs(data.raw["tree"]) do
		local totalColor = {r=0,g=0,b=0,a=0}
		local numberOfColors = 0
		local colors = object.colors
		if colors then
			for _,v in pairs(colors) do
				totalColor.r = totalColor.r+v.r
				totalColor.g = totalColor.g+v.g
				totalColor.b = totalColor.b+v.b
				totalColor.a = totalColor.a + (v.a or 1)
				numberOfColors = numberOfColors + 1
			end
			local avgColor = {}
			for k,v in pairs(totalColor) do
				avgColor[k] = v/numberOfColors
			end
			avgColor.a = 0.2
			data.raw["tree"][name].map_color = colorLib.toColor(avgColor)
		else
			data.raw["tree"][name].map_color = colorLib.toColor("806b344c")
		end
	end
end