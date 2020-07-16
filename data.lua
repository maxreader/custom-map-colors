data:extend({
    {
      type = "custom-input",
      name = "cmc_toggle_map_legend",
      key_sequence = "ALT + M",
      consuming = "game-only",
    },
    {
        name = "cmc_toggle_map_legend_shortcut",
        type = "shortcut",
        toggleable = true,
        action = "lua",
        associated_control_input = "cmc_toggle_map_legend",
        icon = {
            filename = "__core__/graphics/icons/mip/map.png",
            priority = "extra-high-no-scale",
            size = 32,
            scale = 1,
            flags = {"icon"}
        },
        disabled_icon = {
            filename = "__core__/graphics/icons/mip/map.png",
            priority = "extra-high-no-scale",
            size = 32,
            scale = 1,
            flags = {"icon"}
        },
        small_icon = {
            filename = "__core__/graphics/icons/mip/map.png",
            priority = "extra-high-no-scale",
            size = 16,
            x = 32,
            scale = 1,
            flags = {"icon"}
        },
        disabled_small_icon = {
            filename = "__core__/graphics/icons/mip/map.png",
            priority = "extra-high-no-scale",
            size = 16,
            x = 32,
            scale = 1,
            flags = {"icon"}
        },
    },
})
local styles = data.raw["gui-style"]["default"]
styles["map-legend-drag-widget"] = {
    type = "empty_widget_style",
    parent = "draggable_space_header",
    horizontally_stretchable = "on",
    natural_height = 24,
    minimal_width = 24,
}
local row_item_graphical_set = {
    base = {position = {17, 17},  corner_size = 8}
}
styles["map-legend-table"] = {
    type = "table_style",
    parent = "slot_table",
    cell_padding = 10,
    left_padding = 8,
    right_padding = 8,
    apply_row_graphical_set_per_column = false,
    default_row_graphical_set = row_item_graphical_set,
    margin = 0,
}
