#include "QRCodeComponent.h"
#include "qrcodegen.hpp"

QRCodeComponent::QRCodeComponent (const juce::String& url)
    : currentUrl (url)
{
}

void QRCodeComponent::setUrl (const juce::String& url)
{
    currentUrl = url;
    repaint();
}

void QRCodeComponent::paint (juce::Graphics& g)
{
    // Always paint a white background (QR spec requires a light quiet zone).
    g.fillAll (juce::Colours::white);

    if (currentUrl.isEmpty())
        return;

    try
    {
        const auto qr = qrcodegen::QrCode::encodeText (
            currentUrl.toRawUTF8(),
            qrcodegen::QrCode::Ecc::MEDIUM);

        const int qrSize      = qr.getSize();
        const int border      = 2; // quiet zone in modules
        const int totalModules = qrSize + 2 * border;

        const float moduleSize = static_cast<float> (juce::jmin (getWidth(), getHeight()))
                                 / static_cast<float> (totalModules);

        // Centre the QR matrix inside the component bounds.
        const float xOffset = (static_cast<float> (getWidth())  - moduleSize * totalModules) * 0.5f;
        const float yOffset = (static_cast<float> (getHeight()) - moduleSize * totalModules) * 0.5f;

        g.setColour (juce::Colours::black);
        for (int y = 0; y < qrSize; ++y)
        {
            for (int x = 0; x < qrSize; ++x)
            {
                if (qr.getModule (x, y))
                {
                    g.fillRect (xOffset + static_cast<float> (x + border) * moduleSize,
                                yOffset + static_cast<float> (y + border) * moduleSize,
                                moduleSize,
                                moduleSize);
                }
            }
        }
    }
    catch (...) { /* silently ignore encoding errors */ }
}
