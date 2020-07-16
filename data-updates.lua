local entityTypes = require("supported-entities.types")
local machines = require("supported-entities.machines")
local tiles = require("supported-entities.tiles")
local belts = require("supported-entities.belts")
local utilConstants = require("supported-entities.utility-constants")
local military = require("supported-entities.military")
local mapTiles = require("supported-entities.map-tiles")
local defaultMapTiles = mapTiles["Default 0.17"]

local presets = require("presets")
local activePreset = presets[(settings.startup["custom-map-colors-preset"].value)]
local defaultPreset = presets.None

local colorLib = require("colorLib")

--Pastels
--[[
if (settings.startup["custom-map-colors-preset"].value) == "Pastels" then
	activePreset = presets.Default
	for k,v in pairs(presets.Default) do
			local hsl = colorLib.RGBtoHSL(colorLib.toColor(v))
			if hsl.s > 0 and k ~= "solar-panel" then
				hsl.l = (1-hsl.l)/4 + hsl.l
				hsl.s = hsl.s * 0.65
			end
			activePreset[k] = colorLib.colorToHex(colorLib.HSLtoRGB(hsl))
	end
	log(serpent.block(activePreset, {sortkeys = false}))
end]]

--[[Neons
if (settings.startup["custom-map-colors-preset"].value) == "Neons" then
	activePreset = presets.Default
	for k,v in pairs(presets.Default) do
		local hsv = colorLib.RGBtoHSV(colorLib.toColor(v))
		if (hsv.s > 0 and k ~= "solar-panel") then
			hsv.v = 1
		end
		activePreset[k] = colorLib.colorToHex(colorLib.HSVtoRGB(hsv))
	end
	log(serpent.block(activePreset, {sortkeys = false}))
end
]]

--[[InvisibleFactory
for k,v in pairs(presets.Default) do
	activePreset = presets.Default
	local color = {}
	if not tiles[k] then
		color = colorLib.toColor(v)
		color.a = 0
	end
	activePreset[k] = colorLib.colorToHex(color)
end
log(serpent.block(activePreset, {sortkeys = false}))]]

--Monochrome
if settings.startup["custom-map-colors-preset"].value == "Monochrome" then
	local mColor = colorLib.RGBtoHSL(colorLib.toColor(settings.startup["custom-map-colors-monochrome"].value))
	activePreset = presets.Default
	for k,v in pairs(presets.Default) do
		local hsl = colorLib.RGBtoHSL(colorLib.toColor(v))
		if hsl.s > 0 and k ~= "solar-panel" then
			hsl.h =	mColor.h
			hsl.s = hsl.s * mColor.s
			hsl.l = (hsl.l + mColor.l)/2
			hsl.a = mColor.a
		end
		activePreset[k] = colorLib.HSLtoRGB(hsl)
	end
end

--[[Vaporwave Sunset
if settings.startup["custom-map-colors-preset"].value == "Vaporwave Sunset" then
	activePreset = presets.Default
	for object, color in pairs(presets.Default) do
		if not tiles[object] then
			local hsv = colorLib.RGBtoHSV(colorLib.toColor(color))
			local x = hsv.v * hsv.s
			hsv.v = 3*x/4 + 0.25
			hsv.h = 160*x - 115
			hsv.s = 0.8
			if hsv.h > 0 then
				hsv.h = hsv.h + 360
			end
			activePreset[object] = colorLib.HSVtoRGB(hsv)
		end
	end
end]]

--[[Jazz Cup
if settings.startup["custom-map-colors-preset"].value == "Jazz Cup" then
	activePreset = presets.Default
	for object, color in pairs(presets.Default) do
		if not tiles[object] then
			local hsv = colorLib.RGBtoHSV(colorLib.toColor(color))
			local x = hsv.v * hsv.s
			hsv.v = x*0.6 + 0.2
			hsv.h = (147-300)*x + 300
			hsv.s = 0.8
			if hsv.h < 0 then
				hsv.h = hsv.h + 360
			end
			activePreset[object] = colorLib.HSVtoRGB(hsv)
		end
	end
end]]


--currentColors is used for testing and debugging
local currentColors = {}
function pickColor(object)
	local color = colorLib.toColor(settings.startup["use-custom-"..object.."-color"].value and settings.startup["custom-"..object.."-color"].value or activePreset[object] or defaultPreset[object])
	currentColors[object] = colorLib.colorToHex(color)
	return color
end

if settings.startup["custom-map-colors-preset"].value ~= "None" then
	--Change Type Colors
	for _, entityType in pairs(entityTypes) do
		local customColor = pickColor(entityType)
		for k, v in pairs(data.raw[entityType]) do
			v.friendly_map_color = customColor
		end
	end


	--Change specified assembling-machine colors
	for _, machine in pairs(machines) do
		data.raw["assembling-machine"][machine].friendly_map_color = pickColor(machine)
	end


	--Change specified utility constant colors
	for _, utilConstant in pairs(utilConstants) do 
		local name = (string.gsub(utilConstant,"-","_").."_color")
		data.raw["utility-constants"]["default"].chart[name] = pickColor(utilConstant)
	end


	for _, belt in pairs(belts) do
		local customColor = pickColor(belt.."transport-belt")
		data.raw["transport-belt"][belt.."transport-belt"].friendly_map_color = customColor
		data.raw["splitter"][belt.."splitter"].friendly_map_color = colorLib.multiply_color(customColor, 0.8)
		data.raw["underground-belt"][belt.."underground-belt"].friendly_map_color = colorLib.multiply_color(customColor, 0.75)
	end


	local customPipeColor = pickColor("pipe")
	local scale = ("None" == (settings.startup["custom-map-colors-preset"].value)) and 1 or nil

	for _, v in pairs(data.raw["pipe"]) do
		v.friendly_map_color = customPipeColor
	end
	for _, v in pairs(data.raw["pipe-to-ground"]) do
		v.friendly_map_color = customPipeColor
	end
	for _, v in pairs(data.raw["pump"]) do
		v.friendly_map_color = colorLib.multiply_color(customPipeColor, scale or 0.8)
	end
	for _, v in pairs(data.raw["storage-tank"]) do
		v.friendly_map_color = colorLib.multiply_color(customPipeColor, scale or 0.66)
	end


	data.raw["rocket-silo"]["rocket-silo"].friendly_map_color = pickColor("rocket-silo")

	for _,building in pairs(military) do
		data.raw["utility-constants"]["default"].chart.default_friendly_color_by_type[building] = pickColor(building)
	end
end

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

--[[local mapTiles = {}
for k,v in pairs(data.raw["tile"]) do
	log(serpent.line(v.name))
	mapTiles[v.name] = colorLib.colorToHex(v.map_color)
end
log(serpent.block(mapTiles,{sortkeys=false}))]]


--[[local winterTiles = {}
for mapTile, color in pairs(mapTiles["Default 0.17"]) do
	local hsl = colorLib.RGBtoHSL(colorLib.toColor(color))
	hsl.s = 0
	hsl.l = (1+hsl.l)/2
	winterTiles[mapTile] = colorLib.colorToHex(colorLib.HSLtoRGB(hsl))
end]]


--non path tiles
--Default 0.17
if settings.startup["custom-map-colors-map-tiles-preset"].value == "Default 0.17" then
	for mapTile, color in pairs(defaultMapTiles) do
		local hsv = colorLib.RGBtoHSV(colorLib.toColor(color))
		local m = settings.startup["custom-map-colors-map-tiles-multiplier"].value
		hsv.s = math.min((1-hsv.s)*m/10 + hsv.s)
		data.raw["tile"][mapTile].map_color = colorLib.HSVtoRGB(hsv)
	end
end

if settings.startup["custom-map-colors-map-tiles-preset"].value == "Autumn Leaves" then
	for mapTile, color in pairs(defaultMapTiles) do
		color = colorLib.toColor(color)
		fallColor = util.mix_color(color,colorLib.toColor("ffe39e"))
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

if settings.startup["custom-map-colors-map-tiles-preset"].value == "Dark Side of the Moon" then
	for mapTile, color in pairs(mapTiles["Dark Side of the Moon"]) do
		data.raw["tile"][mapTile].map_color = colorLib.toColor(color)
	end
	data.raw["resource"]["coal"].map_color = colorLib.toColor("505050")
end

if settings.startup["custom-map-colors-map-tiles-preset"].value == "Black" then
	local black = colorLib.toColor("000000")
	for tile, _ in pairs(mapTiles["Default 0.17"]) do
		data.raw["tile"][tile].map_color = black
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
	data.raw["utility-constants"]["default"].chart.turret_range_color = black
	data.raw["utility-constants"]["default"].chart.artillery_range_color = black
	data.raw["utility-constants"]["default"].chart.default_enemy_color = black
	data.raw["utility-constants"]["default"].chart.default_color_by_type["tree"] = black
	data.raw["utility-constants"]["default"].chart.resource_outline_selection_color = black
	data.raw["cliff"]["cliff"].map_color = black
end

--Path tiles
for _, tile in pairs(tiles) do
	local customColor = pickColor(tile)
	if data.raw["tile"][tile] then
		data.raw["tile"][tile].map_color = customColor
	elseif data.raw["tile"][tile.."-left"] then
		data.raw["tile"][tile.."-left"].map_color = customColor
		data.raw["tile"][tile.."-right"].map_color = customColor
	end
end
--[[log(serpent.block(currentColors, {sortkeys = false}))
log(serpent.line("Dark Side of the Moon"))
activeMapTiles = {}
for k,v in pairs(mapTiles["Dark Side of the Moon"]) do
	activeMapTiles[k] = colorLib.colorToHex(v)
end
log(serpent.block(activeMapTiles, {sortkeys = false}))
	]]