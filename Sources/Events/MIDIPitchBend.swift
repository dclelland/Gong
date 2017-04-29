//
//  MIDIPitchBend.swift
//  Gong
//
//  Created by Daniel Clelland on 29/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIPitchBend {
    
    public var channel: Int
    
    public var value: Int
    
    public var delay: Double
    
    public init(channel: Int = 0, value: Int, delay: Double = 0.0) {
        self.channel = channel
        self.value = value
        self.delay = delay
    }
    
}

extension MIDIPitchBend: MIDIEvent {
    
    public var packets: [MIDIPacket] {
        return [
            MIDIPacket(.pitchBendChange(channel: UInt8(channel), value: UInt16(value)), delay: delay)
        ]
    }
    
}
