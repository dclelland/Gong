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
            sendNoteOnEvent(key: 60)
        case "D":
            sendNoteOnEvent(key: 62)
        case "E":
            sendNoteOnEvent(key: 64)
        case "F":
            sendNoteOnEvent(key: 65)
        case "G":
            sendNoteOnEvent(key: 67)
        case "A":
            sendNoteOnEvent(key: 69)
        case "B":
            sendNoteOnEvent(key: 71)
        default:
            break
        }
    }
    
    func buttonMouseUp(_ button: NSButton) {
        switch button.title {
        case "C":
            sendNoteOffEvent(key: 60)
        case "D":
            sendNoteOffEvent(key: 62)
        case "E":
            sendNoteOffEvent(key: 64)
        case "F":
            sendNoteOffEvent(key: 65)
        case "G":
            sendNoteOffEvent(key: 67)
        case "A":
            sendNoteOffEvent(key: 69)
        case "B":
            sendNoteOffEvent(key: 71)
        default:
            break
        }
    }

}

extension ViewController {
    
    var device: MIDIDevice? {
        return MIDIDevice(named: "minilogue")
    }
    
    func sendNoteOnEvent(key: UInt8) {
        let message = MIDIMessage(.noteOn(channel: 0, key: key, velocity: 100), time: 1.0)
        device?.send(message)
    }
    
    func sendNoteOffEvent(key: UInt8) {
        let message = MIDIMessage(.noteOff(channel: 0, key: key, velocity: 100), time: 1.0)
        device?.send(message)
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
