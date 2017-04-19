//
//  MIDIDevice.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIDevice: MIDIObject {
    
    public convenience init?(named name: String) {
        guard let device = MIDIDevice.all.first(where: { $0.name == name }) else {
            return nil
        }
        
        self.init(device.reference)
    }
    
    public static var all: [MIDIDevice] {
        let count = MIDIGetNumberOfDevices()
        return (0..<count).lazy.map { index in
            return MIDIDevice(MIDIGetDevice(index))
        }
    }
    
    public var entities: [MIDIEntity] {
        let count = MIDIDeviceGetNumberOfEntities(reference)
        return (0..<count).lazy.map { index in
            return MIDIEntity(MIDIDeviceGetEntity(reference, index))
        }
    }
    
    public func entity(named name: String) -> MIDIEntity? {
        return entities.first(where: { $0.name == name })
    }
    
    public var sources: [MIDIEndpoint<Source>] {
        return entities.map({ $0.sources }).flatMap({ $0 })
    }
    
    public func source(named name: String) -> MIDIEndpoint<Source>? {
        return sources.first(where: { $0.name == name })
    }
    
    public var destinations: [MIDIEndpoint<Destination>] {
        return entities.map({ $0.destinations }).flatMap({ $0 })
    }
    
    public func destination(named name: String) -> MIDIEndpoint<Destination>? {
        return destinations.first(where: { $0.name == name })
    }
    
}

extension MIDIDevice {
    
    public static var allExternalDevices: [MIDIDevice] {
        let count = MIDIGetNumberOfExternalDevices()
        return (0..<count).lazy.map { index in
            return MIDIDevice(MIDIGetExternalDevice(index))
        }
    }
    
}
