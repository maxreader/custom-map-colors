
if script.active_mods["debugadapter"] then require('__debugadapter__/debugadapter.lua') end

local supportedEntities = require('data.entities-table')
local presets = require("data.presets")
local activePreset = presets[(settings.startup["custom-map-colors-preset"].value)]
local defaultPreset = presets.None
local colorLib = require('code.colorLib')




local function pickColor(object)
	Map_legend_data[object] = colorLib.toColor(settings.startup["use-custom-"..object.."-color"].value and settings.startup["custom-"..object.."-color"].value or activePreset[object] or defaultPreset[object] or "006192")
end

local function generate_map_legend_data()
    global.Map_legend_data = {}
    Map_legend_data = global.Map_legend_data
    for _, v in pairs(supportedEntities.belts) do
        pickColor(v.."transport-belt")
    end

    pickColor("pipe")
    if settings.startup["custom-map-colors-preset"].value == "None" then
        Map_legend_data["pipe-to-ground"] = {r = 25, g = 103, b = 150}
        Map_legend_data["pump"] = {r = 109, g = 154, b = 181}
        Map_legend_data["storage-tank"] = {r = 131, g = 166, b = 188}

    end
    --pickColor("rocket-silo")
    for _, v in pairs(supportedEntities.types) do
        pickColor(v)
    end
    for _, v in pairs(supportedEntities.machines) do
        pickColor(v)
    end
    for _, v in pairs(supportedEntities.default_color_by_type) do
        pickColor(v)
    end
    for _, v in pairs(supportedEntities.default_friendly_color_by_type) do
        pickColor(v)
    end
    for _,v in pairs(supportedEntities.utilConstants) do
        local name = (string.gsub(v,"-","_"))
        Map_legend_data[name] = colorLib.toColor(settings.startup["use-custom-"..v.."-color"].value and settings.startup["custom-"..v.."-color"].value or activePreset[v] or defaultPreset[v])
    end
    for _, v in pairs(supportedEntities.paths) do
        pickColor(v)
    end
end


--Special thanks to Raiguard for helping me figure out GUIs
local function create_map_legend(player)
    local MapLegend = global.MapLegend
    local Map_legend_data = global.Map_legend_data

    --[[MapLegend[player.index] = gui.create(player.gui.screen, 'map_legend', player.index,
    {type = 'frame', name = 'map_legend_frame', style = 'dialog_frame', direction = 'vertical',children = {
        {type='flow', --[[style='rb_titlebar_flow', children={
            {type='label', style='frame_title', caption='Map Legend'},
            {type='empty-widget', --[[style='rb_titlebar_draggable_space', save_as='drag_handle'},
            }},
        {type = 'frame', name = 'body_outline', style = 'window_content_frame_packed', direction = 'vertical', children = {
            {type = 'scroll-pane', name = 'scroll', style = 'scroll_pane_under_subheader', direction = 'vertical', children = {
                {type = 'table', name = 'body', column_count = 2, direction = 'horizontal', save_as = 'body'}
            }}
        }}
    }})    
    local body = MapLegend[player.index].body]]

    MapLegend[player.index] = player.gui.left.add({type = 'frame', name = 'map_legend_frame', style = 'dialog_frame', direction = 'vertical'})
    local legend = MapLegend[player.index]
        legend.add({type = 'label', name = 'title', caption = 'Map Legend', style = 'frame_title'})
        local body_outline = legend.add({type = 'frame', name = 'body_outline', style = 'window_content_frame_packed', direction = 'vertical'})
            body_outline.style.maximal_height = 600
            local scroll = body_outline.add({type = 'scroll-pane', name = 'scroll', style = 'scroll_pane_under_subheader', direction = 'vertical'})
                local body = scroll.add({type = 'table', name = 'body', column_count = 2, direction = 'horizontal'})

    for k,v in pairs(Map_legend_data) do    
        body.add({type = 'label', name = k, caption = {"custom-map-colors."..k}})
        body.add({type = 'label', name = k..'color', caption = {"custom-map-colors.map-legend-color", v.r, v.g, v.b}})
    end
end

local function destroy_map_legend(player)
    local MapLegend = global.MapLegend
    MapLegend[player.index].destroy()
end

local function toggle_map_legend(player)
    player.set_shortcut_toggled("cmc_toggle_map_legend_shortcut", not player.is_shortcut_toggled("cmc_toggle_map_legend_shortcut"))
    if player.is_shortcut_toggled("cmc_toggle_map_legend_shortcut") then
        create_map_legend(player)
    else
        destroy_map_legend(player)
    end
end



-- quickbar shortcut
script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name == "cmc_toggle_map_legend_shortcut" then
	    local player = game.players[event.player_index]
        toggle_map_legend(player)
    end
end)

-- hotkey
script.on_event("cmc_toggle_map_legend", function(event)
	local player = game.players[event.player_index]
    toggle_map_legend(player)
end)



script.on_init(function()
    global.MapLegend = {}
    game.forces.player.rechart()
    generate_map_legend_data()
end)

script.on_configuration_changed(function(data)
    global.MapLegend = {}
    if data.mod_startup_settings_changed or data.mod_changes ~=nil then
        game.forces.player.rechart()
        generate_map_legend_data()
    end
end
)