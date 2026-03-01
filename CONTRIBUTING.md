# Contributing to RaidLogAuto

Thank you for your interest in contributing to **RaidLogAuto** - an addon that automatically enables combat logging in raid instances for World of Warcraft! This guide will help you get started.

## How to Contribute

### Reporting Bugs
- Use the [bug report template](https://github.com/Xerrion/RaidLogAuto/issues/new?template=bug-report.yml)
- Include your WoW version, RaidLogAuto version, and steps to reproduce

### Suggesting Features
- Use the [feature request template](https://github.com/Xerrion/RaidLogAuto/issues/new?template=feature-request.yml)
- Explain the problem your feature would solve

### Contributing Code
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Prerequisites

- World of Warcraft client (Retail, TBC Anniversary, MoP Classic, Cata, or Classic)
- [Lua 5.1](https://www.lua.org/) (for linting)
- [Luacheck](https://github.com/mpeterv/luacheck) (for static analysis)
- [Git](https://git-scm.com/)

## Development Setup

1. **Fork and clone** the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/RaidLogAuto.git
   cd RaidLogAuto
   ```

2. **Symlink** the addon into your WoW AddOns folder:
   ```bash
   # Windows (PowerShell as Admin)
   New-Item -ItemType SymbolicLink -Path "$env:PROGRAMFILES\World of Warcraft\_retail_\Interface\AddOns\RaidLogAuto" -Target "$(Get-Location)"
   ```

3. **Reload** in-game with `/reload`

## Code Style

### Formatting
- Indent with **4 spaces** (no tabs)
- No trailing whitespace

### File Header
Every Lua file should start with:
```lua
-------------------------------------------------------------------------------
-- FileName.lua
-- Brief description
--
-- Supported versions: Retail, MoP Classic, TBC Anniversary, Cata, Classic
-------------------------------------------------------------------------------
```

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | PascalCase | `RaidLogAuto_Retail.lua` |
| SavedVariables | PascalCase | `RaidLogAutoDB` |
| Local variables | camelCase | `local isLogging` |
| Functions | PascalCase | `local function ToggleLogging()` |
| Constants | UPPER_SNAKE | `local MAX_RETRIES = 5` |

### Error Handling
- Use defensive nil checks for optional APIs
- Use `pcall` for APIs that may be missing in some versions
- Prefer `or` fallbacks over runtime version checks

## Linting

Run luacheck before submitting changes:

```bash
luacheck .
luacheck path/to/File.lua    # single file for fast feedback
```

## Testing

RaidLogAuto does not have automated tests. Manual testing checklist:

1. Load the addon in the target game version
2. Test slash commands: `/rla status`, `/rla mythic`, `/rla toggle`
3. Enter and exit a raid instance to verify auto-logging
4. Enable Lua errors: `/console scriptErrors 1`
5. Verify no errors in the error frame

## Submitting Changes

1. **Branch** from `master`:
   ```bash
   git checkout -b feat/your-feature-name
   ```

2. **Commit** using [Conventional Commits](https://www.conventionalcommits.org/):
   ```bash
   git commit --no-gpg-sign -m "feat: add mythic+ logging support (#42)"
   ```

3. **Push** your branch and open a PR against `master`

4. **Fill out** the PR template and wait for CI checks

### Branch Naming

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feat/` | New feature | `feat/19-release-please` |
| `fix/` | Bug fix | `fix/20-logging-error` |
| `docs/` | Documentation | `docs/update-readme` |
| `refactor/` | Code improvement | `refactor/21-core-cleanup` |

## What Happens After Your PR

1. **CI** runs luacheck automatically
2. **Review** by a maintainer
3. **Squash merge** into `master`
4. **Release-please** creates a release PR when ready

Thank you for contributing to RaidLogAuto!
