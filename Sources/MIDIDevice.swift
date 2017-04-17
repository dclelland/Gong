//
//  MIDIDevice.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

public class MIDIDevice: MIDIObject {
    
    public static var all: [MIDIDevice] {
        let count = MIDIGetNumberOfDevices()
        return (0..<count).lazy.map { index in
            return MIDIDevice(reference: MIDIGetDevice(index))
        }
    }
    
    public var entities: [MIDIEntity] {
        let count = MIDIDeviceGetNumberOfEntities(reference)
        return (0..<count).lazy.map { index in
            return MIDIEntity(reference: MIDIDeviceGetEntity(reference, index))
        }
    }
    
}

public extension MIDIDevice {
    
    public static var allExternalDevices: [MIDIDevice] {
        let count = MIDIGetNumberOfExternalDevices()
        return (0..<count).lazy.map { index in
            return MIDIDevice(reference: MIDIGetExternalDevice(index))
        }
    }
    
}
