//
//  MIDISequence.swift
//  Gong
//
//  Created by Daniel Clelland on 25/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation



/*
 Do this first, but once Swift 4 protocols are available, extend to MIDIControl, MIDIPitchBend, MIDIRest
 We also need an 'apply' system - and an 'apply(probability: function:)' thing
 And a repeated apply system...?
 See https://github.com/thoughtbot/Runes
 */


// Int, [Int], [[Int]], MIDINote, [MIDINote], [[MIDINote]]




// Music.Time.Juxtapose

/*
 
 -- * Align without composition
 lead,
 follow,
 
 -- * Standard composition
 after,
 before,
 during,
 (|>),
 (<|),
 
 -- ** More exotic
 sustain,
 palindrome,
 
 
 -- * Repetition
 times,
 
 - perhaps need one for maximum polyphony...?
 
 
 
 
 
 - reverse
 - palindrome
 - 
 
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

extension Array where Element == [MIDINote] {
    
    public func parallel() -> [MIDINote] {
        return flatMap { $0 }
    }
    
    public func sequential() -> [MIDINote] {
        return []
    }
    
}
