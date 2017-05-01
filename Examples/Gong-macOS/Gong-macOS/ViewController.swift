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
            
            if let properties = audioFile.properties {
                print(properties)
            }
            
            if let fileFormat: AudioFileTypeID = audioFile.value(for: AudioFile.Property.fileFormat) {
                print(fileFormat)
            }
            
            try audioFile.close()
        } catch let error {
            print(error)
        }
        
        do {
            let url = Bundle.main.resourceURL!.appendingPathComponent("square.aiff")
            
            print(url)
            
            let sampleRate: Float64 = 44_100
            let duration: Float64 = 5
            let frequency: Double = 50.0
            
            let format = Int16.audioStreamDescription(sampleRate: sampleRate, format: kAudioFormatLinearPCM)
            
            let audioFile = try AudioFile(url, type: kAudioFileAIFFType, format: format, flags: .eraseFile)
            
            
            let maximumSampleCount = Int64(sampleRate * duration)
            var sampleCount: Int64 = 0
            var bytesToWrite: UInt32 = 2
            let wavelengthInSamples = Int(Double(sampleRate) / frequency)
            
            while sampleCount < maximumSampleCount {
                for i in 0..<wavelengthInSamples {
                    var sample: UInt16 = UInt16(i)
                    
//                    var sample: UInt16 = {
//                        if i < wavelengthInSamples / 2 {
//                            return CFSwapInt16HostToBig(.max)
//                        } else {
//                            return CFSwapInt16HostToBig(.min)
//                        }
//                    }()
                    
                    try AudioFileWriteBytes(audioFile.reference, false, sampleCount * 2, &bytesToWrite, &sample).audioError("Writing bytes")
                    // this will probably not be very efficient...
                    sampleCount += 1
                }
            }
            
            try audioFile.close()
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
