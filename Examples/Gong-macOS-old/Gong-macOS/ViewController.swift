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

class ViewController: NSViewController {

    override func viewWillAppear() {
        super.viewWillAppear()
        
        MIDI.addObserver(self)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        MIDI.removeObserver(self)
    }
    
    @IBAction func buttonClick(_ button: NSButton) {
        switch button.title {
        case "C":
            playNote(c5)
        case "D":
            playNote(d5)
        case "E":
            playNote(e5)
        case "F":
            playNote(f5)
        case "G":
            playNote(g5)
        case "A":
            playNote(a5)
        case "B":
            playNote(b5)
        default:
            break
        }
    }

}

extension ViewController {
    
    func playNote(_ pitch: Int) {
        guard let output = MIDI.output else {
            return
        }
        
        let note = MIDINote(pitch: pitch)
        
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
