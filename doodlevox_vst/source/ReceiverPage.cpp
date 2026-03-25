#include "ReceiverPage.h"
#include "Theme.h"

ReceiverPage::ReceiverPage (DoodleVoxVSTAudioProcessor& p)
    : processor (p), dragClip (p)
{
    statusLabel.setText ("Waiting for audio...", juce::dontSendNotification);
    statusLabel.setFont (juce::FontOptions (Theme::fontHeading));
    statusLabel.setJustificationType (juce::Justification::centred);
    statusLabel.setColour (juce::Label::textColourId, Theme::grey);
    addAndMakeVisible (statusLabel);

    infoLabel.setFont (juce::FontOptions (Theme::fontCaption));
    infoLabel.setJustificationType (juce::Justification::centred);
    infoLabel.setColour (juce::Label::textColourId, Theme::grey);
    addAndMakeVisible (infoLabel);

    addAndMakeVisible (dragClip);
    dragClip.setVisible (false);

    startTimer (100);
}

void ReceiverPage::paint (juce::Graphics& g)
{
    g.fillAll (Theme::black);
}

void ReceiverPage::resized()
{
    auto area = getLocalBounds().reduced (Theme::pagePadding);

    statusLabel.setBounds (area.removeFromTop (40));
    area.removeFromTop (8);
    infoLabel.setBounds (area.removeFromTop (20));
    area.removeFromTop (16);

    dragClip.setBounds (area.reduced (20, 0));
}

void ReceiverPage::timerCallback()
{
    using State = DoodleVoxVSTAudioProcessor::ReceiverState;
    auto state = processor.receiverState.load();
    bool hasClip = processor.lastReceivedFile.existsAsFile();

    // Detect newly received file
    if (processor.newFileReady.load())
    {
        processor.newFileReady = false;
        clipAvailable = true;
        dragClip.setVisible (true);
        newFileFlashCount = 20; // flash "Voice note received!" for ~2 seconds
    }

    // Update status text and colour
    if (state == State::Receiving)
    {
        statusLabel.setText ("Receiving audio...", juce::dontSendNotification);
        statusLabel.setColour (juce::Label::textColourId, Theme::gold);
    }
    else if (newFileFlashCount > 0)
    {
        --newFileFlashCount;
        statusLabel.setText ("Voice note received!", juce::dontSendNotification);
        statusLabel.setColour (juce::Label::textColourId, Theme::gold);
    }
    else if (clipAvailable && hasClip)
    {
        statusLabel.setText ("Ready - drag clip to DAW", juce::dontSendNotification);
        statusLabel.setColour (juce::Label::textColourId, Theme::white);
    }
    else
    {
        statusLabel.setText ("Waiting for audio...", juce::dontSendNotification);
        statusLabel.setColour (juce::Label::textColourId, Theme::grey);
        if (! hasClip)
        {
            clipAvailable = false;
            dragClip.setVisible (false);
        }
    }

    // Connection metadata
    auto ip = juce::IPAddress::getLocalAddress().toString();
    infoLabel.setText ("Session active | " + ip + ":5000",
                       juce::dontSendNotification);
}
