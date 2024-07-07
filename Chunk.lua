require("__SpecialResourceMarker__.debug")
local Config = require("__SpecialResourceMarker__.Config")

local function _check_chunk(chunk)
    assert(chunk.surface)
    assert(chunk.config)
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
    -- determine special resources in chunk
    local entity_names = Config.get_entity_names(chunk.config)
    local special_entities = chunk.surface.find_entities_filtered { area = area, name = entity_names }
    log("charting area " .. dump_table(area) .. ", found " .. #special_entities .. " entities (" .. dump_table(entity_names) ..")")
    -- add/update markers
end

return Chunk

