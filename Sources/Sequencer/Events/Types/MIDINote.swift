//
//  MIDINote.swift
//  Gong
//
//  Created by Daniel Clelland on 20/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

extension MIDIDevice {
    
    public func send(_ note: MIDINote, via output: MIDIPort<Output>? = MIDI.output) {
        for packet in note.packets {
            send(packet, via: output)
        }
    }
    
    public func send(_ notes: [MIDINote], via output: MIDIPort<Output>? = MIDI.output) {
        for note in notes {
            send(note, via: output)
        }
    }
    
}

public struct MIDINote {
    
    public var channel: MIDIChannel
    
    public var key: MIDIKey
    
    public var velocity: MIDIParameter
    
    public var time: MIDITime
    
    public var duration: MIDIDuration
    
    public init(channel: MIDIChannel = .zero, key: MIDIKey, velocity: MIDIParameter = .max, time: MIDITime = .now, duration: MIDIDuration = .whole) {
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
            MIDIPacket(.noteOn(channel: channel.value, key: key.value, velocity: velocity.value), delay: time.value),
            MIDIPacket(.noteOff(channel: channel.value, key: key.value, velocity: velocity.value), delay: (time + duration).value)
        ]
    }
    
}
