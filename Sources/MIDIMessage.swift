//
//  MIDIMessage.swift
//  Pods
//
//  Created by Daniel Clelland on 19/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//
//  The Official MIDI Specifications, MIDI Reference Tables:
//  https://www.midi.org/specifications/category/reference-tables
//

import Foundation
import CoreMIDI

public struct MIDIMessage {
    
    public enum `Type` {
        
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
    
    public let type: Type
    
    public let delay: TimeInterval
    
    public init(_ type: Type, delay: TimeInterval = 0.0) {
        self.type = type
        self.delay = delay
    }

}

extension MIDIMessage {
    
    internal init(_ packet: MIDIPacket) {
        switch packet.status {
        case 8:
            self.init(.noteOff(channel: packet.channel, key: packet.data1, velocity: packet.data2), delay: packet.delay)
        case 9:
            self.init(.noteOn(channel: packet.channel, key: packet.data1, velocity: packet.data2), delay: packet.delay)
        case 10:
            self.init(.polyphonicKeyPressure(channel: packet.channel, key: packet.data1, pressure: packet.data2), delay: packet.delay)
        case 11:
            switch (packet.data1, packet.data2) {
            case (0...119, _):
                self.init(.controlChange(channel: packet.channel, controller: packet.data1, value: packet.data2), delay: packet.delay)
            case (120, 0):
                self.init(.channelMode(channel: packet.channel, type: .allSoundOff), delay: packet.delay)
            case (121, 0):
                self.init(.channelMode(channel: packet.channel, type: .resetAllControllers), delay: packet.delay)
            case (122, 0):
                self.init(.channelMode(channel: packet.channel, type: .localControlOff), delay: packet.delay)
            case (122, 127):
                self.init(.channelMode(channel: packet.channel, type: .localControlOn), delay: packet.delay)
            case (123, 0):
                self.init(.channelMode(channel: packet.channel, type: .allNotesOff), delay: packet.delay)
            case (124, 0):
                self.init(.channelMode(channel: packet.channel, type: .omniModeOff), delay: packet.delay)
            case (125, 0):
                self.init(.channelMode(channel: packet.channel, type: .omniModeOn), delay: packet.delay)
            case (126, _):
                self.init(.channelMode(channel: packet.channel, type: .monoModeOn(channels: packet.data2)), delay: packet.delay)
            case (127, 0):
                self.init(.channelMode(channel: packet.channel, type: .polyModeOn), delay: packet.delay)
            default:
                self.init(.unknown, delay: packet.delay)
            }
        case 12:
            self.init(.programChange(channel: packet.channel, number: packet.data1), delay: packet.delay)
        case 13:
            self.init(.channelPressure(channel: packet.channel, pressure: packet.data1), delay: packet.delay)
        case 14:
            self.init(.pitchBendChange(channel: packet.channel, leastSignificantBits: packet.data1, mostSignificantBits: packet.data2), delay: packet.delay)
        case 15:
            switch packet.channel {
            case 0:
                self.init(.systemCommon(type: .systemExclusive), delay: packet.delay)
            case 1:
                self.init(.systemCommon(type: .midiTimeCodeQuarterFrame(type: packet.data1 & 0b01110000 >> 4, values: packet.data1 & 0b00001111)), delay: packet.delay)
            case 2:
                self.init(.systemCommon(type: .songPositionPointer(leastSignificantBits: packet.data1, mostSignificantBits: packet.data2)), delay: packet.delay)
            case 3:
                self.init(.systemCommon(type: .songSelect(song: packet.data1)), delay: packet.delay)
            case 5:
                self.init(.systemCommon(type: .tuneRequest), delay: packet.delay)
            case 8:
                self.init(.systemRealTime(type: .timingClock), delay: packet.delay)
            case 10:
                self.init(.systemRealTime(type: .start), delay: packet.delay)
            case 11:
                self.init(.systemRealTime(type: .continue), delay: packet.delay)
            case 12:
                self.init(.systemRealTime(type: .stop), delay: packet.delay)
            case 14:
                self.init(.systemRealTime(type: .activeSensing), delay: packet.delay)
            case 15:
                self.init(.systemRealTime(type: .reset), delay: packet.delay)
            default:
                self.init(.unknown, delay: packet.delay)
            }
        default:
            self.init(.unknown, delay: packet.delay)
        }
    }

}

extension MIDIPacket {
    
    internal init(_ message: MIDIMessage) {
        switch message.type {
        case .noteOff(let channel, let key, let velocity):
            self.init(delay: message.delay, status: 8, channel: channel, data1: key, data2: velocity)
        case .noteOn(let channel, let key, let velocity):
            self.init(delay: message.delay, status: 9, channel: channel, data1: key, data2: velocity)
        case .polyphonicKeyPressure(let channel, let key, let pressure):
            self.init(delay: message.delay, status: 10, channel: channel, data1: key, data2: pressure)
        case .controlChange(let channel, let controller, let value):
            self.init(delay: message.delay, status: 11, channel: channel, data1: controller, data2: value)
        case .channelMode(let channel, let type):
            switch type {
            case .allSoundOff:
                self.init(delay: message.delay, status: 11, channel: channel, data1: 120, data2: 0)
            case .resetAllControllers:
                self.init(delay: message.delay, status: 11, channel: channel, data1: 121, data2: 0)
            case .localControlOff:
                self.init(delay: message.delay, status: 11, channel: channel, data1: 122, data2: 0)
            case .localControlOn:
                self.init(delay: message.delay, status: 11, channel: channel, data1: 122, data2: 127)
            case .allNotesOff:
                self.init(delay: message.delay, status: 11, channel: channel, data1: 123, data2: 0)
            case .omniModeOff:
                self.init(delay: message.delay, status: 11, channel: channel, data1: 124, data2: 0)
            case .omniModeOn:
                self.init(delay: message.delay, status: 11, channel: channel, data1: 125, data2: 0)
            case .monoModeOn(let channels):
                self.init(delay: message.delay, status: 11, channel: channel, data1: 126, data2: channels)
            case .polyModeOn:
                self.init(delay: message.delay, status: 11, channel: channel, data1: 127, data2: 0)
            }
        case .programChange(let channel, let number):
            self.init(delay: message.delay, status: 12, channel: channel, data1: number)
        case .channelPressure(let channel, let pressure):
            self.init(delay: message.delay, status: 13, channel: channel, data1: pressure)
        case .pitchBendChange(let channel, let leastSignificantBits, let mostSignificantBits):
            self.init(delay: message.delay, status: 14, channel: channel, data1: leastSignificantBits, data2: mostSignificantBits)
        case .systemCommon(let type):
            switch type {
            case .systemExclusive:
                self.init(delay: message.delay, status: 15, channel: 0)
            case .midiTimeCodeQuarterFrame(let type, let values):
                self.init(delay: message.delay, status: 15, channel: 1, data1: (type << 4) | (values & 0b00001111))
            case .songPositionPointer(let leastSignificantBits, let mostSignificantBits):
                self.init(delay: message.delay, status: 15, channel: 2, data1: leastSignificantBits, data2: mostSignificantBits)
            case .songSelect(let song):
                self.init(delay: message.delay, status: 15, channel: 3, data1: song)
            case .tuneRequest:
                self.init(delay: message.delay, status: 15, channel: 5)
            }
        case .systemRealTime(let type):
            switch type {
            case .timingClock:
                self.init(delay: message.delay, status: 15, channel: 8)
            case .start:
                self.init(delay: message.delay, status: 15, channel: 10)
            case .continue:
                self.init(delay: message.delay, status: 15, channel: 11)
            case .stop:
                self.init(delay: message.delay, status: 15, channel: 12)
            case .activeSensing:
                self.init(delay: message.delay, status: 15, channel: 14)
            case .reset:
                self.init(delay: message.delay, status: 15, channel: 15)
            }
        default:
            self.init(delay: message.delay, status: 0, channel: 0)
        }
    }
    
}

extension MIDIPacketList {
    
    internal init(_ packet: MIDIPacket) {
        self.init(numPackets: 1, packet: packet)
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

extension MIDIPacket {
    
    fileprivate init(delay: TimeInterval, status: UInt8, channel: UInt8) {
        self.init()
        self.timeStamp = mach_absolute_time() + MIDITimeStamp(delay * 1_000_000_000)
        self.length = 1
        self.data.0 = (status << 4) | (channel & 0b00001111)
    }
    
    fileprivate init(delay: TimeInterval, status: UInt8, channel: UInt8, data1: UInt8) {
        self.init()
        self.timeStamp = mach_absolute_time() + MIDITimeStamp(delay * 1_000_000_000)
        self.length = 2
        self.data.0 = (status << 4) | (channel & 0b00001111)
        self.data.1 = data1 & 0b01111111
    }
    
    fileprivate init(delay: TimeInterval, status: UInt8, channel: UInt8, data1: UInt8, data2: UInt8) {
        self.init()
        self.timeStamp = mach_absolute_time() + MIDITimeStamp(delay * 1_000_000_000)
        self.length = 3
        self.data.0 = (status << 4) | (channel & 0b00001111)
        self.data.1 = data1 & 0b01111111
        self.data.2 = data2 & 0b01111111
    }
    
    fileprivate var delay: TimeInterval {
        return TimeInterval(timeStamp) / 1_000_000_000
    }
    
    fileprivate var status: UInt8 {
        return data.0 >> 4
    }
    
    fileprivate var channel: UInt8 {
        return data.0 & 0b00001111
    }
    
    fileprivate var data1: UInt8 {
        return data.1 & 0b01111111
    }
    
    fileprivate var data2: UInt8 {
        return data.2 & 0b01111111
    }
    
}
