//
//  MIDIPacket.swift
//  Gong
//
//  Created by Daniel Clelland on 16/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//
//  The Official MIDI Specifications, MIDI Reference Tables:
//  https://www.midi.org/specifications/category/reference-tables
//

import Foundation
import CoreMIDI.MIDIServices

extension MIDIPacket {
    
    public init(timestamp: MIDITimeStamp = MIDITimeStamp(0), status: UInt8, channel: UInt8) {
        self.init()
        self.timeStamp = timestamp
        self.length = 1
        self.data.0 = (status << 4) | (channel & 0b00001111)
    }
    
    public init(timestamp: MIDITimeStamp = MIDITimeStamp(0), status: UInt8, channel: UInt8, data1: UInt8) {
        self.init()
        self.timeStamp = timestamp
        self.length = 2
        self.data.0 = (status << 4) | (channel & 0b00001111)
        self.data.1 = data1 & 0b01111111
    }
    
    public init(timestamp: MIDITimeStamp = MIDITimeStamp(0), status: UInt8, channel: UInt8, data1: UInt8, data2: UInt8) {
        self.init()
        self.timeStamp = timestamp
        self.length = 3
        self.data.0 = (status << 4) | (channel & 0b00001111)
        self.data.1 = data1 & 0b01111111
        self.data.2 = data2 & 0b01111111
    }
    
    public enum Message {
        
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
            
        }
        
        case systemCommon(type: SystemCommonType)
        
        public enum SystemRealTimeType {
            
            case timingClock
            
            case start
            
            case `continue`
            
            case stop
            
            case activeSensing
            
            case reset
            
        }
        
        case systemRealTime(type: SystemRealTimeType)
        
        case unknown
        
    }
    
    public init(timestamp: MIDITimeStamp = MIDITimeStamp(0), message: Message) {
        switch message {
        case .noteOff(let channel, let key, let velocity):
            self.init(status: 8, channel: channel, data1: key, data2: velocity)
        case .noteOn(let channel, let key, let velocity):
            self.init(status: 9, channel: channel, data1: key, data2: velocity)
        case .polyphonicKeyPressure(let channel, let key, let pressure):
            self.init(status: 10, channel: channel, data1: key, data2: pressure)
        case .controlChange(let channel, let controller, let value):
            self.init(status: 11, channel: channel, data1: controller, data2: value)
        case .channelMode(let channel, let type):
            switch type {
            case .allSoundOff:
                self.init(status: 11, channel: channel, data1: 120, data2: 0)
            case .resetAllControllers:
                self.init(status: 11, channel: channel, data1: 121, data2: 0)
            case .localControlOff:
                self.init(status: 11, channel: channel, data1: 122, data2: 0)
            case .localControlOn:
                self.init(status: 11, channel: channel, data1: 122, data2: 127)
            case .allNotesOff:
                self.init(status: 11, channel: channel, data1: 123, data2: 0)
            case .omniModeOff:
                self.init(status: 11, channel: channel, data1: 124, data2: 0)
            case .omniModeOn:
                self.init(status: 11, channel: channel, data1: 125, data2: 0)
            case .monoModeOn(let channels):
                self.init(status: 11, channel: channel, data1: 126, data2: channels)
            case .polyModeOn:
                self.init(status: 11, channel: channel, data1: 127, data2: 0)
            }
        case .programChange(let channel, let number):
            self.init(status: 12, channel: channel, data1: number)
        case .channelPressure(let channel, let pressure):
            self.init(status: 13, channel: channel, data1: pressure)
        case .pitchBendChange(let channel, let leastSignificantBits, let mostSignificantBits):
            self.init(status: 14, channel: channel, data1: leastSignificantBits, data2: mostSignificantBits)
        case .systemCommon(let type):
            switch type {
            case .systemExclusive:
                self.init(status: 15, channel: 0)
            case .midiTimeCodeQuarterFrame(let type, let values):
                self.init(status: 15, channel: 1, data1: (type << 4) | (values & 0b00001111))
            case .songPositionPointer(let leastSignificantBits, let mostSignificantBits):
                self.init(status: 15, channel: 2, data1: leastSignificantBits, data2: mostSignificantBits)
            case .songSelect(let song):
                self.init(status: 15, channel: 3, data1: song)
            case .tuneRequest:
                self.init(status: 15, channel: 5)
            }
        case .systemRealTime(let type):
            switch type {
            case .timingClock:
                self.init(status: 15, channel: 8)
            case .start:
                self.init(status: 15, channel: 10)
            case .continue:
                self.init(status: 15, channel: 11)
            case .stop:
                self.init(status: 15, channel: 12)
            case .activeSensing:
                self.init(status: 15, channel: 14)
            case .reset:
                self.init(status: 15, channel: 15)
            }
        default:
            self.init(status: 0, channel: 0)
        }
    }
    
    public var message: Message {
        switch status {
        case 8:
            return .noteOff(channel: channel, key: data1, velocity: data2)
        case 9:
            return .noteOn(channel: channel, key: data1, velocity: data2)
        case 10:
            return .polyphonicKeyPressure(channel: channel, key: data1, pressure: data2)
        case 11:
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
        case 12:
            return .programChange(channel: channel, number: data1)
        case 13:
            return .channelPressure(channel: channel, pressure: data1)
        case 14:
            return .pitchBendChange(channel: channel, leastSignificantBits: data1, mostSignificantBits: data2)
        case 15:
            switch channel {
            case 0:
                return .systemCommon(type: .systemExclusive)
            case 1:
                return .systemCommon(type: .midiTimeCodeQuarterFrame(type: data1 & 0b01110000 >> 4, values: data1 & 0b00001111))
            case 2:
                return .systemCommon(type: .songPositionPointer(leastSignificantBits: data1, mostSignificantBits: data2))
            case 3:
                return .systemCommon(type: .songSelect(song: data1))
            case 5:
                return .systemCommon(type: .tuneRequest)
            case 8:
                return .systemRealTime(type: .timingClock)
            case 10:
                return .systemRealTime(type: .start)
            case 11:
                return .systemRealTime(type: .continue)
            case 12:
                return .systemRealTime(type: .stop)
            case 14:
                return .systemRealTime(type: .activeSensing)
            case 15:
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
    
    // "The timestamps in the packet list must be in ascending order."
    
    internal init(packets: [MIDIPacket]) {
        var packetList = MIDIPacketList()
        packetList.numPackets = UInt32(packets.count)
        
        for var packet in packets {
            
//            @result			Returns null if there was not room in the packet for the
//                event; otherwise returns a packet pointer which should be
//            passed as curPacket in a subsequent call to this function.
            
            let pointer = MIDIPacketListAdd(&packetList, 512, &packet, packet.timeStamp, Int(packet.length), &packet.data.0)
            
            
        }
        
        self = packetList
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
