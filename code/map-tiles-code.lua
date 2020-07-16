local colorLib = require("code.colorLib")
local mapTiles = require("data.map-tiles-data")
local defaultMapTiles = mapTiles["Default 0.18"]

--Default 0.17
if settings.startup["custom-map-colors-map-tiles-preset"].value == "Default 0.17" then
	for mapTile, color in pairs(mapTiles["Default 0.17"]) do
		local hsv = colorLib.RGBtoHSV(colorLib.toColor(color))
		local m = settings.startup["custom-map-colors-map-tiles-multiplier"].value
		hsv.s = math.min((1-hsv.s)*m/10 + hsv.s)
		data.raw["tile"][mapTile].map_color = colorLib.HSVtoRGB(hsv)
	end
end


--Autumn Leaves
if settings.startup["custom-map-colors-map-tiles-preset"].value == "Autumn Leaves" then
	for mapTile, color in pairs(defaultMapTiles) do
		color = colorLib.toColor(color)
		local fallColor = util.mix_color(color,colorLib.toColor("ffe39e"))
		data.raw["tile"][mapTile].map_color = fallColor
	end
	--trees
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
			local hsv = colorLib.RGBtoHSV(avgColor)
			hsv.h = hsv.h/3-0.0
			hsv.s = 1
			if name ~= "tree-04" then
				avgColor = colorLib.HSVtoRGB(hsv)
			else
				avgColor = {r = 0.19, g = 0.39, b = 0.19, a = 0.19}
			end
			avgColor.a = 0.2
			data.raw["tree"][name].map_color = colorLib.toColor(avgColor)
		else
			data.raw["tree"][name].map_color = colorLib.toColor("806b344c")
		end
	end
end

--Winter Wonderland
if settings.startup["custom-map-colors-map-tiles-preset"].value == "Winter Wonderland" then
	--make all tiles unsaturated and lighter
	for tile,name in pairs(data.raw["tile"]) do
		local hsl = colorLib.RGBtoHSL(colorLib.toColor(name.map_color))
		hsl.s = 0
		hsl.l = (1+hsl.l)/2
		data.raw["tile"][tile].map_color = colorLib.toColor(colorLib.HSLtoRGB(hsl))
	end
	--trees, make all of them brown except for tree-04
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
			local brown = colorLib.RGBtoHSV(colorLib.toColor("945b15"))
			local hsv = colorLib.RGBtoHSV(avgColor)
			hsv.s = 1
			hsv.h = brown.h
			hsv.v = hsv.h/90
			if name ~= "tree-04" then
				avgColor = colorLib.HSVtoRGB(hsv)
			else
				avgColor = {r = 0.19, g = 0.39, b = 0.19, a = 0.19}
			end
			avgColor.a = 0.2
			data.raw["tree"][name].map_color = colorLib.toColor(avgColor)
		else
			data.raw["tree"][name].map_color = colorLib.toColor("806b344c")
		end
	end
	data.raw["resource"]["stone"].map_color = colorLib.toColor("cca65e")
end


--Dark Side of the Moon
if settings.startup["custom-map-colors-map-tiles-preset"].value == "Dark Side of the Moon" then
	for mapTile, color in pairs(mapTiles["Dark Side of the Moon"]) do
		data.raw["tile"][mapTile].map_color = colorLib.toColor(color)
	end
	data.raw["resource"]["coal"].map_color = colorLib.toColor("505050")
end

if settings.startup["custom-map-colors-map-tiles-preset"].value == "Black" then
	local black = colorLib.toColor("000000")
	local water_tile_type_names = { "water", "deepwater", "water-green", "deepwater-green", "water-shallow", "water-mud" }
	for tile, _ in pairs(data.raw["tile"]) do
		--Make water dark, but visible
		local isWater = false
		for k, water_tile in pairs(water_tile_type_names) do
			if tile == water_tile then
				isWater = true
				table.remove(water_tile_type_names,k)
			end
		end
		if isWater then
			local HSL = colorLib.RGBtoHSL(data.raw["tile"][tile].map_color)
			HSL.l = HSL.l * 0.3
			data.raw["tile"][tile].map_color = colorLib.HSLtoRGB(HSL)
		else
			data.raw["tile"][tile].map_color = black
		end
	end
	--Make coal lighter, visible
	data.raw["resource"]["coal"].map_color = colorLib.toColor("505050")
end

if settings.startup["custom-map-colors-map-tiles-preset"].value == "Error: Map not found." then
	local black = colorLib.toColor("000000")
	for tile, _ in pairs(data.raw["tile"]) do
		data.raw["tile"][tile].map_color = black
	end
	for resource,_ in pairs(data.raw["resource"]) do
		data.raw["resource"][resource].map_color = black
	end
	table.insert(data.raw["train-stop"]["train-stop"].flags,"not-on-map")
	local cars = data.raw["car"]
	for car,_ in pairs(cars) do
		table.insert(cars[car].flags,"not-on-map")
    end 
    local rollingStocks = {
        "locomotive",
        "cargo-wagon",
        "fluid-wagon",
        "artillery-wagon"
    }
    for _, rollingStockType in pairs(rollingStocks) do
        local trainType = data.raw[rollingStockType]
        for prototype,_ in pairs(trainType) do
            table.insert(trainType[prototype].flags,"not-on-map")
        end
    end


	data.raw["utility-constants"]["default"].chart.turret_range_color = black
	data.raw["utility-constants"]["default"].chart.artillery_range_color = black
	data.raw["utility-constants"]["default"].chart.default_enemy_color = black
	data.raw["utility-constants"]["default"].chart.default_color_by_type["tree"] = black
	data.raw["utility-constants"]["default"].chart.resource_outline_selection_color = black
	data.raw["cliff"]["cliff"].map_color = black
end