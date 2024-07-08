local array = require("__Pacifist__.lib.array")
require("__SpecialResourceMarker__.debug")

-- is this the name of an item that the mod might want to track?
local function _is_mineable_product(product_name, game)
    local item_prototype = game.item_prototypes[product_name]
    return item_prototype and not item_prototype.place_result
end

local function _get_mining_results(prototype, game)
    local product_names = {}
    local products = prototype.mineable_properties.products or {}
    for _, product in pairs(products) do
        if _is_mineable_product(product.name, game) then
            table.insert(product_names, product.name)
        end
    end
    return product_names
end


local Config = {}
Config.new = function()
    return {
        resource_names = {},
        entity_names = {},
        entity_prototypes = {},
    }
end

Config.init = function(config, game)
    local minable_prototypes = game.get_filtered_entity_prototypes({
        { filter = "minable" },
        { filter = "type", type = "resource", mode = "and", invert = true }
    })

    for _, prototype in pairs(minable_prototypes) do
        local mining_results = _get_mining_results(prototype, game)
        if not array.is_empty(mining_results) then
            Config.add_entity_prototype(config, prototype, mining_results)
        end
    end

    log("resources: " .. array.to_string(config.resource_names, "\n"))
    log("entities: " .. array.to_string(config.entity_names, "\n"))
end

Config.add_entity_prototype = function(config, prototype, mining_results)
    local name = prototype.name
    log("results: " .. name .. " -> " .. array.to_string(mining_results, " "))
    config.entity_prototypes[name] = {
        name = name,
        prototype = prototype,
        mining_results = mining_results
    }
    table.insert(config.entity_names, name)
    array.append_unique(config.resource_names, mining_results)
end

Config.get_entity_names = function(config)
    return config.entity_names
end

return Config
