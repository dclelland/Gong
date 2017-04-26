//
//  MIDIPitchBendChange.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIPitchBendChange: MIDIChannelEvent, MIDITimeEvent, MIDIValueEvent {
    
    public var channel: MIDIChannel
    
    public var value: MIDIValue
    
    public var time: MIDITime
    
    public init(channel: MIDIChannel = .zero, value: MIDIValue = .center, time: MIDITime = .now) {
        self.channel = channel
        self.value = value
        self.time = time
    }
    
}

extension MIDIPitchBendChange {
    
    public var packets: [MIDIPacket] {
        return [
            MIDIPacket(.pitchBendChange(channel: UInt8(channel.value), leastSignificantBits: 0, mostSignificantBits: UInt8(value.value)), delay: time.value)
        ]
    }
    
}
