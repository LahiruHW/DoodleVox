#include "ConnectPage.h"

ConnectPage::ConnectPage()
{
    titleLabel.setText ("DoodleVox", juce::dontSendNotification);
    titleLabel.setFont (juce::FontOptions (24.0f));
    titleLabel.setJustificationType (juce::Justification::centred);
    titleLabel.setColour (juce::Label::textColourId, juce::Colour (0xFFFFB800));
    addAndMakeVisible (titleLabel);

    addAndMakeVisible (qrCode);

    instructionLabel.setText ("Scan QR code to connect", juce::dontSendNotification);
    instructionLabel.setFont (juce::FontOptions (14.0f));
    instructionLabel.setJustificationType (juce::Justification::centred);
    instructionLabel.setColour (juce::Label::textColourId, juce::Colours::white);
    addAndMakeVisible (instructionLabel);

    urlLabel.setFont (juce::FontOptions (11.0f));
    urlLabel.setJustificationType (juce::Justification::centred);
    urlLabel.setColour (juce::Label::textColourId, juce::Colour (0xFF888888));
    addAndMakeVisible (urlLabel);
}

void ConnectPage::setUrl (const juce::String& url)
{
    qrCode.setUrl (url);
    urlLabel.setText (url, juce::dontSendNotification);
}

void ConnectPage::paint (juce::Graphics& g)
{
    g.fillAll (juce::Colour (0xFF000000));

    // Gold border around QR code
    if (! qrCode.getBounds().isEmpty())
    {
        g.setColour (juce::Colour (0xFFFFB800));
        g.drawRect (qrCode.getBounds().expanded (2), 2);
    }
}

void ConnectPage::resized()
{
    auto area = getLocalBounds().reduced (16);

    titleLabel.setBounds (area.removeFromTop (40));
    area.removeFromTop (12);

    const int qrDim = juce::jmin (area.getWidth() - 40, area.getHeight() - 80);
    auto qrArea = area.removeFromTop (qrDim);
    qrCode.setBounds (qrArea.withSizeKeepingCentre (qrDim, qrDim));
    area.removeFromTop (12);

    instructionLabel.setBounds (area.removeFromTop (24));
    area.removeFromTop (4);
    urlLabel.setBounds (area.removeFromTop (20));
}
