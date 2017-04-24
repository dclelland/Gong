//
//  MIDIDouble.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public protocol MIDIDoubleUnit { }

public struct MIDIDouble<UnitType: MIDIDoubleUnit> {
    
    let value: Double
    
    init(_ value: Double) {
        self.value = value
    }
    
}

//extension MIDIDouble: BinaryFloatingPoint {
//    
//}
//
//extension MIDIDouble: FloatingPoint {
//    
//}
//
//extension MIDIDouble: ExpressibleByFloatLiteral {
//    
//}
//
//extension MIDIDouble: AbsoluteValuable {
//    
//}
