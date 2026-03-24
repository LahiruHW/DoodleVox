#include "LibraryPage.h"

LibraryPage::LibraryPage()
{
    placeholderLabel.setText ("Library\nComing soon", juce::dontSendNotification);
    placeholderLabel.setFont (juce::FontOptions (16.0f));
    placeholderLabel.setJustificationType (juce::Justification::centred);
    placeholderLabel.setColour (juce::Label::textColourId, juce::Colour (0xFF888888));
    addAndMakeVisible (placeholderLabel);
}

void LibraryPage::paint (juce::Graphics& g)
{
    g.fillAll (juce::Colour (0xFF000000));
}

void LibraryPage::resized()
{
    placeholderLabel.setBounds (getLocalBounds());
}
