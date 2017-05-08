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

extension MIDIPacket {
    
    public init(timeStamp: MIDITimeStamp, length: UInt16 = 0) {
        self.init()
        self.timeStamp = timeStamp
        self.length = length
    }
    
    public init(timeStamp: MIDITimeStamp, length: UInt16 = 1, status: UInt8, channel: UInt8) {
        self.init(timeStamp: timeStamp, length: length)
        self.status = status
        self.channel = channel.leastSignificantFourBits
    }

    public init(timeStamp: MIDITimeStamp, length: UInt16 = 2, status: UInt8, channel: UInt8, data1: UInt8) {
        self.init(timeStamp: timeStamp, length: length, status: status, channel: channel)
        self.data1 = data1.leastSignificantSevenBits
    }

    public init(timeStamp: MIDITimeStamp, length: UInt16 = 3, status: UInt8, channel: UInt8, data1: UInt8, data2: UInt8) {
        self.init(timeStamp: timeStamp, length: length, status: status, channel: channel, data1: data1)
        self.data2 = data2.leastSignificantSevenBits
    }
    
}

extension MIDIPacket {
    
    public var status: UInt8 {
        set {
            data.0.mostSignificantFourBits = newValue
        }
        get {
            return data.0.mostSignificantFourBits
        }
    }
    
    public var channel: UInt8 {
        set {
            data.0.leastSignificantFourBits = newValue
        }
        get {
            return data.0.leastSignificantFourBits
        }
    }
    
    public var data1: UInt8 {
        set {
            data.1.leastSignificantSevenBits = newValue
        }
        get {
            return data.1.leastSignificantSevenBits
        }
    }
    
    public var data2: UInt8 {
        set {
            data.2.leastSignificantSevenBits = newValue
        }
        get {
            return data.2.leastSignificantSevenBits
        }
    }
    
}

extension MIDIPacket {

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
        case unknown
        
    }
    
    public init(_ message: Message, timeStamp: MIDITimeStamp) {
        switch message {
        case .noteOff(let channel, let key, let velocity):
            self.init(timeStamp: timeStamp, status: 8, channel: channel, data1: key, data2: velocity)
        case .noteOn(let channel, let key, let velocity):
            self.init(timeStamp: timeStamp, status: 9, channel: channel, data1: key, data2: velocity)
        case .polyphonicKeyPressure(let channel, let key, let pressure):
            self.init(timeStamp: timeStamp, status: 10, channel: channel, data1: key, data2: pressure)
        case .controlChange(let channel, let controller, let value):
            self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: controller, data2: value)
        case .channelMode(let channel, let type):
            switch type {
            case .allSoundOff:
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 120, data2: 0)
            case .resetAllControllers:
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 121, data2: 0)
            case .localControlOff:
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 122, data2: 0)
            case .localControlOn:
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 122, data2: 127)
            case .allNotesOff:
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 123, data2: 0)
            case .omniModeOff:
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 124, data2: 0)
            case .omniModeOn:
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 125, data2: 0)
            case .monoModeOn(let channels):
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 126, data2: channels)
            case .polyModeOn:
                self.init(timeStamp: timeStamp, status: 11, channel: channel, data1: 127, data2: 0)
            }
        case .programChange(let channel, let number):
            self.init(timeStamp: timeStamp, status: 12, channel: channel, data1: number)
        case .channelPressure(let channel, let pressure):
            self.init(timeStamp: timeStamp, status: 13, channel: channel, data1: pressure)
        case .pitchBendChange(let channel, let value):
            self.init(timeStamp: timeStamp, status: 14, channel: channel, data1: value.leastSignificantSevenBits, data2: value.mostSignificantSevenBits)
        case .systemCommon(let type):
            switch type {
            case .systemExclusive:
                self.init(timeStamp: timeStamp, status: 15, channel: 0)
            case .midiTimeCodeQuarterFrame(let type, let values):
                self.init(timeStamp: timeStamp, status: 15, channel: 1, data1: UInt8(mostSignificantFourBits: type, leastSignificantFourBits: values))
            case .songPositionPointer(let value):
                self.init(timeStamp: timeStamp, status: 15, channel: 2, data1: value.leastSignificantSevenBits, data2: value.mostSignificantSevenBits)
            case .songSelect(let song):
                self.init(timeStamp: timeStamp, status: 15, channel: 3, data1: song)
            case .tuneRequest:
                self.init(timeStamp: timeStamp, status: 15, channel: 5)
            }
        case .systemRealTime(let type):
            switch type {
            case .timingClock:
                self.init(timeStamp: timeStamp, status: 15, channel: 8)
            case .start:
                self.init(timeStamp: timeStamp, status: 15, channel: 10)
            case .continue:
                self.init(timeStamp: timeStamp, status: 15, channel: 11)
            case .stop:
                self.init(timeStamp: timeStamp, status: 15, channel: 12)
            case .activeSensing:
                self.init(timeStamp: timeStamp, status: 15, channel: 14)
            case .reset:
                self.init(timeStamp: timeStamp, status: 15, channel: 15)
            }
        case .unknown:
            self.init(timeStamp: timeStamp)
        }
    }

    public init(_ message: Message, delay: TimeInterval = 0.0) {
        let timeStamp = mach_absolute_time() + MIDITimeStamp(delay * 1_000_000_000)
        self.init(message, timeStamp: timeStamp)
    }
    
}

extension MIDIPacket {
    
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
            return .pitchBendChange(channel: channel, value: UInt16(mostSignificantSevenBits: data2, leastSignificantSevenBits: data1))
        case 15:
            switch channel {
            case 0:
                return .systemCommon(type: .systemExclusive)
            case 1:
                return .systemCommon(type: .midiTimeCodeQuarterFrame(type: data1.mostSignificantFourBits, values: data1.leastSignificantFourBits))
            case 2:
                return .systemCommon(type: .songPositionPointer(value: UInt16(mostSignificantSevenBits: data2, leastSignificantSevenBits: data1)))
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

extension UInt8 {
    
    internal init(leastSignificantSevenBits: UInt8) {
        self.init()
        self.leastSignificantSevenBits = leastSignificantSevenBits
    }
    
    internal var leastSignificantSevenBits: UInt8 {
        set {
            self = (self & 0b1000_0000) | (newValue & 0b111_1111)
        }
        get {
            return self & 0b0111_1111
        }
    }
    
}

extension UInt8 {
    
    internal init(mostSignificantFourBits: UInt8, leastSignificantFourBits: UInt8) {
        self.init()
        self.mostSignificantFourBits = mostSignificantFourBits
        self.leastSignificantFourBits = leastSignificantFourBits
    }
    
    internal var mostSignificantFourBits: UInt8 {
        set {
            self = (self & 0b0000_1111) | ((newValue << 4) & 0b1111_0000)
        }
        get {
            return (self & 0b1111_0000) >> 4
        }
    }
    
    internal var leastSignificantFourBits: UInt8 {
        set {
            self = (self & 0b1111_0000) | (newValue & 0b0000_1111)
        }
        get {
            return self & 0b0000_1111
        }
    }

}

extension UInt16 {
    
    internal init(mostSignificantSevenBits: UInt8, leastSignificantSevenBits: UInt8) {
        self.init()
        self.mostSignificantSevenBits = mostSignificantSevenBits
        self.leastSignificantSevenBits = leastSignificantSevenBits
    }
    
    internal var mostSignificantSevenBits: UInt8 {
        set {
            self = (self & 0b0000_0000_0111_1111) | ((UInt16(newValue) << 7) & 0b0011_1111_1000_0000)
        }
        get {
            return UInt8((self & 0b0011_1111_1000_0000) >> 7)
        }
    }
    
    internal var leastSignificantSevenBits: UInt8 {
        set {
            self = (self & 0b0011_1111_1000_0000) | (UInt16(newValue) & 0b0000_0000_0111_1111)
        }
        get {
            return UInt8(self & 0b0000_0000_0111_1111)
        }
    }
    
}
