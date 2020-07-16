script.on_configuration_changed(function(data)
    if data.mod_startup_settings_changed or data.mod_changes ~=nil then
        game.forces.player.rechart()
    end
end
)