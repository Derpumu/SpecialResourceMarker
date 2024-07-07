local Chunk = {
    surface = nil,
    config = nil,

    new = function(self, o)
        assert(o.surface)
        assert(o.config)
        setmetatable(o, self)
        self.__index = self
        return o
    end,

    chart_special_resources = function(self, area)
        -- TODO: avoid recharting unchanged areas (requires listening for entity destroyed events)
        log("charting area...")
        -- determine special resources in chunk
        local special_entities = self.surface.find_entities_filtered { area = area, name = self.config.get_entity_names() }

        -- add/update markers
    end
}

Chunk.__index = Chunk

return Chunk

