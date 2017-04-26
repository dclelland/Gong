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
    
    var packets: [MIDIPacket] { get }
    
}

public protocol MIDIChannelEvent: MIDIEvent {
    
    var channel: MIDIChannel { set get }
    
}

public protocol MIDITimeEvent: MIDIEvent {
    
    var time: MIDITime { set get }
    
}

public protocol MIDIDurationEvent: MIDITimeEvent {
    
    var duration: MIDIDuration { set get }
    
}

public protocol MIDIValueEvent: MIDIEvent {
    
    var value: MIDIValue { set get }
    
}
