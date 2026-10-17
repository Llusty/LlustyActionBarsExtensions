# Action Bars Enhancements

**0.1.0-dev — preview prototype, NOT a replacement for PR #1831/#1847 yet.**
Folder / addon / Plugin API id: `LlustyActionBarsExtensions`.

Independent addon with six Lua modules, own versioned SavedVariables and its own
EllesmereUI Plugin API section. No upstream files need copying or editing.
Both features default OFF. **Neither feature currently controls EUI bars.**
The settings explicitly say preview only. `/abe status` explains the block.

## Install and try

Copy this folder into `World of Warcraft/_retail_/Interface/AddOns/`, next to
EllesmereUI and EllesmereUIActionBars. Enable all three. `/abe` opens the separate
settings section. `/abe preview` toggles an addon-owned demonstration rectangle.
Enable the desired preview settings there. Move the mouse across it to test
mouseover fade. `/abe simulate combat on`, `/abe simulate combat off`,
`/abe simulate visible off`, `/abe simulate visible on`, and
`/abe simulate showAll on` inject synthetic states. All nine condition names in
the options can be simulated. These commands do not read game state or alter EUI.

Implemented: independent border/overlay/both preview with custom/class color;
OR condition evaluator; resting/maximum opacity; fade-in/out via animation groups;
Visibility precedence then show-all; own persisted settings with validation and
future-schema protection. No Lua OnUpdate, hooks, timers, or recurring polling.
After loading with previews closed, the loader unregisters all events/scripts.
Closing preview stops its animation. A preview opened explicitly has mouse scripts.

Not implemented: live spell suggestion tracking; EUI frame ownership; suppression
of native highlights; base/override spell and macro resolution; PR animated glow
engines; actual combat/target/mount/skyriding events; per-bar options, data/extra
bars, profiles, native show-all/grid/drag/unlock integration. `fade.bars` reserves a
schema slot only and is not an operational feature. The border is a simple custom
border, NOT a claim of parity with Blizzard ring or the seven PR glow styles.

## Safety and compatibility

Dependencies enforce loading after both EUI components. Version/interface list is
copied from inspected EUI retail target metadata; it is not a tested-client claim.
Plugin API absence produces a status message; no fallback into internal APIs.
No EUI SavedVariables, private namespace, named EABButton frame discovery, globals
scan, function replacement, hooks, secure attributes, CVars or state drivers.
No claims of in-game taint safety until manual testing; live frame access is refused.
Secret values are rejected before comparison. Restricted suggestion IDs yield no
match; a future adapter must not infer secret values through side channels.

A newer SavedVariables schema is left intact and session edits are not persisted.
No EUI profile sync or implicit migration from either PR. Preferences use a separate
account-wide SavedVariables table; synthetic preview state is not saved.

## Validation / release gate

Run from this directory: `python3 tests/static.py` and `lua tests/run.lua`.
See [inspection](docs/ARCHITECTURE.md), [manual test plan](docs/IN_GAME_TESTS.md),
and [validation evidence](docs/VALIDATION.md). No stable tag or GitHub release is
permitted before the user reports manual in-game PASS. Passing this prototype's
manual tests alone does not establish live feature parity.
