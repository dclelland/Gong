//
//  MIDIEndpoint.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

public protocol MIDIEndpointType {}

public enum Source: MIDIEndpointType {}
public enum Destination: MIDIEndpointType {}

public class MIDIEndpoint<Type: MIDIEndpointType>: MIDIObject {
    
    public var entity: MIDIEntity? {
        do {
            var entity = MIDIEntityRef()
            try MIDIEndpointGetEntity(reference, &entity).check("Getting entity for MIDIEndpoint")
            return MIDIEntity(reference: entity)
        } catch let error {
            print("\(error)")
            return nil
        }
    }
    
    public func dispose() {
        MIDIEndpointDispose(reference)
    }

}

public extension MIDIEndpoint where Type == Source {
    
    public static var all: [MIDIEndpoint<Source>] {
        let count = MIDIGetNumberOfSources()
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Source>(reference: MIDIGetSource(index))
        }
    }
    
}

extension MIDIEndpoint where Type == Destination {
    
    public static var all: [MIDIEndpoint<Destination>] {
        let count = MIDIGetNumberOfDestinations()
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Destination>(reference: MIDIGetDestination(index))
        }
    }
    
}

extension MIDIEndpoint where Type == Source {
    
    public func received(packets: MIDIPacketList) throws {
        var packets = packets
        try MIDIReceived(reference, &packets).check("Receiving packets with MIDIEndpoint")
    }
    
}

extension MIDIEndpoint where Type == Destination {
    
    public func flushOutput() throws {
        try MIDIFlushOutput(reference).check("Flushing output with MIDIEndpoint")
    }
    
}
