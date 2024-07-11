local Chunk = require("__SpecialResourceMarker__.Chunk")
local Markers = require("__SpecialResourceMarker__.Markers")

local function _check_map(map)
    assert(map.surface)
    assert(map.config)
    assert(map.chunks)
    assert(map.markers)
end

local function _get_chunk_xy(chunk_position)
    local x = chunk_position.x ~= nil and chunk_position.x or chunk_position[1]
    local y = chunk_position.y ~= nil and chunk_position.y or chunk_position[2]
    return x, y
end

local function _get_chunk(map, chunk_position)
    _check_map(map)
    local x, y = _get_chunk_xy(chunk_position)
    map.chunks[x] = map.chunks[x] or {}
    map.chunks[x][y] = map.chunks[x][y] or Chunk.new{ surface = map.surface, config = map.config, markers = map.markers }
    return map.chunks[x][y]
end

local SurfaceMap = {}

SurfaceMap.new = function(o)
    assert(o.surface)
    assert(o.config)
    o.markers = o.markers or Markers.new{surface = o.surface}
    o.chunks = {}
    return o
end

SurfaceMap.chart_special_resources = function(map, chunk_position, area, force)
    _check_map(map)
    local chunk = _get_chunk(map, chunk_position)
    Chunk.chart_special_resources(chunk, area, force)
end

SurfaceMap.delete_chunk = function(map, chunk_position)
    _check_map(map)
    local x, y = _get_chunk_xy(chunk_position)
    if map.chunks[x] then map.chunks[x][y] = nil end
end

return SurfaceMap

