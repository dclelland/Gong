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
    
    public func dispose() throws {
        try MIDIPortDispose(reference).check("Disposing of MIDIPort")
    }
    
}

extension MIDIPort where Type == Input {
    
    public func connect(_ source: MIDIEndpoint<Source>) throws {
        let context = UnsafeMutablePointer.wrap(source.reference)
        try MIDIPortConnectSource(reference, source.reference, context).check("Connecting MIDIPort to source")
    }
    
    public func disconnect(_ source: MIDIEndpoint<Source>) throws {
        try MIDIPortDisconnectSource(reference, source.reference).check("Disconnecting MIDIPort from source")
    }

}

extension MIDIPort where Type == Output {
    
    public func send(_ packet: MIDIPacket, to destination: MIDIEndpoint<Destination>) throws {
        var packetList = MIDIPacketList(packet)
        try MIDISend(reference, destination.reference, &packetList).check("Sending packets to endpoint with MIDIPort")
    }
    
}
