//
//  DragClipComponent.cpp
//  doodlevox_vst
//
//  Created by Lahiru Hasaranga Weliwitiya on 2026-03-21.
//  Copyright © 2026 CreatedByCAPSLOCK. All rights reserved.
//

#include "DragClipComponent.hpp"
#include <JuceHeader.h>

DragClipComponent::DragClipComponent(DoodleVoxVSTAudioProcessor& p)
    : processor(p)
{
}

void DragClipComponent::paint(juce::Graphics& g)
{
    g.fillAll(juce::Colour(0xFF1A1A1A));

    // Gold border to indicate draggable area
    g.setColour(juce::Colour(0xFFFFB800));
    g.drawRect(getLocalBounds(), 2);

    g.setColour(juce::Colours::white);
    g.setFont(juce::FontOptions(14.0f));
    g.drawFittedText("Drag clip to DAW",
                     getLocalBounds().reduced(4),
                     juce::Justification::centred,
                     1);
}

void DragClipComponent::mouseDown(const juce::MouseEvent&)
{
    if (processor.lastReceivedFile.existsAsFile())
    {
        juce::StringArray files;
        files.add(processor.lastReceivedFile.getFullPathName());

        if (auto* container =
            juce::DragAndDropContainer::findParentDragContainerFor(this))
        {
            container->performExternalDragDropOfFiles(files, true);
        }
    }
}
