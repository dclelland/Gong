//
//  MIDIDestination.swift
//  Gong
//
//  Created by Daniel Clelland on 26/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIDestination: MIDIEndpoint {
    
    public convenience init?(named name: String) {
        guard let destination = MIDIDestination.all.first(where: { $0.name == name }) else {
            return nil
        }
        
        self.init(destination.reference)
    }
    
    public static var all: [MIDIDestination] {
        let count = MIDIGetNumberOfDestinations()
        return (0..<count).lazy.map { index in
            return MIDIDestination(MIDIGetDestination(index))
        }
    }
    
}

extension MIDIDestination {
    
    public func flushOutput() throws {
        try MIDIFlushOutput(reference).check("Flushing MIDIDestination output")
    }
    
}

extension MIDIDestination: MIDIPacketSender {
    
    public func send(_ packet: MIDIPacket, via output: MIDIOutput) {
        do {
            try output.send(packet, to: self)
        } catch let error {
            print(error)
        }
    }
    
}
