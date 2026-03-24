#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"
#include "ConnectPage.h"
#include "SessionPage.h"

//==============================================================================
class DoodleVoxVSTAudioProcessorEditor final : public juce::AudioProcessorEditor,
                                              public juce::DragAndDropContainer,
                                              private juce::Timer
{
public:
    explicit DoodleVoxVSTAudioProcessorEditor(DoodleVoxVSTAudioProcessor &);
    ~DoodleVoxVSTAudioProcessorEditor() override;

    //==============================================================================
    void paint(juce::Graphics &) override;
    void resized() override;

private:

    void timerCallback() override;

    DoodleVoxVSTAudioProcessor &processorRef;

    ConnectPage connectPage;
    SessionPage sessionPage;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DoodleVoxVSTAudioProcessorEditor)
};
