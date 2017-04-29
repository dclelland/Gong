//
//  MIDINote.swift
//  Gong
//
//  Created by Daniel Clelland on 20/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDINote {
    
    public var channel: Int
    
    public var key: Int
    
    public var velocity: Int
    
    public var delay: Double
    
    public var duration: Double
    
    public init(channel: Int = 0, key: Int, velocity: Int = 64, delay: Double = 0.0, duration: Double = 1.0) {
        self.channel = channel
        self.key = key
        self.velocity = velocity
        self.delay = delay
        self.duration = duration
    }

}

extension MIDINote: MIDIEvent {
    
    public var packets: [MIDIPacket] {
        return [
            MIDIPacket(.noteOn(channel: UInt8(channel), key: UInt8(key), velocity: UInt8(velocity)), delay: delay),
            MIDIPacket(.noteOff(channel: UInt8(channel), key: UInt8(key), velocity: UInt8(velocity)), delay: delay + duration)
        ]
    }
    
}
