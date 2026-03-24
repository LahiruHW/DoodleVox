#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
DoodleVoxVSTAudioProcessorEditor::DoodleVoxVSTAudioProcessorEditor (DoodleVoxVSTAudioProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p), dragClip(p)
{
    setSize (320, 400);

    // ── Status label ──────────────────────────────────────────────────────────
    statusLabel.setText ("Waiting for connection...", juce::dontSendNotification);
    statusLabel.setJustificationType (juce::Justification::centred);
    statusLabel.setFont (juce::FontOptions (16.0f));
    addAndMakeVisible (statusLabel);

    // ── QR code ───────────────────────────────────────────────────────────────
    qrCode.setUrl (processorRef.getServerUrl());
    addAndMakeVisible (qrCode);

    // ── URL text label (below QR) ─────────────────────────────────────────────
    urlLabel.setText ("Scan to connect:\n" + processorRef.getServerUrl(),
                       juce::dontSendNotification);
    urlLabel.setJustificationType (juce::Justification::centred);
    urlLabel.setFont (juce::FontOptions (12.0f));
    addAndMakeVisible (urlLabel);

    // ── Drag clip component ───────────────────────────────────────────────────
    addAndMakeVisible (dragClip);
    dragClip.setVisible (false);

    startTimer (100);
}

DoodleVoxVSTAudioProcessorEditor::~DoodleVoxVSTAudioProcessorEditor()
{
}

void DoodleVoxVSTAudioProcessorEditor::resized()
{
    auto area = getLocalBounds().reduced (8);

    statusLabel.setBounds (area.removeFromTop (36));
    area.removeFromTop (4);

    // Reserve a square region for the QR code (as large as will fit the width).
    const int qrDim = juce::jmin (area.getWidth(), area.getHeight() - 60);
    qrCode.setBounds (area.removeFromTop (qrDim));
    area.removeFromTop (4);

    urlLabel.setBounds (area.removeFromTop (36));
    area.removeFromTop (4);

    dragClip.setBounds (area.reduced (4));
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

    if (p.receiverState == DoodleVoxVSTAudioProcessor::ReceiverState::Receiving)
    {
        statusLabel.setText ("Receiving audio...", juce::dontSendNotification);
    }
    else
    {
        statusLabel.setText ("Scan QR code to connect", juce::dontSendNotification);
    }

    // Refresh URL label / QR code in case the IP has changed (e.g. on reconnect).
    const juce::String url = p.getServerUrl();
    if (urlLabel.getText() != "Scan to connect:\n" + url)
    {
        urlLabel.setText ("Scan to connect:\n" + url, juce::dontSendNotification);
        qrCode.setUrl (url);
    }

    if (p.newFileReady)
    {
        p.newFileReady = false;
        dragClip.setVisible (true);
        statusLabel.setText ("Clip ready \xe2\x80\x94 drag to DAW", juce::dontSendNotification);
    }

    repaint();
}