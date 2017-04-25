//
//  MIDIValue.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIValue: MIDIInteger {
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
    
}

extension MIDIValue {
    
    public static let min: MIDIValue = 0
    public static let max: MIDIValue = 127
    
    public static let center: MIDIValue = 64
    
}
