# DoodleVox (VST)

## Summary

The VST plugin acts as a **wireless audio receiver** inside a DAW. A companion mobile app (see `doodlevox_mobile`) records a voice note and streams the audio over Wi-Fi to the plugin, which saves the clip and lets the producer drag it straight onto a DAW track.

## Architecture Flowchart

```mermaid
flowchart TD
    subgraph Mobile["Mobile App"]
        M1[Record voice note]
        M2[Scan QR code]
        M3["HTTP POST audio\n(application/octet-stream)"]
    end

    subgraph Plugin["DoodleVox VST/AU Plugin"]
        subgraph Server["ServerThread (TCP :5000)"]
            S1[Listen for connections]
            S2{Parse HTTP request}
            S3{Validate session token}
            S4["GET → Handshake\n(200 Connected)"]
            S5["POST → Read body"]
            S6["Decode audio\n(WAV/AIFF/MP3)"]
            S7["Re-encode as 16-bit WAV\n→ sessionDir/clip.wav"]
            S8["403 Forbidden"]
        end

        subgraph UI["Plugin UI (PluginEditor)"]
            P1["ConnectPage\n(QR code + URL)"]
            P2["SessionPage\n(TabbedComponent)"]
            T1["Tab: Receiver\n(status + drag-to-DAW)"]
            T2["Tab: Library\n(placeholder)"]
        end

        PROC["PluginProcessor\n• sessionToken\n• sessionDir\n• ReceiverState"]
    end

    subgraph DAW["Digital Audio Workstation"]
        D1[DAW Track / Playlist]
    end

    M1 --> M2
    M2 -->|"GET ?token=..."| S1
    S1 --> S2
    S2 --> S3
    S3 -->|Valid| S4
    S3 -->|Invalid| S8
    S4 -->|"sessionActive = true"| PROC
    PROC -->|Poll timer 100ms| P1
    P1 -->|Session active| P2
    P2 --> T1
    P2 --> T2

    M3 -->|"POST ?token=..."| S1
    S5 --> S6
    S6 --> S7
    S7 -->|"newFileReady = true"| PROC
    PROC -->|Poll| T1

    T1 -->|"Drag & Drop\n(DragClipComponent)"| D1

    S2 -->|GET| S4
    S2 -->|POST| S5

    style Mobile fill:#1a1a1a,stroke:#FFB800,color:#fff
    style Plugin fill:#111,stroke:#FFB800,color:#fff
    style Server fill:#1a1a1a,stroke:#888,color:#fff
    style UI fill:#1a1a1a,stroke:#888,color:#fff
    style DAW fill:#1a1a1a,stroke:#FFB800,color:#fff
```

## What's Been Implemented

### Build System (`CMakeLists.txt`)
- CMake project (`DoodleVox`, v0.0.1) targeting **Standalone**, **AU**, and **VST3** formats via JUCE 8.0.12.
- Cross-platform: macOS (universal binary `x86_64` + `arm64`, deployment target `10.13` / `11.0` arm64), Linux (WebKit2GTK), Windows (MSVC static runtime).
- `SharedCode` interface library for shared includes and compile definitions.
- `AudioPluginData` binary-data target bundling `assets/`.
- QR code generation via [nayuki/QR-Code-generator](https://github.com/nayuki/QR-Code-generator) v1.8.0 (fetched automatically by CPM).
- Helper script `xcode_setup.sh` for Xcode project generation.

### Session Management & TCP Server (`PluginProcessor`)
- On construction, generates a random **session token** (8-char hex via `juce::Uuid`) and creates a per-session temp directory (`DoodleVox_<token>/`).
- Spins up a background **`ServerThread`** listening on **TCP port 5000**.
- The server URL (including token) is encoded into a QR code: `http://<local-ip>:5000?token=<token>`.
- On each incoming connection the server:
  1. Reads the HTTP header byte-by-byte until `\r\n\r\n`.
  2. **Validates the session token** from the `?token=` query parameter — rejects with `403 Forbidden` if invalid.
  3. **GET** requests → handshake response (`200 Connected`), sets `sessionActive = true`.
  4. **POST** requests → reads `Content-Length` bytes into memory, decodes audio via `juce::AudioFormatManager` (WAV, AIFF, MP3, etc.), re-encodes as 16-bit WAV to `sessionDir/clip.wav` (overwriting any previous clip), responds `200 OK`, sets `newFileReady = true`.
- On destruction: stops server thread, **deletes the entire session directory** (all received clips removed).

### Plugin UI — Two-Page Architecture (`PluginEditor`)
The editor (380 × 500 px) switches between two top-level pages using a 100 ms polling timer:

#### Page 1: Connect (`ConnectPage`)
Shown on launch. Displays:
- **"DoodleVox"** title in gold.
- **QR code** encoding the server URL (with session token), rendered via `QRCodeComponent` + nayuki library.
- Instruction text and the raw URL for manual entry.

#### Page 2: Session (`SessionPage`)
Shown after a successful handshake (`sessionActive = true`). Contains a `juce::TabbedComponent` with:

| Tab | Component | Description |
|-----|-----------|-------------|
| **Receiver** | `ReceiverPage` | Status display (Idle → Receiving → Received → Ready to drag). Shows connection metadata. `DragClipComponent` appears when a clip is available. |
| **Library** | `LibraryPage` | Placeholder for future clip history (not yet implemented). |

The tab bar is designed to be extended with additional tabs (e.g., effects processing) in future versions.

#### Drag-and-Drop (`DragClipComponent`)
- Hidden until a clip is received; visible in the Receiver tab.
- Initiates a native **external drag-and-drop** of the WAV file via `juce::DragAndDropContainer::performExternalDragDropOfFiles`, allowing the clip to be dropped directly onto a DAW track.

### UI Theme: Midnight Sun
| Role | Colour | Usage |
|------|--------|-------|
| Primary | `#FFB800` (gold) | Titles, borders, active status, interactive accents |
| Secondary | `#FFFFFF` (white) | Primary text, ready-state labels |
| Tertiary | `#888888` (grey) | Secondary text, disabled/idle states |
| Neutral | `#000000` (black) | All backgrounds |

Sharp corners (0 roundedness) throughout. Dark-mode only.

### Source File Structure (`source/`)
```
source/
├── PluginProcessor.h/.cpp    — Audio processor, server thread, session management
├── PluginEditor.h/.cpp       — Top-level editor, page switching
├── ConnectPage.h/.cpp        — QR code connection page
├── SessionPage.h/.cpp        — Tabbed session container
├── ReceiverPage.h/.cpp       — Audio receiver status + drag-to-DAW
├── LibraryPage.h/.cpp        — Clip library placeholder
├── DragClipComponent.hpp/.cpp — Drag-and-drop file component
└── QRCodeComponent.h/.cpp    — QR code renderer (nayuki wrapper)
```

### Assets
- `assets/placeholder.txt` — reserves the `assets/` directory for the CMake binary-data target.

## Prerequisites

1. CMake (>= 3.22)
2. A C++ 17 toolchain (Xcode on macOS, MSVC on Windows)
3. JUCE modules are included in `modules/JUCE` (no separate download needed)
4. QR code library is fetched automatically via CPM

## Getting Started

1. Configure the project:

   ```bash
   mkdir -p build && cd build
   cmake -S .. -B .
   ```

   For an Xcode project: `cmake -G "Xcode" ..`

2. Build:

   ```bash
   cmake --build build --config Debug
   ```

3. The built plugin is automatically copied to:
   - **VST3**: `~/Library/Audio/Plug-Ins/VST3/DoodleVox.vst3`
   - **AU**: `~/Library/Audio/Plug-Ins/Components/DoodleVox.component`

## Using Visual Studio Code

1. Install the `CMake Tools` extension.
2. Open the workspace and let CMake configure (`CMake: Configure`).
3. Build via `CMake: Build` or run the Standalone target with `CMake: Run Without Debug`.

## macOS / Xcode

```bash
cd build && cmake -G "Xcode" ..
open DoodleVox.xcodeproj
```

The `xcode_setup.sh` script at the repo root automates this.

## Testing the Plugin

1. Build the project (see above).
2. Open a DAW (FL Studio, REAPER, Logic Pro, Ableton, etc.) and scan for new plugins.
3. Insert **DoodleVox** on any track.
4. The QR code page appears — scan with the companion mobile app.
5. After the handshake, the Receiver tab shows connection status.
6. Record and send audio from the mobile app.
7. Drag the received clip onto a DAW track.
