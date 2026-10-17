local _, A = ...
A.defaults = {
    schema = 1,
    assisted = { enabled = false, style = "ring", classColor = false,
        color = { r = 0.15, g = 0.5, b = 1 }, opacity = 0.3 },
    fade = { enabled = false, minimum = 0, maximum = 1, fadeIn = 0.2,
        fadeOut = 0.4, conditions = {}, bars = {} },
}
function A.Copy(value)
    if type(value) ~= "table" then return value end
    local result = {}
    for k, v in pairs(value) do result[k] = A.Copy(v) end
    return result
end
local function number(value, fallback, low, high)
    if type(value) ~= "number" or value ~= value then return fallback end
    return math.max(low, math.min(high, value))
end
function A.LoadDB(saved)
    -- A newer schema is preserved, never downgraded or rewritten.
    if type(saved) == "table" and type(saved.schema) == "number" and saved.schema > 1 then
        return A.Copy(A.defaults), "Newer saved schema: read-only defaults for this session"
    end
    local d = A.Copy(A.defaults)
    if type(saved) ~= "table" then return d end
    for _, key in ipairs({"assisted", "fade"}) do
        if type(saved[key]) == "table" then
            for k in pairs(d[key]) do
                if type(saved[key][k]) == type(d[key][k]) then d[key][k] = A.Copy(saved[key][k]) end
            end
        end
    end
    d.assisted.color = {
        r = number(d.assisted.color.r, 0.15, 0, 1),
        g = number(d.assisted.color.g, 0.5, 0, 1),
        b = number(d.assisted.color.b, 1, 0, 1),
    }
    if not ({ring=true, overlay=true, both=true})[d.assisted.style] then d.assisted.style = "ring" end
    d.assisted.opacity = number(d.assisted.opacity, 0.3, 0, 1)
    for _, k in ipairs({"minimum", "maximum"}) do d.fade[k] = number(d.fade[k], A.defaults.fade[k], 0, 1) end
    d.fade.maximum = math.max(d.fade.minimum, d.fade.maximum)
    for _, k in ipairs({"fadeIn", "fadeOut"}) do d.fade[k] = number(d.fade[k], A.defaults.fade[k], 0, 5) end
    local conditions = {}
    for _, k in ipairs({"combat","party","raid","instance","mounted","flying","target","enemy_target","mouseover"}) do
        conditions[k] = d.fade.conditions[k] == true
    end
    d.fade.conditions = conditions
    return d
end
