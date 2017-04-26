//
//  MIDIControlChange.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIControl: MIDIChannelEvent, MIDIParameterEvent {
    
    public var channel: MIDIChannel
    
    public var controller: MIDIParameter
    
    public var value: MIDIParameter
    
    public var time: MIDITime
    
    public var duration: MIDIDuration
    
    public init(channel: MIDIChannel = .zero, controller: MIDIParameter, value: MIDIParameter, time: MIDITime = .now, duration: MIDIDuration = .instant) {
        self.channel = channel
        self.controller = controller
        self.value = value
        self.time = time
        self.duration = duration
    }
    
}

extension MIDIControl {
    
    public var packets: [MIDIPacket] {
        if duration == .instant {
            return [
                MIDIPacket(.controlChange(channel: UInt8(channel.value), controller: UInt8(controller.value), value: UInt8(value.value)), delay: time.value)
            ]
        } else {
            return [
                MIDIPacket(.controlChange(channel: UInt8(channel.value), controller: UInt8(controller.value), value: UInt8(value.value)), delay: time.value),
                /// Need to add a ramp, and startValue/endValue
                MIDIPacket(.controlChange(channel: UInt8(channel.value), controller: UInt8(controller.value), value: UInt8(value.value)), delay: (time + duration).value)
            ]
        }
    }
    
}
