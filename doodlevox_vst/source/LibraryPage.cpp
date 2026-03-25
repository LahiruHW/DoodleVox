#include "LibraryPage.h"
#include "Theme.h"

LibraryPage::LibraryPage()
{
    placeholderLabel.setText ("Library\nComing soon", juce::dontSendNotification);
    placeholderLabel.setFont (juce::FontOptions (Theme::fontBody));
    placeholderLabel.setJustificationType (juce::Justification::centred);
    placeholderLabel.setColour (juce::Label::textColourId, Theme::grey);
    addAndMakeVisible (placeholderLabel);
}

void LibraryPage::paint (juce::Graphics& g)
{
    g.fillAll (Theme::black);
}

void LibraryPage::resized()
{
    placeholderLabel.setBounds (getLocalBounds());
}
