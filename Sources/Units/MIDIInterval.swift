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
    
    public static var P1: MIDIInterval { return 0 }
    public static var m2: MIDIInterval { return 1 }
    public static var M2: MIDIInterval { return 2 }
    public static var m3: MIDIInterval { return 3 }
    public static var M3: MIDIInterval { return 4 }
    public static var P4: MIDIInterval { return 5 }
    public static var P5: MIDIInterval { return 7 }
    public static var m6: MIDIInterval { return 8 }
    public static var M6: MIDIInterval { return 9 }
    public static var m7: MIDIInterval { return 10 }
    public static var M7: MIDIInterval { return 11 }
    public static var P8: MIDIInterval { return 12 }
    public static var m9: MIDIInterval { return 13 }
    public static var M9: MIDIInterval { return 14 }
    public static var m10: MIDIInterval { return 15 }
    public static var M10: MIDIInterval { return 16 }
    public static var P11: MIDIInterval { return 17 }
    public static var P12: MIDIInterval { return 19 }
    public static var m13: MIDIInterval { return 20 }
    public static var M13: MIDIInterval { return 21 }
    public static var m14: MIDIInterval { return 22 }
    public static var M14: MIDIInterval { return 23 }
    public static var P15: MIDIInterval { return 24 }
    
}

extension MIDIInterval {
    
    public static var d2: MIDIInterval { return 0 }
    public static var A1: MIDIInterval { return 1 }
    public static var d3: MIDIInterval { return 2 }
    public static var A2: MIDIInterval { return 3 }
    public static var d4: MIDIInterval { return 4 }
    public static var A3: MIDIInterval { return 5 }
    public static var d5: MIDIInterval { return 6 }
    public static var A4: MIDIInterval { return 6 }
    public static var d6: MIDIInterval { return 7 }
    public static var A5: MIDIInterval { return 8 }
    public static var d7: MIDIInterval { return 9 }
    public static var A6: MIDIInterval { return 10 }
    public static var d8: MIDIInterval { return 11 }
    public static var A7: MIDIInterval { return 12 }
    public static var d9: MIDIInterval { return 12 }
    public static var A8: MIDIInterval { return 13 }
    public static var d10: MIDIInterval { return 14 }
    public static var A9: MIDIInterval { return 15 }
    public static var d11: MIDIInterval { return 16 }
    public static var A10: MIDIInterval { return 17 }
    public static var d12: MIDIInterval { return 18 }
    public static var A11: MIDIInterval { return 18 }
    public static var d13: MIDIInterval { return 19 }
    public static var A12: MIDIInterval { return 20 }
    public static var d14: MIDIInterval { return 21 }
    public static var A13: MIDIInterval { return 22 }
    public static var d15: MIDIInterval { return 23 }
    public static var A14: MIDIInterval { return 24 }
    public static var A15: MIDIInterval { return 25 }
    
}
