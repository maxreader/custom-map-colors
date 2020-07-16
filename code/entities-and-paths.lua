local supportedEntities = {
    belts = {
        "",
        "fast-",
        "express-"
    },
    machines = {
        "chemical-plant",
        "oil-refinery",
        "centrifuge"
    },
    types ={
        "assembling-machine",
        "furnace",
        "lab",
        "reactor",
        "boiler",
        "electric-pole",
        "radar",
        "rocket-silo"
    },
    paths = {
        "stone-path",
        "concrete",
        "hazard-concrete",
        "refined-concrete",
        "refined-hazard-concrete" 
     },
     default_friendly_color_by_type = {
        "solar-panel",
        "accumulator",
        "ammo-turret",
        "fluid-turret",
        "electric-turret",
        "wall",
        "gate"
    },
    default_color_by_type = {
        "heat-pipe",
        "beacon",
        "generator",
        "roboport"
    },
    utilConstants = {
        "default-friendly",
        "vehicle-outer",
        "vehicle-inner",
        "rail",
    }
    
}

local presets = require("data.presets")
local activePreset = presets[(settings.startup["custom-map-colors-preset"].value)]
local defaultPreset = presets.None
local colorLib = require("code.colorLib")

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
    for _, entity in pairs(supportedEntities.default_color_by_type) do
        chart.default_color_by_type[entity] = pickColor(entity)
    end
    for _, entity in pairs(supportedEntities.default_friendly_color_by_type) do
        chart.default_friendly_color_by_type[entity] = pickColor(entity)
    end

    --Change Type Colors
	for _, entityType in pairs(supportedEntities.types) do
		local customColor = pickColor(entityType)
		for k, v in pairs(data.raw[entityType]) do
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