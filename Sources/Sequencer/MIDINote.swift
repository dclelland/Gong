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
    
    public var startVelocity: Int
    
    public var startDelay: TimeInterval
    
    public var endVelocity: Int
    
    public var endDelay: TimeInterval
    
    public init(channel: Int = 0, key: MIDIKey, startVelocity: Int = 127, startDelay: TimeInterval = 0.0, endVelocity: Int = 127, endDelay: TimeInterval = 1.0) {
        self.channel = channel
        self.key = key
        self.startVelocity = startVelocity
        self.startDelay = startDelay
        self.endVelocity = endVelocity
        self.endDelay = endDelay
    }
    
}

extension MIDINote: MIDISequence {
    
    public var messages: [MIDIMessage] {
        return [
            MIDIMessage(.noteOn(channel: UInt8(channel), key: UInt8(key.number), velocity: UInt8(startVelocity)), delay: startDelay),
            MIDIMessage(.noteOff(channel: UInt8(channel), key: UInt8(key.number), velocity: UInt8(endVelocity)), delay: endDelay)
        ]
    }
    
}
