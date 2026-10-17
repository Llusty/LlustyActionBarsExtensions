local name, A = ...
A.conditions = {"combat","party","raid","instance","mounted","flying","target","enemy_target","mouseover"}
function A.Save()
    if not A.schemaWarning then LlustyActionBarsExtensionsDB = A.db end
end
function A.RefreshPreview()
    A.Save()
    if not A.preview or not A.preview:IsShown() then return end
    A.AssistedHighlight.Paint(A.preview, A.db.assisted)
    A.AdvancedFade.Apply(A.preview, A.db.fade, A.previewState)
end
function A.TogglePreview()
    if A.preview then
        if A.preview:IsShown() then A.preview.animation:Stop(); A.preview:Hide()
        else A.preview:Show(); A.RefreshPreview() end
        return
    end
    local f = CreateFrame("Frame", nil, UIParent)
    A.preview = f
    f:SetSize(240, 64); f:SetPoint("CENTER"); f:EnableMouse(true)
    local background = f:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(); background:SetColorTexture(0.08,0.08,0.08,1)
    f.fill = f:CreateTexture(nil,"ARTWORK"); f.fill:SetAllPoints()
    f.edges = {}
    for i=1,4 do
        local e=f:CreateTexture(nil,"OVERLAY"); f.edges[i]=e
        if i<3 then e:SetSize(240,2); e:SetPoint(i==1 and "TOP" or "BOTTOM")
        else e:SetSize(2,64); e:SetPoint(i==3 and "LEFT" or "RIGHT") end
    end
    local label=f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    label:SetPoint("CENTER"); label:SetText("ABE preview - /abe preview to close")
    f.animation=f:CreateAnimationGroup()
    f.alphaAnimation=f.animation:CreateAnimation("Alpha")
    f.animation:SetScript("OnFinished",function() f:SetAlpha(f.target) end)
    A.previewState={visible=true}
    f:SetScript("OnEnter",function() A.previewState.mouseover=true; A.RefreshPreview() end)
    f:SetScript("OnLeave",function() A.previewState.mouseover=false; A.RefreshPreview() end)
    A.RefreshPreview()
end
local loader=CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent",function(self, _, loaded)
    if loaded ~= name then return end
    self:UnregisterAllEvents(); self:SetScript("OnEvent",nil)
    A.db,A.schemaWarning=A.LoadDB(LlustyActionBarsExtensionsDB)
    A.Save()
    local _, reason=A.Compatibility.Status(); A.status=reason
    A.RegisterOptions()
end)
SLASH_LLUSTYACTIONBARSEXTENSIONS1="/abe"
SlashCmdList.LLUSTYACTIONBARSEXTENSIONS=function(message)
    if message == "preview" then A.TogglePreview()
    elseif message:match("^simulate ") then
        if not A.preview then A.TogglePreview() end
        local key, value=message:match("^simulate (%w+_?%w*) (%w+)$")
        local valid={visible=true,showAll=true}
        for _, condition in ipairs(A.conditions) do valid[condition]=true end
        if valid[key] and (value=="on" or value=="off") then
            A.previewState[key]=value=="on"; A.RefreshPreview()
        else print("/abe simulate <condition|visible|showAll> <on|off>") end
    elseif message == "status" then print(A.status); if A.schemaWarning then print(A.schemaWarning) end
    elseif EllesmereUI and EllesmereUI.OpenPlugin then EllesmereUI.OpenPlugin(name) end
end
