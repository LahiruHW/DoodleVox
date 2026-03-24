#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"
#include "DragClipComponent.hpp"

class ReceiverPage : public juce::Component,
                     private juce::Timer
{
public:
    explicit ReceiverPage (DoodleVoxVSTAudioProcessor& p);

    void paint (juce::Graphics& g) override;
    void resized() override;

private:
    void timerCallback() override;

    DoodleVoxVSTAudioProcessor& processor;
    juce::Label statusLabel;
    juce::Label infoLabel;
    DragClipComponent dragClip;
    bool clipAvailable = false;
    int newFileFlashCount = 0;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (ReceiverPage)
};
