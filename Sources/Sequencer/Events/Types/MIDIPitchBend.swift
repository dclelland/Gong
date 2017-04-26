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
    
    public init(channel: MIDIChannel = .zero, value: MIDIParameter = .center, time: MIDITime = .now, duration: MIDIDuration = .instant) {
        self.channel = channel
        self.value = value
        self.time = time
        self.duration = duration
    }
    
}

extension MIDIPitchBend {
    
    public var packets: [MIDIPacket] {
        if duration == .instant {
            return [
                MIDIPacket(.pitchBendChange(channel: channel.value, leastSignificantBits: 0, mostSignificantBits: value.value), delay: time.value)
            ]
        }
        
        return [
            MIDIPacket(.pitchBendChange(channel: channel.value, leastSignificantBits: 0, mostSignificantBits: value.value), delay: time.value),
            /// Need to add a ramp, and startValue/endValue
            MIDIPacket(.pitchBendChange(channel: channel.value, leastSignificantBits: 0, mostSignificantBits: value.value), delay: (time + duration).value)
        ]
    }
    
}
