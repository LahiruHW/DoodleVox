#!/bin/zsh

# NOTE: ONLY FOR MacOS

# 1. create directories
mkdir xcode-build

# 2. generate Xcode project folder
cd xcode-build

# 3. generate Xcode project
cmake -G Xcode ..