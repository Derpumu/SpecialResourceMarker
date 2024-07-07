local Chunk = {
    surface = nil,

    new = function(self, o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end,

    chart_special_resources = function(self, area, resource_names)
        -- TODO: avoid recharting unchanged areas (requires listening for entity destroyed events)
        log("charting area...")
        -- determine special resources in chunk
        local special_entities = self.surface.find_entities_filtered{area=area, name = resource_names}
        -- add/update markers
    end
}

return Chunk

