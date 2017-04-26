//
//  MIDISource.swift
//  Gong
//
//  Created by Daniel Clelland on 26/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIPacketSource {
    
    func receive(_ packet: MIDIPacket)
    
}

extension MIDIPacketSource {
    
    public func receive(_ packets: [MIDIPacket]) {
        for packet in packets {
            receive(packet)
        }
    }
    
}

public class MIDISource: MIDIEndpoint {
    
    public convenience init?(named name: String) {
        guard let source = MIDISource.all.first(where: { $0.name == name }) else {
            return nil
        }
        
        self.init(source.reference)
    }
    
    public static var all: [MIDISource] {
        let count = MIDIGetNumberOfSources()
        return (0..<count).lazy.map { index in
            return MIDISource(MIDIGetSource(index))
        }
    }
    
}

extension MIDISource: MIDIPacketSource {
    
    public func receive(_ packet: MIDIPacket) {
        do {
            var packetList = MIDIPacketList(packet)
            try MIDIReceived(reference, &packetList).check("Receiving packets with MIDISource")
        } catch let error {
            print(error)
        }
    }
    
}
