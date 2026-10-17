local _, A = ...
A.AdvancedFade = {}
function A.AdvancedFade.Target(settings, state)
    -- All inputs from any future live adapter MUST be plain public values.
    -- Visibility is authoritative, including when show-all is requested.
    if not A.Boolean(state.visible) then return 0 end
    if A.Boolean(state.showAll) then return 1 end
    if not settings.enabled then return 1 end
    for key, selected in pairs(settings.conditions) do
        if selected == true and A.Boolean(state[key]) then return settings.maximum end
    end
    return settings.minimum
end
function A.AdvancedFade.Apply(host, settings, state)
    assert(host == A.preview, "External frames require a documented ownership API")
    local target = A.AdvancedFade.Target(settings, state)
    if host.target == target then return end
    local from = host:GetAlpha()
    host.animation:Stop()
    host.target = target
    local duration = target > from and settings.fadeIn or settings.fadeOut
    if duration == 0 or from == target then host:SetAlpha(target); return end
    host.alphaAnimation:SetFromAlpha(from)
    host.alphaAnimation:SetToAlpha(target)
    host.alphaAnimation:SetDuration(duration)
    host.animation:Play()
end
