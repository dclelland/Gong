//
//  MIDIDevice.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

class MIDIDevice: MIDIObject {
    
    static var all: [MIDIDevice] {
        let count = MIDIGetNumberOfDevices()
        return (0..<count).lazy.map { index in
            return MIDIDevice(reference: MIDIGetDevice(index))
        }
    }
    
    var entities: [MIDIEntity] {
        let count = MIDIDeviceGetNumberOfEntities(reference)
        return (0..<count).lazy.map { index in
            return MIDIEntity(reference: MIDIDeviceGetEntity(reference, index))
        }
    }
    
}

extension MIDIDevice {
    
    static var allExternalDevices: [MIDIDevice] {
        let count = MIDIGetNumberOfExternalDevices()
        return (0..<count).lazy.map { index in
            return MIDIDevice(reference: MIDIGetExternalDevice(index))
        }
    }
    
}

extension MIDIDevice {
    
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
