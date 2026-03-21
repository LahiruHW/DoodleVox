#pragma once

#include <JuceHeader.h>

//==============================================================================
class DoodleVoxVSTAudioProcessor final : public juce::AudioProcessor
{
public:
    //==============================================================================
    DoodleVoxVSTAudioProcessor();
    ~DoodleVoxVSTAudioProcessor() override;

    //==============================================================================
    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;

    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;
    using AudioProcessor::processBlock;

    //==============================================================================
    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    //==============================================================================
    const juce::String getName() const override;

    bool acceptsMidi() const override;
    bool producesMidi() const override;
    bool isMidiEffect() const override;
    double getTailLengthSeconds() const override;

    //==============================================================================
    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram (int index) override;
    const juce::String getProgramName (int index) override;
    void changeProgramName (int index, const juce::String& newName) override;

    //==============================================================================
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;

    enum class ReceiverState { Idle , Receiving };
    std::atomic<ReceiverState> receiverState { ReceiverState::Idle };
    juce::File lastReceivedFile;
    std::atomic<bool> newFileReady { false };

private:

    class ServerThread : public juce::Thread
    {
    public:
        ServerThread(DoodleVoxVSTAudioProcessor& p)
                : Thread("VoiceBridgeServer"), processor(p) {}

        void run() override
        {
            juce::StreamingSocket server;
            
            int portNum = 5000;
            
            if (!server.createListener(portNum))
            {
                DBG("Failed to create server");
                return;
            }

            // DBG("Server listening on port 5000");
            DBG("Server listening on " + juce::IPAddress::getLocalAddress().toString() + ":" + juce::String(portNum));

            while (!threadShouldExit())
            {
                std::unique_ptr<juce::StreamingSocket> client(server.waitForNextConnection());
                if (client != nullptr)
                    handleClient(client.get());
            }
        }
        
        
    private:

        void handleClient(juce::StreamingSocket* socket)
        {
            
            processor.receiverState = ReceiverState::Receiving;
            DBG("Client connected");
            
            // ==================================================================================
            // RECEIVING HEADER =================================================================
            // ==================================================================================
            
            juce::MemoryBlock headerData;
            char c;
            
            // Read header byte-by-byte until "\r\n\r\n"
            while (socket->read(&c, 1, true) > 0)
            {
                headerData.append(&c, 1);
                auto size = headerData.getSize();
                auto data = static_cast<const char*>(headerData.getData());

                if (size >= 4 &&
                    data[size-4] == '\r' &&
                    data[size-3] == '\n' &&
                    data[size-2] == '\r' &&
                    data[size-1] == '\n')
                {
                    break;
                }
            }
            
            juce::String headerString(
                static_cast<const char*>(headerData.getData()),
                headerData.getSize());

            DBG("HEADERS:\n" + headerString);
            
            // ==================================================================================
            // VALIDATING PAYLOAD (using Conent-Length) =========================================
            // ==================================================================================

            // Extract Content-Length
            int contentLength = 0;
            auto lines = juce::StringArray::fromLines(headerString);
            for (auto& line : lines)
            {
                if (line.startsWithIgnoreCase("Content-Length:"))
                {
                    contentLength = line.fromFirstOccurrenceOf(":", false, false)
                                        .trim()
                                        .getIntValue();
                }
            }
            if (contentLength <= 0)
            {
                DBG("Invalid content length");
                return;
            }
            DBG("Content-Length = " + juce::String(contentLength));
            
        //    // ==================================================================================
        //    // RECEIVING BODY (I.E. THE AUDIO FILE) =============================================
        //    // ==================================================================================
           
        //    auto filename =
        //            "clip_" + juce::Time::getCurrentTime().toString(true, true) + ".wav";
           
        //    juce::File outputFile =
        //            juce::File::getSpecialLocation(juce::File::tempDirectory)
        //            .getChildFile(filename);
           
        //    juce::FileOutputStream stream(outputFile);

        //    if (!stream.openedOk())
        //        return;

        //    int remaining = contentLength;
        //    char buffer[4096];
        //    while (remaining > 0)
        //    {
        //        int bytesToRead = juce::jmin(remaining, (int)sizeof(buffer));
        //        int bytesRead = socket->read(buffer, bytesToRead, true);
        //        if (bytesRead <= 0)
        //            break;
        //        stream.write(buffer, bytesRead);
        //        remaining -= bytesRead;
        //    }

        //    // saving the audio to a file
        //    stream.flush();
        //    DBG("Audio saved to: " + outputFile.getFullPathName());
        //    outputFile.revealToUser();
        //    processor.lastReceivedFile = outputFile;
        //    processor.newFileReady = true;
        //    processor.receiverState = ReceiverState::Idle;
            

            // ==================================================================================
            // READ BODY INTO MEMORY (instead of writing directly)
            // ==================================================================================

            juce::MemoryBlock audioData;

            int remaining = contentLength;
            char buffer[4096];

            while (remaining > 0)
            {
                int bytesToRead = juce::jmin(remaining, (int)sizeof(buffer));
                int bytesRead = socket->read(buffer, bytesToRead, true);
                if (bytesRead <= 0)
                    break;

                audioData.append(buffer, bytesRead);
                remaining -= bytesRead;
            }

            DBG("Received raw audio bytes: " + juce::String(audioData.getSize()));
            
            // ==================================================================================
            // DECODE AUDIO (ANY FORMAT)
            // ==================================================================================

            juce::AudioFormatManager formatManager;
            formatManager.registerBasicFormats();

            auto memStream = std::make_unique<juce::MemoryInputStream>(audioData, false);

            std::unique_ptr<juce::AudioFormatReader> reader(
                formatManager.createReaderFor(std::move(memStream)));

            if (reader == nullptr)
            {
                DBG("Unsupported or invalid audio format");
                processor.receiverState = ReceiverState::Idle;
                return;
            }

            DBG("Detected format: " + reader->getFormatName());
            
            
            // ==================================================================================
            // WRITE AS WAV
            // ==================================================================================

            auto filename =
                "clip_" + juce::Time::getCurrentTime().formatted("%Y%m%d_%H%M%S") + ".wav";

            juce::File outputFile =
                juce::File::getSpecialLocation(juce::File::tempDirectory)
                .getChildFile(filename);

            auto outStream = outputFile.createOutputStream();

            if (outStream == nullptr)
            {
                DBG("Failed to create output stream");
                processor.receiverState = ReceiverState::Idle;
                return;
            }

            juce::WavAudioFormat wavFormat;
            
            std::unique_ptr<juce::AudioFormatWriter> writer(
                wavFormat.createWriterFor(
                    outStream.get(),
                    reader->sampleRate,
                    (unsigned int) reader->numChannels,
                    16,
                    {},
                    0)
            );

            if (writer == nullptr)
            {
                DBG("Failed to create WAV writer");
                processor.receiverState = ReceiverState::Idle;
                return;
            }

            outStream.release(); // writer owns stream now

            juce::AudioBuffer<float> bufferData(
                reader->numChannels,
                (int)reader->lengthInSamples);

            reader->read(&bufferData,
                         0,
                         bufferData.getNumSamples(),
                         0,
                         true,
                         true);

            writer->writeFromAudioSampleBuffer(bufferData,
                                               0,
                                               bufferData.getNumSamples());

            DBG("Audio saved to: " + outputFile.getFullPathName());
            outputFile.revealToUser();
            processor.lastReceivedFile = outputFile;
            processor.newFileReady = true;
            processor.receiverState = ReceiverState::Idle;
            
        };
        
        DoodleVoxVSTAudioProcessor& processor;
        
    };

    ServerThread serverThread { *this };

    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (DoodleVoxVSTAudioProcessor)
};
