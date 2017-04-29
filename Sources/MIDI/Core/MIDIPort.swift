//
//  MIDIPort.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIPort: MIDIObject {
    
    public func dispose() throws {
        try MIDIPortDispose(reference).midiError("Disposing of MIDIPort")
    }
    
}
