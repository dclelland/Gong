//
//  MIDIEvent.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

extension MIDIDevice {
    
    public func send(_ event: MIDIEvent, via output: MIDIPort<Output>? = MIDI.output) {
        for packet in event.packets {
            send(packet, via: output)
        }
    }
    
    public func send(_ events: [MIDIEvent], via output: MIDIPort<Output>? = MIDI.output) {
        for event in events {
            send(event, via: output)
        }
    }

}

public protocol MIDIEvent {
    
    var time: MIDITime { set get }
    
    var duration: MIDIDuration { set get }
    
    var packets: [MIDIPacket] { get }
    
}
