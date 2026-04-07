# DoodleVox (Mobile)

Mobile companion app for the free DoodleVox VST plugin.

How music producers take notes. Capture vocal ideas instantly without breaking creative flow, then send them straight to your DAW over a local network.

## Information

This project was built using **Flutter 3.41.4** & **Dart 3.11.1**.

### Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.5+1 | State management |
| `go_router` | ^17.1.0 | Declarative routing & navigation |
| `record` | ^6.2.0 | Audio recording with amplitude streaming |
| `audioplayers` | ^6.6.0 | Audio playback |
| `http` | ^1.6.0 | HTTP client (DAW communication) |
| `mobile_scanner` | ^7.2.0 | QR code scanning |
| `path_provider` | ^2.1.5 | File system directory access |
| `shared_preferences` | ^2.5.4 | Persistent key-value storage |
| `logging` | ^1.3.0 | Structured logging |
| `package_info_plus` | ^9.0.0 | App version & build info |
| `flutter_screenutil` | ^5.9.3 | Responsive layout scaling |
| `google_fonts` | ^8.0.2 | Inter font family |
| `flutter_animate` | ^4.5.2 | Composable animation utilities |
| `cupertino_icons` | ^1.0.8 | iOS-style icon set |
| `flutter_native_splash` | ^2.4.7 | Native splash screen generation |
| `flutter_launcher_icons` | ^0.14.4 | App icon generation |

### Dev Dependencies

| Package | Version |
|---------|---------|
| `flutter_lints` | ^6.0.0 |
| `flutter_test` | SDK |

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.41.4`
- Dart `>=3.11.1`
- Xcode (for iOS builds)
- Android Studio or the Android SDK (for Android builds)
- A physical device is recommended for audio recording/playback and QR scanning

### Setup

1. **Clone the repository**

   ```bash
   git clone <repo-url>
   cd doodlevox_mobile
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate assets** (splash screen & launcher icons)

   ```bash
   dart run flutter_native_splash:create
   dart run flutter_launcher_icons
   ```

4. **Run the app**

   ```bash
   flutter run
   ```

### Android Release Signing

Release builds require a `key.properties` file at `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to>/upload-keystore.jks
```

This file is git-ignored. Debug builds use the default debug keystore automatically.

**For the release build config files, please contact the project maintainer (LahiruHW) directly.**

## Project Structure

```
lib/
├── main.dart                          # Entry point & provider setup
├── models/
│   └── dv_recording.dart              # Recording data model (UUID, waveform, sync status)
├── providers/
│   ├── dv_audio_provider.dart         # Audio recording & playback state
│   ├── dv_daw_provider.dart           # DAW connection over local network
│   ├── dv_library_provider.dart       # Recording library with JSON persistence
│   ├── dv_prefs_provider.dart         # User preferences (theme, language)
│   └── dv_sync_provider.dart          # Bidirectional metadata sync with DAW
├── screens/
│   ├── qr_scan_screen.dart            # QR scanner for DAW connection
│   ├── record/
│   │   ├── record_screen.dart         # Main recording interface
│   │   └── effects_bottom_sheet_screen.dart
│   ├── library/
│   │   └── library_screen.dart        # Scrollable list of saved recordings
│   ├── settings/
│   │   └── settings_screen.dart
│   └── shared/
│       └── dv_main_shell.dart         # Tab navigation shell (Record / Library)
├── styles/
│   ├── dv_colors.dart                 # Midnight Sun colour palette
│   ├── dv_text_theme.dart             # Inter-based type scale
│   ├── dv_themes.dart                 # Light & dark ThemeData
│   ├── dv_button_style.dart           # Button theme extension
│   ├── dv_record_screen_style.dart    # Record screen theming
│   ├── dv_library_screen_style.dart   # Library screen theming
│   ├── dv_qr_scan_style.dart          # QR scan screen theming
│   ├── dv_snackbar_style.dart         # Snackbar theming
│   └── dv_effects_sheet_style.dart    # Effects sheet theming
├── utils/
│   ├── dv_app_info.dart               # App metadata wrapper
│   ├── dv_shared_prefs.dart           # SharedPreferences wrapper
│   ├── routing/
│   │   ├── dv_router.dart             # GoRouter route definitions
│   │   └── dv_cupertino_sheet_page.dart
│   ├── painters/
│   │   └── border_beam_painter.dart   # Animated border beam effect
│   └── animations/
│       └── background_grid_blinker.dart
└── widgets/
    ├── dv_logo.dart                   # Theme-aware app logo
    ├── dv_waveform.dart               # Real-time waveform visualiser
    └── shared/
        ├── dv_primary_button.dart
        ├── dv_secondary_button.dart
        ├── dv_alert_dialog.dart
        └── dv_snackbar.dart
```

## Architecture

### State Management

The app uses **Provider** (`ChangeNotifier`) with five providers registered at the root:

| Provider | Responsibility |
|----------|---------------|
| `DVPrefsProvider` | Theme mode, language, first-launch flag |
| `DVAudioProvider` | Audio recording lifecycle, amplitude streaming, playback |
| `DVDawProvider` | Local network handshake & file transfer to the DAW plugin |
| `DVLibraryProvider` | CRUD for saved recordings, JSON file persistence |
| `DVSyncProvider` | Periodic metadata sync between mobile and DAW |

### Navigation

`go_router` with a `StatefulShellRoute.indexedStack` provides tab-based navigation that preserves state across the **Record** and **Library** tabs. Routes:

| Path | Screen |
|------|--------|
| `/` | QR Scan (initial) |
| `/main/record` | Record (tab 0) |
| `/main/library` | Library (tab 1) |
| `/record/effects` | Effects bottom sheet (modal) |
| `/settings` | Settings |

### DAW Connection Flow

1. The DoodleVox VST plugin displays a QR code containing `http://<ip>:<port>?token=<token>`
2. The mobile app scans the QR code and performs a GET handshake to validate the session
3. Once connected, recorded audio can be sent to the DAW via POST
4. If the connection is skipped, all recording and library features work offline — only the "Send to DAW" action and metadata sync are disabled

### Library & Sync

- Every recording is auto-saved to the library when the user stops recording
- Each recording has an immutable UUID, editable title (defaults to the recorded date/time), waveform data, and a sync status
- The "Record Again" action overwrites the current recording slot; "Send to DAW" finalises the slot and marks it as synced
- Metadata sync (title changes, deletions) runs periodically over the local network **only for recordings that exist on both the mobile app and the DAW** — recordings are never automatically pushed to the DAW

## Design System

**Theme:** Midnight Sun

| Token | Value | Usage |
|-------|-------|-------|
| Primary | `#FFB800` (Gold) | Interactive elements, branding, waveform |
| Secondary | `#FFFFFF` (White) | Text, contrast |
| Tertiary | `#888888` (Grey) | Disabled states, subtle accents |
| Neutral | `#000000` (Black) | Dark mode background |

- **Typography:** Inter (variable font)
- **Shape:** Smooth circular corners (20px border radius on components)
- **Theme mode:** System-based (dark mode primary target) 
