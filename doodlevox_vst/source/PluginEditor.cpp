#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
DoodleVoxVSTAudioProcessorEditor::DoodleVoxVSTAudioProcessorEditor (DoodleVoxVSTAudioProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p), dragClip(p)
{

    // Make sure that before the constructor has finished, you've set the
    // editor's size to whatever you need it to be.
    setSize (300, 200);

    // add status label to the window
    statusLabel.setText("Waiting for connection...", juce::dontSendNotification);
    statusLabel.setJustificationType(juce::Justification::centred);
    statusLabel.setFont(juce::FontOptions(18.0f));
    addAndMakeVisible(statusLabel);

    // Detect local IP & add IP address text to the window
    juce::String ipText = "IP not found";
    auto addresses = juce::IPAddress::getAllAddresses();
    // for (auto& addr : addresses)
    // {
    //     if (!addr.isLoopback())
    //     {
    //         ipText = addr.toString();
    //         break;
    //     }
    //     break;
    // }
    ipText = addresses[0].getLocalAddress().toString();
    
    ipLabel.setText("Send audio to:\n" + ipText + ":5000", juce::dontSendNotification);
    ipLabel.setJustificationType(juce::Justification::centred);
    ipLabel.setFont(juce::FontOptions(14.0f));
    addAndMakeVisible(ipLabel);
    
    // drag clip
    addAndMakeVisible(dragClip);
    dragClip.setVisible(false);
    
    startTimer(100); // check every 100 ms
    // startTimerHz(10); // UI update rate
}

DoodleVoxVSTAudioProcessorEditor::~DoodleVoxVSTAudioProcessorEditor()
{
}

void DoodleVoxVSTAudioProcessorEditor::resized()
{
    // This is generally where you'll want to lay out the positions of any
    // subcomponents in your editor..

    auto area = getLocalBounds();
    statusLabel.setBounds(area.removeFromTop(50));
    ipLabel.setBounds(area.removeFromTop(40));
    dragClip.setBounds(area.reduced(20));
}

//==============================================================================
void DoodleVoxVSTAudioProcessorEditor::paint (juce::Graphics& g)
{
    // // (Our component is opaque, so we must completely fill the background with a solid colour)
    // g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));
    // g.setColour (juce::Colours::white);
    // g.setFont (juce::FontOptions (15.0f));
    // g.drawFittedText ("Hello World!", getLocalBounds(), juce::Justification::centred, 1);
    
    auto& p = static_cast<DoodleVoxVSTAudioProcessor&>(processor);
    if (p.receiverState == DoodleVoxVSTAudioProcessor::ReceiverState::Receiving) {
        g.fillAll(juce::Colours::orange);
    }
    else {
        g.fillAll(juce::Colours::darkgrey);
    }
}

void DoodleVoxVSTAudioProcessorEditor::timerCallback()
{
    auto& p = static_cast<DoodleVoxVSTAudioProcessor&>(processor);
    if (p.receiverState == DoodleVoxVSTAudioProcessor::ReceiverState::Receiving) {
        statusLabel.setText("Receiving audio...", juce::dontSendNotification);
    }
    else {
        statusLabel.setText("Status: Waiting", juce::dontSendNotification);
    }

    // Check if new audio file arrived - drag it into the editor if so
    if (p.newFileReady)
    {
        p.newFileReady = false;
        
        dragClip.setVisible(true);
        statusLabel.setText("Clip Ready - Drag Below", juce::dontSendNotification);

        DBG("Dragged file into DAW");
    }
    
    repaint();
}