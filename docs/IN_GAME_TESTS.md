# Manual in-game test plan

All items are **NOT RUN**. Record client build, EUI version, addon commit, actual
result and Lua/taint log for each. Do not label an untested scenario PASS.

1. Install beside unmodified EUI. New SavedVariables: both features OFF. Reload,
   open EUI: separate Action Bars Enhancements section, no update popup/errors.
2. Open both pages, search for Maximum opacity before visiting them, leave/return,
   reset settings. No preview appears from opening/searching. `/abe status`
   reports live integration blocked; no controls imply live support.
3. Set border / overlay / both; custom RGB / class color; opacity 0/1. Explicitly
   open preview. Check appearance, close/reopen it. Real EUI highlights unchanged.
4. Enable preview fade: min .2, max .8, in .2s, out .4s. Select mouseover and combat.
   Hover plus `/abe simulate combat on/off`: either true reaches .8, neither .2.
   Exercise rapid reversals and durations 0/5; no snap at animation end.
5. Simulate every condition individually; target and enemy_target independently;
   party versus raid are independent injected states, not game detection.
6. `visible off` wins even with `showAll on`; visible on + showAll on reaches 1.
   Toggle showAll off. No actual protected frame is hidden/shown by this addon.
7. Change settings, reload/relog: preferences persist, preview stays closed.
   Reset then reload. On a backed-up test database inject malformed values and
   future schema: no Lua error, future database unchanged after reload.
8. With previews closed and features off, inspect event/hook/CPU tools: no addon
   OnUpdate, recurring timer, installed hooks or active runtime event handlers.
9. Combat, instance/M+, secrets, page/form/vehicle/pet swaps, action dragging,
   EUI show-all/unlock/keybinding modes and profiles: no effects from this addon on
   native bars, no new blocked-action messages/taint errors. This is isolation
   testing, NOT validation of live highlight/fade support.
10. Disable/re-enable addon and reload. Compare EUI behavior and settings. Test
    alongside each existing PR separately; no duplicate glow created by addon.

Live feature tests remain BLOCKED pending public integration: recommendations,
macros/overrides, no duplicate glows, secure combat behavior, native Visibility,
show-all, all main/data/extra bars, flyouts and profile/rebuild durability. They
must be designed and run after integration; preview simulation cannot pass them.

Do not publish a stable release until user manual PASS and resolution or explicit
scope acceptance of all remaining live-feature blockers.
