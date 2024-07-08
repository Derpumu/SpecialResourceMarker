local Config = {}


Config.new = function()
    return {
        resource_names = { "coal", "stone" },
        entity_names = { "rock-huge", "rock-big" },
        entity_prototypes = {}, -- TODO: find prototypes
    }
end

Config.get_entity_names = function(cfg)
    return cfg.entity_names
end

return Config
