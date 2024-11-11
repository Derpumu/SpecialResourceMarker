local array = require("__SpecialResourceMarker__.lib.array")

local function _get_xy(position)
    local x = position.x ~= nil and position.x or position[1]
    local y = position.y ~= nil and position.y or position[2]
    return x, y
end

local function _get_chunk(surface_map, chunk_position)
    local x, y = _get_xy(chunk_position)
    surface_map.chunks = surface_map.chunks or {}
    surface_map.chunks[x] = surface_map.chunks[x] or {}
    surface_map.chunks[x][y] = surface_map.chunks[x][y] or { charted = {} }
    return surface_map.chunks[x][y]
end

local function _get_special_product(entity)
    local mineable_properties = entity.prototype.mineable_properties
    if not mineable_properties.minable then return nil end

    for _, product in pairs(mineable_properties.products) do
        if product.name and not array.contains(storage.ignored_resources, product.name)
        then
            return product
        end
    end

    return nil
end

local function _create_tag_spec(position, name, product)
    local signalID = {
        type = product.type,
        name = product.name,
    }

    local text = name
    return { position = position, icon = signalID, text = text }
end

local function _add_marker(force, surface, position, name, product)
    local delta=5
    local surrounding_area = { { position.x - delta, position.y - delta }, { position.x + delta, position.y + delta } }
    local existing_tags = force.find_chart_tags(surface, surrounding_area)
    if existing_tags and not array.is_empty(existing_tags) then
        return
    end

    local tag_spec = _create_tag_spec(position, name, product)
    force.add_chart_tag(surface, tag_spec)
end

local function _check_and_chart_entity(force, entity)
    if not entity.minable then return end

    local special_product = _get_special_product(entity)
    if special_product then
        _add_marker(force, entity.surface, entity.position, entity.name, special_product)
    end
end

local function _chart_special_entities(surface_index, chunk_position, area, force)
    local surface_map = storage.surface_map[surface_index]
    local chunk = _get_chunk(surface_map, chunk_position)
    if chunk.charted[force] then return end

    local surface = game.get_surface(surface_index)
    if not surface then return end
    local entities = surface.find_entities_filtered { area = area, type = {"tree", "simple-entity"} }

    for _, entity in pairs(entities) do
        _check_and_chart_entity(force, entity)
    end

    chunk.charted[force] = true
end

local function on_chunk_charted(event)
    -- Called when a chunk is charted or re-charted, i.e. "seen" by players or radars

    local surface_index = event.surface_index
    local chunk_position = event.position
    local area = event.area
    local force = event.force

    _chart_special_entities(surface_index, chunk_position, area, force)
end

local function _add_surface_map(surface_id)
    storage.surface_map[surface_id] = {}
end

local function on_surface_created(event)
    _add_surface_map(event.surface_index)
end

local function on_surface_deleted(event)
    -- on_surface_deleted -> remove from storage data
    storage.surface_map[event.surface_index] = nil
end

local function init_storage()
    storage.ignored_resources = { "wood", "stone" }
    if settings.global["srm-ignore-coal"].value then
        log("ignoring coal")
        table.insert(storage.ignored_resources, "coal")
    end

    storage.surface_map = storage.surface_map or {}
    for _, surface in pairs(game.surfaces) do
        if not storage.surface_map[surface.index] then _add_surface_map(surface.index) end
        for chunk in surface.get_chunks() do
            for _, force in pairs(game.forces) do
                if force.is_chunk_charted(surface, chunk) then
                    _chart_special_entities(surface.index, chunk, chunk.area, force)
                end
            end
        end
    end
end

function on_init()
    -- called once when the mod is added to a save (new game or later)
    init_storage()
end

function on_configuration_changed(configuration_changed_data)
    -- called when mod startup settings have changed, mods have been added or removed, or mod/game version have changed etc.
    init_storage() -- in case we load an older save that does not have the same data
end

script.on_init(on_init)
script.on_configuration_changed(on_configuration_changed)

script.on_event({ defines.events.on_chunk_charted }, on_chunk_charted)
script.on_event({ defines.events.on_surface_created }, on_surface_created)
script.on_event({ defines.events.on_surface_deleted }, on_surface_deleted)
