#include "ConnectPage.h"
#include "Theme.h"

ConnectPage::ConnectPage()
{
    titleLabel.setText ("DoodleVox", juce::dontSendNotification);
    titleLabel.setFont (juce::FontOptions (Theme::fontTitle));
    titleLabel.setJustificationType (juce::Justification::centred);
    titleLabel.setColour (juce::Label::textColourId, Theme::gold);
    addAndMakeVisible (titleLabel);

    addAndMakeVisible (qrCode);

    instructionLabel.setText ("Scan QR code to connect", juce::dontSendNotification);
    instructionLabel.setFont (juce::FontOptions (Theme::fontLabel));
    instructionLabel.setJustificationType (juce::Justification::centred);
    instructionLabel.setColour (juce::Label::textColourId, Theme::white);
    addAndMakeVisible (instructionLabel);

    urlLabel.setFont (juce::FontOptions (Theme::fontCaption));
    urlLabel.setJustificationType (juce::Justification::centred);
    urlLabel.setColour (juce::Label::textColourId, Theme::grey);
    addAndMakeVisible (urlLabel);
}

void ConnectPage::setUrl (const juce::String& url)
{
    qrCode.setUrl (url);
    urlLabel.setText (url, juce::dontSendNotification);
}

void ConnectPage::paint (juce::Graphics& g)
{
    g.fillAll (Theme::black);

    // Gold border around QR code
    if (! qrCode.getBounds().isEmpty())
    {
        g.setColour (Theme::gold);
        g.drawRect (qrCode.getBounds().expanded (Theme::borderWidth), Theme::borderWidth);
    }
}

void ConnectPage::resized()
{
    auto area = getLocalBounds().reduced (Theme::pagePadding);

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
