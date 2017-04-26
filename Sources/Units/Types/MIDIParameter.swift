//
//  MIDIParameter.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIParameter: MIDIInteger {
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
    
}

extension MIDIParameter {
    
    public static let min: MIDIParameter = 0
    public static let max: MIDIParameter = 127
    
    public static let center: MIDIParameter = 64
    
}
