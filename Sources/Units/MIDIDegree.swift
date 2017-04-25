//
//  MIDIDegree.swift
//  Gong
//
//  Created by Daniel Clelland on 22/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIDegree: MIDIInteger {
    
    public let value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
    
}

extension MIDIDegree {
    
    public static let i: MIDIDegree = 1
    public static let ii: MIDIDegree = 2
    public static let iii: MIDIDegree = 3
    public static let iv: MIDIDegree = 4
    public static let v: MIDIDegree = 5
    public static let vi: MIDIDegree = 6
    public static let vii: MIDIDegree = 7
    
}
