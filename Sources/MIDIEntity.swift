//
//  MIDIEntity.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

public class MIDIEntity: MIDIObject {
    
    public var device: MIDIDevice? {
        do {
            var device = MIDIDeviceRef()
            try MIDIEntityGetDevice(reference, &device).check("Getting device for MIDIEntity")
            return MIDIDevice(reference: device)
        } catch let error {
            print("\(error)")
            return nil
        }
    }
    
    public var sources: [MIDIEndpoint<Source>] {
        let count = MIDIEntityGetNumberOfSources(reference)
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Source>(reference: MIDIEntityGetSource(reference, index))
        }
    }
    
    public var destinations: [MIDIEndpoint<Destination>] {
        let count = MIDIEntityGetNumberOfDestinations(reference)
        return (0..<count).lazy.map { index in
            return MIDIEndpoint<Destination>(reference: MIDIEntityGetDestination(reference, index))
        }
    }
    
}

extension MIDIEntity {
    
    public var name: String {
        return self[kMIDIPropertyName]!
    }
    
    public var uniqueID: Int {
        return self[kMIDIPropertyUniqueID]!
    }
    
}
