//
//  ViewController.swift
//  Gong-macOS
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Cocoa
import Gong
import Runes

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
        
        MIDI.addObserver(self)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        MIDI.removeObserver(self)
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
    
    var output: MIDIOutput? {
        return MIDI.output
    }
    
    func sendNoteOnEvent(key: MIDIKey) {
        guard let device = device, let output = output else {
            return
        }
        
        let sequence = (0..<5).map { index in
            return MIDINote(
                key: key + MIDIInterval(index),
                time: .now + MIDITime(index)
            )
        }
        
        let transposed = sequence.transposed(up: .P5).chorded(with: .maj)
        
        device.send(transposed, via: output)
    }
    
    func sendNoteOffEvent(key: MIDIKey) {
//        for key in key.chord(.P1, .P5, .P8) {
//            let message = MIDIMessage(.noteOff(channel: 0, key: UInt8(key.number), velocity: 100))
//            device?.send(message)
//        }
    }
    
}

extension ViewController: MIDIObserver {
    
    func receive(_ notification: MIDINotification) {
        print(notification)
    }
    
    func receive(_ packet: MIDIPacket, from source: MIDISource) {
        switch packet.message {
        case .noteOn, .noteOff, .controlChange, .pitchBendChange:
            print(packet, source)
        default:
            break
        }
    }
    
}
