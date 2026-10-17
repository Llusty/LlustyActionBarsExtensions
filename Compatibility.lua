local _, A = ...
A.Compatibility = {}
function A.Compatibility.Status()
    return false, "EUI ActionBars has no documented ownership/target API. Live modules are blocked; preview only."
end
function A.Public(value)
    -- Never compare, index, stringify, or do arithmetic on secret values.
    if issecretvalue and issecretvalue(value) then return nil end
    return value
end
function A.Boolean(value)
    value = A.Public(value)
    return value == true
end
-- Intentionally no EABButton globals, AceAddon lookup, private namespace,
-- SavedVariables reads, frame scanning, hooks or native glow suppression.
