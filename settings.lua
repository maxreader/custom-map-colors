local presets = require("data.presets")
local mapTiles = require("data.map-tiles-data")
local customMapColorsAllowedPresets = {}
for k,_ in pairs(presets) do
    table.insert(customMapColorsAllowedPresets, k)
end
local customMapTileColorPresets= {}
for k,_ in pairs(mapTiles) do
    table.insert(customMapTileColorPresets, k)
end
data:extend({
    {
        type = "string-setting",
        name = "custom-map-colors-preset",
        setting_type = "startup",
        default_value = "Default",
        allowed_values = customMapColorsAllowedPresets,
        order = "1"
    },
    {
        type = "string-setting",
        name = "custom-map-colors-monochrome",
        setting_type = "startup",
        default_value = "0000bb",
        order = "2"
    },
    {
        type = "string-setting",
        name = "custom-map-colors-map-tiles-preset",
        setting_type = "startup",
        default_value = "Default 0.17",
        allowed_values = customMapTileColorPresets,
        order = "3"
    },
    {
        type = "double-setting",
        name = "custom-map-colors-map-tiles-multiplier",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 0.1,
        maximum_value = 10,
        order = "4"
    },
    {
        type = "bool-setting",
        name = "use-custom-map-colors-fancy-trees",
        setting_type = "startup",
        default_value = true,
        order = "5"
    },
    {
        type = "bool-setting",
        name = "use-custom-default-friendly-color",
        setting_type = "startup",
        default_value = false,
        order = "a"
    },
    {
        type = "string-setting",
        name = "custom-default-friendly-color",
        setting_type = "startup",
        default_value = "006192",
        order = "aa"
    },
    {
        type = "bool-setting",
        name = "use-custom-transport-belt-color",
        setting_type = "startup",
        default_value = false,
        order = "ab"
    },
    {
        type = "string-setting",
        name = "custom-transport-belt-color",
        setting_type = "startup",
        default_value = "fAba00",
        order = "aba"
    },
    {
        type = "bool-setting",
        name = "use-custom-fast-transport-belt-color",
        setting_type = "startup",
        default_value = false,
        order = "abc"
    },
    {
        type = "string-setting",
        name = "custom-fast-transport-belt-color",
        setting_type = "startup",
        default_value = "fa450e",
        order = "abd"
    },
    {
        type = "bool-setting",
        name = "use-custom-express-transport-belt-color",
        setting_type = "startup",
        default_value = false,
        order = "abe"
    },
    {
        type = "string-setting",
        name = "custom-express-transport-belt-color",
        setting_type = "startup",
        default_value = "36c9ff",
        order ="abf"
    },
    {
        type = "bool-setting",
        name = "use-custom-pipe-color",
        setting_type = "startup",
        default_value = false,
        order = "abg"
    },
    {
        type = "string-setting",
        name = "custom-pipe-color",
        setting_type = "startup",
        default_value = "b429ff",
        order = "abh"
    },
    {
        type = "bool-setting",
        name = "use-custom-assembling-machine-color",
        setting_type = "startup",
        default_value = false,
        order = "abi"
    },
    {
        type = "string-setting",
        name = "custom-assembling-machine-color",
        setting_type = "startup",
        default_value = "0086c9",
        order = "abj"
    },
    {
        type = "bool-setting",
        name = "use-custom-chemical-plant-color",
        setting_type = "startup",
        default_value = false,
        order = "abk"
    },
    {
        type = "string-setting",
        name = "custom-chemical-plant-color",
        setting_type = "startup",
        default_value = "4bc04b",
        order = "abl"
    },
    {
        type = "bool-setting",
        name = "use-custom-oil-refinery-color",
        setting_type = "startup",
        default_value = false,
        order = "abm"
    },
    {
        type = "string-setting",
        name = "custom-oil-refinery-color",
        setting_type = "startup",
        default_value = "328032",
        order = "abn"
    },
    {
        type = "bool-setting",
        name = "use-custom-furnace-color",
        setting_type = "startup",
        default_value = false,
        order = "abo"
    },
    {
        type = "string-setting",
        name = "custom-furnace-color",
        setting_type = "startup",
        default_value = "ffa826",
        order = "abp"
    },
    {
        type = "bool-setting",
        name = "use-custom-lab-color",
        setting_type = "startup",
        default_value = false,
        order = "abq"
    },
    {
        type = "string-setting",
        name = "custom-lab-color",
        setting_type = "startup",
        default_value = "ff90bd",
        order = "abr"
    },
    {
        type = "bool-setting",
        name = "use-custom-rocket-silo-color",
        setting_type = "startup",
        default_value = false,
        order = "abs"
    },
    {
        type = "string-setting",
        name = "custom-rocket-silo-color",
        setting_type = "startup",
        default_value = "2b4544",
        order = "abt"
    },
    {
        type = "bool-setting",
        name = "use-custom-beacon-color",
        setting_type = "startup",
        default_value = false,
        order = "abu"
    },
    {
        type = "string-setting",
        name = "custom-beacon-color",
        setting_type = "startup",
        default_value = "008192",
        order = "abv"
    },
    {
        type = "bool-setting",
        name = "use-custom-centrifuge-color",
        setting_type = "startup",
        default_value = false,
        order = "abw"
    },
    {
        type = "string-setting",
        name = "custom-centrifuge-color",
        setting_type = "startup",
        default_value = "40ff40",
        order = "abx"
    },
    {
        type = "bool-setting",
        name = "use-custom-reactor-color",
        setting_type = "startup",
        default_value = false,
        order = "aby"
    },
    {
        type = "string-setting",
        name = "custom-reactor-color",
        setting_type = "startup",
        default_value = "2aba25",
        order = "abz"
    },
    {
        type = "bool-setting",
        name = "use-custom-heat-pipe-color",
        setting_type = "startup",
        default_value = false,
        order = "abza"
    },
    {
        type = "string-setting",
        name = "custom-heat-pipe-color",
        setting_type = "startup",
        default_value = "8e0000",
        order = "abzb"
    },
    {
        type = "bool-setting",
        name = "use-custom-boiler-color",
        setting_type = "startup",
        default_value = false,
        order = "abzc"
    },
    {
        type = "string-setting",
        name = "custom-boiler-color",
        setting_type = "startup",
        default_value = "00008c",
        order = "abzd"
    },
    {
        type = "bool-setting",
        name = "use-custom-generator-color",
        setting_type = "startup",
        default_value = false,
        order = "aca"
    },
    {
        type = "string-setting",
        name = "custom-generator-color",
        setting_type = "startup",
        default_value = "005926",
        order = "acb"
    },
    {
        type = "bool-setting",
        name = "use-custom-electric-pole-color",
        setting_type = "startup",
        default_value = false,
        order = "acc"
    },
    {
        type = "string-setting",
        name = "custom-electric-pole-color",
        setting_type = "startup",
        default_value = "eeee29",
        order = "acd"
    },
    {
        type = "bool-setting",
        name = "use-custom-solar-panel-color",
        setting_type = "startup",
        default_value = false,
        order = "ace"
    },
    {
        type = "string-setting",
        name = "custom-solar-panel-color",
        setting_type = "startup",
        default_value = "1f2124",
        order = "acf"
    },
    {
        type ="bool-setting",
        name = "use-custom-accumulator-color",
        setting_type = "startup",
        default_value = false,
        order = "acg"
    },
    {
        type = "string-setting",
        name = "custom-accumulator-color",
        setting_type = "startup",   
        default_value = "7a7a7a",
        order = "ach"
    },
    {
        type ="bool-setting",
        name = "use-custom-radar-color",
        setting_type = "startup",
        default_value = false,
        order = "aci"
    },
    {
        type = "string-setting",
        name = "custom-radar-color",
        setting_type = "startup",
        default_value = "7ce8c0",
        order = "acj"
    },
    {
        type ="bool-setting",
        name = "use-custom-roboport-color",
        setting_type = "startup",
        default_value = false,
        order = "ack"
    },
    {
        type = "string-setting",
        name = "custom-roboport-color",
        setting_type = "startup",
        default_value = "4888e8",
        order = "acl"
    },
    {
        type ="bool-setting",
        name = "use-custom-stone-path-color",
        setting_type = "startup",
        default_value = false,
        order = "acm"
    },
    {
        type = "string-setting",
        name = "custom-stone-path-color",
        setting_type = "startup",
        default_value = "323232",
        order = "acn"
    },
    {
        type ="bool-setting",
        name = "use-custom-concrete-color",
        setting_type = "startup",
        default_value = false,
        order = "aco"
    },
    {
        type = "string-setting",
        name = "custom-concrete-color",
        setting_type = "startup",
        default_value = "646464",
        order = "acp"
    },
    {
        type ="bool-setting",
        name = "use-custom-hazard-concrete-color",
        setting_type = "startup",
        default_value = false,
        order = "acq"
    },
    {
        type = "string-setting",
        name = "custom-hazard-concrete-color",
        setting_type = "startup",
        default_value = "808000",
        order = "acr"
    },
    {
        type ="bool-setting",
        name = "use-custom-refined-concrete-color",
        setting_type = "startup",
        default_value = false,
        order = "acs"
    },
    {
        type = "string-setting",
        name = "custom-refined-concrete-color",
        setting_type = "startup",
        default_value = "969696",
        order = "act"
    },
    {
        type ="bool-setting",
        name = "use-custom-refined-hazard-concrete-color",
        setting_type = "startup",
        default_value = false,
        order = "acu"
    },
    {
        type = "string-setting",
        name = "custom-refined-hazard-concrete-color",
        setting_type = "startup",
        default_value = "808000",
        order = "acv"
    },
    {
        type ="bool-setting",
        name = "use-custom-vehicle-outer-color",
        setting_type = "startup",
        default_value = false,
        order = "acw"
    },
    {
        type = "string-setting",
        name = "custom-vehicle-outer-color",
        setting_type = "startup",
        default_value = "ff1a1a",
        order = "acx"
    },
    {
        type ="bool-setting",
        name = "use-custom-vehicle-inner-color",
        setting_type = "startup",
        default_value = false,
        order = "acy"
    },
    {
        type = "string-setting",
        name = "custom-vehicle-inner-color",
        setting_type = "startup",
        default_value = "e6e6e6",
        order = "acz"
    },
    {
        type ="bool-setting",
        name = "use-custom-rail-color",
        setting_type = "startup",
        default_value = false,
        order = "ada"
    },
    {
        type = "string-setting",
        name = "custom-rail-color",
        setting_type = "startup",
        default_value = "9fcacc",
        order = "adb"
    },
    {
        type ="bool-setting",
        name = "use-custom-ammo-turret-color",
        setting_type = "startup",
        default_value = false,
        order = "adc"
    },
    {
        type = "string-setting",
        name = "custom-ammo-turret-color",
        setting_type = "startup",
        default_value = "caa718",
        order = "add"
    },
    {
        type ="bool-setting",
        name = "use-custom-electric-turret-color",
        setting_type = "startup",
        default_value = false,
        order = "ade"
    },
    {
        type = "string-setting",
        name = "custom-electric-turret-color",
        setting_type = "startup",
        default_value = "d92e2e",
        order = "adf"
    },
    {
        type ="bool-setting",
        name = "use-custom-fluid-turret-color",
        setting_type = "startup",
        default_value = false,
        order = "adg"
    },
    {
        type = "string-setting",
        name = "custom-fluid-turret-color",
        setting_type = "startup",
        default_value = "eb7303",
        order = "adh"
    },
    {
        type ="bool-setting",
        name = "use-custom-wall-color",
        setting_type = "startup",
        default_value = false,
        order = "adi"
    },
    {
        type = "string-setting",
        name = "custom-wall-color",
        setting_type = "startup",
        default_value = "cddacd",
        order = "adj"
    },
    {
        type ="bool-setting",
        name = "use-custom-gate-color",
        setting_type = "startup",
        default_value = false,
        order = "adk"
    },
    {
        type = "string-setting",
        name = "custom-gate-color",
        setting_type = "startup",
        default_value = "808080",
        order = "adl"
    }
})