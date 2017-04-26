//
//  MIDIChord.swift
//  Pods
//
//  Created by Daniel Clelland on 22/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIChord: MIDIArray {
    
    public typealias Element = MIDIInterval
    
    public let elements: [Element]
    
    public init() {
        self.elements = []
    }

    public init(_ elements: [Element]) {
        self.elements = elements
    }

}

extension MIDIChord {
    
    // Should also be able to do something like .c4.maj
    
    public static let maj: MIDIChord = [.P1, .M3, .P5]
    public static let min: MIDIChord = [.P1, .m3, .P5]
    public static let aug: MIDIChord = [.P1, .M3, .A5]
    public static let dim: MIDIChord = [.P1, .m3, .d5]
    
    public static let sus2: MIDIChord = [.P1, .M2, .P5]
    public static let sus4: MIDIChord = [.P1, .P4, .P5]
    
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
