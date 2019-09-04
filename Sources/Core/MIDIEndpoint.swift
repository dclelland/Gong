//
//  MIDIEndpoint.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIEndpoint: MIDIObject {
    
    public var entity: MIDIEntity? {
        do {
            var entityReference = MIDIEntityRef()
            try MIDIEndpointGetEntity(reference, &entityReference).midiError("Getting entity for MIDIEndpoint")
            return MIDIEntity(entityReference)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    public var device: MIDIDevice? {
        return entity?.device
    }

    public var displayName: String {
        return "\(device?.displayName ?? "No device"): \(name ?? "Unknown Port")"
    }
    
    public func dispose() throws {
        try MIDIEndpointDispose(reference).midiError("Disposing of MIDIEndpoint")
    }
}
