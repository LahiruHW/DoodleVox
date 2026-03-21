# DoodleVox (VST)

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
