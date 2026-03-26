cmake_minimum_required(VERSION 3.23.1)

# Include CPM for package management
include("${CMAKE_CURRENT_SOURCE_DIR}/modules/cmake-includes/CPM.cmake")

# General setup
set(PROJECT_NAME "DoodleVox")
set(CURRENT_VERSION "0.0.8")
set(PRODUCT_NAME "DoodleVox")
set(COMPANY_NAME "CreatedByCAPSLOCK")
set(BUNDLE_ID "com.createdbycapslock.DoodleVox")
set(FORMATS Standalone AU VST3)

project(DoodleVox VERSION ${CURRENT_VERSION})

add_subdirectory(modules/JUCE)

# Project configuration
set(CMAKE_CXX_STANDARD 17)

# macOS-specific settings
if(APPLE)
        set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13" CACHE STRING "Minimum OS X deployment version" FORCE)
        set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "Architectures" FORCE)
        set(CMAKE_XCODE_ATTRIBUTE_MACOSX_DEPLOYMENT_TARGET[arch=arm64] "11.0" CACHE STRING "arm 64 minimum deployment target" FORCE)
endif()

# Linux-specific settings
if(UNIX AND CMAKE_SYSTEM_NAME STREQUAL "Linux")
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(WEBKIT2 REQUIRED webkit2gtk-4.0)

        include_directories(${WEBKIT2_INCLUDE_DIRS})
        link_directories(${WEBKIT2_LIBRARY_DIRS})
        add_definitions(${WEBKIT2_CFLAGS_OTHER})
endif()

# # Disable all warnings
# add_definitions(-w)

# Append custom module path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/modules/cmake-include/sudara-cmake")

# Windows-specific settings
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE INTERNAL "")
endif()

# Disable auto-copying the plugin to system directories inside CI runners,
# where write access to the install locations is not guaranteed.
if(DEFINED ENV{CI})
    set(COPY_AFTER_BUILD FALSE)
else()
    set(COPY_AFTER_BUILD FALSE)
endif()

# Define the plugin
juce_add_plugin("${PROJECT_NAME}"
        COMPANY_NAME "${COMPANY_NAME}"
        BUNDLE_ID "${BUNDLE_ID}"
        COPY_PLUGIN_AFTER_BUILD ${COPY_AFTER_BUILD}
        PLUGIN_MANUFACTURER_CODE Cbcl
        PLUGIN_CODE Dvxp
        FORMATS ${FORMATS}
        PRODUCT_NAME "${PRODUCT_NAME}"
        NEEDS_MIDI_INPUT FALSE
        NEEDS_MIDI_OUTPUT FALSE
        IS_MIDI_EFFECT FALSE
        IS_SYNTH TRUE
)

add_compile_definitions(JUCE_PROJECT_NAME="${PROJECT_NAME}")

# Define SharedCode as an INTERFACE library
add_library(SharedCode INTERFACE)

# Set compile features for SharedCode
target_compile_features(SharedCode INTERFACE cxx_std_20)

# Include directories and compile definitions for SharedCode
target_include_directories(SharedCode INTERFACE
        "${CMAKE_CURRENT_SOURCE_DIR}/source"
        "${CMAKE_CURRENT_SOURCE_DIR}/modules/JUCE/modules"
        "${CMAKE_BINARY_DIR}/AudioPluginData" # Include directory for AudioPluginData
)

# Set JUCE flags for SharedCode
target_compile_definitions(SharedCode INTERFACE
        JUCE_GLOBAL_MODULE_SETTINGS_INCLUDED=1
        JUCE_WEB_BROWSER=1
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0
        CMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}"
        VERSION="${CURRENT_VERSION}"
        JUCE_DISPLAY_SPLASH_SCREEN=0
        PRODUCT_NAME_WITHOUT_VERSION="${PRODUCT_NAME}"
        JUCE_ENABLE_REPAINT_DEBUGGING=0
)

# Add sources to the main project
file(GLOB_RECURSE SourceFiles CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/source/*.h"
)

# Sources to main project
target_sources("${PROJECT_NAME}" PRIVATE ${SourceFiles})

# Assets setup
file(GLOB_RECURSE Assets "${CMAKE_CURRENT_SOURCE_DIR}/assets/*.*")

# Add the Assets binary data as a target
juce_add_binary_data(AudioPluginData SOURCES ${Assets})

# Link AudioPluginData to SharedCode
target_link_libraries(SharedCode INTERFACE AudioPluginData)

# Ensure AudioPluginData is built before the main project
add_dependencies(${PROJECT_NAME} AudioPluginData)

# Link libraries to main project
target_link_libraries("${PROJECT_NAME}" PRIVATE
        SharedCode
        AudioPluginData
        juce::juce_audio_basics
        juce::juce_audio_devices
        juce::juce_audio_formats
        juce::juce_audio_plugin_client
        juce::juce_audio_processors
        juce::juce_audio_utils
        juce::juce_core
        juce::juce_data_structures
        juce::juce_dsp
        juce::juce_events
        juce::juce_graphics
        juce::juce_gui_basics
        juce::juce_gui_extra
        juce::juce_product_unlocking
        PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags
)

# Ensure the main project knows where its sources are
target_include_directories("${PROJECT_NAME}" PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/source"
)

# ── QR Code generator (nayuki/QR-Code-generator, BSD-2-Clause) ────────────────
CPMAddPackage(
    NAME qrcodegen
    GITHUB_REPOSITORY nayuki/QR-Code-generator
    GIT_TAG v1.8.0
    DOWNLOAD_ONLY YES
)
if(qrcodegen_ADDED)
    target_sources("${PROJECT_NAME}" PRIVATE
        "${qrcodegen_SOURCE_DIR}/cpp/qrcodegen.cpp"
    )
    target_include_directories(SharedCode INTERFACE
        "${qrcodegen_SOURCE_DIR}/cpp"
    )
endif()

# Generate a consolidated JuceHeader.h for convenience (allows `#include <JuceHeader.h>`)
juce_generate_juce_header("${PROJECT_NAME}")

# ── Install rules & CPack installer configuration ─────────────────────────────
# Build artefacts land under <build>/DoodleVox_artefacts/<config>/
set(ARTEFACT_DIR "${CMAKE_BINARY_DIR}/DoodleVox_artefacts")

if(APPLE)
    # macOS: .pkg installer via productbuild
    # Default install destinations (user can relocate in the installer UI)
    install(DIRECTORY "${ARTEFACT_DIR}/$<CONFIG>/VST3/DoodleVox.vst3"
            DESTINATION "Library/Audio/Plug-Ins/VST3"
            COMPONENT VST3)
    install(DIRECTORY "${ARTEFACT_DIR}/$<CONFIG>/AU/DoodleVox.component"
            DESTINATION "Library/Audio/Plug-Ins/Components"
            COMPONENT AU)
    install(DIRECTORY "${ARTEFACT_DIR}/$<CONFIG>/Standalone/DoodleVox.app"
            DESTINATION "Applications"
            COMPONENT Standalone)

    set(CPACK_GENERATOR "productbuild")
    set(CPACK_PRODUCTBUILD_IDENTITY_NAME "" CACHE STRING
        "Developer ID Installer certificate name (leave empty for unsigned)")
    set(CPACK_PRODUCTBUILD_DOMAINS TRUE)           # enable domain chooser (user/local/system)
    set(CPACK_PRODUCTBUILD_DOMAINS_USER TRUE)
    set(CPACK_PRODUCTBUILD_DOMAINS_ROOT TRUE)
    set(CPACK_PRODUCTBUILD_DOMAINS_ANYWHERE FALSE)

elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    # Windows: NSIS installer with user-selectable directory
    install(DIRECTORY "${ARTEFACT_DIR}/$<CONFIG>/VST3/DoodleVox.vst3"
            DESTINATION "VST3"
            COMPONENT VST3)
    install(DIRECTORY "${ARTEFACT_DIR}/$<CONFIG>/Standalone/"
            DESTINATION "Standalone"
            COMPONENT Standalone)

    set(CPACK_GENERATOR "NSIS")
    set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
    set(CPACK_NSIS_MODIFY_PATH OFF)
    # Default install root – user can change during install
    set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64\\\\${COMPANY_NAME}")

elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    # Linux: .deb package
    install(DIRECTORY "${ARTEFACT_DIR}/$<CONFIG>/VST3/DoodleVox.vst3"
            DESTINATION "lib/vst3"
            COMPONENT VST3)
    install(PROGRAMS "${ARTEFACT_DIR}/$<CONFIG>/Standalone/DoodleVox"
            DESTINATION "bin"
            COMPONENT Standalone)

    set(CPACK_GENERATOR "DEB")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "${COMPANY_NAME}")
    set(CPACK_DEBIAN_PACKAGE_SECTION "sound")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "libasound2, libfreetype6, libx11-6")
endif()

# Common CPack settings
set(CPACK_PACKAGE_NAME "${PRODUCT_NAME}")
set(CPACK_PACKAGE_VENDOR "${COMPANY_NAME}")
set(CPACK_PACKAGE_VERSION "${CURRENT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "DoodleVox audio plug-in")
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")
endif()
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PRODUCT_NAME}")

include(CPack)
