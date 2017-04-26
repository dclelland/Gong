//
//  MIDIVelocity.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIVelocity: MIDIInteger {
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
    
}

extension MIDIVelocity {
    
    public static let pianississimo: MIDIVelocity = 16
    public static let pianissimo: MIDIVelocity = 33
    public static let piano: MIDIVelocity = 49
    public static let mezzopiano: MIDIVelocity = 64
    public static let mezzoforte: MIDIVelocity = 80
    public static let forte: MIDIVelocity = 96
    public static let fortissimo: MIDIVelocity = 112
    public static let fortississimo: MIDIVelocity = 127
    
}
