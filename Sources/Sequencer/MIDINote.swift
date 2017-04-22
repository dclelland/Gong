//
//  MIDINote.swift
//  Gong
//
//  Created by Daniel Clelland on 20/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

typealias MIDIMessageSequece = [MIDIMessage]

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
    
    public let channel: UInt8
    
    public let key: MIDIKey
    
    public let startVelocity: UInt8
    
    public let startDelay: TimeInterval
    
    public let endVelocity: UInt8
    
    public let endDelay: TimeInterval
    
    public init(channel: UInt8 = 0, key: MIDIKey, startVelocity: UInt8 = 127, startDelay: TimeInterval = 0.0, endVelocity: UInt8 = 127, endDelay: TimeInterval = 1.0) {
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
            MIDIMessage(.noteOn(channel: channel, key: key, velocity: startVelocity), delay: startDelay),
            MIDIMessage(.noteOff(channel: channel, key: key, velocity: endVelocity), delay: endDelay)
        ]
    }
    
}
