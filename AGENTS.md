# RaidLogAuto - Agent Guidelines

This is a World of Warcraft addon that automatically enables combat logging when entering raid instances and disables it when leaving. The addon supports multiple WoW versions: Retail, MoP Classic, TBC Anniversary, Cataclysm Classic, and Classic Era.

---

## Build & Release Commands

### Packaging (using BigWigsMods/packager)
```bash
# No local build needed - GitHub Actions handles packaging
# On tag push, automatically packages for all versions via .github/workflows/release.yml
```

### Running a Single Test (Manual)
Since this is a WoW addon, there are no automated unit tests. Testing is done manually in-game:
1. Load the addon in the appropriate WoW version (Retail/Classic/TBC/Cata)
2. Enter/exit raid instances to verify combat logging toggles
3. Test slash commands: `/rla`, `/rla on`, `/rla off`, `/rla toggle`, `/rla mythic`, `/rla silent`, `/rla help`

---

## Project Structure

```
RaidLogAuto/
├── AGENTS.md                    # This file
├── RaidLogAuto.toc              # TOC file - defines which Lua to load per version
├── RaidLogAuto_Retail.lua       # Retail (Raids + Mythic+)
├── RaidLogAuto_Mists.lua        # MoP Classic (Raids + Mythic+)
├── RaidLogAuto_TBC.lua          # TBC Anniversary (Raids)
├── RaidLogAuto_Cata.lua         # Cataclysm Classic (Raids)
├── RaidLogAuto_Classic.lua      # Classic Era (Raids)
├── RaidLogAuto.lua              # Deprecated - DO NOT EDIT
├── .luacheckrc                  # Luacheck configuration
├── .pkgmeta                     # Packaging metadata
├── .github/workflows/
│   ├── lint.yml                # Luacheck CI on PRs and master
│   ├── release.yml             # Auto-packaging on tag push
│   └── release-please.yml     # Automated versioning and changelog
```

### Version-Specific Files

| File | Interface | Game Version | Features |
|------|-----------|--------------|----------|
| RaidLogAuto_Retail.lua | Interface | Retail | Raids + Mythic+ |
| RaidLogAuto_Mists.lua | Interface-Mists | MoP Classic | Raids + Mythic+ |
| RaidLogAuto_TBC.lua | Interface-BCC | TBC Anniversary | Raids |
| RaidLogAuto_Cata.lua | Interface-Cata | Cataclysm Classic | Raids |
| RaidLogAuto_Classic.lua | Interface-Classic | Classic Era | Raids |

---

## Code Style Guidelines

### General Principles
- **Keep it simple** - This is a small addon (~200 lines), avoid over-engineering
- **Local scope everything** - Use `local` for all variables and functions
- **Cache API functions** - Cache frequently-used global API functions as locals for performance
- **One file per version** - Don't mix version-specific code; use separate files

### Lua Formatting

```lua
-- Use 4 spaces for indentation (no tabs)
-- Maximum line length: 120 characters
-- Use spaces around operators: local x = 1 + 2
-- No trailing whitespace

-- Header comment format:
 -------------------------------------------------------------------------------
 -- FileName
 -- Description of what this file does
 --
 -- Supported versions: Retail, MoP Classic (or relevant versions)
 -------------------------------------------------------------------------------

local ADDON_NAME, _ = ...

-- Constants (uppercase)
local CONSTANT_NAME = "value"

-- Local references for performance (camelCase)
local IsInInstance = IsInInstance
local LoggingCombat = LoggingCombat

-- Color codes (defined once at top)
local COLOR_YELLOW = "|cffffff00"
local COLOR_GREEN = "|cff00ff00"
local COLOR_RED = "|cffff0000"
local COLOR_RESET = "|r"
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | PascalCase | RaidLogAuto_Retail.lua |
| Global variables | PascalCase | RaidLogAutoDB |
| Local variables | camelCase | local currentState |
| Functions | PascalCase | local function UpdateLogging() |
| Constants | UPPER_SNAKE | local DEFAULT_DELAY = 1 |
| Slash commands | UPPER_SNAKE | SLASH_RAIDLOGAUTO1 |

### Functions

```lua
-- Prefer early returns
local function ShouldEnableLogging()
    if not RaidLogAutoDB.enabled then
        return false
    end

    local inInstance, instanceType = IsInInstance()
    if not inInstance then
        return false
    end

    -- Main logic
    return instanceType == "raid"
end
```

### Event Handling

```lua
local frame = CreateFrame("Frame")

local function OnEvent(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        -- Initialize and register other events
        self:UnregisterEvent("ADDON_LOADED")
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Handle event
    end
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("ADDON_LOADED")
```

### Version-Specific Code

**DO NOT** use runtime checks for version-specific features. Instead:

1. **Create separate files** for different versions
2. **Document supported versions** in the file header
3. **Remove unused code** - don't include Mythic+ code in files where it doesn't exist

### Error Handling

- Use `pcall` for risky operations that might fail on some versions
- Provide fallback values for deprecated/removed globals
- Handle nil gracefully with defensive checks

```lua
-- Safe API call with fallback
local currentlyLogging = LoggingCombat and LoggingCombat() or false

-- Defensive nil check
if RaidLogAutoDB and RaidLogAutoDB.printMessages then
    -- Safe to use
end
```

### SavedVariables

```lua
-- Initialize defaults in ADDON_LOADED handler
local defaults = {
    enabled = true,
    raidOnly = true,
    mythicPlus = false,      -- Retail/Mists only
    printMessages = true,
}

-- Merge defaults (preserves existing user values)
for key, value in pairs(defaults) do
    if RaidLogAutoDB[key] == nil then
        RaidLogAutoDB[key] = value
    end
end
```

### Slash Commands

```lua
SLASH_RAIDLOGAUTO1 = "/raidlogauto"
SLASH_RAIDLOGAUTO2 = "/rla"

SlashCmdList["RAIDLOGAUTO"] = function(msg)
    local cmd = msg:lower():trim()
    -- Handle commands
end
```

---

## Common Pitfalls to Avoid

1. **LoggingCombat API** - Available in all versions (modern client)
2. **C_ChallengeMode API** - API exists in all versions, but M+ content only in Retail/MoP Classic
3. **Deprecated globals** - `COMBATLOGENABLED`/`COMBATLOGDISABLED` removed in Cataclysm
4. **Race conditions** - Use C_Timer for delayed operations after PLAYER_ENTERING_WORLD
5. **Timer leaks** - Cancel pending timers before setting new ones
6. **Memory leaks** - Unregister events when no longer needed

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
