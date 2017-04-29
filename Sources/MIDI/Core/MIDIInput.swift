//
//  MIDIInput.swift
//  Gong
//
//  Created by Daniel Clelland on 26/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIInput: MIDIPort {
    
    public func connect(_ source: MIDISource) throws {
        let context = UnsafeMutablePointer.wrap(source.reference)
        try MIDIPortConnectSource(reference, source.reference, context).check("Connecting MIDIInput to source")
    }
    
    public func disconnect(_ source: MIDISource) throws {
        try MIDIPortDisconnectSource(reference, source.reference).check("Disconnecting MIDIInput from source")
    }
    
}
