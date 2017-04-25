//
//  MIDINote.swift
//  Gong
//
//  Created by Daniel Clelland on 20/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDINote: MIDIChannelEvent, MIDIDurationEvent {
    
    public var channel: MIDIChannel
    
    public var key: MIDIKey
    
    public var velocity: MIDIValue
    
    public var time: MIDITime
    
    public var duration: MIDIDuration
    
    public init(channel: MIDIChannel = .zero, key: MIDIKey, velocity: MIDIValue = .max, time: MIDITime = .now, duration: MIDIDuration = .whole) {
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
            MIDIPacket(.noteOn(channel: UInt8(channel.value), key: UInt8(key.value), velocity: UInt8(velocity.value)), delay: time.value),
            MIDIPacket(.noteOff(channel: UInt8(channel.value), key: UInt8(key.value), velocity: UInt8(velocity.value)), delay: (time + duration).value)
        ]
    }
    
}

//typealias MIDIPacketSequence = [MIDIPacket]
//
//public protocol MIDISequence {
//
//    var packets: [MIDIPacket] { get }
//    
//}
//
//extension MIDIDevice {
//    
//    public func send(_ sequence: MIDISequence, via output: MIDIPort<Output>? = MIDI.output) {
//        for packet in sequence.packets {
//            send(packet, via: output)
//        }
//    }
//    
//}
//
//public struct MIDINote {
//    
//    public var channel: Int
//    
//    public var key: MIDIKey
//    
//    public var velocity: Int
//    
//    public var time: MIDITime
//    
//    public var duration: MIDIDuration
//    
//    public init(channel: Int = 0, key: MIDIKey, velocity: Int = 127, time: MIDITime = .now, duration: MIDIDuration = .whole) {
//        self.channel = channel
//        self.key = key
//        self.velocity = velocity
//        self.time = time
//        self.duration = duration
//    }
//    
//    public var startVelocity: Int {
//        return velocity
//    }
//    
//    public var startDelay: TimeInterval {
//        return time.value
//    }
//    
//    public var endVelocity: Int {
//        return velocity
//    }
//    
//    public var endDelay: TimeInterval {
//        return (time + duration).value
//    }
//    
//}
//
//extension MIDINote: MIDISequence {
//    
//    public var packets: [MIDIPacket] {
//        return [
//            MIDIPacket(.noteOn(channel: UInt8(channel), key: UInt8(key.value), velocity: UInt8(startVelocity)), delay: startDelay),
//            MIDIPacket(.noteOff(channel: UInt8(channel), key: UInt8(key.value), velocity: UInt8(endVelocity)), delay: endDelay)
//        ]
//    }
//    
//}
