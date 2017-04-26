//
//  MIDIChannel.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIChannel: MIDIInteger {
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
    
}

extension MIDIChannel {
    
    public static let zero: MIDIChannel = 0
    
    public static let all: [MIDIChannel] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    
}
