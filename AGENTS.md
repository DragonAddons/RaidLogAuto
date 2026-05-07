# RaidLogAuto AGENTS.md

Deviates from workspace conventions: no Ace3, no shared `ns`, no AceDB.

## Version-Specific Files

| File | TOC Directive | Game Version |
|------|---------------|--------------|
| `RaidLogAuto_Retail.lua` | `## Interface` | Retail (raids + Mythic+) |
| `RaidLogAuto_Mists.lua` | `## Interface-Mists` | MoP Classic (raids + Mythic+) |
| `RaidLogAuto_TBC.lua` | `## Interface-BCC` | TBC Anniversary (raids) |
| `RaidLogAuto_Cata.lua` | `## Interface-Cata` | Cataclysm Classic (raids) |
| `RaidLogAuto_Classic.lua` | `## Interface-Classic` | Classic Era (raids) |

## Namespace Pattern

Use `local ADDON_NAME, _ = ...` - the shared `ns` table is intentionally discarded. Each version-specific file is fully self-contained; do not factor logic into a shared module.

## SavedVariables Defaults Merge

No AceDB. Defaults are merged manually in the `ADDON_LOADED` handler:

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

## Known Gotchas

- `RaidLogAuto.lua` is **deprecated** and excluded from packaging - do not edit it.
