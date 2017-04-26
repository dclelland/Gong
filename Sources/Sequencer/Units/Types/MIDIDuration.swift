//
//  MIDIDuration.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIDuration: MIDIDouble {
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
    
}

extension MIDIDuration {
    
    public static let octuple: MIDIDuration = 8.0
    public static let quadruple: MIDIDuration = 4.0
    public static let double: MIDIDuration = 2.0
    public static let whole: MIDIDuration = 1.0
    public static let half: MIDIDuration = 1.0 / 2.0
    public static let quarter: MIDIDuration = 1.0 / 4.0
    public static let eighth: MIDIDuration = 1.0 / 8.0
    public static let sixteenth: MIDIDuration = 1.0 / 16.0
    public static let thirtySecond: MIDIDuration = 1.0 / 32.0
    public static let sixtyFourth: MIDIDuration = 1.0 / 64.0
    
}

extension MIDIDuration {
    
    public func stretch(_ ratio: Value) -> MIDIDuration {
        return MIDIDuration(self.value * ratio)
    }
    
    public var dot: MIDIDuration {
        return stretch(1.5)
    }
    
}

extension MIDIDuration {
    
    public func tuplet(_ ratio: Double) -> MIDIDuration {
        return MIDIDuration(self.value / ratio)
    }
    
    public var duplet: MIDIDuration {
        return tuplet(2.0 / 1.0)
    }
    
    public var triplet: MIDIDuration {
        return tuplet(3.0 / 2.0)
    }
    
    public var quadruplet: MIDIDuration {
        return tuplet(4.0 / 3.0)
    }
    
    public var quintuplet: MIDIDuration {
        return tuplet(5.0 / 4.0)
    }
    
    public var sextuplet: MIDIDuration {
        return tuplet(6.0 / 5.0)
    }
    
    public var septuplet: MIDIDuration {
        return tuplet(7.0 / 6.0)
    }
    
    public var octuplet: MIDIDuration {
        return tuplet(8.0 / 7.0)
    }

}
