//
//  MIDIPacket.swift
//  Gong
//
//  Created by Daniel Clelland on 21/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//
//  The Official MIDI Specifications, MIDI Reference Tables:
//  https://www.midi.org/specifications/category/reference-tables
//

import Foundation
import CoreMIDI

public struct MIDIPacket {
    
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
        
        case pitchBendChange(channel: UInt8, value: UInt16)
        
        public enum SystemCommonType {
            
            case systemExclusive
            
            case midiTimeCodeQuarterFrame(type: UInt8, values: UInt8)
            
            case songPositionPointer(value: UInt16)
            
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
        
    }
    
    public let message: Message
    
    public let timeStamp: MIDITimeStamp
    
    public init(_ message: Message, timeStamp: MIDITimeStamp) {
        self.message = message
        self.timeStamp = timeStamp
    }
    
    public init(_ message: Message, delay: TimeInterval = 0.0) {
        let timeStamp = mach_absolute_time() + MIDITimeStamp(delay * 1_000_000_000)
        self.init(message, timeStamp: timeStamp)
    }
    
}

extension MIDIPacket {
    
    internal init?(_ packet: CoreMIDI.MIDIPacket) {
        switch packet.status {
        case 8:
            self.init(.noteOff(channel: packet.channel, key: packet.data1, velocity: packet.data2), timeStamp: packet.timeStamp)
        case 9:
            self.init(.noteOn(channel: packet.channel, key: packet.data1, velocity: packet.data2), timeStamp: packet.timeStamp)
        case 10:
            self.init(.polyphonicKeyPressure(channel: packet.channel, key: packet.data1, pressure: packet.data2), timeStamp: packet.timeStamp)
        case 11:
            switch (packet.data1, packet.data2) {
            case (0...119, _):
                self.init(.controlChange(channel: packet.channel, controller: packet.data1, value: packet.data2), timeStamp: packet.timeStamp)
            case (120, 0):
                self.init(.channelMode(channel: packet.channel, type: .allSoundOff), timeStamp: packet.timeStamp)
            case (121, 0):
                self.init(.channelMode(channel: packet.channel, type: .resetAllControllers), timeStamp: packet.timeStamp)
            case (122, 0):
                self.init(.channelMode(channel: packet.channel, type: .localControlOff), timeStamp: packet.timeStamp)
            case (122, 127):
                self.init(.channelMode(channel: packet.channel, type: .localControlOn), timeStamp: packet.timeStamp)
            case (123, 0):
                self.init(.channelMode(channel: packet.channel, type: .allNotesOff), timeStamp: packet.timeStamp)
            case (124, 0):
                self.init(.channelMode(channel: packet.channel, type: .omniModeOff), timeStamp: packet.timeStamp)
            case (125, 0):
                self.init(.channelMode(channel: packet.channel, type: .omniModeOn), timeStamp: packet.timeStamp)
            case (126, _):
                self.init(.channelMode(channel: packet.channel, type: .monoModeOn(channels: packet.data2)), timeStamp: packet.timeStamp)
            case (127, 0):
                self.init(.channelMode(channel: packet.channel, type: .polyModeOn), timeStamp: packet.timeStamp)
            default:
                return nil
            }
        case 12:
            self.init(.programChange(channel: packet.channel, number: packet.data1), timeStamp: packet.timeStamp)
        case 13:
            self.init(.channelPressure(channel: packet.channel, pressure: packet.data1), timeStamp: packet.timeStamp)
        case 14:
            self.init(.pitchBendChange(channel: packet.channel, value: UInt16(mostSignificantSevenBits: packet.data2, leastSignificantSevenBits: packet.data1)), timeStamp: packet.timeStamp)
        case 15:
            switch packet.channel {
            case 0:
                self.init(.systemCommon(type: .systemExclusive), timeStamp: packet.timeStamp)
            case 1:
                self.init(.systemCommon(type: .midiTimeCodeQuarterFrame(type: packet.data1.mostSignificantFourBits, values: packet.data1.leastSignificantFourBits)), timeStamp: packet.timeStamp)
            case 2:
                self.init(.systemCommon(type: .songPositionPointer(value: UInt16(mostSignificantSevenBits: packet.data2, leastSignificantSevenBits: packet.data1))), timeStamp: packet.timeStamp)
            case 3:
                self.init(.systemCommon(type: .songSelect(song: packet.data1)), timeStamp: packet.timeStamp)
            case 5:
                self.init(.systemCommon(type: .tuneRequest), timeStamp: packet.timeStamp)
            case 8:
                self.init(.systemRealTime(type: .timingClock), timeStamp: packet.timeStamp)
            case 10:
                self.init(.systemRealTime(type: .start), timeStamp: packet.timeStamp)
            case 11:
                self.init(.systemRealTime(type: .continue), timeStamp: packet.timeStamp)
            case 12:
                self.init(.systemRealTime(type: .stop), timeStamp: packet.timeStamp)
            case 14:
                self.init(.systemRealTime(type: .activeSensing), timeStamp: packet.timeStamp)
            case 15:
                self.init(.systemRealTime(type: .reset), timeStamp: packet.timeStamp)
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
}

extension CoreMIDI.MIDIPacket {
    
    internal init(timeStamp: MIDITimeStamp, length: UInt16 = 1, status: UInt8, channel: UInt8) {
        self.init()
        self.timeStamp = timeStamp
        self.length = length
        self.status = status
        self.data.0 = (status << 4) | (channel & 0b00001111)
    }
    
    internal init(timeStamp: MIDITimeStamp, length: UInt16 = 2, status: UInt8, channel: UInt8, data1: UInt8) {
        self.init(timeStamp: timeStamp, length: length, status: status, channel: channel)
        self.data1 = data1.leastSignificantSevenBits
    }
    
    internal init(timeStamp: MIDITimeStamp, length: UInt16 = 3, status: UInt8, channel: UInt8, data1: UInt8, data2: UInt8) {
        self.init(timeStamp: timeStamp, length: length, status: status, channel: channel, data1: data1)
        self.data2 = data2.leastSignificantSevenBits
    }
    
    internal init(_ packet: MIDIPacket) {
        switch packet.message {
        case .noteOff(let channel, let key, let velocity):
            self.init(timeStamp: packet.timeStamp, status: 8, channel: channel, data1: key, data2: velocity)
        case .noteOn(let channel, let key, let velocity):
            self.init(timeStamp: packet.timeStamp, status: 9, channel: channel, data1: key, data2: velocity)
        case .polyphonicKeyPressure(let channel, let key, let pressure):
            self.init(timeStamp: packet.timeStamp, status: 10, channel: channel, data1: key, data2: pressure)
        case .controlChange(let channel, let controller, let value):
            self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: controller, data2: value)
        case .channelMode(let channel, let type):
            switch type {
            case .allSoundOff:
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 120, data2: 0)
            case .resetAllControllers:
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 121, data2: 0)
            case .localControlOff:
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 122, data2: 0)
            case .localControlOn:
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 122, data2: 127)
            case .allNotesOff:
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 123, data2: 0)
            case .omniModeOff:
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 124, data2: 0)
            case .omniModeOn:
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 125, data2: 0)
            case .monoModeOn(let channels):
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 126, data2: channels)
            case .polyModeOn:
                self.init(timeStamp: packet.timeStamp, status: 11, channel: channel, data1: 127, data2: 0)
            }
        case .programChange(let channel, let number):
            self.init(timeStamp: packet.timeStamp, status: 12, channel: channel, data1: number)
        case .channelPressure(let channel, let pressure):
            self.init(timeStamp: packet.timeStamp, status: 13, channel: channel, data1: pressure)
        case .pitchBendChange(let channel, let value):
            self.init(timeStamp: packet.timeStamp, status: 14, channel: channel, data1: value.leastSignificantSevenBits, data2: value.mostSignificantSevenBits)
        case .systemCommon(let type):
            switch type {
            case .systemExclusive:
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 0)
            case .midiTimeCodeQuarterFrame(let type, let values):
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 1, data1: UInt8(mostSignificantFourBits: type, leastSignificantFourBits: values))
            case .songPositionPointer(let value):
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 2, data1: value.leastSignificantSevenBits, data2: value.mostSignificantSevenBits)
            case .songSelect(let song):
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 3, data1: song)
            case .tuneRequest:
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 5)
            }
        case .systemRealTime(let type):
            switch type {
            case .timingClock:
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 8)
            case .start:
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 10)
            case .continue:
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 11)
            case .stop:
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 12)
            case .activeSensing:
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 14)
            case .reset:
                self.init(timeStamp: packet.timeStamp, status: 15, channel: 15)
            }
        }
    }
    
}

extension CoreMIDI.MIDIPacketList {
    
    internal init(_ packet: MIDIPacket) {
        self.init(numPackets: 1, packet: CoreMIDI.MIDIPacket(packet))
    }
    
    internal var packets: [MIDIPacket] {
        var packets = [packet]
        for _ in (0..<numPackets) {
            if var packet = packets.last {
                packets.append(MIDIPacketNext(&packet).pointee)
            }
        }
        return packets.flatMap(MIDIPacket.init)
    }
    
}

extension CoreMIDI.MIDIPacket {
    
    internal var status: UInt8 {
        set {
            data.0.mostSignificantFourBits = newValue
        }
        get {
            return data.0.mostSignificantFourBits
        }
    }
    
    internal var channel: UInt8 {
        set {
            data.0.leastSignificantFourBits = newValue
        }
        get {
            return data.0.leastSignificantFourBits
        }
    }
    
    internal var data1: UInt8 {
        set {
            data.1.leastSignificantSevenBits = newValue
        }
        get {
            return data.1.leastSignificantSevenBits
        }
    }
    
    internal var data2: UInt8 {
        set {
            data.2.leastSignificantSevenBits = newValue
        }
        get {
            return data.2.leastSignificantSevenBits
        }
    }

}

extension UInt8 {
    
    fileprivate init(leastSignificantSevenBits: UInt8) {
        self.init()
        self.leastSignificantSevenBits = leastSignificantSevenBits
    }
    
    fileprivate var leastSignificantSevenBits: UInt8 {
        set {
            self = (self & 0b1000_0000) | (newValue & 0b111_1111)
        }
        get {
            return self & 0b0111_1111
        }
    }
    
}

extension UInt8 {
    
    fileprivate init(mostSignificantFourBits: UInt8, leastSignificantFourBits: UInt8) {
        self.init()
        self.mostSignificantFourBits = mostSignificantFourBits
        self.leastSignificantFourBits = leastSignificantFourBits
    }
    
    fileprivate var mostSignificantFourBits: UInt8 {
        set {
            self = (self & 0b0000_1111) | ((newValue << 4) & 0b1111_0000)
        }
        get {
            return (self & 0b1111_0000) >> 4
        }
    }
    
    fileprivate var leastSignificantFourBits: UInt8 {
        set {
            self = (self & 0b1111_0000) | (newValue & 0b0000_1111)
        }
        get {
            return self & 0b0000_1111
        }
    }

}

extension UInt16 {
    
    fileprivate init(mostSignificantSevenBits: UInt8, leastSignificantSevenBits: UInt8) {
        self.init()
        self.mostSignificantSevenBits = mostSignificantSevenBits
        self.leastSignificantSevenBits = leastSignificantSevenBits
    }
    
    fileprivate var mostSignificantSevenBits: UInt8 {
        set {
            self = (self & 0b0000_0000_0111_1111) | ((UInt16(newValue) << 7) & 0b0011_1111_1000_0000)
        }
        get {
            return UInt8((self & 0b0011_1111_1000_0000) >> 7)
        }
    }
    
    fileprivate var leastSignificantSevenBits: UInt8 {
        set {
            self = (self & 0b0011_1111_1000_0000) | (UInt16(newValue) & 0b0000_0000_0111_1111)
        }
        get {
            return UInt8(self & 0b0000_0000_0111_1111)
        }
    }
    
}
