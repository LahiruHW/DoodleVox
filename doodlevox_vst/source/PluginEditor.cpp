#include "PluginProcessor.h"
#include "PluginEditor.h"
#include "Theme.h"

//==============================================================================
DoodleVoxVSTAudioProcessorEditor::DoodleVoxVSTAudioProcessorEditor (DoodleVoxVSTAudioProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p), sessionPage (p)
{
    setSize (380, 500);

    connectPage.setUrl (processorRef.getServerUrl());
    addAndMakeVisible (connectPage);

    addChildComponent (sessionPage); // hidden until session is established

    startTimer (100);
}

DoodleVoxVSTAudioProcessorEditor::~DoodleVoxVSTAudioProcessorEditor()
{
}

void DoodleVoxVSTAudioProcessorEditor::resized()
{
    auto bounds = getLocalBounds();
    connectPage.setBounds (bounds);
    sessionPage.setBounds (bounds);
}

//==============================================================================
void DoodleVoxVSTAudioProcessorEditor::paint (juce::Graphics& g)
{
    g.fillAll (Theme::black);
}

void DoodleVoxVSTAudioProcessorEditor::timerCallback()
{
    if (processorRef.sessionActive.load())
    {
        if (connectPage.isVisible())
        {
            connectPage.setVisible (false);
            sessionPage.setVisible (true);
        }
    }
    else
    {
        // Keep QR code URL updated in case the IP changes
        connectPage.setUrl (processorRef.getServerUrl());
    }
}