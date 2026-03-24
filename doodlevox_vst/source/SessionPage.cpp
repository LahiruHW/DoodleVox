#include "SessionPage.h"

SessionPage::SessionPage (DoodleVoxVSTAudioProcessor& p)
    : receiverPage (p),
      tabs (juce::TabbedButtonBar::TabsAtTop)
{
    tabs.addTab ("Receiver", juce::Colour (0xFF111111), &receiverPage, false);
    tabs.addTab ("Library",  juce::Colour (0xFF111111), &libraryPage,  false);

    tabs.setColour (juce::TabbedComponent::backgroundColourId, juce::Colour (0xFF000000));
    tabs.setColour (juce::TabbedComponent::outlineColourId,    juce::Colour (0xFF333333));
    tabs.setTabBarDepth (30);

    addAndMakeVisible (tabs);
}

SessionPage::~SessionPage()
{
    tabs.clearTabs();
}

void SessionPage::paint (juce::Graphics& g)
{
    g.fillAll (juce::Colour (0xFF000000));
}

void SessionPage::resized()
{
    tabs.setBounds (getLocalBounds());
}
