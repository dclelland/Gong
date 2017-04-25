//
//  MIDIDouble.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public protocol MIDIDouble/*: BinaryFloatingPoint*/ {
    
    var value: Double { get }
    
    init(_ value: Double)
    
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
