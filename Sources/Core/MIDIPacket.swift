//
//  MIDIPacket.swift
//  Gong
//
//  Created by Daniel Clelland on 21/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

extension MIDIPacket {
    
    public init(delay: TimeInterval, length: UInt16 = 1, status: UInt8, channel: UInt8) {
        self.init()
        self.timeStamp = mach_absolute_time() + MIDITimeStamp(delay * 1_000_000_000)
        self.length = length
        self.data.0 = (status << 4) | (channel & 0b00001111)
    }
    
    public init(delay: TimeInterval, length: UInt16 = 2, status: UInt8, channel: UInt8, data1: UInt8) {
        self.init(delay: delay, length: length, status: status, channel: channel)
        self.data.1 = data1 & 0b01111111
    }
    
    public init(delay: TimeInterval, length: UInt16 = 3, status: UInt8, channel: UInt8, data1: UInt8, data2: UInt8) {
        self.init(delay: delay, length: length, status: status, channel: channel, data1: data1)
        self.data.2 = data2 & 0b01111111
    }
    
    public var delay: TimeInterval {
        return TimeInterval(timeStamp) / 1_000_000_000
    }
    
    public var status: UInt8 {
        return data.0 >> 4
    }
    
    public var channel: UInt8 {
        return data.0 & 0b00001111
    }
    
    public var data1: UInt8 {
        return data.1 & 0b01111111
    }
    
    public var data2: UInt8 {
        return data.2 & 0b01111111
    }
    
}

extension MIDIPacketList {
    
    public init(_ packet: MIDIPacket) {
        self.init(numPackets: 1, packet: packet)
    }
    
    public var packets: [MIDIPacket] {
        var packets = [packet]
        for _ in (0..<numPackets) {
            if var packet = packets.last {
                packets.append(MIDIPacketNext(&packet).pointee)
            }
        }
        return packets
    }
    
}
