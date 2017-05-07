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

// https://github.com/AlesTsurko/LearningCoreAudioWithSwift2.0/blob/master/CH02_CAToneFileGenerator/CAToneFileGenerator/main.swift

class ViewController: NSViewController {

    override func viewWillAppear() {
        super.viewWillAppear()
        
        MIDI.addObserver(self)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
//        do {
//            let url = Bundle.main.url(forResource: "narkopop_1", withExtension: "mp3")!
//            let audioFile = try AudioFile.open(url)
//            
//            if let fileFormat = audioFile.fileFormat {
//                print("File format:", fileFormat)
//            }
//            
//            if let dataFormat = audioFile.dataFormat {
//                print("Data format:", dataFormat)
//            }
//            
//            if let properties = audioFile.properties {
//                print("Properties:", properties)
//            }
//            
//            if let magicCookie: UnsafeRawPointer = try? audioFile.value(for: AudioFile.Property.magicCookieData) {
//                
//                print("Magic cookie:", magicCookie)
//            }
//            
//            try audioFile.close()
//        } catch let error {
//            print(error)
//        }
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
            
            let formats: [AudioStreamBasicDescription] = try AudioFile.globalInfoArray(for: AudioFile.GlobalInfoProperty.availableStreamDescriptionsForFormat, specifier: specifier)
            
            print("FORMATS:", formats)
            
            
//            let absds = try AudioFile.globalInfo(for: kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, dataSize: infoSize, specifier: specifier).audioError("test")
            
//            
//            var asbds = UnsafeMutablePointer<AudioStreamBasicDescription>.alloc(Int(infoSize))
//            
//            audioErr = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, UInt32(sizeof(fileTypeAndFormat.dynamicType)), &fileTypeAndFormat, &infoSize, asbds)
//            
//            assert(audioErr == noErr)
//            
//            let asbdsCount = Int(infoSize) / sizeof(AudioStreamBasicDescription)
//            
//            var formats = [String]()
//            
//            for i in 0..<asbdsCount {
//                var format4cc = asbds[i].mFormatID.bigEndian
//                
//                withUnsafePointer(&format4cc) {ptr in
//                    formats.append(String(format: "%d: mFormatID: %4.4s, mFormatFlags: %d, mBitsPerChannel: %d", arguments: [i, ptr, asbds[i].mFormatFlags, asbds[i].mBitsPerChannel]))
//                }
//                
//                
//            }
//            
//            formats
//            free(asbds)
            
            
            
            
            
            
            
            
            
//            print(result)
            
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
