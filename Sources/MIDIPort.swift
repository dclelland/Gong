//
//  MIDIPort.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIPortType {}

public enum Input: MIDIPortType {}
public enum Output: MIDIPortType {}

public class MIDIPort<Type: MIDIPortType>: MIDIObject {
    
    public func connect(_ source: MIDIEndpoint<Source>) throws {
        let context = UnsafeMutablePointer.wrap(source.reference)
        try MIDIPortConnectSource(reference, source.reference, context).check("Connecting MIDIPort to source")
    }
    
    public func disconnect(_ source: MIDIEndpoint<Source>) throws {
        try MIDIPortDisconnectSource(reference, source.reference).check("Disconnecting MIDIPort from source")
    }
    
    public func dispose() throws {
        try MIDIPortDispose(reference).check("Disposing of MIDIPort")
    }
    
}

extension MIDIPort where Type == Output {
    
    public func send(packets: MIDIPacketList, to destination: MIDIEndpoint<Destination>) throws {
        var packets = packets
        try MIDISend(reference, destination.reference, &packets).check("Sending packets to endpoint with MIDIPort")
    }
    
}
