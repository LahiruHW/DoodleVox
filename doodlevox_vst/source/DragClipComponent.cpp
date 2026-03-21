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
    g.fillAll(juce::Colours::darkgrey);
    g.setColour(juce::Colours::white);

    g.drawFittedText("Drag Clip To DAW",
                     getLocalBounds(),
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
