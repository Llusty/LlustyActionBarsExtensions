# Validation evidence — 2026-10-17

PASS (local, Lua 5.5.1; NOT WoW's Lua runtime):
- luac syntax checks on all six runtime modules.
- 22 headless assertions: defaults opt-in, deep copies, malformed data, clamps,
  future schema, OR rules, Visibility/show-all precedence, secret rejection,
  plain spell matching, external frame refusal, load guard, own Plugin API
  registration, search-prebuild nil widget returns and idle event/script teardown.
- Static scan for hooks, per-frame scripts, timers, EUI DB/secure attribute access.
- TOC dependencies, saved variable name and module list.
- Clean upstream inspection checkout (`git status --porcelain` empty).
- Read-only fork branch snapshots before/after were identical:
  main adb030a725f4cff03cc6b2a2b1cbefcd03a33a63;
  highlight 881b8f8e9be689c8c0f1ee4b7b8099b0c1496ca2;
  fade 2f7a650928092aec70225287707f72fc11e5f68b.

NOT RUN: WoW loading, actual Plugin API registration, widget display, animation
rendering/interruption, taint/combat/restricted instance testing, SavedVariables
serialization/relog, CPU measurements, actual client compatibility.
BLOCKED: live EUI highlight/fade parity and data/extra bar support.

Retrieved 9.5.4 attachment SHA256:
- EUI_ActionBars_Glows.lua:
  92f5c455be57880ec0d40755cd2b15fcff18a565539f5d71c07023f5fe1ff136
- EllesmereUIActionBars(20261013-211221).lua:
  5d9196dd6f42d6736c4f0652093c33b896e4f227e3283c60f6579905b1baa624
- AnimationsPage_Options.lua:
  5c0c39b923ee5eebe16fbde4e47094573d5f15ed43d15053d620b8689ed82d89
- BarVisibilityLayout_Options.lua:
  13016fc700d0f48c0f47c3c49942ef696bc7f1f2161e0f1b518c9b318c20e988

Only the independent addon is committed. Source inspection files are outside its
repository. Neither EUI TOC nor Lua source was edited. No stable release/tag.
