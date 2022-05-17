//
//  MIDIEventList.swift
//  Gong
//
//  Created by Daniel Clelland on 17/05/22.
//

import Foundation
import CoreMIDI

public typealias MIDIEventList = CoreMIDI.MIDIEventList

extension MIDIEventList {
    
    public init(_ packet: MIDIEventPacket, protocolID: MIDIProtocolID = ._1_0) {
        self.init(protocol: protocolID, numPackets: 1, packet: packet)
    }
    
    public var packets: [MIDIEventPacket] {
        var packets = [packet]
        for _ in (0..<numPackets) {
            if var packet = packets.last {
                packets.append(MIDIEventPacketNext(&packet).pointee)
            }
        }
        return packets
    }
    
}
