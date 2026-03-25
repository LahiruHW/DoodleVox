#pragma once

#include <JuceHeader.h>
#include "QRCodeComponent.h"


/**
 * ConnectPage shows the QR code and connection instructions before a session is established. 
 * 
 * It also updates the QR code URL if the local IP changes while waiting for a connection.
 */
class ConnectPage : public juce::Component
{
public:
    ConnectPage();

    void setUrl (const juce::String& url);

    void paint (juce::Graphics& g) override;
    void resized() override;

private:
    juce::Label titleLabel;
    QRCodeComponent qrCode;
    juce::Label instructionLabel;
    juce::Label urlLabel;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (ConnectPage)
};
