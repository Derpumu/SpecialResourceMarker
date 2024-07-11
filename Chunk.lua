require("__SpecialResourceMarker__.debug")
local Config = require("__SpecialResourceMarker__.Config")
local Markers = require("__SpecialResourceMarker__.Markers")

local function _check_chunk(chunk)
    assert(chunk.surface)
    assert(chunk.config)
    assert(chunk.markers)
end

local function _reduce_entities(special_entities)
    -- return array[position, prototype, name]
    local reduced_entities = {}
    for _, entity in pairs(special_entities) do
        table.insert(reduced_entities, { position = entity.position, prototype = entity.prototype, name = entity.name })
    end
    return reduced_entities
end

local Chunk = {}

Chunk.new = function(o)
    _check_chunk(o)
    return o
end

Chunk.chart_special_resources = function(chunk, area, force)
    _check_chunk(chunk)

    -- TODO: avoid recharting unchanged areas (requires listening for entity destroyed events)

    local entity_names = Config.get_entity_names(chunk.config)
    local special_entities = chunk.surface.find_entities_filtered { area = area, name = entity_names }
    local reduced_entities = _reduce_entities(special_entities)

    for _, entity in pairs(special_entities) do
        local resources =  Config.get_special_resources_for_entity(chunk.config, entity.name)
        Markers.add_or_update(chunk.markers, force, entity.position, resources);
    end
end

return Chunk

