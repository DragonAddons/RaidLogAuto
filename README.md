<div align="center">

<img src="https://raw.githubusercontent.com/Xerrion/RaidLogAuto/master/icon.png" alt="RaidLogAuto" width="128" />

# RaidLogAuto

**Automatically enable combat logging in raids & Mythic+ - so you never forget again.**

[![Latest Release](https://img.shields.io/github/v/release/Xerrion/RaidLogAuto?style=for-the-badge&logo=github&label=Latest%20Release)](https://github.com/Xerrion/RaidLogAuto/releases/latest)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![WoW Versions](https://img.shields.io/badge/WoW-Retail%20%7C%20Classic-blue?style=for-the-badge&logo=battledotnet)](https://worldofwarcraft.blizzard.com/)
[![Build](https://img.shields.io/github/actions/workflow/status/Xerrion/RaidLogAuto/release.yml?style=for-the-badge&logo=github&label=Build)](https://github.com/Xerrion/RaidLogAuto/actions)
[![CurseForge Downloads](https://img.shields.io/curseforge/dt/1457114?style=for-the-badge&logo=curseforge&label=CurseForge)](https://www.curseforge.com/wow/addons/raidlogauto)
[![Wago Downloads](https://img.shields.io/badge/Wago-rN4kWyGD-C1272D?style=for-the-badge&logo=wago)](https://addons.wago.io/addons/raidlogauto)

</div>

---

RaidLogAuto automatically toggles the combat log when you enter or leave raid, dungeon, and Mythic+ content, so you
never end a session with a missing or empty WoWCombatLog.txt.

## ✨ Features

- 🔄 **Automatic Logging** - Auto-enables combat log on raid/dungeon/M+ entry, auto-disables on exit
- ⏱️ **Grace Period** - 5-second grace period after Mythic+ completion to capture final logs
- ⚔️ **Granular Toggles** - Per-content-type toggles: raid, dungeon, and Mythic+
- 📊 **ACL Auto-Enable** - Optional Advanced Combat Logging auto-enable for detailed parse data
- 🔔 **One-Time Reminder** - Popup reminder about ACL settings and CombatLog.txt cleanup
- 🌍 **Multi-Version** - Supports Retail, MoP Classic, TBC Anniversary, and Classic Era
- 🪶 **Zero Dependencies** - Lightweight footprint with zero external library dependencies (no Ace3, no LibStub)
- 💾 **Account-Wide** - Settings persist across characters via SavedVariables

---

## 🔧 How It Works

```
 ┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
 │  Enter Raid  │ ──────▶ │  Combat Logging  │ ──────▶ │  Leave Raid  │
 │  or Mythic+  │         │    ENABLED ✅     │         │  or Mythic+  │
 └──────────────┘         └──────────────────┘         └──────┬───────┘
                                                              │
                                                              ▼
                                                   ┌──────────────────┐
                                                   │  Combat Logging  │
                                                   │   DISABLED ❌     │
                                                   └──────────────────┘
```

RaidLogAuto monitors instance transitions and Mythic+ lifecycle events. When you enter a supported instance type,
the addon ensures combat logging is active. To prevent truncated logs in Mythic+, the addon waits for a 5-second
grace period after `CHALLENGE_MODE_COMPLETED` before disabling the log.

---

## 🎮 Supported Versions

| Client | Interface | Listener File |
|:---|:---|:---|
| Retail | 120005, 120001, 120000 | `RaidLogAuto_Retail.lua` |
| MoP Classic | 50502, 50503 | `RaidLogAuto_Mists.lua` |
| TBC Anniversary | 20505 | `RaidLogAuto_BCC.lua` |
| Classic Era | 11508, 11507 | `RaidLogAuto_Vanilla.lua` |

---

## 📋 Events Handled

| Event | Purpose |
|:---|:---|
| `ADDON_LOADED` | Initialize SavedVariables and apply defaults |
| `PLAYER_ENTERING_WORLD` | Re-evaluate context after login or zone change |
| `ZONE_CHANGED_NEW_AREA` | Toggle log when crossing into raid/dungeon boundaries |
| `CHALLENGE_MODE_START` | Force-enable log for Mythic+ runs |
| `CHALLENGE_MODE_COMPLETED` | Schedule 5-second delayed disable to capture final events |

---

## 📦 Installation

### Download

<div align="center">

[![CurseForge](https://img.shields.io/badge/CurseForge-Download-F16436?style=for-the-badge&logo=curseforge)](https://www.curseforge.com/wow/addons/raidlogauto)
[![Wago](https://img.shields.io/badge/Wago-Download-C1272D?style=for-the-badge&logo=wago)](https://addons.wago.io/addons/raidlogauto)
[![GitHub](https://img.shields.io/badge/GitHub-Releases-181717?style=for-the-badge&logo=github)](https://github.com/Xerrion/RaidLogAuto/releases/latest)

</div>

### Manual Install

1. Download the latest release from one of the sources above.
2. Extract the `RaidLogAuto` folder into your AddOns directory:
   - `World of Warcraft/_retail_/Interface/AddOns/RaidLogAuto/`
3. Restart WoW or type `/reload`.

---

## ⌨️ Slash Commands

All commands use the `/rla` prefix (or the full `/raidlogauto`):

| Command | Description |
|:---|:---|
| `/rla` | Show current status and settings |
| `/rla on` | Enable the addon |
| `/rla off` | Disable the addon |
| `/rla toggle` | Toggle addon status on/off |
| `/rla mythic` | Toggle Mythic+ logging (Retail/MoP only) |
| `/rla silent` | Toggle chat notifications (Silent Mode) |
| `/rla acl` | Manually check or enable Advanced Combat Logging |
| `/rla help` | Show help commands |

---

<details>
<summary><h2>⚙️ Configuration</h2></summary>

Settings are stored in the `RaidLogAutoDB` SavedVariable and are **account-wide**.

| Variable | Default | Description |
|:---|:---|:---|
| `enabled` | `true` | Master toggle - enable or disable the addon |
| `raidOnly` | `true` | Only log in raid instances |
| `mythicPlus` | `false` | Log Mythic+ dungeons (Retail/MoP only) |
| `printMessages` | `true` | Show status messages in chat |
| `combatLogReminderDismissed` | `false` | Tracks if the one-time cleanup reminder was dismissed |

</details>

<details>
<summary><h2>📁 Combat Log Location</h2></summary>

After a session, your combat log is saved to:

| OS | Path |
|:---|:---|
| Windows | `World of Warcraft\_retail_\Logs\WoWCombatLog.txt` |
| macOS | `/Applications/World of Warcraft/_retail_/Logs/WoWCombatLog.txt` |

Replace `_retail_` with the appropriate folder for your game version (e.g., `_classic_era_`, `_classic_`).

</details>

---

## 🤝 Contributing

Contributions are welcome! Please refer to [AGENTS.md](AGENTS.md) and [CONTRIBUTING.md](CONTRIBUTING.md) for
development guidelines, including the use of `luacheck`.

1. Fork the repository
2. Create your feature branch (`git checkout -b feat/my-feature`)
3. Commit your changes (`git commit -m 'feat: add my feature'`)
4. Push to the branch (`git push origin feat/my-feature`)
5. Open a Pull Request

---

<div align="center">

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

---

Made with ❤️ for the WoW community by [Xerrion](https://github.com/Xerrion)

</div>
