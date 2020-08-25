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
    
    public init(delay: TimeInterval = 0.0) {
        self.init()
        self.timeStamp = mach_absolute_time() + MIDITimeStamp(delay * 1_000_000_000)
    }
    
}

extension MIDIPacket {
    
    public init(status: UInt8, channel: UInt8, delay: TimeInterval = 0.0) {
        self.init(delay: delay)
        self.length = 1
        self.status = status
        self.channel = channel.leastSignificantFourBits
    }

    public init(status: UInt8, channel: UInt8, data1: UInt8, delay: TimeInterval = 0.0) {
        self.init(delay: delay)
        self.length = 2
        self.status = status
        self.channel = channel.leastSignificantFourBits
        self.data1 = data1.leastSignificantSevenBits
    }

    public init(status: UInt8, channel: UInt8, data1: UInt8, data2: UInt8, delay: TimeInterval = 0.0) {
        self.init(delay: delay)
        self.length = 3
        self.status = status
        self.channel = channel.leastSignificantFourBits
        self.data1 = data1.leastSignificantSevenBits
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
    
    public init(bytes: [UInt8], delay: TimeInterval = 0.0) {
        self.init(delay: delay)
        self.length = UInt16(bytes.count)
        self.bytes = bytes
    }
    
}

extension MIDIPacket {
    
    public var bytes: [UInt8] {
        get {
            let bytes = Mirror(reflecting: data).children.compactMap { child in
                return child.value as? UInt8
            }
            
            return bytes.unpad(with: 0)
        }
        set {
            let bytes = newValue.pad(with: 0, to: 256)
            data = (bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7], bytes[8], bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15], bytes[16], bytes[17], bytes[18], bytes[19], bytes[20], bytes[21], bytes[22], bytes[23], bytes[24], bytes[25], bytes[26], bytes[27], bytes[28], bytes[29], bytes[30], bytes[31], bytes[32], bytes[33], bytes[34], bytes[35], bytes[36], bytes[37], bytes[38], bytes[39], bytes[40], bytes[41], bytes[42], bytes[43], bytes[44], bytes[45], bytes[46], bytes[47], bytes[48], bytes[49], bytes[50], bytes[51], bytes[52], bytes[53], bytes[54], bytes[55], bytes[56], bytes[57], bytes[58], bytes[59], bytes[60], bytes[61], bytes[62], bytes[63], bytes[64], bytes[65], bytes[66], bytes[67], bytes[68], bytes[69], bytes[70], bytes[71], bytes[72], bytes[73], bytes[74], bytes[75], bytes[76], bytes[77], bytes[78], bytes[79], bytes[80], bytes[81], bytes[82], bytes[83], bytes[84], bytes[85], bytes[86], bytes[87], bytes[88], bytes[89], bytes[90], bytes[91], bytes[92], bytes[93], bytes[94], bytes[95], bytes[96], bytes[97], bytes[98], bytes[99], bytes[100], bytes[101], bytes[102], bytes[103], bytes[104], bytes[105], bytes[106], bytes[107], bytes[108], bytes[109], bytes[110], bytes[111], bytes[112], bytes[113], bytes[114], bytes[115], bytes[116], bytes[117], bytes[118], bytes[119], bytes[120], bytes[121], bytes[122], bytes[123], bytes[124], bytes[125], bytes[126], bytes[127], bytes[128], bytes[129], bytes[130], bytes[131], bytes[132], bytes[133], bytes[134], bytes[135], bytes[136], bytes[137], bytes[138], bytes[139], bytes[140], bytes[141], bytes[142], bytes[143], bytes[144], bytes[145], bytes[146], bytes[147], bytes[148], bytes[149], bytes[150], bytes[151], bytes[152], bytes[153], bytes[154], bytes[155], bytes[156], bytes[157], bytes[158], bytes[159], bytes[160], bytes[161], bytes[162], bytes[163], bytes[164], bytes[165], bytes[166], bytes[167], bytes[168], bytes[169], bytes[170], bytes[171], bytes[172], bytes[173], bytes[174], bytes[175], bytes[176], bytes[177], bytes[178], bytes[179], bytes[180], bytes[181], bytes[182], bytes[183], bytes[184], bytes[185], bytes[186], bytes[187], bytes[188], bytes[189], bytes[190], bytes[191], bytes[192], bytes[193], bytes[194], bytes[195], bytes[196], bytes[197], bytes[198], bytes[199], bytes[200], bytes[201], bytes[202], bytes[203], bytes[204], bytes[205], bytes[206], bytes[207], bytes[208], bytes[209], bytes[210], bytes[211], bytes[212], bytes[213], bytes[214], bytes[215], bytes[216], bytes[217], bytes[218], bytes[219], bytes[220], bytes[221], bytes[222], bytes[223], bytes[224], bytes[225], bytes[226], bytes[227], bytes[228], bytes[229], bytes[230], bytes[231], bytes[232], bytes[233], bytes[234], bytes[235], bytes[236], bytes[237], bytes[238], bytes[239], bytes[240], bytes[241], bytes[242], bytes[243], bytes[244], bytes[245], bytes[246], bytes[247], bytes[248], bytes[249], bytes[250], bytes[251], bytes[252], bytes[253], bytes[254], bytes[255])
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
            case systemExclusive(bytes: [UInt8])
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
    
    public init(_ message: Message, delay: TimeInterval = 0.0) {
        switch message {
        case .noteOff(let channel, let key, let velocity):
            self.init(status: 8, channel: channel, data1: key, data2: velocity, delay: delay)
        case .noteOn(let channel, let key, let velocity):
            self.init(status: 9, channel: channel, data1: key, data2: velocity, delay: delay)
        case .polyphonicKeyPressure(let channel, let key, let pressure):
            self.init(status: 10, channel: channel, data1: key, data2: pressure, delay: delay)
        case .controlChange(let channel, let controller, let value):
            self.init(status: 11, channel: channel, data1: controller, data2: value, delay: delay)
        case .channelMode(let channel, let type):
            switch type {
            case .allSoundOff:
                self.init(status: 11, channel: channel, data1: 120, data2: 0, delay: delay)
            case .resetAllControllers:
                self.init(status: 11, channel: channel, data1: 121, data2: 0, delay: delay)
            case .localControlOff:
                self.init(status: 11, channel: channel, data1: 122, data2: 0, delay: delay)
            case .localControlOn:
                self.init(status: 11, channel: channel, data1: 122, data2: 127, delay: delay)
            case .allNotesOff:
                self.init(status: 11, channel: channel, data1: 123, data2: 0, delay: delay)
            case .omniModeOff:
                self.init(status: 11, channel: channel, data1: 124, data2: 0, delay: delay)
            case .omniModeOn:
                self.init(status: 11, channel: channel, data1: 125, data2: 0, delay: delay)
            case .monoModeOn(let channels):
                self.init(status: 11, channel: channel, data1: 126, data2: channels, delay: delay)
            case .polyModeOn:
                self.init(status: 11, channel: channel, data1: 127, data2: 0, delay: delay)
            }
        case .programChange(let channel, let number):
            self.init(status: 12, channel: channel, data1: number, delay: delay)
        case .channelPressure(let channel, let pressure):
            self.init(status: 13, channel: channel, data1: pressure, delay: delay)
        case .pitchBendChange(let channel, let value):
            self.init(status: 14, channel: channel, data1: value.leastSignificantSevenBits, data2: value.mostSignificantSevenBits, delay: delay)
        case .systemCommon(let type):
            switch type {
            case .systemExclusive(let bytes):
                self.init(bytes: bytes, delay: delay)
            case .midiTimeCodeQuarterFrame(let type, let values):
                self.init(status: 15, channel: 1, data1: UInt8(mostSignificantFourBits: type, leastSignificantFourBits: values), delay: delay)
            case .songPositionPointer(let value):
                self.init(status: 15, channel: 2, data1: value.leastSignificantSevenBits, data2: value.mostSignificantSevenBits, delay: delay)
            case .songSelect(let song):
                self.init(status: 15, channel: 3, data1: song, delay: delay)
            case .tuneRequest:
                self.init(status: 15, channel: 5, delay: delay)
            }
        case .systemRealTime(let type):
            switch type {
            case .timingClock:
                self.init(status: 15, channel: 8, delay: delay)
            case .start:
                self.init(status: 15, channel: 10, delay: delay)
            case .continue:
                self.init(status: 15, channel: 11, delay: delay)
            case .stop:
                self.init(status: 15, channel: 12, delay: delay)
            case .activeSensing:
                self.init(status: 15, channel: 14, delay: delay)
            case .reset:
                self.init(status: 15, channel: 15, delay: delay)
            }
        case .unknown:
            self.init(delay: delay)
        }
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
                return .systemCommon(type: .systemExclusive(bytes: bytes))
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

extension Array where Element: Equatable {
    
    internal func pad(with element: Element, to count: Int) -> [Element] {
        return self + [Element](repeating: element, count: count - self.count)
    }
    
    internal func unpad(with element: Element) -> [Element] {
        return reversed().drop(while: {$0 == element}).reversed()
    }
    
}
