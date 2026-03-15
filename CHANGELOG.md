## [1.2.0] - 2026-03-01

### 🚀 Features

- *(RaidLogAuto)* Add ACL auto-enable and CombatLog.txt reminder (#18)

### 📚 Documentation

- Add issue templates and PR template (#17)

### ⚙️ Miscellaneous Tasks

- Fix release workflow (#15)
## [1.4.2](https://github.com/Xerrion/RaidLogAuto/compare/1.4.1...1.4.2) (2026-03-15)


### Bug Fixes

* correct packager directive end-tags and vanilla filename in TOC ([#33](https://github.com/Xerrion/RaidLogAuto/issues/33)) ([#35](https://github.com/Xerrion/RaidLogAuto/issues/35)) ([fcafaae](https://github.com/Xerrion/RaidLogAuto/commit/fcafaae855eccd2f88b886c5b410c46af2e5b2fd))

## [1.4.1](https://github.com/Xerrion/RaidLogAuto/compare/1.4.0...1.4.1) (2026-03-15)


### Bug Fixes

* inline shared release workflows ([#32](https://github.com/Xerrion/RaidLogAuto/issues/32)) ([d8e5bdd](https://github.com/Xerrion/RaidLogAuto/commit/d8e5bdd9705221851c6e3f6bd429225b748eb097))

## [1.4.0](https://github.com/Xerrion/RaidLogAuto/compare/1.3.0...1.4.0) (2026-03-13)


### Features

* correct versions and loading ([280726b](https://github.com/Xerrion/RaidLogAuto/commit/280726b3ba5641d718de20542922119a08730a87))

## [1.3.0](https://github.com/Xerrion/RaidLogAuto/compare/1.2.0...1.3.0) (2026-03-03)


### Features

* align repo setup with DragonToast ([#19](https://github.com/Xerrion/RaidLogAuto/issues/19), [#20](https://github.com/Xerrion/RaidLogAuto/issues/20), [#21](https://github.com/Xerrion/RaidLogAuto/issues/21), [#22](https://github.com/Xerrion/RaidLogAuto/issues/22)) ([#23](https://github.com/Xerrion/RaidLogAuto/issues/23)) ([56b932b](https://github.com/Xerrion/RaidLogAuto/commit/56b932b1503269033fc982a2d86e79b68672688a))


### Bug Fixes

* add WOW_PROJECT_ID guards to version-specific Lua files ([#26](https://github.com/Xerrion/RaidLogAuto/issues/26)) ([#29](https://github.com/Xerrion/RaidLogAuto/issues/29)) ([4dbb629](https://github.com/Xerrion/RaidLogAuto/commit/4dbb629b0ac0d2103dd800ac487dde378204b16f)), closes [#25](https://github.com/Xerrion/RaidLogAuto/issues/25)

## [1.2.0](https://github.com/Xerrion/RaidLogAuto/compare/1.1.2...1.2.0) (2026-03-01)


### Features

* align repo setup with DragonToast ([#19](https://github.com/Xerrion/RaidLogAuto/issues/19), [#20](https://github.com/Xerrion/RaidLogAuto/issues/20), [#21](https://github.com/Xerrion/RaidLogAuto/issues/21), [#22](https://github.com/Xerrion/RaidLogAuto/issues/22)) ([#23](https://github.com/Xerrion/RaidLogAuto/issues/23)) ([56b932b](https://github.com/Xerrion/RaidLogAuto/commit/56b932b1503269033fc982a2d86e79b68672688a))
* **RaidLogAuto:** add ACL auto-enable and CombatLog.txt reminder ([#18](https://github.com/Xerrion/RaidLogAuto/issues/18)) ([f4b79b1](https://github.com/Xerrion/RaidLogAuto/commit/f4b79b1674ae31fa76060b14b3f800eb7eca7386))

## [1.1.2] - 2026-02-22

### ⚙️ Miscellaneous Tasks

- Combine release-please and packager into single workflow (#11)
- Add workflow_dispatch trigger for manual packaging (#12)
- Update release workflows (#13)
- Release 1.1.2 (#14)
## [1.1.1] - 2026-02-21

### 🐛 Bug Fixes

- Restore tag configuration in release-please config (#9)

### 💼 Other

- Simplify release-please tag configuration (#7)

### ⚙️ Miscellaneous Tasks

- Update release please info (#6)
- Configure changelog sections for release-please (#8)
- *(master)* Release 1.1.1 (#10)
## [1.1.0] - 2026-02-21

### 🚀 Features

- Split addon into version-specific files for multi-version support

### 🐛 Bug Fixes

- Remove unused variables in RaidLogAuto_Main.lua
- Remove unused variables in RaidLogAuto_Legacy.lua
- Remove unused variables in RaidLogAuto_Classic.lua

### 🚜 Refactor

- Split addon into version-specific files (#5)

### 📚 Documentation

- Modernize README with badges, emojis, and visual improvements

### ⚙️ Miscellaneous Tasks

- Add Release Please for automated versioning and changelog
- Add luacheck linting workflow
- Add luacheck configuration
- Remove redundant release-type from workflow
- *(master)* Release 1.1.0 (#4)
