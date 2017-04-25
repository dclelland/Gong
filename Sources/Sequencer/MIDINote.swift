//
//  MIDINote.swift
//  Gong
//
//  Created by Daniel Clelland on 20/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

typealias MIDIMessageSequence = [MIDIMessage]

public protocol MIDISequence {

    var messages: [MIDIMessage] { get }
    
}

extension MIDIDevice {
    
    public func send(_ sequence: MIDISequence, via output: MIDIPort<Output>? = MIDI.output) {
        for message in sequence.messages {
            send(message, via: output)
        }
    }
    
}

public struct MIDINote {
    
    public var channel: Int
    
    public var key: MIDIKey
    
    public var velocity: Int
    
    public var time: MIDITime
    
    public var duration: MIDIDuration
    
    public init(channel: Int = 0, key: MIDIKey, velocity: Int = 127, time: MIDITime = .now, duration: MIDIDuration = .whole) {
        self.channel = channel
        self.key = key
        self.velocity = velocity
        self.time = time
        self.duration = duration
    }
    
    public var startVelocity: Int {
        return velocity
    }
    
    public var startDelay: TimeInterval {
        return time.value
    }
    
    public var endVelocity: Int {
        return velocity
    }
    
    public var endDelay: TimeInterval {
        return (time + duration).value
    }
    
}

extension MIDINote: MIDISequence {
    
    public var messages: [MIDIMessage] {
        return [
            MIDIMessage(.noteOn(channel: UInt8(channel), key: UInt8(key.value), velocity: UInt8(startVelocity)), delay: startDelay),
            MIDIMessage(.noteOff(channel: UInt8(channel), key: UInt8(key.value), velocity: UInt8(endVelocity)), delay: endDelay)
        ]
    }
    
}
