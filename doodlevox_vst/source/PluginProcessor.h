#pragma once

#include <JuceHeader.h>

#if JUCE_WINDOWS
 #include <windows.h>
#endif

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

    /** Returns "http://<local-ip>:<port>?token=..." once the server is listening, or empty string
        if the server hasn't bound a port yet (e.g. still starting up or all ports are in use). */
    juce::String getServerUrl() const
    {
        const int port = serverPort.load();
        if (port == 0) return {};
        return "http://" + getLanIpAddress() + ":" + juce::String (port) + "?token=" + sessionToken;
    }

    /** Picks the best LAN IPv4 address, skipping loopback (127.x) and APIPA link-local
        (169.254.x) addresses that Windows commonly returns from virtual or unconnected adapters.
        Prefers 192.168.x.x, then 10.x.x.x, then any other routable address. */
    static juce::String getLanIpAddress()
    {
        const auto addresses = juce::IPAddress::getAllAddresses (false); // IPv4 only

        juce::String fallback;

        for (const auto& addr : addresses)
        {
            const auto s = addr.toString();

            if (s.startsWith ("127."))    continue; // loopback
            if (s.startsWith ("169.254.")) continue; // APIPA / link-local

            if (s.startsWith ("192.168.")) return s; // most common home/office Wi-Fi — take immediately
            if (s.startsWith ("10."))       return s; // corporate LAN

            if (fallback.isEmpty())
                fallback = s; // 172.x or anything else — keep as last resort
        }

        if (fallback.isNotEmpty()) return fallback;

        return juce::IPAddress::getLocalAddress().toString(); // ultimate fallback
    }

    enum class ReceiverState { Idle , Receiving };
    std::atomic<ReceiverState> receiverState { ReceiverState::Idle };
    juce::File lastReceivedFile;
    std::atomic<bool> newFileReady { false };
    std::atomic<bool> clientEverConnected { false };
    std::atomic<bool> sessionActive { false };
    std::atomic<int>  serverPort { 0 }; // 0 = not yet listening
    std::atomic<bool> firewallRuleAdded { false }; // Windows only; false = needs manual firewall config
    juce::String sessionToken;
    juce::File sessionDir;

private:

    class ServerThread : public juce::Thread
    {
    public:
        ServerThread(DoodleVoxVSTAudioProcessor& p)
                : Thread("VoiceBridgeServer"), processor(p) {}

        void run() override
        {
            juce::StreamingSocket server;

            // Port 5000 is often in Windows' excluded dynamic port range; try a
            // short range so we always land on a free port.
            int portNum = -1;
            for (int tryPort = 5000; tryPort <= 5010 && !threadShouldExit(); ++tryPort)
            {
                if (server.createListener (tryPort))
                {
                    portNum = tryPort;
                    break;
                }
            }

            if (portNum < 0)
            {
                DBG("Failed to create server on any port (5000-5010)");
                return;
            }

            processor.serverPort = portNum;
            DBG("Server listening on " + juce::IPAddress::getLocalAddress().toString() + ":" + juce::String(portNum));

           #if JUCE_WINDOWS
            processor.firewallRuleAdded = ensureWindowsFirewallRule();
            if (!processor.firewallRuleAdded)
                DBG("WARNING: No Windows Firewall rule for DoodleVox — reinstall the plugin, "
                    "run the DAW as Administrator once, or add a manual inbound TCP allow "
                    "rule for ports 5000-5010.");
           #endif

            while (!threadShouldExit())
            {
                std::unique_ptr<juce::StreamingSocket> client(server.waitForNextConnection());
                if (client != nullptr)
                    handleClient(client.get());
            }
        }
        
        
    private:

       #if JUCE_WINDOWS
        // Ensure an inbound allow rule exists for the DoodleVox port range.
        // The rule is normally created by the installer (which runs elevated);
        // checking for it needs no admin rights, but adding it does — so if the
        // check fails and the DAW isn't elevated, returns false and the user must
        // reinstall or add the rule manually.
        static bool ensureWindowsFirewallRule() noexcept
        {
            auto runAndWait = [](std::wstring cmd) noexcept -> DWORD
            {
                try
                {
                    STARTUPINFOW si{};
                    si.cb = sizeof si;
                    PROCESS_INFORMATION pi{};

                    if (!CreateProcessW (nullptr, &cmd[0],
                                         nullptr, nullptr, FALSE,
                                         CREATE_NO_WINDOW,
                                         nullptr, nullptr, &si, &pi))
                        return (DWORD)-1;

                    WaitForSingleObject (pi.hProcess, 5000);
                    DWORD exitCode = (DWORD)-1;
                    GetExitCodeProcess (pi.hProcess, &exitCode);
                    CloseHandle (pi.hProcess);
                    CloseHandle (pi.hThread);
                    return exitCode;
                }
                catch (...) { return (DWORD)-1; }
            };

            // 'show rule' needs no elevation; exit code 0 = the rule already
            // exists (created by the installer or a previous elevated run).
            if (runAndWait (L"cmd.exe /c netsh advfirewall firewall show rule "
                            L"name=\"DoodleVox\"") == 0)
                return true;

            // No rule yet — try to add one; exit code 0 = success,
            // non-zero = the DAW isn't running with admin rights.
            DWORD result = runAndWait (L"cmd.exe /c netsh advfirewall firewall add rule "
                                       L"name=\"DoodleVox\" dir=in action=allow "
                                       L"protocol=TCP localport=5000-5010 "
                                       L"profile=any");
            return result == 0;
        }
       #endif

        void handleClient(juce::StreamingSocket* socket)
        {
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
            
            auto lines = juce::StringArray::fromLines(headerString);
            
            if (lines.isEmpty()) return;
            
            // ==================================================================================
            // PARSE REQUEST LINE & VALIDATE SESSION TOKEN =====================================
            // ==================================================================================
            
            auto requestLine = lines[0];
            auto method = requestLine.upToFirstOccurrenceOf(" ", false, false).trim();
            auto urlPart = requestLine.fromFirstOccurrenceOf(" ", false, false)
                                      .upToFirstOccurrenceOf(" ", false, false).trim();
            
            juce::String requestToken;
            if (urlPart.contains("token="))
            {
                requestToken = urlPart.fromFirstOccurrenceOf("token=", false, false);
                if (requestToken.contains("&"))
                    requestToken = requestToken.upToFirstOccurrenceOf("&", false, false);
            }
            
            if (requestToken != processor.sessionToken)
            {
                DBG("Invalid session token: " + requestToken);
                const char* resp = "HTTP/1.1 403 Forbidden\r\nContent-Length: 9\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nForbidden";
                socket->write(resp, (int)strlen(resp));
                return;
            }
            
            processor.clientEverConnected = true;
            processor.sessionActive = true;
            
            // ==================================================================================
            // HANDLE GET (HANDSHAKE) ==========================================================
            // ==================================================================================
            
            if (method.equalsIgnoreCase("GET"))
            {
                DBG("Handshake successful");
                const char* resp = "HTTP/1.1 200 OK\r\nContent-Length: 9\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nConnected";
                socket->write(resp, (int)strlen(resp));
                return;
            }
            
            if (!method.equalsIgnoreCase("POST"))
            {
                const char* resp = "HTTP/1.1 405 Method Not Allowed\r\nContent-Length: 18\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nMethod Not Allowed";
                socket->write(resp, (int)strlen(resp));
                return;
            }
            
            processor.receiverState = ReceiverState::Receiving;
            DBG("Receiving audio upload...");
            
            // ==================================================================================
            // VALIDATING PAYLOAD (using Content-Length) ========================================
            // ==================================================================================

            // Extract Content-Length
            int contentLength = 0;
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
                const char* resp = "HTTP/1.1 400 Bad Request\r\nContent-Length: 3\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nErr";
                socket->write(resp, (int)strlen(resp));
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

                audioData.append(buffer, (size_t) bytesRead);
                remaining -= bytesRead;
            }

            DBG("Received raw audio bytes: " + juce::String(audioData.getSize()));
            
            // ==================================================================================
            // DECODE AUDIO (ANY FORMAT)
            // ==================================================================================

            juce::AudioFormatManager formatManager;
            formatManager.registerBasicFormats();
           #if JUCE_MAC || JUCE_IOS
            formatManager.registerFormat(new juce::CoreAudioFormat(), true);
           #elif JUCE_WINDOWS
            formatManager.registerFormat(new juce::WindowsMediaAudioFormat(), true);
           #endif

            auto memStream = std::make_unique<juce::MemoryInputStream>(audioData, false);

            std::unique_ptr<juce::AudioFormatReader> reader(
                formatManager.createReaderFor(std::move(memStream)));

            if (reader == nullptr)
            {
                DBG("Unsupported or invalid audio format");
                const char* resp = "HTTP/1.1 415 Unsupported Media Type\r\nContent-Length: 16\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nUnsupported format";
                socket->write(resp, (int)strlen(resp));
                processor.receiverState = ReceiverState::Idle;
                return;
            }

            DBG("Detected format: " + reader->getFormatName());
            
            
            // ==================================================================================
            // WRITE AS WAV
            // ==================================================================================

            juce::File outputFile = processor.sessionDir.getChildFile("clip.wav");

            if (outputFile.existsAsFile())
                outputFile.deleteFile();

            auto outStream = outputFile.createOutputStream();

            if (outStream == nullptr)
            {
                DBG("Failed to create output stream");
                processor.receiverState = ReceiverState::Idle;
                return;
            }

            juce::WavAudioFormat wavFormat;

            // release() transfers ownership to the writer — avoids double-free
            // since createWriterFor takes a raw ptr but also owns/deletes the stream
            std::unique_ptr<juce::AudioFormatWriter> writer (
                wavFormat.createWriterFor (
                    outStream.release(),
                    reader->sampleRate,
                    (unsigned int) reader->numChannels,
                    16,
                    {},
                    0));

            if (writer == nullptr)
            {
                DBG("Failed to create WAV writer");
                processor.receiverState = ReceiverState::Idle;
                return;
            }

            juce::AudioBuffer<float> bufferData(
                (int) reader->numChannels,
                (int) reader->lengthInSamples);

            reader->read(&bufferData,
                         0,
                         bufferData.getNumSamples(),
                         0,
                         true,
                         true);

            writer->writeFromAudioSampleBuffer(bufferData,
                                               0,
                                               bufferData.getNumSamples());

            writer.reset();  // flush and close the file
            reader.reset();

            DBG("Audio saved to: " + outputFile.getFullPathName());

            // Send HTTP 200 OK before signalling the UI so the mobile client
            // receives confirmation before the connection closes.
            const char* okResp = "HTTP/1.1 200 OK\r\nContent-Length: 2\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nOK";
            socket->write(okResp, (int)strlen(okResp));

            processor.lastReceivedFile = outputFile;
            processor.newFileReady = true;
            processor.receiverState = ReceiverState::Idle;
        }
        
        DoodleVoxVSTAudioProcessor& processor;
        
    };

    ServerThread serverThread { *this };

    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (DoodleVoxVSTAudioProcessor)
};
