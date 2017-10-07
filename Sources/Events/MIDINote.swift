//
//  MIDINote.swift
//  Gong
//
//  Created by Daniel Clelland on 20/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public struct MIDINote {
    
    public var channel: Int
    
    public var pitch: Int
    
    public var velocity: Int
    
    public var start: Double
    
    public var duration: Double
    
    public init(channel: Int = 0, pitch: Int, velocity: Int = 64, start: Double = 0.0, duration: Double = 1.0) {
        self.channel = channel
        self.pitch = pitch
        self.velocity = velocity
        self.start = start
        self.duration = duration
    }

}

extension MIDINote: MIDIEvent {
    
    public var packets: [MIDIPacket] {
        return [
            MIDIPacket(.noteOn(channel: UInt8(channel), key: UInt8(pitch), velocity: UInt8(velocity)), delay: onset),
            MIDIPacket(.noteOff(channel: UInt8(channel), key: UInt8(pitch), velocity: UInt8(velocity)), delay: offset)
        ]
    }
    
}

extension MIDINote {
    
    public var onset: Double {
        return min(start, start + duration)
    }
    
    public var offset: Double {
        return max(start, start + duration)
    }
    
}
