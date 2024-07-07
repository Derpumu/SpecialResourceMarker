require("__SpecialResourceMarker__.debug")
local SurfaceMap = require("__SpecialResourceMarker__.SurfaceMap")
local Config = require("__SpecialResourceMarker__.Config")


local function on_chunk_charted(event)
    -- Called when a chunk is charted or re-charted, i.e. "seen" by players or radars

	local surface_index = event.surface_index
	local chunk_position = event.position
	local area = event.area
	-- local force = event.force

	local surface_map = global.surface_map[surface_index]
	SurfaceMap.chart_special_resources(surface_map, chunk_position, area)
end

local function on_chunk_deleted(event)
    -- Called when one or more chunks are deleted
    -- possible alternative_ on_pre_chunk_deleted, called before the chunks are deleted
	local surface_index = event.surface_index
    local chunk_positions = event.positions	-- array[ChunkPosition]
	local surface_map = global.surface_map[surface_index]
	for _, chunk_position in pairs(chunk_positions) do
		SurfaceMap.delete_chunk(surface_map, chunk_position)
	end
end

local function _add_surface_map(surface_id)
	global.surface_map[surface_id] = SurfaceMap.new{
		surface = game.get_surface(surface_id),
		config = global.config
	}
end

local function on_surface_created(event)
	_add_surface_map(event.surface_index)
end

local function on_surface_deleted(event)
    -- on_surface_deleted -> remove from global data
	global.surface_map[event.surface_index] = nil
end

--local function on_entity_destroyed(event)
--    -- check if entity was in global data collection and remove/modify markers
--    -- on_entity_died -> does this get called on minables? Possibly for entities with special loot, if we ever want that feature
--end

local function init_global()
	-- initialize global data
	global.config = global.config or {}
	global.surface_map = global.surface_map or {}
	if not global.surface_map[1] then _add_surface_map(1) end -- no event raised for nauvis
end

function on_init()
	-- called once when the mod is added to a save (new game or later)
	init_global()
end

function on_configuration_changed(configuration_changed_data)
	-- called when mod startup settings have changed, mods have been added or removed, or mod/game version have changed etc.
	init_global() -- in case we load an older save that does not have the same data

-- go through prototypes to scan for special resources and the entities that drop them
-- check if those lists differ from the ones in the save and
--     update mappings and preferences table
--     rescan and tag chunks
end

script.on_init(on_init)
script.on_configuration_changed(on_configuration_changed)

script.on_event({defines.events.on_chunk_charted}, on_chunk_charted)
script.on_event({defines.events.on_chunk_deleted}, on_chunk_deleted)
script.on_event({defines.events.on_surface_created}, on_surface_created)
script.on_event({defines.events.on_surface_deleted}, on_surface_deleted)
