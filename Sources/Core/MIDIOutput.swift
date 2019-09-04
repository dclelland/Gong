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
    
    public func send(_ packet: MIDIPacket, to destination: MIDIDestination) throws {
        var packetList = MIDIPacketList(packet)
        try MIDISend(reference, destination.reference, &packetList).midiError("Sending packets to destination with MIDIOutput")
    }

    public func send(_ packetList: MIDIPacketList, to destination: MIDIDestination) throws {
        var packetList = packetList // stupid, it's not mutated by MIDISend, but it's required by the compiler...
        try MIDISend(reference, destination.reference, &packetList).midiError("Sending packet list to destination with MIDIOutput")
    }
}
