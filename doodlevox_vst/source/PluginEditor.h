#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"
#include "QRCodeComponent.h"
#include "DragClipComponent.hpp"

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

    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    DoodleVoxVSTAudioProcessor &processorRef;

    juce::Label statusLabel;
    juce::Label urlLabel;      // small text URL shown below the QR code
    QRCodeComponent qrCode;
    DragClipComponent dragClip;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(DoodleVoxVSTAudioProcessorEditor)
};
