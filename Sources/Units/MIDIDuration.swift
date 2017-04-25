//
//  MIDIDuration.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIDuration: MIDIDouble {
    
    public let value: Double
    
    public init(_ value: Double) {
        self.value = value
    }
    
}

extension MIDIDuration {
    
    public static let whole: MIDIDuration = MIDIDuration(1.0)
    public static let half: MIDIDuration = MIDIDuration(0.5)
    public static let quarter: MIDIDuration = MIDIDuration(0.25)
    public static let eighth: MIDIDuration = MIDIDuration(0.125)
    public static let sixteenth: MIDIDuration = MIDIDuration(0.0625)
    
}
