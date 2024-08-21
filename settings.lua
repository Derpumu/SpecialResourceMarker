data:extend({
    {
        type = "bool-setting",
        name = "srm-ignore-coal",
        setting_type = "runtime-global",
        default_value = false
    }
})

-- alien biomes has so many huge rocks giving coal that we don't want them cluttering our map
if mods["alien-biomes"] then
    data.raw["bool-setting"]["srm-ignore-coal"].default_value = true
end