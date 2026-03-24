#!/bin/zsh

# NOTE: ONLY FOR MacOS

# 1. create directories
mkdir xcode-build

# 2. generate Xcode project folder
cd xcode-build

# 3. generate Xcode project
cmake -G Xcode ..

# running the build
cmake --build "/Users/lahiruhw/Documents/My PORTFOLIO/Apps/DoodleVox/doodlevox_vst/build" --config Debug --target all -j 10 --