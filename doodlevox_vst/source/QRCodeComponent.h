#pragma once

#include <JuceHeader.h>

/**
 * Renders a QR code for the given URL string using the nayuki QR-Code-generator
 * library.  The quiet zone (4-module border) is included automatically.
 */
class QRCodeComponent : public juce::Component
{
public:
    explicit QRCodeComponent (const juce::String& url = {});

    /** Replace the encoded URL and repaint. */
    void setUrl (const juce::String& url);

    void paint (juce::Graphics& g) override;

private:
    juce::String currentUrl;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (QRCodeComponent)
};
