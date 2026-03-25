#include "SessionPage.h"
#include "Theme.h"

SessionPage::SessionPage (DoodleVoxVSTAudioProcessor& p)
    : receiverPage (p),
      tabs (juce::TabbedButtonBar::TabsAtTop)
{
    tabs.addTab ("Receiver", Theme::panelGrey, &receiverPage, false);
    tabs.addTab ("Library",  Theme::panelGrey, &libraryPage,  false);

    tabs.setColour (juce::TabbedComponent::backgroundColourId, Theme::black);
    tabs.setColour (juce::TabbedComponent::outlineColourId,    Theme::borderGrey);
    tabs.setTabBarDepth (Theme::tabBarDepth);

    addAndMakeVisible (tabs);
}

SessionPage::~SessionPage()
{
    tabs.clearTabs();
}

void SessionPage::paint (juce::Graphics& g)
{
    g.fillAll (Theme::black);
}

void SessionPage::resized()
{
    tabs.setBounds (getLocalBounds());
}
