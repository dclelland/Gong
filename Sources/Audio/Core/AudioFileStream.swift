//
//  AudioFileStream.swift
//  Gong
//
//  Created by Daniel Clelland on 27/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioFileStream {
    
    public let reference: AudioFileStreamID
    
    public init(_ reference: AudioFileStreamID) {
        self.reference = reference
    }
    
}

extension AudioFileStream {
    
    public func open() {
        //    public func AudioFileStreamOpen(_ inClientData: UnsafeMutableRawPointer?, _ inPropertyListenerProc: @escaping AudioToolbox.AudioFileStream_PropertyListenerProc, _ inPacketsProc: @escaping AudioToolbox.AudioFileStream_PacketsProc, _ inFileTypeHint: AudioFileTypeID, _ outAudioFileStream: UnsafeMutablePointer<AudioFileStreamID?>) -> OSStatus
    }
    
    public func close() throws {
        try AudioFileStreamClose(reference).audioError("Closing AudioFileStream")
    }
    
    public func parse(bytes: UnsafeRawPointer, size: UInt32, flags: AudioFileStreamParseFlags) throws {
        try AudioFileStreamParseBytes(reference, size, bytes, flags).audioError("Parsing AudioFileStream bytes")
    }
    
    public func seek(offset: Int64, flags: AudioFileStreamSeekFlags) throws -> Int64 {
        var byteOffset: Int64 = 0
        var flags = flags
        try AudioFileStreamSeek(reference, offset, &byteOffset, &flags).audioError("Seeking AudioFileStream")
        return byteOffset
    }
    
}

extension AudioFileStream {
    
    public struct Property {
        public let readyToProducePackets = kAudioFileStreamProperty_ReadyToProducePackets
        public let fileFormat = kAudioFileStreamProperty_FileFormat
        public let dataFormat = kAudioFileStreamProperty_DataFormat
        public let formatList = kAudioFileStreamProperty_FormatList
        public let magicCookieData = kAudioFileStreamProperty_MagicCookieData
        public let audioDataByteCount = kAudioFileStreamProperty_AudioDataByteCount
        public let audioDataPacketCount = kAudioFileStreamProperty_AudioDataPacketCount
        public let maximumPacketSize = kAudioFileStreamProperty_MaximumPacketSize
        public let dataOffset = kAudioFileStreamProperty_DataOffset
        public let channelLayout = kAudioFileStreamProperty_ChannelLayout
        public let packetToFrame = kAudioFileStreamProperty_PacketToFrame
        public let frameToPacket = kAudioFileStreamProperty_FrameToPacket
        public let packetToByte = kAudioFileStreamProperty_PacketToByte
        public let byteToPacket = kAudioFileStreamProperty_ByteToPacket
        public let packetTableInfo = kAudioFileStreamProperty_PacketTableInfo
        public let packetSizeUpperBound = kAudioFileStreamProperty_PacketSizeUpperBound
        public let averageBytesPerPacket = kAudioFileStreamProperty_AverageBytesPerPacket
        public let bitRate = kAudioFileStreamProperty_BitRate
        public let infoDictionary = kAudioFileStreamProperty_InfoDictionary
    }
    
    public func value<T>(for property: AudioFileStreamPropertyID) throws -> T {
        var size = try info(for: property).size
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        return data.pointee
    }
    
    public func array<T>(for property: AudioFileStreamPropertyID) throws -> [T] {
        var size = try info(for: property).size
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        
        let count = Int(size) / MemoryLayout<T>.size
        return (0..<count).map { index in
            return data[index]
        }
    }
    
    public func set<T>(value: T, for property: AudioFileStreamPropertyID) throws {
        let size = try info(for: property).size
        var data = value
        return try set(data: &data, for: property, size: size)
    }
    
}

extension AudioFileStream {
        
    internal func info(for property: AudioFileStreamPropertyID) throws -> (size: UInt32, isWritable: Bool) {
        var size: UInt32 = 0
        var isWritable: DarwinBoolean = false
        try AudioFileStreamGetPropertyInfo(reference, property, &size, &isWritable).audioError("Getting AudioFileStream property info")
        return (size: size, isWritable: isWritable.boolValue)
    }
    
    internal func data<T>(for property: AudioFileStreamPropertyID, size: inout UInt32) throws -> UnsafeMutablePointer<T> {
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        try AudioFileStreamGetProperty(reference, property, &size, data).audioError("Getting AudioFileStream property")
        return data
    }
    
    internal func set<T>(data: UnsafeMutablePointer<T>, for property: AudioFileStreamPropertyID, size: UInt32) throws {
        try AudioFileStreamSetProperty(reference, property, size, data).audioError("Setting AudioFileStream property")
    }
    
}
