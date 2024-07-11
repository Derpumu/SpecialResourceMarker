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

local _abundant_resources = {
    "raw-fish",
    "wood",
    "stone"
}

local function _is_special_item(item_name)
    return not array.contains(_abundant_resources, item_name)
end



local Config = {}
Config.new = function(o)
    o = o or {}
    o.resource_names = {}
    o.tracked_entity_names = {}
    o.entity_prototypes = {}
    return o
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
    log("entities: " .. array.to_string(config.tracked_entity_names, "\n"))
end

Config.add_entity_prototype = function(config, prototype, mining_results)
    local name = prototype.name
    log("results: " .. name .. " -> " .. array.to_string(mining_results, " "))
    local track_entities = array.any_of(mining_results, _is_special_item)
    config.entity_prototypes[name] = {
        name = name,
        prototype = prototype,
        mining_results = mining_results,
        track = track_entities
    }
    if track_entities then
        table.insert(config.tracked_entity_names, name)
    end
    array.append_unique(config.resource_names, mining_results)
end

Config.get_entity_names = function(config)
    return config.tracked_entity_names
end

Config.get_special_resources_for_entity = function(config, prototype_name)
    local mining_results = config.entity_prototypes[prototype_name].mining_results
    local special_resources = {}
    for _, special_result in ipairs(config.tracked_entity_names) do
        if array.contains(mining_results, special_result) then
            table.insert(special_resources, special_result)
        end
    end
    return special_resources
end

return Config
