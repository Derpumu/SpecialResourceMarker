local Chunk = require("__SpecialResourceMarker__.Chunk")
require("__SpecialResourceMarker__.debug")

local function get_chunk_xy(chunk_position)
    local x = chunk_position.x ~= nil and chunk_position.x or chunk_position[1]
    local y = chunk_position.y ~= nil and chunk_position.y or chunk_position[2]
    return x, y
end

local SurfaceMap = {
    chunks = {},
    surface = nil,

    new = function(self, o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end,

    chart_special_resources = function(self, chunk_position, area)
        local chunk = self:_get_chunk(chunk_position)
        chunk:chart_special_resources(area, {})
    end,

    delete_chunk = function(self, chunk_position)
        local x, y = get_chunk_xy(chunk_position)
        if self.chunks[x] then self.chunks[x][y] = nil end
    end,

    _get_chunk = function(self, chunk_position)
        local x, y = get_chunk_xy(chunk_position)
        self.chunks[x] = self.chunks[x] or {}
        self.chunks[x][y] = self.chunks[x][y] or Chunk:new{surface=self.surface}
        return self.chunks[x][y]
    end,
}

return SurfaceMap

