//
//  MIDIMessage.swift
//  hibiscus
//
//  Created by Daniel Clelland on 16/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//
//  The Official MIDI Specifications, MIDI Reference Tables:
//  https://www.midi.org/specifications/category/reference-tables
//

import Foundation
import CoreMIDI.MIDIServices

public enum MIDIMessage {
    
    case noteOff(channel: UInt8, key: UInt8, velocity: UInt8)
    
    case noteOn(channel: UInt8, key: UInt8, velocity: UInt8)
    
    case polyphonicKeyPressure(channel: UInt8, key: UInt8, pressure: UInt8)
    
    case controlChange(channel: UInt8, controller: UInt8, value: UInt8)
    
    public enum ChannelModeType {
        
        case allSoundOff
        
        case resetAllControllers
        
        case localControlOff
        
        case localControlOn
        
        case allNotesOff
        
        case omniModeOff
        
        case omniModeOn
        
        case monoModeOn(channels: UInt8)
        
        case polyModeOn
        
    }
    
    case channelMode(channel: UInt8, type: ChannelModeType)
    
    case programChange(channel: UInt8, number: UInt8)
    
    case channelPressure(channel: UInt8, pressure: UInt8)
    
    case pitchBendChange(channel: UInt8, leastSignificantBits: UInt8, mostSignificantBits: UInt8)
    
    public enum SystemCommonType {
        
        case systemExclusive
        
        case midiTimeCodeQuarterFrame(type: UInt8, values: UInt8)
        
        case songPositionPointer(leastSignificantBits: UInt8, mostSignificantBits: UInt8)
        
        case songSelect(song: UInt8)
        
        case tuneRequest
        
        case undefined
        
        case endOfExclusive
        
    }
    
    case systemCommon(type: SystemCommonType)
    
    public enum SystemRealTimeType {
        
        case timingClock
        
        case start
        
        case `continue`
        
        case stop
        
        case activeSensing
        
        case reset
        
        case undefined
        
    }
    
    case systemRealTime(type: SystemRealTimeType)
    
    case unknown
    
}

extension MIDIPacket {
    
    public init(timestamp: MIDITimeStamp = MIDITimeStamp(0), message: MIDIMessage) {
        self.init(timeStamp: timestamp, length: 0, data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    
    public var message: MIDIMessage {
        switch status {
        case 0b1000:
            return .noteOff(channel: channel, key: data1, velocity: data2)
        case 0b1001:
            return .noteOn(channel: channel, key: data1, velocity: data2)
        case 0b1010:
            return .polyphonicKeyPressure(channel: channel, key: data1, pressure: data2)
        case 0b1011:
            switch (data1, data2) {
            case (0...119, _):
                return .controlChange(channel: channel, controller: data1, value: data2)
            case (120, 0):
                return .channelMode(channel: channel, type: .allSoundOff)
            case (121, 0):
                return .channelMode(channel: channel, type: .resetAllControllers)
            case (122, 0):
                return .channelMode(channel: channel, type: .localControlOff)
            case (122, 127):
                return .channelMode(channel: channel, type: .localControlOn)
            case (123, 0):
                return .channelMode(channel: channel, type: .allNotesOff)
            case (124, 0):
                return .channelMode(channel: channel, type: .omniModeOff)
            case (125, 0):
                return .channelMode(channel: channel, type: .omniModeOn)
            case (126, _):
                return .channelMode(channel: channel, type: .monoModeOn(channels: data2))
            case (127, 0):
                return .channelMode(channel: channel, type: .polyModeOn)
            default:
                return .unknown
            }
        case 0b1100:
            return .programChange(channel: channel, number: data1)
        case 0b1101:
            return .channelPressure(channel: channel, pressure: data1)
        case 0b1110:
            return .pitchBendChange(channel: channel, leastSignificantBits: data1, mostSignificantBits: data2)
        case 0b1111:
            switch channel {
            case 0b0000:
                return .systemCommon(type: .systemExclusive)
            case 0b0001:
                return .systemCommon(type: .midiTimeCodeQuarterFrame(type: data1 & 0b01110000 >> 4, values: data1 & 0b00001111))
            case 0b0010:
                return .systemCommon(type: .songPositionPointer(leastSignificantBits: data1, mostSignificantBits: data2))
            case 0b0011:
                return .systemCommon(type: .songSelect(song: data1))
            case 0b0100:
                return .systemCommon(type: .undefined)
            case 0b0101:
                return .systemCommon(type: .tuneRequest)
            case 0b0110:
                return .systemCommon(type: .undefined)
            case 0b0111:
                return .systemCommon(type: .endOfExclusive)
            case 0b1000:
                return .systemRealTime(type: .timingClock)
            case 0b1001:
                return .systemRealTime(type: .undefined)
            case 0b1010:
                return .systemRealTime(type: .start)
            case 0b1011:
                return .systemRealTime(type: .continue)
            case 0b1100:
                return .systemRealTime(type: .stop)
            case 0b1101:
                return .systemRealTime(type: .undefined)
            case 0b1110:
                return .systemRealTime(type: .activeSensing)
            case 0b1111:
                return .systemRealTime(type: .reset)
            default:
                return .unknown
            }
        default:
            return .unknown
        }
    }
    
    private var status: UInt8 {
        return data.0 >> 4
    }
    
    private var channel: UInt8 {
        return data.0 & 0b00001111
    }
    
    private var data1: UInt8 {
        return data.1 & 0b01111111
    }
    
    private var data2: UInt8 {
        return data.2 & 0b01111111
    }
    
}

extension MIDIPacketList {
    
    internal init(packets: [MIDIPacket]) {
        let packet = UnsafeMutablePointer<MIDIPacketList>.allocate(capacity: 1)
        
        //        let packets = MIDIPacketListInit(UnsafeMutablePointer<MIDIPacketList>)
        
        self.init()
        //        MIDIPacketListInit
        //        MIDIPacketListAdd
        //        guard var first = packets.first else {
        //            self.init(numPackets: 1, packet: MIDIPacket(timestamp: 0, message: .unknown))
        //        }
        //
        //        self.init(numPackets: UInt32(packets.count), packet: &first)
    }
    
    internal mutating func add(packet: MIDIPacket) {
        //        MIDIPacketListAdd(&self, Int, &packet, packet.timeStamp, Int, UnsafePointer<UInt8>)
    }
    
    internal var packets: [MIDIPacket] {
        var packets = [packet]
        for _ in (0..<numPackets) {
            if var packet = packets.last {
                packets.append(MIDIPacketNext(&packet).pointee)
            }
        }
        return packets
    }
    
}
