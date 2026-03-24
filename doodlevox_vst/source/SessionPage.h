#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"
#include "ReceiverPage.h"
#include "LibraryPage.h"

class SessionPage : public juce::Component
{
public:
    explicit SessionPage (DoodleVoxVSTAudioProcessor& p);
    ~SessionPage() override;

    void paint (juce::Graphics& g) override;
    void resized() override;

private:
    ReceiverPage receiverPage;
    LibraryPage libraryPage;
    juce::TabbedComponent tabs;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (SessionPage)
};
