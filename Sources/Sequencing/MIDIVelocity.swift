//
//  MIDIVelocity.swift
//  Gong
//
//  Created by Daniel Clelland on 25/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: Velocity setters

extension Array where Element == MIDINote {
    
    public func setVelocity(_ velocity: Int) -> [MIDINote] {
        return mapVelocity { _ in
            return velocity
        }
    }
    
    public func mapVelocity(_ transform: (Int) -> Int) -> [MIDINote] {
        return map { note in
            var note = note
            note.velocity = transform(note.velocity)
            return note
        }
    }
    
}

// MARK: Velocity transformations

extension Array where Element == MIDINote {
    
    public func make(louder amount: Int) -> [MIDINote] {
        return mapVelocity { velocity in
            return velocity + amount
        }
    }
    
    public func make(softer amount: Int) -> [MIDINote] {
        return mapVelocity { velocity in
            return velocity - amount
        }
    }
    
}

// MARK: - Velocity constants

public let ppp = 16
public let pp = 33
public let p = 49
public let mp = 64
public let mf = 80
public let f = 96
public let ff = 112
public let fff = 127
