//
//  ViewController.swift
//  hibiscus-macOS
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Cocoa
import Gong
import CoreMIDI

class ViewController: NSViewController {

    override func viewWillAppear() {
        super.viewWillAppear()
        
        MIDI.addReceiver(self)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        MIDI.removeReceiver(self)
    }
    
    @IBAction func buttonClick(_ button: NSButton) {
        switch button.title {
        case "C":
            sendNote(key: 60)
        case "D":
            sendNote(key: 62)
        case "E":
            sendNote(key: 64)
        case "F":
            sendNote(key: 65)
        case "G":
            sendNote(key: 67)
        case "A":
            sendNote(key: 69)
        case "B":
            sendNote(key: 71)
        default:
            break
        }
    }

}

extension ViewController {
    
    var device: MIDIDevice? {
        return MIDIDevice(named: "minilogue")
    }
    
    func sendNote(key: UInt8) {
        device?.send(MIDINote(key: key, duration: 0.5))
    }
    
}

extension ViewController: MIDIReceiver {
    
    func receive(_ event: MIDIEvent) {
        print(event)
    }
    
    func receive(_ message: MIDIMessage, from source: MIDIEndpoint<Source>) {
        switch message.type {
        case .noteOn, .noteOff, .controlChange:
            print(message, source)
        default:
            break
        }
    }
    
}
