//
//  Combinators.swift
//  Gong
//
//  Created by Daniel Clelland on 26/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import Runes

extension Array where Element == MIDINote {
    
    public func channelMap(_ transform: (MIDIChannel) -> MIDIChannel) -> [MIDINote] {
        return map { note in
            var note = note
            note.channel = transform(note.channel)
            return note
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
    
    public func keyApply(_ transform: (MIDIKey) -> [MIDIKey]) -> [MIDINote] {
        return flatMap { note in
            return transform(note.key).map { key in
                var note = note
                note.key = key
                return note
            }
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
    
    public func chorded(with chord: MIDIChord) -> [MIDINote] {
        return keyApply { key in
            return chord.map { interval in
                return key + interval // could combine with transposed(up:)
            }
        }
    }
    
//    public func backwards() -> [MIDINote] {
//        
//    }
//    
//    public func repeated(_ times: Int) -> [MIDINote] {
//        
//    }
//    
//    public func palindromed() -> [MIDINote] {
//        
//    }
//    
//    public func concatenated(with sequence)
    
}

extension Array where Element == MIDINote {
    
    public func velocityMap(_ transform: (MIDIVelocity) -> MIDIVelocity) -> [MIDINote] {
        return map { note in
            var note = note
            note.velocity = transform(note.velocity)
            return note
        }
    }
    
}
