//
//  MIDIScale.swift
//  Pods
//
//  Created by Daniel Clelland on 23/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIScale {
    
    public var intervals: [MIDIInterval]
    
    public init() {
        self.intervals = []
    }
    
    public init(_ intervals: [MIDIInterval]) {
        self.intervals = intervals
    }
    
}

extension MIDIScale {
    
    public static let major: MIDIScale = [.P1, .M2, .M3, .P4, .P5, .M6, .M7]
    public static let minor: MIDIScale = [.P1, .M2, .m3, .P4, .P5, .m6, .m7]
    
}

extension MIDIScale: Collection {
    
    public var startIndex: Int {
        return intervals.startIndex
    }
    
    public var endIndex: Int {
        return intervals.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return intervals.index(after: i)
    }
    
    public subscript(position: Int) -> MIDIInterval {
        return intervals[position]
    }
    
}

extension MIDIScale: RangeReplaceableCollection {
    
    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Iterator.Element == MIDIInterval {
        intervals.replaceSubrange(subrange, with: newElements)
    }
    
}

extension MIDIScale: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: MIDIInterval...) {
        self.init(elements)
    }
    
}
