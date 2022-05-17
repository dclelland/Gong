//
//  MIDIOutput.swift
//  Gong
//
//  Created by Daniel Clelland on 26/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIOutput: MIDIPort {
    
    public func send(_ packet: MIDIPacket, to destination: MIDIDestination, protocolID: MIDIProtocolID = ._1_0) throws {
        var eventList = MIDIEventList(protocol: protocolID, numPackets: 1, packet: packet)
        try MIDISendEventList(reference, destination.reference, &eventList).midiError("Sending packets to destination with MIDIOutput")
    }
    
}
