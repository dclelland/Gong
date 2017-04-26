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
            var deviceReference = MIDIDeviceRef()
            try MIDIEntityGetDevice(reference, &deviceReference).check("Getting device for MIDIEntity")
            return MIDIDevice(deviceReference)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    public var sources: [MIDISource] {
        let count = MIDIEntityGetNumberOfSources(reference)
        return (0..<count).lazy.map { index in
            return MIDISource(MIDIEntityGetSource(reference, index))
        }
    }
    
    public func source(named name: String) -> MIDISource? {
        return sources.first(where: { $0.name == name })
    }
    
    public var destinations: [MIDIDestination] {
        let count = MIDIEntityGetNumberOfDestinations(reference)
        return (0..<count).lazy.map { index in
            return MIDIDestination(MIDIEntityGetDestination(reference, index))
        }
    }
    
    public func destination(named name: String) -> MIDIDestination? {
        return destinations.first(where: { $0.name == name })
    }
    
}

extension MIDIEntity: MIDIPacketSender {
    
    public func send(_ packet: MIDIPacket, via output: MIDIOutput) {
        for destination in destinations {
            destination.send(packet, via: output)
        }
    }
    
}

extension MIDIEntity: MIDIPacketReceiver {
    
    public func receive(_ packet: MIDIPacket) {
        for source in sources {
            source.receive(packet)
        }
    }
    
}
