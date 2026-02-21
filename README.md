<div align="center">

<img src="https://raw.githubusercontent.com/Xerrion/RaidLogAuto/master/icon.png" alt="RaidLogAuto" width="128" />

# RaidLogAuto

**Automatically enable combat logging in raids & Mythic+ — so you never forget again.**

[![Latest Release](https://img.shields.io/github/v/release/Xerrion/RaidLogAuto?style=for-the-badge&logo=github&label=Latest%20Release)](https://github.com/Xerrion/RaidLogAuto/releases/latest)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![WoW Versions](https://img.shields.io/badge/WoW-Retail%20%7C%20Classic-blue?style=for-the-badge&logo=battledotnet)](https://worldofwarcraft.blizzard.com/)
[![Build](https://img.shields.io/github/actions/workflow/status/Xerrion/RaidLogAuto/release.yml?style=for-the-badge&logo=github&label=Build)](https://github.com/Xerrion/RaidLogAuto/actions)
[![CurseForge Downloads](https://img.shields.io/curseforge/dt/1457114?style=for-the-badge&logo=curseforge&label=CurseForge)](https://www.curseforge.com/wow/addons/raidlogauto)

</div>

---

## ✨ Features

- 🔄 **Automatic Combat Logging** — Starts recording when you enter a raid, stops when you leave
- ⚔️ **Mythic+ Support** — Optionally log Mythic+ dungeons (Retail & MoP Classic)
- 🌍 **Multi-Version** — Works across Retail, MoP Classic, Cataclysm Classic, TBC Anniversary, Classic Era, and Wrath Classic
- 🪶 **Lightweight** — Minimal memory footprint, zero performance impact
- 🔇 **Silent Mode** — Toggle chat notifications on or off
- ⚡ **Zero Config** — Install and forget — it just works

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

RaidLogAuto listens for instance changes. When you zone into a raid (or a Mythic+ dungeon, if enabled), it automatically calls `/combatlog` for you. When you leave, it turns logging off — keeping your log files clean and your uploads hassle-free.

---

## 🎮 Supported Versions

| Version | Lua File | Features |
|:--------|:---------|:---------|
| **Retail** | `RaidLogAuto_Main.lua` | Raid logging + Mythic+ |
| **MoP Classic** | `RaidLogAuto_Main.lua` | Raid logging + Mythic+ |
| **Cataclysm Classic** | `RaidLogAuto_Legacy.lua` | Raid logging |
| **TBC Anniversary** | `RaidLogAuto_Legacy.lua` | Raid logging |
| **Classic Era** | `RaidLogAuto_Classic.lua` | Raid logging (limited) |
| **Wrath Classic** | `RaidLogAuto_Classic.lua` | Raid logging (limited) |

---

## 📦 Installation

### Download

<div align="center">

[![CurseForge](https://img.shields.io/badge/CurseForge-Download-F16436?style=for-the-badge&logo=curseforge)](https://www.curseforge.com/wow/addons/raidlogauto)
[![Wago](https://img.shields.io/badge/Wago-Download-C1272D?style=for-the-badge&logo=wago)](https://addons.wago.io/addons/raidlogauto)
[![GitHub](https://img.shields.io/badge/GitHub-Releases-181717?style=for-the-badge&logo=github)](https://github.com/Xerrion/RaidLogAuto/releases/latest)

</div>

### Manual Install

1. Download the latest release from one of the sources above
2. Extract the `RaidLogAuto` folder into your AddOns directory:
   ```
   World of Warcraft/_retail_/Interface/AddOns/RaidLogAuto/
   ```
3. Restart WoW or type `/reload`

> **Tip:** Use an addon manager like [CurseForge App](https://www.curseforge.com/download/app) or [WowUp](https://wowup.io/) for automatic updates.

---

## ⌨️ Commands

All commands use the `/rla` prefix (or the full `/raidlogauto`):

| Command | Description |
|:--------|:------------|
| `/rla` | Show current status |
| `/rla on` | Enable auto-logging |
| `/rla off` | Disable auto-logging |
| `/rla toggle` | Toggle on/off |
| `/rla mythic` | Toggle Mythic+ logging *(Retail & MoP Classic only)* |
| `/rla silent` | Toggle chat notifications |
| `/rla help` | Show help |

---

<details>
<summary><h2>⚙️ Configuration</h2></summary>

Settings are stored in the `RaidLogAutoDB` SavedVariable and persist per-character.

| Variable | Default | Description |
|:---------|:--------|:------------|
| `enabled` | `true` | Master toggle — enable or disable the addon |
| `mythicPlus` | `false` | Log Mythic+ dungeons *(Retail & MoP Classic only)* |
| `printMessages` | `true` | Show status messages in chat |

All settings can be changed via the [slash commands](#%EF%B8%8F-commands) above.

</details>

<details>
<summary><h2>📁 Combat Log Location</h2></summary>

After a raid, your combat log is saved to:

| OS | Path |
|:---|:-----|
| **Windows** | `World of Warcraft\_retail_\Logs\WoWCombatLog.txt` |
| **macOS** | `/Applications/World of Warcraft/_retail_/Logs/WoWCombatLog.txt` |

> Replace `_retail_` with the appropriate folder for your game version (e.g. `_classic_era_`, `_classic_`).

Upload your logs to [Warcraft Logs](https://www.warcraftlogs.com/) for detailed analysis! 📊

</details>

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an [issue](https://github.com/Xerrion/RaidLogAuto/issues) or submit a [pull request](https://github.com/Xerrion/RaidLogAuto/pulls).

1. Fork the repository
2. Create your feature branch (`git checkout -b feat/my-feature`)
3. Commit your changes (`git commit -m 'feat: add my feature'`)
4. Push to the branch (`git push origin feat/my-feature`)
5. Open a Pull Request

---

<div align="center">

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

---

Made with ❤️ for the WoW community by [Xerrion](https://github.com/Xerrion)

</div>
