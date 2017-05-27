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
    
    public func close() {
        //    public func AudioFileStreamClose(_ inAudioFileStream: AudioFileStreamID) -> OSStatus
    }
    
    public func parseBytes() {
        //    public func AudioFileStreamParseBytes(_ inAudioFileStream: AudioFileStreamID, _ inDataByteSize: UInt32, _ inData: UnsafeRawPointer, _ inFlags: AudioFileStreamParseFlags) -> OSStatus
    }
    
    public func seek() {
        //    public func AudioFileStreamSeek(_ inAudioFileStream: AudioFileStreamID, _ inPacketOffset: Int64, _ outDataByteOffset: UnsafeMutablePointer<Int64>, _ ioFlags: UnsafeMutablePointer<AudioFileStreamSeekFlags>) -> OSStatus
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
    
    public func info() {
        //    public func AudioFileStreamGetPropertyInfo(_ inAudioFileStream: AudioFileStreamID, _ inPropertyID: AudioFileStreamPropertyID, _ outPropertyDataSize: UnsafeMutablePointer<UInt32>?, _ outWritable: UnsafeMutablePointer<DarwinBoolean>?) -> OSStatus
    }
    
    public func set<T>(value: T) {
        //    public func AudioFileStreamSetProperty(_ inAudioFileStream: AudioFileStreamID, _ inPropertyID: AudioFileStreamPropertyID, _ inPropertyDataSize: UInt32, _ inPropertyData: UnsafeRawPointer) -> OSStatus
    }
    
    public func value<T>() -> T? {
        return nil
        //    public func AudioFileStreamGetProperty(_ inAudioFileStream: AudioFileStreamID, _ inPropertyID: AudioFileStreamPropertyID, _ ioPropertyDataSize: UnsafeMutablePointer<UInt32>, _ outPropertyData: UnsafeMutableRawPointer) -> OSStatus
    }
    
}
