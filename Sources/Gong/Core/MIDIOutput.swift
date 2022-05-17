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
    
    public func send(_ packet: MIDIEventPacket, to destination: MIDIDestination, protocolID: MIDIProtocolID = ._1_0) throws {
        var eventList = MIDIEventList(packet, protocolID: protocolID)
        try MIDISendEventList(reference, destination.reference, &eventList).midiError("Sending packets to destination with MIDIOutput")
    }
    
}
