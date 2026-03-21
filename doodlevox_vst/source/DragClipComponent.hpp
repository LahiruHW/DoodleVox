//
//  DragClipComponent.hpp
//  doodlevox_vst
//
//  Created by Lahiru Hasaranga Weliwitiya on 2026-03-21.
//  Copyright © 2026 CreatedByCAPSLOCK. All rights reserved.
//

#ifndef DragClipComponent_hpp
#define DragClipComponent_hpp

#include <stdio.h>
#include <JuceHeader.h>
#include "PluginProcessor.h"

class DragClipComponent : public juce::Component
{
public:
    DragClipComponent(DoodleVoxVSTAudioProcessor& p);

    void paint(juce::Graphics& g) override;
    void mouseDown(const juce::MouseEvent&) override;

private:
    DoodleVoxVSTAudioProcessor& processor;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (DragClipComponent)
};


#endif /* DragClipComponent_hpp */
