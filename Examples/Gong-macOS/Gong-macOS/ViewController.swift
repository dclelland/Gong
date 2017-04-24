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
    
    @IBOutlet var cButton: NSButton!
    @IBOutlet var dButton: NSButton!
    @IBOutlet var eButton: NSButton!
    @IBOutlet var fButton: NSButton!
    @IBOutlet var gButton: NSButton!
    @IBOutlet var aButton: NSButton!
    @IBOutlet var bButton: NSButton!
    
    var buttons: [NSButton] {
        return [cButton, dButton, eButton, fButton, gButton, aButton, bButton]
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        
        for button in buttons {
            button.sendAction(on: [.leftMouseDown, .leftMouseUp])
        }
        
        MIDI.addReceiver(self)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        MIDI.removeReceiver(self)
    }
    
    @IBAction func buttonClick(_ button: NSButton) {
        switch button.window?.currentEvent?.type {
        case .leftMouseDown?:
            buttonMouseDown(button)
        case .leftMouseUp?:
            buttonMouseUp(button)
        default:
            break
        }
    }
    
    func buttonMouseDown(_ button: NSButton) {
        switch button.title {
        case "C":
            sendNoteOnEvent(key: .c4)
        case "D":
            sendNoteOnEvent(key: .d4)
        case "E":
            sendNoteOnEvent(key: .e4)
        case "F":
            sendNoteOnEvent(key: .f4)
        case "G":
            sendNoteOnEvent(key: .g4)
        case "A":
            sendNoteOnEvent(key: .a4)
        case "B":
            sendNoteOnEvent(key: .b4)
        default:
            break
        }
    }
    
    func buttonMouseUp(_ button: NSButton) {
        switch button.title {
        case "C":
            sendNoteOffEvent(key: .c4)
        case "D":
            sendNoteOffEvent(key: .d4)
        case "E":
            sendNoteOffEvent(key: .e4)
        case "F":
            sendNoteOffEvent(key: .f4)
        case "G":
            sendNoteOffEvent(key: .g4)
        case "A":
            sendNoteOffEvent(key: .a4)
        case "B":
            sendNoteOffEvent(key: .b4)
        default:
            break
        }
    }

}

extension ViewController {
    
    var device: MIDIDevice? {
        return MIDIDevice(named: "minilogue")
    }
    
    func sendNoteOnEvent(key: MIDIKey) {
        let sequence = [
            MIDINote(key: key + .P1, delay: 0.0, duration: 0.1),
            MIDINote(key: key + .M2, delay: 0.1, duration: 0.1),
            MIDINote(key: key + .M3, delay: 0.2, duration: 0.1),
            MIDINote(key: key + .P4, delay: 0.3, duration: 0.1),
            MIDINote(key: key + .P5, delay: 0.4, duration: 0.1),
        ]
        
        for note in sequence {
            device?.send(note)
        }
        
//        for key in key.chord(.P1, .P5, .P8) {
//            let message = MIDIMessage(.noteOn(channel: 0, key: UInt8(key.number), velocity: 100))
//            device?.send(message)
//        }
    }
    
    func sendNoteOffEvent(key: MIDIKey) {
//        for key in key.chord(.P1, .P5, .P8) {
//            let message = MIDIMessage(.noteOff(channel: 0, key: UInt8(key.number), velocity: 100))
//            device?.send(message)
//        }
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
