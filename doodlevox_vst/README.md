# DoodleVox (VST)

## Summary

The VST plugin acts as a **wireless audio receiver** inside a DAW. A companion mobile app (see `doodlevox_mobile`) records a voice note and streams the audio over Wi-Fi to the plugin, which saves the clip and lets the producer drag it straight onto a DAW track.

### What's Been Implemented

#### Build System (`CMakeLists.txt`)
- CMake project (`DoodleVox`, v0.0.1) that targets **Standalone**, **AU**, and **VST3** plugin formats via the JUCE framework.
- Cross-platform support: macOS (universal binary: `x86_64` + `arm64`, min deployment target `10.13` / `11.0` for arm64), Linux (WebKit2GTK dependency), and Windows (MSVC static runtime).
- A `SharedCode` interface library that exposes shared include paths and compile definitions to all targets.
- `AudioPluginData` binary-data target that bundles everything inside `assets/` into the binary.
- Helper script `xcode_setup.sh` to generate an Xcode project via `cmake -G Xcode`.

#### TCP Audio Receiver (`PluginProcessor`)
- `DoodleVoxVSTAudioProcessor` (extends `juce::AudioProcessor`) spins up a background **`ServerThread`** on construction that listens on **TCP port 5000**.
- On each incoming connection the server:
  1. Reads an HTTP-style header byte-by-byte until the `\r\n\r\n` terminator.
  2. Parses the `Content-Length` header to know exactly how many audio bytes to expect.
  3. Reads the raw audio payload into an in-memory `juce::MemoryBlock`.
  4. Decodes the audio using `juce::AudioFormatManager` (supports any JUCE-registered format: WAV, AIFF, MP3, etc.).
  5. Re-encodes the decoded audio as a 16-bit **WAV** file and writes it to the system temp directory with a timestamped filename (`clip_YYYYMMDD_HHMMSS.wav`).
  6. Sets `newFileReady = true` and stores the output path in `lastReceivedFile` so the editor can react.
- The server also exposes a `ReceiverState` enum (`Idle` / `Receiving`) so the UI can reflect the current transfer state.
- The thread is cleanly stopped (with a 1-second timeout) when the processor is destroyed.

#### Plugin UI (`PluginEditor` + `DragClipComponent`)
- `DoodleVoxVSTAudioProcessorEditor` (300 × 200 px) contains:
  - **Status label** — shows "Status: Waiting" or "Receiving audio…" depending on `ReceiverState`.
  - **IP label** — detects the machine's local IP address at startup and displays `Send audio to: <IP>:5000` so the user knows where to point the mobile app.
  - **Background colour** — dark grey at rest; turns **orange** while a transfer is in progress.
  - A **100 ms polling timer** that checks `newFileReady` and updates labels and visibility.
- `DragClipComponent` is hidden by default and made visible once a file has been received. Clicking/dragging it initiates a native **external drag-and-drop** of the saved WAV file (via `juce::DragAndDropContainer::performExternalDragDropOfFiles`), allowing the clip to be dropped directly onto a DAW track.

#### Assets
- `assets/placeholder.txt` — reserves the `assets/` directory so the CMake binary-data target always finds at least one file to bundle.

## Prerequisites

1. CMake (>= 3.15 recommended)
2. JUCE (matching the modules included in `modules/JUCE`)
3. A C++ toolchain and IDE for your platform (Xcode on macOS recommended)

## Notes

- The project is configured with CMake and includes JUCE modules under `modules/JUCE`.
- If you run into missing dependencies, ensure your JUCE modules and platform toolchain are installed and accessible.

## Getting Started

Quick steps to configure and build the plugin from the repository root.

1. Create a build directory and configure the project:

   ```bash
   mkdir -p build
   cd build
   cmake -S .. -B .
   ```

   - To generate an Xcode project on macOS use `cmake -G "Xcode" ..` from the `build` folder.

2. Build the project (from the workspace root or `build` directory):

   ```bash
   cmake --build build --config Debug
   ```

3. Install or copy the built plugin to your system plugin folder for testing.
   - macOS VST3 path: `~/Library/Audio/Plug-Ins/VST3`
   - Or use your DAW/host's plugin scan/load workflow.

## Using Visual Studio Code

1. Install the `CMake Tools` extension.
2. Open the workspace in VS Code and let CMake configure the project (use the status bar or `CMake: Configure`).
3. Use `CMake: Build` or the command palette entry `CMake: Run Without Debug` to build the selected target.

## macOS / Xcode

- There is an `xcode_setup.sh` script at the repository root which may help with Xcode-specific setup; review and run it if you plan to open the generated Xcode project.
- To open in Xcode after generating an Xcode project:

  ```bash
  open build/DoodleVox.xcodeproj
  ```

## Testing the Plugin

- After building, launch a host (for example, REAPER, Logic Pro, or a plugin sandbox) and point it to the VST3 folder above, then scan for new plugins.
- For quick checks you can load the plugin binary directly in a plugin host or use JUCE's AudioPluginHost.
