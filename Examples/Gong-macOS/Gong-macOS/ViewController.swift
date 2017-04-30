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
            let url = URL(string: "~/Desktop/square.aiff")!
            
            let format = AudioStreamBasicDescription(
                mSampleRate: 44_100,
                mFormatID: kAudioFormatLinearPCM,
                mFormatFlags: kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
                mBytesPerPacket: 2,
                mFramesPerPacket: 1,
                mBytesPerFrame: 2,
                mChannelsPerFrame: 1,
                mBitsPerChannel: 16,
                mReserved: 0
            )
            
            let audioFile = try AudioFile(url, type: kAudioFileAIFFType, format: format, flags: .eraseFile)
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
