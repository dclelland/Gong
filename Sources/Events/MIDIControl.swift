//
//  MIDIControl.swift
//  Gong
//
//  Created by Daniel Clelland on 29/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIControl {
    
    public var channel: Int
    
    public var controller: Int
    
    public var value: Int
    
    public var delay: Double
    
    public init(channel: Int = 0, controller: Int, value: Int = 64, delay: Double = 0.0) {
        self.channel = channel
        self.controller = controller
        self.value = value
        self.delay = delay
    }
    
}

extension MIDIControl: MIDIEvent {
    
    public var packets: [MIDIPacket] {
        return [
            MIDIPacket(.controlChange(channel: UInt8(channel), controller: UInt8(channel), value: UInt8(channel)), delay: delay)
        ]
    }
    
}
