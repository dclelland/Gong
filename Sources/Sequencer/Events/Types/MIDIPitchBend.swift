//
//  MIDIPitchBend.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIPitchBend: MIDIChannelEvent, MIDIParameterEvent {
    
    public var time: MIDITime
    
    public var duration: MIDIDuration
    
    public var channel: MIDIChannel
    
    public var value: MIDIParameter
    
    public init(channel: MIDIChannel = .zero, value: MIDIParameter = .center, time: MIDITime = .now, duration: MIDIDuration = .whole) {
        self.channel = channel
        self.value = value
        self.time = time
        self.duration = duration
    }
    
}

extension MIDIPitchBend {
    
    public var packets: [MIDIPacket] {
        return [
            MIDIPacket(.pitchBendChange(channel: UInt8(channel.value), leastSignificantBits: 0, mostSignificantBits: UInt8(value.value)), delay: time.value)
        ]
    }
    
}
