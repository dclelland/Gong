//
//  MIDINote.swift
//  Gong
//
//  Created by Daniel Clelland on 20/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

extension MIDIPacketDestination {
    
    public func send(_ note: MIDINote, via output: MIDIOutput) {
        for packet in note.packets {
            send(packet, via: output)
        }
    }
    
    public func send(_ notes: [MIDINote], via output: MIDIOutput) {
        for note in notes {
            send(note, via: output)
        }
    }
    
}

public struct MIDINote {
    
    public var channel: Int
    
    public var key: Int
    
    public var velocity: Int
    
    public var time: Double
    
    public var duration: Double
    
    public init(channel: Int = 0, key: Int, velocity: Int = 64, time: Double = 0.0, duration: Double = 1.0) {
        self.channel = channel
        self.key = key
        self.velocity = velocity
        self.time = time
        self.duration = duration
    }

}

extension MIDINote {
    
    public var packets: [MIDIPacket] {
        return [
            MIDIPacket(.noteOn(channel: UInt8(channel), key: UInt8(key), velocity: UInt8(velocity)), delay: time),
            MIDIPacket(.noteOff(channel: UInt8(channel), key: UInt8(key), velocity: UInt8(velocity)), delay: time + duration)
        ]
    }
    
}
