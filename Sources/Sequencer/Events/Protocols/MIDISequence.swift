//
//  MIDISequence.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDISequence: MIDIArray {
    
    public typealias Element = MIDIEvent
    
    public let elements: [Element]
    
    public init() {
        self.elements = []
    }
    
    public init(_ elements: [Element]) {
        self.elements = elements
    }
    
}

extension MIDISequence: MIDIEvent {

    public var packets: [MIDIPacket] {
        return elements.flatMap { event in
            return event.packets
        }
    }
    
}
