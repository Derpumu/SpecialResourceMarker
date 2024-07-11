require("__SpecialResourceMarker__.debug")

local function _get_xy(position)
    local x = position.x ~= nil and position.x or position[1]
    local y = position.y ~= nil and position.y or position[2]
    return x, y
end

local function _check_markers(markers)
    assert(markers.surface)
    assert(markers.tags)
end



-- TODO: find correct signal ID and text for resources
local function _create_taginfo(resources)
	local signalID = {
		type="virtual",
		name="signal-dot",
	}

    local text = "resources!"
    return signalID, text
end

local Markers = {}

Markers.new = function(o)
    assert(o.surface)
    o.tags = o.tags or {}
    return o
end

Markers.add_or_update = function(markers, force, position, resources)
    _check_markers(markers)
    local force_id = force.index
    local signalID, text = _create_taginfo(resources)
    local x, y = _get_xy(position)

    markers.tags[force_id] = markers.tags[force_id] or {}
    markers.tags[force_id][x] = markers.tags[force_id][x] or {}
    local tag = markers.tags[force_id][x][y]

    if tag then
        tag.icon = signalID
        tag.text = text
    else
    	local tagData = {
	    	position = position,
		    text = text,
		    icon = signalID,
	    }
        markers.tags[force_id][x][y] = force.add_chart_tag(markers.surface,tagData)
    end
end

return Markers