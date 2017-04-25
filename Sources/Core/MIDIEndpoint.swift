//
//  MIDIEndpoint.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIEndpointType {}

public enum Source: MIDIEndpointType {}

public enum Destination: MIDIEndpointType {}

public class MIDIEndpoint<Type: MIDIEndpointType>: MIDIObject {
    
    public var entity: MIDIEntity? {
        do {
            var entityReference = MIDIEntityRef()
            try MIDIEndpointGetEntity(reference, &entityReference).check("Getting entity for MIDIEndpoint")
            return MIDIEntity(entityReference)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    public var device: MIDIDevice? {
        return entity?.device
    }
    
    public func dispose() {
        MIDIEndpointDispose(reference)
    }

}

extension MIDIEndpoint where Type == Source {
    
    public convenience init?(named name: String) {
        guard let source = MIDIEndpoint<Source>.all.first(where: { $0.name == name }) else {
            return nil
        }
        
        self.init(source.reference)
    }
    
    public static var all: [MIDIEndpoint<Source>] {
        let count = MIDIGetNumberOfSources()
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Source>(MIDIGetSource(index))
        }
    }
    
}

extension MIDIEndpoint where Type == Destination {
    
    public convenience init?(named name: String) {
        guard let destination = MIDIEndpoint<Type>.all.first(where: { $0.name == name }) else {
            return nil
        }
        
        self.init(destination.reference)
    }
    
    public static var all: [MIDIEndpoint<Destination>] {
        let count = MIDIGetNumberOfDestinations()
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Destination>(MIDIGetDestination(index))
        }
    }
    
}

extension MIDIEndpoint where Type == Source {
    
    public func received(_ packet: MIDIPacket) throws {
        var packetList = MIDIPacketList(packet)
        try MIDIReceived(reference, &packetList).check("Receiving packets with MIDIEndpoint")
    }
    
}

extension MIDIEndpoint where Type == Destination {
    
    public func flushOutput() throws {
        try MIDIFlushOutput(reference).check("Flushing output with MIDIEndpoint")
    }
    
}
