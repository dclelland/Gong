//
//  MIDIChord.swift
//  Pods
//
//  Created by Daniel Clelland on 22/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIChord {
    
    public var intervals: [MIDIInterval]
    
    public init() {
        self.intervals = []
    }

    public init(_ intervals: [MIDIInterval]) {
        self.intervals = intervals
    }

    public static let maj: MIDIChord = [.P1, .M3, .P5]
    public static let min: MIDIChord = [.P1, .m3, .P5]
    public static let aug: MIDIChord = [.P1, .M3, .A5]
    public static let dim: MIDIChord = [.P1, .m3, .d5]
    
    public static var sus2: MIDIChord = [.P1, .M2, .P5]
    public static var sus4: MIDIChord = [.P1, .P4, .P5]
    
    public static let maj7: MIDIChord = .maj + [.M7]
    public static let min7: MIDIChord = .min + [.m7]
    public static let dom7: MIDIChord = .maj + [.m7]
    public static let dim7: MIDIChord = .dim + [.d7]
    public static let halfDim7: MIDIChord = .dim + [.m7]
    public static let minMaj7: MIDIChord = .min + [.M7]
    public static let augMaj7: MIDIChord = .aug + [.M7]
    
    public static let aug7: MIDIChord = .aug + [.m7]
    public static let dimMaj7: MIDIChord = .dim + [.M7]
    public static let dom7Flat5: MIDIChord = [.P1, .M3, .d5, .m7]
    
    public static let add6: MIDIChord = .maj + [.M6]
    public static let add6add9: MIDIChord = .maj + [.M6, .M9]

}

extension MIDIChord: Collection {
    
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

extension MIDIChord: RangeReplaceableCollection {
    
    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Iterator.Element == MIDIInterval {
        intervals.replaceSubrange(subrange, with: newElements)
    }
    
}

extension MIDIChord: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: MIDIInterval...) {
        self.init(elements)
    }
    
}
