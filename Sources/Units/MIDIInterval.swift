//
//  MIDIInterval.swift
//  Pods
//
//  Created by Daniel Clelland on 22/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIInterval: MIDIInteger {
    
    public let value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
    
}

extension MIDIInterval {
    
    public static let P1: MIDIInterval = 0
    public static let m2: MIDIInterval = 1
    public static let M2: MIDIInterval = 2
    public static let m3: MIDIInterval = 3
    public static let M3: MIDIInterval = 4
    public static let P4: MIDIInterval = 5
    public static let P5: MIDIInterval = 7
    public static let m6: MIDIInterval = 8
    public static let M6: MIDIInterval = 9
    public static let m7: MIDIInterval = 10
    public static let M7: MIDIInterval = 11
    public static let P8: MIDIInterval = 12
    public static let m9: MIDIInterval = 13
    public static let M9: MIDIInterval = 14
    public static let m10: MIDIInterval = 15
    public static let M10: MIDIInterval = 16
    public static let P11: MIDIInterval = 17
    public static let P12: MIDIInterval = 19
    public static let m13: MIDIInterval = 20
    public static let M13: MIDIInterval = 21
    public static let m14: MIDIInterval = 22
    public static let M14: MIDIInterval = 23
    public static let P15: MIDIInterval = 24
    
}

extension MIDIInterval {
    
    public static let d2: MIDIInterval = 0
    public static let A1: MIDIInterval = 1
    public static let d3: MIDIInterval = 2
    public static let A2: MIDIInterval = 3
    public static let d4: MIDIInterval = 4
    public static let A3: MIDIInterval = 5
    public static let d5: MIDIInterval = 6
    public static let A4: MIDIInterval = 6
    public static let d6: MIDIInterval = 7
    public static let A5: MIDIInterval = 8
    public static let d7: MIDIInterval = 9
    public static let A6: MIDIInterval = 10
    public static let d8: MIDIInterval = 11
    public static let A7: MIDIInterval = 12
    public static let d9: MIDIInterval = 12
    public static let A8: MIDIInterval = 13
    public static let d10: MIDIInterval = 14
    public static let A9: MIDIInterval = 15
    public static let d11: MIDIInterval = 16
    public static let A10: MIDIInterval = 17
    public static let d12: MIDIInterval = 18
    public static let A11: MIDIInterval = 18
    public static let d13: MIDIInterval = 19
    public static let A12: MIDIInterval = 20
    public static let d14: MIDIInterval = 21
    public static let A13: MIDIInterval = 22
    public static let d15: MIDIInterval = 23
    public static let A14: MIDIInterval = 24
    public static let A15: MIDIInterval = 25
    
}
