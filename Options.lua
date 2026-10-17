local _, A = ...
function A.RegisterOptions()
    if not EllesmereUI or not EllesmereUI.RegisterPlugin then
        A.status = "Plugin API unavailable: update EllesmereUI"; return
    end
    local function build(page, parent, offset)
        local W, y = EllesmereUI.Widgets, offset
        local _, h = W:SectionHeader(parent, "DEVELOPMENT: PREVIEW ONLY - LIVE EUI BLOCKED", y); y = y - h
        local function toggle(label, t, key)
            local _, height = W:Toggle(parent, label, y, function() return t[key] end,
                function(v) t[key] = v; A.RefreshPreview() end); y = y - height
        end
        local function slider(label, t, key, lo, hi, step)
            local _, height = W:Slider(parent, label, y, lo, hi, step,
                function() return t[key] end, function(v)
                    t[key] = v
                    if t.minimum and t.maximum < t.minimum then t.maximum = t.minimum end
                    A.RefreshPreview()
                end); y = y - height
        end
        if page == "Assisted Highlight" then
            local s = A.db.assisted
            toggle("Enable highlight preview (EUI bars unsupported)", s, "enabled")
            toggle("Use class color", s, "classColor")
            local _, height = W:Dropdown(parent, "Preview composition", y,
                {ring="Border", overlay="Overlay", both="Border and overlay"},
                function() return s.style end, function(v) s.style=v; A.RefreshPreview() end)
            y = y - height
            _, height = W:ColorPicker(parent, "Custom color", y,
                function() return s.color.r, s.color.g, s.color.b end,
                function(r,g,b) s.color={r=r,g=g,b=b}; A.RefreshPreview() end, false)
            y = y - height
            slider("Overlay opacity", s, "opacity", 0, 1, 0.05)
        else
            local s = A.db.fade
            toggle("Enable fade preview (EUI bars unsupported)", s, "enabled")
            slider("Resting opacity", s, "minimum", 0, 1, 0.05)
            slider("Maximum opacity", s, "maximum", 0, 1, 0.05)
            slider("Fade in seconds", s, "fadeIn", 0, 5, 0.05)
            slider("Fade out seconds", s, "fadeOut", 0, 5, 0.05)
            for _, key in ipairs(A.conditions) do toggle("OR: " .. key, s.conditions, key) end
        end
        return math.abs(y)
    end
    A.registered = EllesmereUI.RegisterPlugin("LlustyActionBarsExtensions", {
        label="Action Bars Enhancements", modules={{key="Settings",title="Development Settings",
        description="Use /abe preview to test addon-owned frames. Live EUI integration is blocked.",
        pages={"Assisted Highlight", "Advanced Fade"}, buildPage=build,
        onReset=function() A.db=A.Copy(A.defaults); A.Save(); A.RefreshPreview() end}}
    })
end
