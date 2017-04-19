//
//  MIDIEntity.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIEntity: MIDIObject {
    
    public var device: MIDIDevice? {
        do {
            var device = MIDIDeviceRef()
            try MIDIEntityGetDevice(reference, &device).check("Getting device for MIDIEntity")
            return MIDIDevice(reference: device)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    public var sources: [MIDIEndpoint<Source>] {
        let count = MIDIEntityGetNumberOfSources(reference)
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Source>(reference: MIDIEntityGetSource(reference, index))
        }
    }
    
    public func source(named name: String) -> MIDIEndpoint<Source>? {
        return sources.first(where: { $0.name == name })
    }
    
    public var destinations: [MIDIEndpoint<Destination>] {
        let count = MIDIEntityGetNumberOfDestinations(reference)
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Destination>(reference: MIDIEntityGetDestination(reference, index))
        }
    }
    
    public func destination(named name: String) -> MIDIEndpoint<Destination>? {
        return destinations.first(where: { $0.name == name })
    }
    
}
