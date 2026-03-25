#pragma once

#include <JuceHeader.h>

/**
 * Centralised style constants for the "Midnight Sun" theme.
 * Matches the design system in doodlevox_mobile/DESIGN.md.
 */
namespace Theme
{
    // ── Colours ──────────────────────────────────────────────────────────────
    const juce::Colour gold{0xFFFFB800};       // Primary   – interactive accents, titles
    const juce::Colour white{0xFFFFFFFF};      // Secondary – primary text, ready-state
    const juce::Colour grey{0xFF888888};       // Tertiary  – secondary text, disabled/idle
    const juce::Colour black{0xFF000000};      // Neutral   – backgrounds
    const juce::Colour darkGrey{0xFF1A1A1A};   // Elevated surface (cards, drag area)
    const juce::Colour panelGrey{0xFF111111};  // Tab panel background
    const juce::Colour borderGrey{0xFF333333}; // Subtle borders (tab outline)

    // ── Font Sizes ───────────────────────────────────────────────────────────
    constexpr float fontTitle = 24.0f;
    constexpr float fontHeading = 18.0f;
    constexpr float fontBody = 16.0f;
    constexpr float fontLabel = 14.0f;
    constexpr float fontCaption = 11.0f;

    // ── Borders / Spacing ────────────────────────────────────────────────────
    constexpr int borderWidth = 2;
    constexpr int pagePadding = 16;
    constexpr int tabBarDepth = 30;
}
