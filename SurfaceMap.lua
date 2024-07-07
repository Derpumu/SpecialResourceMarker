local Chunk = require("__SpecialResourceMarker__.Chunk")
require("__SpecialResourceMarker__.debug")

local function _get_chunk_xy(chunk_position)
    local x = chunk_position.x ~= nil and chunk_position.x or chunk_position[1]
    local y = chunk_position.y ~= nil and chunk_position.y or chunk_position[2]
    return x, y
end

local function _get_chunk(sm, chunk_position)
    local x, y = _get_chunk_xy(chunk_position)
    sm.chunks[x] = sm.chunks[x] or {}
    sm.chunks[x][y] = sm.chunks[x][y] or Chunk:new { surface = sm.surface, config = sm.config }
    return sm.chunks[x][y]
end


local SurfaceMap = {}

SurfaceMap.new = function(o)
    assert(o.surface)
    assert(o.config)
    o.chunks = {}
    return o
end

SurfaceMap.chart_special_resources = function(sm, chunk_position, area)
    local chunk = _get_chunk(sm, chunk_position)
    chunk:chart_special_resources(area, {})
end

SurfaceMap.delete_chunk = function(sm, chunk_position)
    local x, y = _get_chunk_xy(chunk_position)
    if sm.chunks[x] then sm.chunks[x][y] = nil end
end

return SurfaceMap

