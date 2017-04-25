//
//  MIDIScale.swift
//  Pods
//
//  Created by Daniel Clelland on 23/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIScale: MIDIArray {
    
    public let elements: [MIDIInterval]
    
    public init() {
        self.elements = []
    }
    
    public init(_ elements: [MIDIInterval]) {
        self.elements = elements
    }
    
}

extension MIDIScale {
    
    public static let major: MIDIScale = [.P1, .M2, .M3, .P4, .P5, .M6, .M7]
    public static let minor: MIDIScale = [.P1, .M2, .m3, .P4, .P5, .m6, .m7]
    
}
