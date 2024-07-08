require("__SpecialResourceMarker__.debug")
local Config = require("__SpecialResourceMarker__.Config")

local function _check_chunk(chunk)
    assert(chunk.surface)
    assert(chunk.config)
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
    assert(o.surface)
    assert(o.config)
    return o
end

Chunk.chart_special_resources = function(chunk, area)
    _check_chunk(chunk)
    -- TODO: avoid recharting unchanged areas (requires listening for entity destroyed events)
    -- determine entities with special resources in chunk
    local entity_names = Config.get_entity_names(chunk.config)
    local special_entities = chunk.surface.find_entities_filtered { area = area, name = entity_names }
    local reduced_entities = _reduce_entities(special_entities)
    log("charting area for entities. found " .. #reduced_entities .. " entities")
    -- TODO: add/update markers
end

return Chunk

