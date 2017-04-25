//
//  MIDIControlChange.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIControl: MIDIChannelEvent, MIDITimeEvent {
    
    public var channel: MIDIChannel
    
    public var controller: MIDIValue
    
    public var value: MIDIValue
    
    public var time: MIDITime
    
}

extension MIDIControl {
    
    public var packets: [MIDIPacket] {
        return [
            MIDIPacket(.controlChange(channel: UInt8(channel.value), controller: UInt8(controller.value), value: UInt8(value.value)), delay: time.value)
        ]
    }
    
}
