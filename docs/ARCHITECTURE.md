# Inspection and support boundaries — 2026-10-17

Primary sources inspected locally:
- https://github.com/EllesmereGaming/EllesmereUI/blob/main/PLUGINS_API.md
- upstream main: `2e23e868593762c256ee84823851c1a280640cd4` (9.5.5)
- https://github.com/EllesmereGaming/EllesmereUI/pull/1831 head:
  `881b8f8e9be689c8c0f1ee4b7b8099b0c1496ca2`
- https://github.com/EllesmereGaming/EllesmereUI/pull/1847 head:
  `2f7a650928092aec70225287707f72fc11e5f68b`
- Recovered four uploaded 9.5.4 files from cached conversation attachments.

API v1 documents settings registration, not an ActionBars extension interface.
It requires a separate section and prohibits hooking/replacing EUI functions and
relying on underscore internals. RegisterPlugin/OpenPlugin are the only EUI calls
used here. WidgetFactory signatures were checked against current source. Page
builders create no frames/events/previews themselves; they tolerate nil widget
objects during search prebuild. Reset replaces only our database.

## Assisted Highlight

EUI Glows.lua owns custom highlights on its EABButton frames, which are removed
from Blizzard's ActionBarButtonEventsFrame candidate list. Blizzard manager
callbacks alone do not provide a documented enumeration of these EUI buttons or
exclusive renderer ownership. Registering another callback cannot safely remove
EUI's painter. Suppressing its textures/frames would mutate implementation details.
The PR uses shared EUI glow engines and a private button data wrapper, not a
public extension contract. Its style set includes Pixel Glow, Action Button Glow,
Auto-Cast Shine, Shape Glow, GCD, Modern WoW Glow, Classic WoW Glow; these are NOT
ported here. No shared engine code/assets were copied. Independent preview
composition is implemented; live rendering is deliberately refused.

Blizzard manager OnAssistedHighlightSpellChange / OnSetUseAssistedHighlight and
ActionButton.OnActionChanged are candidate event signals, not EUI ownership APIs.
Future integration needs lifecycle subscription/unsubscription, authoritative public
button/action enumeration, base/override resolution and explicit single-owner
highlight delegation, including secure combat and secret-value contracts.

## Advanced Fade

9.5.4 and current core hold local _fadeAlpha, a shared fade queue, FadeTo/StopFade,
and cap-layer twins. Visibility/ExtraBars writers and hover state share ownership.
The PR reaches BAR_LOOKUP, barFrames, dataBarFrames, extraBarHolders,
_gridState, _dragState, _quickKeybindState, spellbook-forced state and profile data.
There is no documented API exporting these as a stable extension surface.
Post-hook SetAlpha would compete with interpolation and cached alpha, miss twins,
and fail to implement Visibility/show-all semantics. Reparenting protected buttons,
installing secure drivers or discovering named frames would not solve ownership.
None is attempted.

Future minimum public contract: enumerate stable bar ids/capabilities; opt-in
exclusive alpha ownership and reversible release; cancel native transitions;
provide visibility, show-all/grid/drag/spellbook/keybind/unlock state notifications;
atomic alpha/twin updates; lifecycle events for rebuilds/profiles/paging; secure
combat and secret-value restrictions. EUI remains the authority for hiding frames.
Data, bag/micro, vehicle, pet, stance, queue/status and extra bars need independent
capability declarations; unsupported bars must be rejected, never guessed.

## Modules

Defaults: schema validation / independent copies. Compatibility: explicit blocked
capability and secret gates. AssistedHighlight: plain spell comparator and owned
preview painter. AdvancedFade: pure OR/precedence evaluator and owned animation.
Options: separate API section. Core: load/save, slash commands and explicit preview.
No public adapter registration is offered until an upstream ownership contract
exists. Next stage: propose that contract to upstream for review, or retain the
existing PRs for users needing full functionality. No PR/comment was sent.
