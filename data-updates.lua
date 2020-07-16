-- Got this from stackexchange https://stackoverflow.com/questions/46006804/check-if-rgb-color-code-is-valid
local function validHexColor(color)
		return nil ~= color:find("^%x%x%x%x%x%x%x%x$") or color:find("^%x%x%x%x%x%x$") or color:find("^%x%x%x%x$") or color:find("^%x%x%x$")
end

local function toColor(color, default)
	return util.color(validHexColor(color) and color or default)
end

local function multiply_color(c1, n)
	return
	{
	  (c1.r or c1[1] or 0) * (n or 0),
	  (c1.g or c1[2] or 0) * (n or 0),
	  (c1.b or c1[3] or 0) * (n or 0),
	  (c1.a)
	}
end

--Default Building Color
if settings.startup["use-custom-default-friendly-color"].value 	then
	data.raw["utility-constants"]["default"].chart.default_friendly_color = toColor(settings.startup["custom-default-friendly-color"].value, "006192")
end

--Base Belts
if settings.startup["use-custom-transport-belt-color"].value then
	local customTransportBeltColor = toColor(settings.startup["custom-transport-belt-color"].value, "faba00")
	data.raw["transport-belt"]["transport-belt"].friendly_map_color = customTransportBeltColor -- 250, 186, 0
	data.raw["splitter"]["splitter"].friendly_map_color = multiply_color(customTransportBeltColor, 0.8)-- 200, 149, 0
	data.raw["underground-belt"]["underground-belt"].friendly_map_color = multiply_color(customTransportBeltColor, 0.75) -- 188, 140, 0
end

if settings.startup["use-custom-fast-transport-belt-color"].value then
	local customFastTransportBeltColor = toColor(settings.startup["custom-fast-transport-belt-color"].value, "fa450e")
	data.raw["transport-belt"]["fast-transport-belt"].friendly_map_color = customFastTransportBeltColor -- 250, 69, 15
	data.raw["splitter"]["fast-splitter"].friendly_map_color = multiply_color(customFastTransportBeltColor, 0.8) -- 200, 55, 12
	data.raw["underground-belt"]["fast-underground-belt"].friendly_map_color = multiply_color(customFastTransportBeltColor, 0.75) -- 188, 52, 11
end

if settings.startup["use-custom-express-transport-belt-color"].value then
	local customExpressTransportBeltColor = toColor(settings.startup["custom-express-transport-belt-color"].value, "36c9ff")
	data.raw["transport-belt"]["express-transport-belt"].friendly_map_color = customExpressTransportBeltColor -- 97, 179, 255
	data.raw["splitter"]["express-splitter"].friendly_map_color = multiply_color(customExpressTransportBeltColor, 0.8)
	data.raw["underground-belt"]["express-underground-belt"].friendly_map_color = multiply_color(customExpressTransportBeltColor, 0.75)
end

--changes color of pipes/storage tank, including Bob's
if settings.startup["use-custom-pipe-color"].value then
	local customPipeColor = toColor(settings.startup["custom-pipe-color"].value, "b429ff")
	for _, v in pairs(data.raw["pipe"]) do
		v.friendly_map_color = customPipeColor 
	end
	for _, v in pairs(data.raw["pipe-to-ground"]) do
		v.friendly_map_color = customPipeColor 
	end
	for _, v in pairs(data.raw["pump"]) do
		v.friendly_map_color = multiply_color(customPipeColor, 0.8)
	end
	for _, v in pairs(data.raw["storage-tank"]) do
		v.friendly_map_color = multiply_color(customPipeColor, 0.66) 
	end
end

--All Assembling Machines
if settings.startup["use-custom-assembling-machine-color"].value then
	local customAssemblerColor = toColor(settings.startup["custom-assembling-machine-color"].value, "0086c9")
	for _, v in pairs(data.raw["assembling-machine"]) do
		v.friendly_map_color = customAssemblerColor
	end
end

--Chemical plants
if settings.startup["use-custom-chemical-plant-color"].value then
	data.raw["assembling-machine"]["chemical-plant"].friendly_map_color = toColor(settings.startup["custom-chemical-plant-color"].value, "4bc04b")
end

--Refineries
if settings.startup["use-custom-refinery-color"].value then
	data.raw["assembling-machine"]["oil-refinery"].friendly_map_color = toColor(settings.startup["custom-refinery-color"].value, "328032")
end

--Furnaces
if settings.startup["use-custom-furnace-color"].value then
	local customFurnaceColor = toColor(settings.startup["custom-furnace-color"].value, "ffa826")
	for _, v in pairs(data.raw["furnace"]) do
		v.friendly_map_color = customFurnaceColor
	end
end

--Labs
if settings.startup["use-custom-lab-color"].value then
	data.raw["lab"]["lab"].friendly_map_color = toColor(settings.startup["custom-lab-color"].value, "ff90bd")
end

--Rocket Silo
if settings.startup["use-custom-rocket-silo-color"].value then
	data.raw["rocket-silo"]["rocket-silo"].friendly_map_color = toColor(settings.startup["custom-rocket-silo-color"].value, "2b4544")
end

--Beacons
if settings.startup["use-custom-beacon-color"].value then
	local customBeaconColor = toColor(settings.startup["custom-beacon-color"].value, "008192")
	for _, v in pairs(data.raw["beacon"]) do
		v.friendly_map_color = customBeaconColor
	end
end

--Centrifuges
if settings.startup["use-custom-centrifuge-color"].value then
	data.raw["assembling-machine"]["centrifuge"].friendly_map_color = toColor(settings.startup["custom-centrifuge-color"].value, "40ff40")
end

--Reactors
if settings.startup["use-custom-reactor-color"].value then
	local customReactorColor = toColor(settings.startup["custom-reactor-color"].value, "2aba25")
	for _, v in pairs(data.raw["reactor"]) do
		v.friendly_map_color = customReactorColor
	end
end

--Heat Pipes
if settings.startup["use-custom-heat-pipe-color"].value then
	local customHeatPipeColor = toColor(settings.startup["custom-heat-pipe-color"].value, "8e0000")
	for _, v in pairs(data.raw["heat-pipe"]) do
		v.friendly_map_color = customHeatPipeColor
	end
end

--Boilers/Heat Exchangers
if settings.startup["use-custom-boiler-color"].value then
	local customBoilerColor = toColor(settings.startup["custom-boiler-color"].value, "00008c")
	for _, v in pairs(data.raw["boiler"]) do
		v.friendly_map_color = customBoilerColor
	end
end

--Generators
if settings.startup["use-custom-generator-color"].value then
	local customGeneratorColor = toColor(settings.startup["custom-generator-color"].value, "005926")
	for _, v in pairs(data.raw["generator"]) do
		v.friendly_map_color = customGeneratorColor
	end
end

--Electric Poles
if settings.startup["use-custom-electric-pole-color"].value then
	local customElectricPoleColor = toColor(settings.startup["custom-electric-pole-color"].value, "eeee29")
	for _, v in pairs(data.raw["electric-pole"]) do
		v.friendly_map_color = customElectricPoleColor
	end
end

--Solar Panels
if settings.startup["use-custom-solar-panel-color"].value then
	local customSolarPanelColor = toColor(settings.startup["custom-solar-panel-color"].value, "1f2124")
	for _, v in pairs(data.raw["solar-panel"]) do
		v.friendly_map_color = customSolarPanelColor
	end
end

--Accumulators
if settings.startup["use-custom-accumulator-color"].value then
	local customAccumulatorColor = toColor(settings.startup["custom-accumulator-color"].value, "7a7a7a")
	for _, v in pairs(data.raw["accumulator"]) do
		v.friendly_map_color = customAccumulatorColor
	end
end

--Radars
if settings.startup["use-custom-radar-color"].value then
	local customRadarColor = toColor(settings.startup["custom-radar-color"].value, "7ce8c0")
	for _, v in pairs(data.raw["radar"]) do
		v.friendly_map_color = customRadarColor
	end
end

--Roboports
if settings.startup["use-custom-roboport-color"].value then
	local customRoboportColor = toColor(settings.startup["custom-roboport-color"].value, "4888e8")
	for _, v in pairs(data.raw["roboport"]) do
		v.friendly_map_color = customRoboportColor
	end
end

--Tiles
if settings.startup["use-custom-stone-path-color"].value then
	data.raw["tile"]["stone-path"].map_color = toColor(settings.startup["custom-stone-path-color"].value, "323232")
end

if settings.startup["use-custom-concrete-color"].value then
	data.raw["tile"]["concrete"].map_color = toColor(settings.startup["custom-concrete-color"].value, "646464")
end

if settings.startup["use-custom-hazard-concrete-color"].value then
	local customHazardConcreteColor = toColor(settings.startup["custom-hazard-concrete-color"].value, "808000")
	data.raw["tile"]["hazard-concrete-left"].map_color = customHazardConcreteColor
	data.raw["tile"]["hazard-concrete-right"].map_color = customHazardConcreteColor
end

if settings.startup["use-custom-refined-concrete-color"].value then
	data.raw["tile"]["refined-concrete"].map_color = toColor(settings.startup["custom-refined-concrete-color"].value, "969696")
end

if settings.startup["use-custom-refined-hazard-concrete-color"].value then
	local customRefinedHazardConcreteColor = toColor(settings.startup["custom-refined-hazard-concrete-color"].value, "808000")
	data.raw["tile"]["refined-hazard-concrete-left"].map_color = customRefinedHazardConcreteColor
	data.raw["tile"]["refined-hazard-concrete-right"].map_color = customRefinedHazardConcreteColor
end

--Vehicles
if settings.startup["use-custom-vehicle-outer-color"].value then
	data.raw["utility-constants"]["default"].chart.vehicle_outer_color = toColor(settings.startup["custom-vehicle-outer-color"].value, "ff1a1a")
end
if settings.startup["use-custom-vehicle-inner-color"].value then
	data.raw["utility-constants"]["default"].chart.vehicle_inner_color = toColor(settings.startup["custom-vehicle-inner-color"].value, "e6e6e6")
end

--Rails
if settings.startup["use-custom-rail-color"].value then
	data.raw["utility-constants"]["default"].chart.rail_color = toColor(settings.startup["custom-rail-color"].value, "9fcacc")
end
