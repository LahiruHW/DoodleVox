//
//  DragClipComponent.cpp
//  doodlevox_vst
//
//  Created by Lahiru Hasaranga Weliwitiya on 2026-03-21.
//  Copyright © 2026 CreatedByCAPSLOCK. All rights reserved.
//

#include "DragClipComponent.hpp"
#include "Theme.h"
#include <JuceHeader.h>

DragClipComponent::DragClipComponent(DoodleVoxVSTAudioProcessor& p)
    : processor(p)
{
}

void DragClipComponent::paint(juce::Graphics& g)
{
    g.fillAll(Theme::darkGrey);

    // Gold border to indicate draggable area
    g.setColour(Theme::gold);
    g.drawRect(getLocalBounds(), Theme::borderWidth);

    g.setColour(Theme::white);
    g.setFont(juce::FontOptions(Theme::fontLabel));
    g.drawFittedText("Drag clip to DAW",
                     getLocalBounds().reduced(4),
                     juce::Justification::centred,
                     1);
}

void DragClipComponent::mouseDrag(const juce::MouseEvent&)
{
    if (processor.lastReceivedFile.existsAsFile())
    {
        juce::StringArray files;
        files.add(processor.lastReceivedFile.getFullPathName());

        if (auto* container =
            juce::DragAndDropContainer::findParentDragContainerFor(this))
        {
            container->performExternalDragDropOfFiles(files, true, this);
        }
    }
}
