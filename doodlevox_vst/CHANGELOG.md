# Changelog

All notable changes to the DoodleVox VST plugin are documented here.
GitHub Releases are generated automatically from commit and PR history.

---

## [0.1.1] — 2026-05-27
- Windows: Add support for custom audio formats
- Windows: Set NSIS `MODIFY_PATH` to `ON` so the install directory is added to PATH

## [0.1.0] — 2026-03-31
- Disable standalone installation on macOS to avoid conflicts with existing plugin installs

## [0.0.9] — 2026-03-27
- Fix installer path resolution on macOS (second attempt)

## [0.0.8] — 2026-03-27
- Fix installer path resolution on macOS

## [0.0.7] — 2026-03-26
- Test installer release build workflow

## [0.0.6] — 2026-03-26
- Add automated GitHub Actions release workflow
- Add `package.sh` installer build script (CPack-based)
- Add license text and license info in README

## [0.0.3] — 2026-03-25
- Basic MVP complete
- QR code generation for pairing with the mobile app
- Centralized style data via `Theme.h`
