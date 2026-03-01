# RaidLogAuto - Agent Guidelines

World of Warcraft addon that automatically enables combat logging in raid instances and disables it on exit. Supports Retail, MoP Classic, TBC Anniversary, Cataclysm Classic, and Classic Era.

## Build, Lint, and Release

There is no local build step. GitHub Actions handles everything:

- **Lint** (`.github/workflows/lint.yml`) - Runs `luacheck --no-color` on PRs to master via `nebularg/actions-luacheck`.
- **Release PR** (`.github/workflows/release-pr.yml`) - On master push, generates a changelog with git-cliff and opens/updates an `autorelease` PR.
- **Release** (`.github/workflows/release.yml`) - On tag push (or merged autorelease PR), packages with `BigWigsMods/packager@v2` and uploads to CurseForge, Wago, and GitHub.

### Running Luacheck Locally

```bash
luacheck .
```

Configuration is in `.luacheckrc` (Lua 5.1 std, no max line length, excludes deprecated `RaidLogAuto.lua`).

### Manual Testing

There are no automated tests. Test in-game:

1. Load the addon in the target WoW version
2. Enter and exit a raid instance, verify combat logging toggles on/off
3. (Retail/MoP only) Start and finish a Mythic+ key with `/rla mythic` enabled
4. Test slash commands: `/rla`, `/rla on`, `/rla off`, `/rla toggle`, `/rla mythic`, `/rla silent`, `/rla help`
5. Check `/rla status` output matches expected SavedVariable state

#### Advanced Combat Logging Auto-Enable

1. Disable ACL in WoW settings: `/console advancedCombatLogging 0`
2. Enter a raid instance - verify chat message: "Advanced Combat Logging was disabled. Automatically enabled it for you."
3. Verify ACL is now enabled: `/rla status` should show "Advanced Combat Logging: ON"
4. Enter another raid - verify NO duplicate ACL message (it is already on)

#### CombatLog.txt Reminder Dialog

1. Reset the reminder: `/run RaidLogAutoDB.combatLogReminderDismissed = false; ReloadUI()`
2. Enter a raid instance - verify a StaticPopup dialog appears warning about CombatLog.txt
3. Click "OK, Got It" - verify dialog dismisses
4. Leave and re-enter the raid - verify the dialog does NOT reappear
5. `/reload` and re-enter - verify dialog still does NOT reappear (persisted)

#### /rla acl Command

1. `/rla acl` with ACL enabled - shows "Advanced Combat Logging: ON"
2. `/console advancedCombatLogging 0` then `/rla acl` - should auto-enable and confirm

## Project Structure

```
RaidLogAuto/
  RaidLogAuto.toc              # TOC - maps Interface versions to Lua files
  RaidLogAuto_Retail.lua       # Retail (Raids + Mythic+)
  RaidLogAuto_Mists.lua        # MoP Classic (Raids + Mythic+)
  RaidLogAuto_TBC.lua          # TBC Anniversary (Raids only)
  RaidLogAuto_Cata.lua         # Cataclysm Classic (Raids only)
  RaidLogAuto_Classic.lua      # Classic Era (Raids only)
  RaidLogAuto.lua              # DEPRECATED - do not edit or load
  .luacheckrc                  # Luacheck config
  .pkgmeta                     # BigWigsMods packager metadata
  cliff.toml                   # git-cliff changelog config
  .github/workflows/
    lint.yml                   # Luacheck CI
    release-pr.yml             # Auto release PR via git-cliff
    release.yml                # Tag-based packaging and upload
```

Each game version loads exactly one Lua file via the TOC `Interface-*` directives. One file per version; never mix version-specific code across files.

## Code Style

### General Rules

- Keep it simple. Each file is roughly 160-200 lines. Avoid over-engineering.
- Use `local` for all variables and functions. Only globals: `RaidLogAutoDB` (SavedVariable) and slash command registrations.
- Cache frequently-used WoW API globals as local references at the top of the file.
- Keep functions under 50 lines. Extract helpers when longer.
- Prefer early returns over deeply nested conditionals.
- Plain Lua 5.1; no type annotations, LuaLS, or EmmyLua comments.

### File Layout (every version file follows this order)

```lua
 -------------------------------------------------------------------------------
-- FileName (without .lua)
-- Brief description. Version: <Game Version>. Features: <feature list>
 -------------------------------------------------------------------------------
local ADDON_NAME, _ = ...
-- 1. SavedVariables init and defaults table
-- 2. Local API caching (IsInInstance, LoggingCombat, print)
-- 3. Localized strings table (L)
-- 4. Color constants (COLOR_YELLOW, COLOR_GREEN, COLOR_RED, COLOR_RESET)
-- 5. Helper functions (Print, ShouldEnableLogging, UpdateLogging)
-- 6. Event handler frame and OnEvent
-- 7. Slash command registration and handler
```

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | PascalCase with underscore suffix | `RaidLogAuto_Retail.lua` |
| Global variables | PascalCase | `RaidLogAutoDB` |
| Local variables | camelCase | `local shouldLog` |
| Local functions | PascalCase | `local function UpdateLogging()` |
| Constants | UPPER_SNAKE_CASE | `local COLOR_GREEN = ...` |
| Slash commands | UPPER_SNAKE_CASE | `SLASH_RAIDLOGAUTO1` |

### Local API Caching

Cache WoW globals used more than once, placed right after the defaults table:
`local IsInInstance = IsInInstance; local LoggingCombat = LoggingCombat; local print = print`

### Localized Strings

Use a local `L` table with `or` fallbacks for globals that may not exist in all versions. `COMBATLOGENABLED`/`COMBATLOGDISABLED` were removed in Cataclysm, so always provide a fallback string.

```lua
local L = {
    ENABLED = COMBATLOGENABLED or "Combat logging enabled.",
    DISABLED = COMBATLOGDISABLED or "Combat logging disabled.",
    ADDON_LOADED = "RaidLogAuto loaded. Type /rla for options.",
}
```

### SavedVariables

Initialize `RaidLogAutoDB` with a defaults merge in the `ADDON_LOADED` handler to preserve existing user values while adding new keys. Only Retail and Mists files include `mythicPlus = false` in defaults.

```lua
RaidLogAutoDB = RaidLogAutoDB or {}
local defaults = { enabled = true, raidOnly = true, printMessages = true }
for key, value in pairs(defaults) do
    if RaidLogAutoDB[key] == nil then RaidLogAutoDB[key] = value end
end
```

### Event Handling

Register `ADDON_LOADED` first, then remaining events after initialization. Unregister `ADDON_LOADED` immediately after use. Use `C_Timer.After(1, UpdateLogging)` on `PLAYER_ENTERING_WORLD` to handle the race condition where instance info is not yet available.

### Error Handling

- Guard API calls that may be nil: `if C_ChallengeMode and C_ChallengeMode.GetActiveChallengeMapID then`
- Use `or` fallbacks for globals that may not exist (see Localized Strings)
- No `pcall` is used; defensive nil checks are sufficient

## Version-Specific Rules

Do NOT use runtime version checks. The TOC routes each game version to the correct Lua file. If a feature only exists in certain versions (e.g. Mythic+), include the code only in those files.

| Feature | Retail | Mists | TBC | Cata | Classic |
|---------|--------|-------|-----|------|---------|
| Raid logging | Yes | Yes | Yes | Yes | Yes |
| Mythic+ logging | Yes | Yes | No | No | No |
| CHALLENGE_MODE events | Yes | Yes | No | No | No |

## Common Pitfalls

1. `COMBATLOGENABLED`/`COMBATLOGDISABLED` removed in Cata; always provide `or` fallbacks
2. `C_ChallengeMode` API exists in all clients but M+ only runs on Retail and MoP Classic
3. `PLAYER_ENTERING_WORLD` fires before instance info is ready; use `C_Timer.After` delay
4. Cancel or guard against redundant timers to avoid duplicate log toggles
5. Unregister events you no longer need (e.g. `ADDON_LOADED` after init)

## Repository Constraints

- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` files exist. All agent guidance lives in this file.
- Do not add new dependencies without discussing trade-offs first
- Do not edit `RaidLogAuto.lua`; it is deprecated and excluded from packaging
- Prefer ripgrep (`rg`) over `grep` when searching the codebase
- Keep changes minimal and focused; this is a small, stable addon
