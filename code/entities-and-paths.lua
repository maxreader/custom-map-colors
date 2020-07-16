local supportedEntities = require('data.entities-table')
local presets = require("data.presets")
local activePreset = presets[(settings.startup["custom-map-colors-preset"].value)]
local defaultPreset = presets.None
local colorLib = require("code.colorLib")

if settings.startup["custom-map-colors-preset"].value == "Monochrome" then
    for object, color in pairs(presets["Default"]) do
        color = colorLib.RGBtoHSV(color)
        local monochromeColor = colorLib.RGBtoHSV(settings.startup["custom-map-colors-monochrome"].value)
        color.s = color.s * monochromeColor.s
        color.v = color.v * monochromeColor.v
        color.a = color.a * monochromeColor.a
        color.h = monochromeColor.h
        activePreset[object] = colorLib.HSVtoRGB(color)
    end
end

local currentColors = {}
local function pickColor(object)
	local color = colorLib.toColor(settings.startup["use-custom-"..object.."-color"].value and settings.startup["custom-"..object.."-color"].value or activePreset[object] or defaultPreset[object])
	currentColors[object] = colorLib.colorToHex(color)
	return color
end

if settings.startup["custom-map-colors-preset"].value ~= "None" then
    local chart = data.raw["utility-constants"].default.chart

    --Fluid things
    local pipeColor = pickColor("pipe")
    local scale = ("None" == (settings.startup["custom-map-colors-preset"].value)) and 1 or nil
    chart.default_color_by_type["pipe"] = pipeColor
    chart.default_color_by_type["pipe-to-ground"] = pipeColor
    chart.default_color_by_type["pump"] = colorLib.multiply_color(pipeColor, scale or 0.8)
    chart.default_color_by_type['storage-tank'] = colorLib.multiply_color(pipeColor, scale or 0.66)

	--Default Colors by Type
    for _, v in pairs(supportedEntities.default_color_by_type) do
        chart.default_color_by_type[v] = pickColor(v)
    end
    for _, v in pairs(supportedEntities.default_friendly_color_by_type) do
        chart.default_friendly_color_by_type[v] = pickColor(v)
    end

    --Change Type Colors
	for _, v in pairs(supportedEntities.types) do
		local customColor = pickColor(v)
		for k, v in pairs(data.raw[v]) do
			v.friendly_map_color = customColor
		end
    end

    --Change specified assembling-machine colors
	for _, machine in pairs(supportedEntities.machines) do
		data.raw["assembling-machine"][machine].friendly_map_color = pickColor(machine)
    end
    
    --Change specified utility constant colors
	for _, utilConstant in pairs(supportedEntities.utilConstants) do
		local name = (string.gsub(utilConstant,"-","_").."_color")
		chart[name] = pickColor(utilConstant)
	end

    --Change belt colors by tier
    for _, belt in pairs(supportedEntities.belts) do
		local customColor = pickColor(belt.."transport-belt")
		data.raw["transport-belt"][belt.."transport-belt"].friendly_map_color = customColor
		data.raw["splitter"][belt.."splitter"].friendly_map_color = colorLib.multiply_color(customColor, 0.8)
		data.raw["underground-belt"][belt.."underground-belt"].friendly_map_color = colorLib.multiply_color(customColor, 0.75)
    end
    
    --Rocket Silo
    data.raw["rocket-silo"]["rocket-silo"].friendly_map_color = pickColor("rocket-silo")

    --Path Tiles
    for _, tile in pairs(supportedEntities.paths) do
        local customColor = pickColor(tile)
        if settings.startup["custom-map-colors-map-tiles-preset"].value == "Error: Map not found." then
            customColor = colorLib.toColor("000000")
        end
        if data.raw["tile"][tile] then
            data.raw["tile"][tile].map_color = customColor
        elseif data.raw["tile"][tile.."-left"] then
            data.raw["tile"][tile.."-left"].map_color = customColor
            data.raw["tile"][tile.."-right"].map_color = customColor
        end
    end
end
