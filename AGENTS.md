# RaidLogAuto - Agent Guidelines

## CI/CD

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| `lint.yml` | `pull_request_target` to `master` | Runs Luacheck |
| `release.yml` | Push to `master` | release-please creates/updates a Release PR; dispatches `packager.yml` on release |
| `packager.yml` | `workflow_dispatch` (from release.yml) | Builds and publishes via BigWigsMods packager |

---

## Version-Specific Files

| File | Interface | Game Version | Features |
|------|-----------|--------------|----------|
| RaidLogAuto_Retail.lua | Interface | Retail | Raids + Mythic+ |
| RaidLogAuto_Mists.lua | Interface-Mists | MoP Classic | Raids + Mythic+ |
| RaidLogAuto_TBC.lua | Interface-BCC | TBC Anniversary | Raids |
| RaidLogAuto_Cata.lua | Interface-Cata | Cataclysm Classic | Raids |
| RaidLogAuto_Classic.lua | Interface-Classic | Classic Era | Raids |

---

## Key WoW API Functions Used

| Function | Availability | Purpose |
|----------|--------------|---------|
| `IsInInstance()` | All versions | Check if player is in instance |
| `IsInRaid()` | All versions | Check if player is in raid |
| `LoggingCombat([bool])` | All versions | Get/set combat logging state |
| `C_ChallengeMode.GetActiveChallengeMapID()` | All versions (content in Retail/MoP only) | Get active M+ map ID |
| `C_Timer.After(seconds, func)` | All versions | Delayed function execution |
| `CreateFrame("Frame")` | All versions | Create event frame |

---

## RaidLogAuto-Specific Patterns

### Namespace

Unlike all other addons in this workspace, RaidLogAuto discards the shared namespace:

```lua
local ADDON_NAME, _ = ...
```

There is no `ns` table. Each version-specific file is fully self-contained.

### SavedVariables Defaults Merge

RaidLogAuto does not use AceDB. Defaults are merged manually in the `ADDON_LOADED` handler:

```lua
local defaults = {
    enabled = true,
    raidOnly = true,
    mythicPlus = false,      -- Retail/Mists only
    printMessages = true,
}

for key, value in pairs(defaults) do
    if RaidLogAutoDB[key] == nil then
        RaidLogAutoDB[key] = value
    end
end
```

---

## Known Gotchas

- `RaidLogAuto.lua` is **deprecated** and excluded from packaging - do not edit it
- Missing APIs for a target version - check `docs/` for the exact client build
- Deprecated globals like `COMBATLOGENABLED` and `COMBATLOGDISABLED` (removed in Cata; always provide `or` fallbacks)
- Race conditions on `PLAYER_ENTERING_WORLD` - use a short `C_Timer.After` delay
- Timer leaks - cancel `C_Timer` or `AceTimer` handles before reusing
