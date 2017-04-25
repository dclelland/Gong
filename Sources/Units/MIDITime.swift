//
//  MIDITime.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDITime: MIDIDouble {
    
    public let value: Double
    
    public init(_ value: Double) {
        self.value = value
    }
    
}

extension MIDITime {

    public static let now: MIDITime = MIDITime(0.0)
    
}

extension MIDITime {
    
    public static func + (lhs: MIDITime, rhs: MIDIDuration) -> MIDITime {
        return MIDITime(lhs.value + rhs.value)
    }
    
    public static func + (lhs: MIDIDuration, rhs: MIDITime) -> MIDITime {
        return MIDITime(lhs.value + rhs.value)
    }
    
    public static func - (lhs: MIDITime, rhs: MIDIDuration) -> MIDITime {
        return MIDITime(lhs.value - rhs.value)
    }
    
    public static func - (lhs: MIDIDuration, rhs: MIDITime) -> MIDITime {
        return MIDITime(lhs.value - rhs.value)
    }
    
}
