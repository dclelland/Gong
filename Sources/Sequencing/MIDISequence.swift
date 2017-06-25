//
//  MIDISequence.swift
//  Gong
//
//  Created by Daniel Clelland on 25/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation


/*
 
 Focus:
 
 // Music.Time.Juxtapose
 
 - apply
 - apply(times:)
 
 See https://github.com/thoughtbot/Runes
 
 - lead
 - follow
 - after
 - before
 - during
 
 - repeat(times:)
 - reverse
 - palindrome
 
 */

// MARK: Basic composition

extension Array where Element == Int {
    
    public func parallel() -> [MIDINote] {
        return map { pitch in
            return MIDINote(pitch: pitch)
        }
    }
    
    public func sequential() -> [MIDINote] {
        return enumerated().map { (offset, pitch) in
            return MIDINote(pitch: pitch, start: Double(offset))
        }
    }
    
}

extension Array where Element == MIDINote {
    
    public func parallel() -> [MIDINote] {
        return self
    }
    
    public func sequential() -> [MIDINote] {
        return [] // loop over, appending and delaying
    }
    
    
}

extension Array where Element == [MIDINote] {
    
    public func parallel() -> [MIDINote] {
        return flatMap { $0 }
    }
    
    public func sequential() -> [MIDINote] {
        return [] // loop over, appending and delaying
    }
    
}
