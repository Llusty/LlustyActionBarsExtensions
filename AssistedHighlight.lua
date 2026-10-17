local _, A = ...
A.AssistedHighlight = {}
function A.AssistedHighlight.Match(suggested, buttonSpell)
    suggested, buttonSpell = A.Public(suggested), A.Public(buttonSpell)
    if type(suggested) ~= "number" or type(buttonSpell) ~= "number" then return false end
    return suggested > 0 and suggested == buttonSpell
end
function A.AssistedHighlight.Paint(host, settings)
    -- Only addon-owned preview hosts can be painted.
    assert(host == A.preview, "External frames require a documented ownership API")
    local color = settings.color
    if settings.classColor and UnitClass and RAID_CLASS_COLORS then
        local _, class = UnitClass("player")
        color = RAID_CLASS_COLORS[class] or color
    end
    local r, g, b = color.r, color.g, color.b
    host.fill:SetColorTexture(r, g, b, settings.opacity)
    host.fill:SetShown(settings.enabled and settings.style ~= "ring")
    for _, edge in ipairs(host.edges) do
        edge:SetColorTexture(r, g, b, 1)
        edge:SetShown(settings.enabled and settings.style ~= "overlay")
    end
end
