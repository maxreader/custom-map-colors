require("code.entities-and-paths")
require("code.fancy-trees")
require("code.map-tiles-code")

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
    }
})