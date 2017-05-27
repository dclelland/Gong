//
//  ViewController.swift
//  Gong-macOS
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Cocoa
import CoreMIDI
import Gong
import AudioToolbox
import AVFoundation

// https://github.com/AlesTsurko/LearningCoreAudioWithSwift2.0/blob/master/CH02_CAToneFileGenerator/CAToneFileGenerator/main.swift

class ViewController: NSViewController {

    override func viewWillAppear() {
        super.viewWillAppear()
        
        MIDI.addObserver(self)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        do {
            let url = Bundle.main.url(forResource: "narkopop_1", withExtension: "mp3")!
            let audioFile = try AudioFile.open(url)
            
            if let fileFormat = audioFile.fileFormat {
                print("File format:", fileFormat)
            }
            
            if let dataFormat = audioFile.dataFormat {
                print("Data format:", dataFormat)
            }
            
            if let properties = audioFile.properties {
                print("Properties:", properties)
            }
            
            if let tableInfo: [AudioFilePacketTableInfo] = try? audioFile.array(for: AudioFile.Property.packetTableInfo) {
                print("Packet table info:", tableInfo)
            }
            
            try audioFile.close()
        } catch let error {
            print(error)
        }
//
//        do {
//            let url = Bundle.main.resourceURL!.appendingPathComponent("square.aiff")
//            
//            print(url)
//            
//            let sampleRate: Float64 = 44_100
//            let duration: Float64 = 5
//            let frequency: Double = 50.0
//            
//            let format = Int16.audioStreamDescription(sampleRate: sampleRate, format: kAudioFormatLinearPCM)
//            
//            let audioFile = try AudioFile(url, type: kAudioFileAIFFType, format: format, flags: .eraseFile)
//            
//            
//            let maximumSampleCount = Int64(sampleRate * duration)
//            var sampleCount: Int64 = 0
//            let bytesToWrite: UInt32 = 2
//            let wavelengthInSamples = Int(Double(sampleRate) / frequency)
//            
//            
//            while sampleCount < maximumSampleCount {
//                for i in 0..<wavelengthInSamples {
//                    // Square wave
//                    var sample = i < wavelengthInSamples / 2 ? (Int16.max).bigEndian : (Int16.min).bigEndian
//                    
//                    // Saw wave
////                    var sample = Int16(((Double(i) / Double(wavelengthInSamples)) * Double(Int16.max) * 2) - Double(Int16.max)).bigEndian
//                    
//                    // Sine wave
////                    var sample = Int16(Double(Int16.max) * sin(2 * .pi * (Double(i) / Double(wavelengthInSamples)))).bigEndian
//                    
//                    try audioFile.writeBytes(from: &sample, start: Int64(sampleCount * 2), count: bytesToWrite)
//                    
//                    sampleCount += 1
//                }
//            }
//            
//            
//            try audioFile.close()
//        } catch let error {
//            print(error)
//        }
        
        do {
            let specifier = AudioFileTypeAndFormatID(
                mFileType: kAudioFileAIFFType,
                mFormatID: kAudioFormatLinearPCM
            )
            
            let formats: [AudioStreamBasicDescription] = try AudioFile.array(for: AudioFile.GlobalProperty.availableStreamDescriptionsForFormat, specifier: specifier)
            
            print("Formats:", formats)
        } catch let error {
            print(error)
        }
        
        do {
            let deviceID: AudioDeviceID = try AudioObject.system.value(for: AudioObjectPropertyAddress(
                mSelector: kAudioHardwarePropertyDefaultInputDevice,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: 0
            ))

            print("DEVICE A", deviceID)

            let sampleRate: Double = try AudioObject(deviceID).value(for: AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyNominalSampleRate,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: 0
            ))
            
            print("SAMPLE RATE", sampleRate)
            
            var recorderFormat = AudioStreamBasicDescription(
                mSampleRate: sampleRate,
                mFormatID: kAudioFormatMPEG4AAC,
                mFormatFlags: 0,
                mBytesPerPacket: 0,
                mFramesPerPacket: 0,
                mBytesPerFrame: 0,
                mChannelsPerFrame: 0,
                mBitsPerChannel: 0,
                mReserved: 0
            )
            
            var recorderFormatSize = UInt32(MemoryLayout.size(ofValue: recorderFormat))
            
            try AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, nil, &recorderFormatSize, &recorderFormat).audioError("getting recorder format")
            
//            recorderFormat = try AudioFormat.value(for: AudioFormat.Property.formatInfo)
            
            print("recorder format", recorderFormat)
            
            
            let url = Bundle.main.resourceURL!.appendingPathComponent("packets.caf")
            let audioFile = try AudioFile(url, type: kAudioFileCAFType, format: recorderFormat, flags: .eraseFile)
            
            
            struct Recorder {
                let file: AudioFile
                var packet: Int64 = 0
                var running: Bool = false

                init(file: AudioFile) {
                    self.file = file
                }
            }
            
            let recorder = Recorder(file: audioFile)
            
            let queue = try AudioQueue.createInput(format: recorderFormat) { (queue, buffer, timeStamp, packetDescriptions) in
                print("recorder", recorder)
            }
            
            let outputStreamDescription: AudioStreamBasicDescription = try queue.value(for: kAudioConverterCurrentOutputStreamDescription)
            print("output stream description", outputStreamDescription)
            
            try queue.set(value: 1, for: AudioQueue.Property.enableLevelMetering)
//            kAudioConverterCompressionMagicCookie
            let cookie: UnsafeMutablePointer<UInt8> = try queue.value(for: AudioQueue.Property.magicCookie)
            
            try audioFile.set(value: cookie, for: AudioFile.Property.magicCookieData) // this is erroring atm
            
//            
//            // Other set up as needed
//            let bufferByteSize = ComputeRecordBufferSize(recordFormat, queue: queue, seconds: 0.5)
//            
//            for _ in 0..<kNumberRecordBuffers {
//                var buffer = AudioQueueBufferRef()
//                error = AudioQueueAllocateBuffer(queue, UInt32(bufferByteSize), &buffer)
//                
//                CheckError(error, operation: "AudioQueueAllocateBuffer failed")
//                
//                error = AudioQueueEnqueueBuffer(queue, buffer, 0, nil)
//                
//                CheckError(error, operation: "AudioQueueEnqueueBuffer failed")
//            }
//            
//            // Start queue
//            recorder.running = true
//            
//            error = AudioQueueStart(queue, nil)
//            
//            CheckError(error, operation: "AudioQueueStart failed")
//            
//            print("Recording, press <return> to stop:\n")
//            getchar()
//            
//            // Stop queue
//            print("* recording done *\n")
//            
//            recorder.running = false
//            
//            error = AudioQueueStop(queue, true)
//            
//            CheckError(error, operation: "AudioQueueStop failed")
//            
//            CopyEncoderCookieToFile(queue, theFile: recorder.recordFile)
//            
//            AudioQueueDispose(queue, true)
//            AudioFileClose(recorder.recordFile)
            
            
            
            
            
            
        } catch let error {
            print(error)
        }
        
        
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        MIDI.removeObserver(self)
    }
    
    @IBAction func buttonClick(_ button: NSButton) {
        switch button.title {
        case "C":
            playNote(60)
        case "D":
            playNote(62)
        case "E":
            playNote(64)
        case "F":
            playNote(65)
        case "G":
            playNote(67)
        case "A":
            playNote(69)
        case "B":
            playNote(71)
        default:
            break
        }
    }

}

extension ViewController {
    
    func playNote(_ key: Int) {
        guard let output = MIDI.output else {
            return
        }
        
        let note = MIDINote(key: key)
        
        for device in MIDIDevice.all {
            device.send(note, via: output)
        }
    }
    
}

extension ViewController: MIDIObserver {
    
    func receive(_ notice: MIDINotice) {
        print(notice)
    }
    
    func receive(_ packet: MIDIPacket, from source: MIDISource) {
        switch packet.message {
        case .noteOn, .noteOff, .controlChange, .pitchBendChange:
            print(packet.message, source)
        default:
            break
        }
    }
    
}
