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
    
    public var channel: MIDIChannel
    
    public var key: MIDIKey
    
    public var velocity: MIDIVelocity
    
    public var time: MIDITime
    
    public var duration: MIDIDuration
    
    public init(channel: MIDIChannel = .zero, key: MIDIKey, velocity: MIDIVelocity = .mezzopiano, time: MIDITime = .now, duration: MIDIDuration = .whole) {
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

extension Array where Element == MIDINote {
    
    public func channelMap(_ transform: (MIDIChannel) -> MIDIChannel) -> [MIDINote] {
        return map { note in
            var note = note
            note.channel = transform(note.channel)
            return note
        }
    }
    
    public func tuned(to channel: MIDIChannel) {
        return channelMap { _ in
            return channel
        }
    }

}

extension Array where Element == MIDINote {
    
    public func keyMap(_ transform: (MIDIKey) -> MIDIKey) -> [MIDINote] {
        return map { note in
            var note = note
            note.key = transform(note.key)
            return note
        }
    }
    
    public func transposed(up interval: MIDIInterval) -> [MIDINote] {
        return keyMap { key in
            return key + interval
        }
    }
    
    public func transposed(down interval: MIDIInterval) -> [MIDINote] {
        return keyMap { key in
            return key - interval
        }
    }
    
}
