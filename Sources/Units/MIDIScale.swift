//
//  MIDIScale.swift
//  Pods
//
//  Created by Daniel Clelland on 23/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIScale: MIDIArray {
    
    public typealias Element = MIDIInterval
    
    public let elements: [Element]
    
    public init() {
        self.elements = []
    }
    
    public init(_ elements: [Element]) {
        self.elements = elements
    }
    
}

extension MIDIScale {
    
    public static let major: MIDIScale = [.P1, .M2, .M3, .P4, .P5, .M6, .M7]
    public static let minor: MIDIScale = [.P1, .M2, .m3, .P4, .P5, .m6, .m7]
    
    public static let chromatic: MIDIScale = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    
}
