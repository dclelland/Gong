//
//  MIDIEndpoint.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

protocol MIDIEndpointType {}

enum Source: MIDIEndpointType {}
enum Destination: MIDIEndpointType {}

class MIDIEndpoint<Type: MIDIEndpointType>: MIDIObject {
    
    var entity: MIDIEntity? {
        do {
            var entity = MIDIEntityRef()
            try MIDIEndpointGetEntity(reference, &entity).check("Getting entity for MIDIEndpoint")
            return MIDIEntity(reference: entity)
        } catch let error {
            print("\(error)")
            return nil
        }
    }
    
    func dispose() {
        MIDIEndpointDispose(reference)
    }

}

extension MIDIEndpoint where Type == Source {
    
    static var all: [MIDIEndpoint<Source>] {
        let count = MIDIGetNumberOfSources()
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Source>(reference: MIDIGetSource(index))
        }
    }
    
}

extension MIDIEndpoint where Type == Destination {
    
    static var all: [MIDIEndpoint<Destination>] {
        let count = MIDIGetNumberOfDestinations()
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Destination>(reference: MIDIGetDestination(index))
        }
    }
    
}

extension MIDIEndpoint where Type == Source {
    
    func received(packets: UnsafePointer<MIDIPacketList>) throws {
        try MIDIReceived(reference, packets).check("Receiving packets with MIDIEndpoint")
    }
    
}

extension MIDIEndpoint where Type == Destination {
    
    func flushOutput() throws {
        try MIDIFlushOutput(reference).check("Flushing output with MIDIEndpoint")
    }
    
}

extension MIDIEndpoint {
    
    var name: String {
        return self[kMIDIPropertyName]!
    }
    
    var manufacturer: String {
        return self[kMIDIPropertyManufacturer]!
    }
    
    var model: String {
        return self[kMIDIPropertyModel]!
    }
    
    var uniqueID: Int {
        return self[kMIDIPropertyUniqueID]!
    }
    
}
