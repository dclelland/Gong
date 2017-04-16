//
//  MIDIPort.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

class MIDIPort: MIDIObject {
    
    func connect(_ source: MIDIEndpoint<Source>, context: UnsafeMutableRawPointer? = nil) throws {
        try MIDIPortConnectSource(reference, source.reference, context).check("Connecting MIDIPort to source")
    }
    
    func disconnect(_ source: MIDIEndpoint<Source>) throws {
        try MIDIPortDisconnectSource(reference, source.reference).check("Disconnecting MIDIPort from source")
    }
    
    func dispose() throws {
        try MIDIPortDispose(reference).check("Disposing of MIDIPort")
    }
    
}

extension MIDIPort {
    
    func send(packets: MIDIPacketList, to destination: MIDIEndpoint<Destination>) throws {
        var packets = packets
        try MIDISend(reference, destination.reference, &packets).check("Sending packets to endpoint with MIDIPort")
    }
    
}
