local A, checks = {}, 0
local function check(value, message) checks=checks+1; assert(value,message) end
for _,f in ipairs({'Defaults','Compatibility','AssistedHighlight','AdvancedFade'}) do
    assert(loadfile(f..'.lua'))('LlustyActionBarsExtensions',A)
end
local db=A.LoadDB(nil)
check(not db.assisted.enabled and not db.fade.enabled,'opt-in')
local second=A.LoadDB(nil); db.assisted.color.r=1
check(second.assisted.color.r==0.15,'independent defaults')
local malformed=A.LoadDB({fade={minimum=4,maximum=-1,fadeIn=0/0,conditions={combat='true'}},assisted={color={r='x'},style='bad'}})
check(malformed.fade.minimum==1 and malformed.fade.maximum==1,'clamp and order')
check(malformed.fade.fadeIn==0.2 and not malformed.fade.conditions.combat,'sanitize')
check(malformed.assisted.color.r==0.15 and malformed.assisted.style=='ring','malformed color')
local future={schema=999}; local _,warning=A.LoadDB(future)
check(warning and future.schema==999,'future schema preserved')
local s=second.fade; s.enabled=true; s.minimum=0.2; s.maximum=0.8
s.conditions={combat=true,mouseover=true}
check(A.AdvancedFade.Target(s,{visible=true})==0.2,'rest')
check(A.AdvancedFade.Target(s,{visible=true,combat=true})==0.8,'combat OR')
check(A.AdvancedFade.Target(s,{visible=true,mouseover=true})==0.8,'hover OR')
check(A.AdvancedFade.Target(s,{visible=false,showAll=true,combat=true})==0,'visibility precedence')
check(A.AdvancedFade.Target(s,{visible=true,showAll=true})==1,'show-all')
local secret=setmetatable({},{__eq=function() error('secret compared') end,__tostring=function() error('secret printed') end})
issecretvalue=function(v) return rawequal(v,secret) end
check(not A.AssistedHighlight.Match(secret,1),'secret spell rejected')
check(A.AdvancedFade.Target(s,{visible=true,combat=secret})==0.2,'secret condition rejected')
check(A.AssistedHighlight.Match(123,123) and not A.AssistedHighlight.Match(nil,123),'spell match')
check(not A.Compatibility.Status(),'EUI fails closed')
check(not pcall(A.AdvancedFade.Apply,{},s,{}),'external frame refused')
local frames={}
CreateFrame=function()
 local f={events={},scripts={}}
 function f:RegisterEvent(e) self.events[e]=true end
 function f:UnregisterAllEvents() self.events={} end
 function f:SetScript(k,v) self.scripts[k]=v end
 frames[#frames+1]=f; return f
end
SlashCmdList={}
local spec
local W={}
for _,method in ipairs({'SectionHeader','Toggle','Slider','Dropdown','ColorPicker'}) do
 W[method]=function() return nil,50 end
end
EllesmereUI={Widgets=W,RegisterPlugin=function(id,v) spec=v; return true end,OpenPlugin=function()end}
assert(loadfile('Options.lua'))('LlustyActionBarsExtensions',A)
assert(loadfile('Core.lua'))('LlustyActionBarsExtensions',A)
frames[1].scripts.OnEvent(frames[1],'ADDON_LOADED','OtherAddon')
check(not A.db,'load guard')
frames[1].scripts.OnEvent(frames[1],'ADDON_LOADED','LlustyActionBarsExtensions')
check(#frames==1 and not next(frames[1].events) and not next(frames[1].scripts),'idle no events or scripts')
check(spec and #spec.modules==1,'own plugin section')
for _,page in ipairs(spec.modules[1].pages) do check(spec.modules[1].buildPage(page,{},-10)>0,'search prebuild nil widgets') end
check(#frames==1 and not A.preview,'options do not create live frames')
print('PASS: '..checks..' headless assertions (not an in-game PASS)')
