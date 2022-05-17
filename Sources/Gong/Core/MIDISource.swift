//
//  MIDISource.swift
//  Gong
//
//  Created by Daniel Clelland on 26/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

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

extension MIDISource {
    
    public func received(_ packet: MIDIEventPacket, protocolID: MIDIProtocolID = ._1_0) throws {
        var eventList = MIDIEventList(packet, protocolID: protocolID)
        try MIDIReceivedEventList(reference, &eventList).midiError("Receiving packets with MIDISource")
    }
    
}
