#pragma once

#include <JuceHeader.h>

class LibraryPage : public juce::Component
{
public:
    LibraryPage();

    void paint (juce::Graphics& g) override;
    void resized() override;

private:
    juce::Label placeholderLabel;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (LibraryPage)
};
