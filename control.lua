local supportedEntities = require('data.entities-table')
local presets = require("data.presets")
local activePreset = presets[(settings.startup["custom-map-colors-preset"].value)]
local defaultPreset = presets.None
local colorLib = require('code.colorLib')

local function pickColor(object)
    Map_legend_data.entities[object] = colorLib.toColor(
                                           settings.startup["use-custom-" .. object .. "-color"]
                                               .value and
                                               settings.startup["custom-" .. object .. "-color"]
                                                   .value or activePreset[object] or
                                               defaultPreset[object] or "006192")
end

local function generate_map_legend_data()
    global.Map_legend_data = {
        entities = {},
        resources = {},
        trees = {},
        tiles = {},
        iconMap = {}
    }
    Map_legend_data = global.Map_legend_data
    for _, v in pairs(supportedEntities.belts) do pickColor(v .. "transport-belt") end

    pickColor("pipe")
    if settings.startup["custom-map-colors-preset"].value == "None" then
        Map_legend_data.entities["pipe-to-ground"] =
            {r = 25, g = 103, b = 150}
        Map_legend_data.entities["pump"] = {
            r = 109,
            g = 154,
            b = 181
        }
        Map_legend_data.entities["storage-tank"] =
            {r = 131, g = 166, b = 188}

    end
    -- pickColor("rocket-silo")
    for _, v in pairs(supportedEntities.types) do pickColor(v) end
    for _, v in pairs(supportedEntities.machines) do pickColor(v) end
    for _, v in pairs(supportedEntities.default_color_by_type) do pickColor(v) end
    for _, v in pairs(supportedEntities.default_friendly_color_by_type) do pickColor(v) end
    for _, v in pairs(supportedEntities.utilConstants) do
        local name = (string.gsub(v, "-", "_"))
        Map_legend_data.entities[name] = colorLib.toColor(
                                             settings.startup["use-custom-" .. v .. "-color"].value and
                                                 settings.startup["custom-" .. v .. "-color"].value or
                                                 activePreset[v] or defaultPreset[v])
    end

    for name, resource in pairs(game.get_filtered_entity_prototypes(
                                    {
            {filter = "type", type = "resource"}
        })) do Map_legend_data.resources[name] = colorLib.toColor(resource.map_color) end
    for name, tree in pairs(game.get_filtered_entity_prototypes(
                                {
            {filter = "type", type = "tree"}
        })) do Map_legend_data.trees[name] = colorLib.toColor(tree.map_color) end

    local iconMap = Map_legend_data.iconMap
    for k, _ in pairs(Map_legend_data.entities) do iconMap[k] = "[img=entity/" .. k .. "]" end

    iconMap["assembling-machine"] = "[img=technology/automation]"
    iconMap["furnace"] = "[img=technology/advanced-material-processing]"
    iconMap["reactor"] = "[img=technology/nuclear-power]"
    iconMap["electric-pole"] = "[img=technology/electric-energy-distribution-1]"
    iconMap["generator"] = "[img=entity/steam-turbine]"
    iconMap["ammo-turret"] = "[img=entity/gun-turret]"
    iconMap["fluid-turret"] = "[img=entity/flamethrower-turret]"
    iconMap["electric-turret"] = "[img=entity/laser-turret]"
    iconMap["wall"] = "[img=entity/stone-wall]"
    iconMap["rail"] = "[img=entity/curved-rail]"
    iconMap["vehicle_outer"] = "[img=entity/car]"
    iconMap["vehicle_inner"] = "[img=entity/car]"
    iconMap["default_friendly"] = "[img=entity/character]"

    local tileBlacklist = {
        ["stone-path"] = true,
        ["concrete"] = true,
        ["hazard-concrete-left"] = true,
        ["hazard-concrete-right"] = true,
        ["refined-concrete"] = true,
        ["refined-hazard-concrete-left"] = true,
        ["refined-hazard-concrete-right"] = true,
        ["acid-refined-concrete"] = true,
        ["black-refined-concrete"] = true,
        ["blue-refined-concrete"] = true,
        ["brown-refined-concrete"] = true,
        ["cyan-refined-concrete"] = true,
        ["green-refined-concrete"] = true,
        ["orange-refined-concrete"] = true,
        ["pink-refined-concrete"] = true,
        ["purple-refined-concrete"] = true,
        ["red-refined-concrete"] = true,
        ["yellow-refined-concrete"] = true,
        ["bio-tile"] = true,
        ["factory-entrance-1"] = true,
        ["factory-entrance-2"] = true,
        ["factory-entrance-3"] = true,
        ["factory-pattern-1"] = true,
        ["factory-pattern-2"] = true,
        ["factory-pattern-3"] = true,
        ["factory-floor-1"] = true,
        ["factory-floor-2"] = true,
        ["factory-floor-3"] = true,
        ["factory-wall-1"] = true,
        ["factory-wall-2"] = true,
        ["factory-wall-3"] = true,
        ["lab-dark-1"] = true,
        ["lab-dark-2"] = true,
        ["lab-white"] = true,
        ["out-of-factory"] = true,
        ["out-of-map"] = true,
        ["tutorial-grid"] = true,
        ["BuildTile"] = true
    }
    for name, tile in pairs(game.tile_prototypes) do
        if not tileBlacklist[name] then
            Map_legend_data.tiles[name] = colorLib.toColor(tile.map_color)
        end
    end
end

local function create_tab(parent, name, data, locale_type)
    local iconMap = global.Map_legend_data.iconMap
    local tab = parent.add {type = "tab", caption = name}
    local tab_outline = parent.add({
        type = 'frame',
        name = name .. 'tab_outline',
        style = 'window_content_frame_packed',
        direction = 'vertical'
    })
    tab_outline.style.maximal_height = 600
    local tab_scroll = tab_outline.add({
        type = 'scroll-pane',
        name = 'scroll',
        style = 'scroll_pane_under_subheader',
        direction = 'vertical'
    })
    tab_scroll.style.padding = 0
    tab_scroll.style.margin = 0
    local tab_body = tab_scroll.add({
        type = 'table',
        name = 'body',
        style = 'map-legend-table',
        column_count = 3,
        direction = 'horizontal'
    })
    for k, v in pairs(data) do
        if locale_type == "custom-map-colors" then
            tab_body.add({
                type = 'label',
                name = k .. 'icon',
                caption = iconMap[k]
            })
            tab_body.add({
                type = 'label',
                name = k,
                caption = {locale_type .. '.' .. k}
            })
        else
            tab_body.add({
                type = 'label',
                name = k .. 'icon',
                caption = "[img=" .. locale_type .. "/" .. k .. "]"
            })
            tab_body.add({
                type = 'label',
                name = k,
                caption = {locale_type .. "-name." .. k}
            })
        end
        tab_body[k].style.vertically_stretchable = true
        tab_body[k].style.horizontally_stretchable = true
        tab_body.add({
            type = 'label',
            name = k .. 'color',
            caption = {
                "custom-map-colors.map-legend-color", v.r,
                v.g, v.b
            }
        })
    end
    parent.add_tab(tab, tab_outline)
end

-- Special thanks to Raiguard for helping me figure out GUIs
local function create_map_legend(player)
    local MapLegend = global.MapLegend
    local Map_legend_data = global.Map_legend_data
    local legend = player.gui.screen.add {
        type = 'frame',
        name = 'map_legend',
        direction = 'vertical'
    }
    MapLegend[player.index] = legend

    legend.location = global.Position[player.index]

    local header = legend.add{ -- HEADER
        type = 'flow',
        name = 'title_bar_flow',
        direction = 'horizontal'
    }.add{
        type = 'label',
        name = 'title',
        caption = {'custom-map-colors.map-legend'},
        style = 'frame_title'
    }.parent.add {
        type = 'empty-widget',
        name = 'title_drag_widget',
        style = 'map-legend-drag-widget'
    }
    header.drag_target = legend
    header.style.height = 24
    header.style.minimal_width = 24

    local tabbed_pane_outline = legend.add({
        type = 'frame',
        name = 'tabbed_pane_outline',
        style = 'inside_deep_frame_for_tabs',
        direction = 'vertical'
    })
    local tabbed_pane = tabbed_pane_outline.add {
        type = "tabbed-pane"
    }
    create_tab(tabbed_pane, "Entities\nand paths", Map_legend_data.entities, "custom-map-colors")
    create_tab(tabbed_pane, "Resources", Map_legend_data.resources, "entity")
    create_tab(tabbed_pane, "Trees", Map_legend_data.trees, "entity")
    create_tab(tabbed_pane, "Tiles", Map_legend_data.tiles, "tile")
end

local function destroy_map_legend(index)
    local legend = global.MapLegend[index]
    legend.destroy()
end

local function toggle_map_legend(index)
    local player = game.get_player(index)
    player.set_shortcut_toggled("cmc_toggle_map_legend_shortcut",
                                not player.is_shortcut_toggled("cmc_toggle_map_legend_shortcut"))
    if player.is_shortcut_toggled("cmc_toggle_map_legend_shortcut") then
        create_map_legend(player)
    else
        destroy_map_legend(index)
    end
end

local on_gui_location_changed = function(event)
    local element = event.element
    if element.name == "map_legend" then global.Position[event.player_index] = element.location end
end

script.on_event(defines.events.on_gui_location_changed, on_gui_location_changed)

-- quickbar shortcut
script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name == "cmc_toggle_map_legend_shortcut" then
        toggle_map_legend(event.player_index)
    end
end)

-- hotkey
script.on_event("cmc_toggle_map_legend", function(event) toggle_map_legend(event.player_index) end)

script.on_init(function()
    global.MapLegend = {}
    global.Position = {}
    game.forces.player.rechart()
    generate_map_legend_data()
end)

script.on_configuration_changed(function(data)
    if global.MapLegend and #global.MapLegend > 0 then
        for k, v in pairs(global.MapLegend) do
            v.destroy()
            game.get_player(k).set_shortcut_toggled("cmc_toggle_map_legend_shortcut", false)
        end
    end
    global.MapLegend = {}
    global.Position = {}
    if data.mod_startup_settings_changed ~= nil then
        game.forces.player.rechart()
        generate_map_legend_data()
    end
end)
