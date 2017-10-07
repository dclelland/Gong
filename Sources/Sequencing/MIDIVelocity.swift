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
    
    public func volume(louder amount: Int) -> [MIDINote] {
        return mapVelocity { velocity in
            return velocity + amount
        }
    }
    
    public func volume(softer amount: Int) -> [MIDINote] {
        return mapVelocity { velocity in
            return velocity - amount
        }
    }
    
}

// MARK: - Velocity constants

public let pianississimo = 16
public let pianissimo = 33
public let piano = 49
public let mezzopiano = 64
public let mezzoforte = 80
public let forte = 96
public let fortissimo = 112
public let fortississimo = 127
