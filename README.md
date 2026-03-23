# DoodleVox

<div style="display:flex; gap:0; width:100%; max-width:100%;">
  <img src="doodlevox_mobile/assets/images/feature_graphic/feature_graphic_light.png" alt="DoodleVox App Screenshot" style="width:50%; height:auto; display:block; object-fit:cover; margin:0; padding:0;">
  <img src="doodlevox_mobile/assets/images/feature_graphic/feature_graphic_dark.png" alt="DoodleVox App Screenshot" style="width:50%; height:auto; display:block; object-fit:cover; margin:0; padding:0;">
</div>
<br>

Easy voice-notes for music producers.
<br>

This parent repository is a small multi-target project containing two main components:
<br>

- [`doodlevox_mobile`](doodlevox_mobile) — a Flutter mobile app (Android & iOS) located in the `doodlevox_mobile/` folder. It contains the app source in `lib/`, platform folders (`android/`, `ios/`) and build/test configs.


- [`doodlevox_vst`](doodlevox_vst) — an audio plugin (C++/JUCE) located in the `doodlevox_vst/` folder. It contains CMake build files, source code, and plugin assets.
  <br>

Each subfolder contains its own README and build instructions.

Start there for platform-specific setup.
