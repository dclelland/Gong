//
//  AudioFile.swift
//  Gong
//
//  Created by Daniel Clelland on 30/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

// should really model an AudioFile as a collection or buffer
// mutable lazy collection: buffer/samples
// this is how you interface with AudioFileWriteBytes and AudioFileReadBytes

public class AudioFile {
    
    public let reference: AudioFileID
    
    public init(_ reference: AudioFileID) {
        self.reference = reference
    }
    
    public convenience init(_ url: URL, type: AudioFileTypeID, format: AudioStreamBasicDescription, flags: AudioFileFlags) throws {
        var audioFileReference: AudioFileID? = nil
        var format = format
        try AudioFileCreateWithURL(url as CFURL, type, &format, flags, &audioFileReference).audioError("Creating AudioFile with URL \"\(url)\"")
        self.init(audioFileReference!)
    }
    
    public static func open(_ url: URL, permissions: AudioFilePermissions = .readWritePermission, typeHint: AudioFileTypeID = 0) throws -> AudioFile {
        var audioFileReference: AudioFileID? = nil
        try AudioFileOpenURL(url as CFURL, permissions, typeHint, &audioFileReference).audioError("Opening AudioFile with URL \"\(url)\"")
        return AudioFile(audioFileReference!)
    }
    
    public func close() throws {
        try AudioFileClose(reference).audioError("Closing AudioFile")
    }
    
    public func optimize() throws {
        try AudioFileOptimize(reference).audioError("Optimizing AudioFile")
    }
    
}

extension AudioFile {
    
    public func read(to buffer: UnsafeMutableRawPointer, start: Int64, count: UInt32, useCache: Bool = false) throws {
        var count = count
        try AudioFileReadBytes(reference, useCache, start, &count, buffer).audioError("Reading buffer from AudioFile")
    }
    
    public func write(from buffer: UnsafeRawPointer, start: Int64, count: UInt32, useCache: Bool = false) throws {
        var count = count
        try AudioFileWriteBytes(reference, useCache, start, &count, buffer).audioError("Writing buffer to AudioFile")
    }
    
}

extension AudioFile {
    
    public struct Property {
        
        public static let fileFormat = kAudioFilePropertyFileFormat

        public static let dataFormat = kAudioFilePropertyDataFormat

        public static let isOptimized = kAudioFilePropertyIsOptimized

        public static let magicCookieData = kAudioFilePropertyMagicCookieData

        public static let audioDataByteCount = kAudioFilePropertyAudioDataByteCount

        public static let audioDataPacketCount = kAudioFilePropertyAudioDataPacketCount

        public static let maximumPacketSize = kAudioFilePropertyMaximumPacketSize

        public static let dataOffset = kAudioFilePropertyDataOffset

        public static let channelLayout = kAudioFilePropertyChannelLayout

        public static let deferSizeUpdates = kAudioFilePropertyDeferSizeUpdates

        public static let dataFormatName = kAudioFilePropertyDataFormatName

        public static let markerList = kAudioFilePropertyMarkerList

        public static let regionList = kAudioFilePropertyRegionList

        public static let packetToFrame = kAudioFilePropertyPacketToFrame

        public static let frameToPacket = kAudioFilePropertyFrameToPacket

        public static let packetToByte = kAudioFilePropertyPacketToByte

        public static let byteToPacket = kAudioFilePropertyByteToPacket

        public static let chunkIDs = kAudioFilePropertyChunkIDs

        public static let infoDictionary = kAudioFilePropertyInfoDictionary

        public static let packetTableInfo = kAudioFilePropertyPacketTableInfo

        public static let formatList = kAudioFilePropertyFormatList

        public static let packetSizeUpperBound = kAudioFilePropertyPacketSizeUpperBound

        public static let reserveDuration = kAudioFilePropertyReserveDuration

        public static let estimatedDuration = kAudioFilePropertyEstimatedDuration

        public static let bitRate = kAudioFilePropertyBitRate

        public static let id3Tag = kAudioFilePropertyID3Tag

        public static let sourceBitDepth = kAudioFilePropertySourceBitDepth

        public static let albumArtwork = kAudioFilePropertyAlbumArtwork

        public static let audioTrackCount = kAudioFilePropertyAudioTrackCount

        public static let useAudioTrack = kAudioFilePropertyUseAudioTrack
        
    }
    
    public func value<T>(for property: AudioFilePropertyID) throws -> T {
        let (dataSize, _) = try info(for: property)
        return try value(for: property, dataSize: dataSize)
    }
    
    public func setValue<T>(_ value: T, for property: AudioFilePropertyID) throws {
        let (dataSize, _) = try info(for: property)
        return try setValue(value, for: property, dataSize: dataSize)
    }
    
}

extension AudioFile {
    
    public func info(for property: AudioFilePropertyID) throws -> (dataSize: UInt32, isWritable: Bool) {
        var dataSize: UInt32 = 0
        var isWritable: UInt32 = 0
        try AudioFileGetPropertyInfo(reference, property, &dataSize, &isWritable).audioError("Getting AudioFile property info")
        return (dataSize: dataSize, isWritable: isWritable != 0)
    }

    public func value<T>(for property: AudioFilePropertyID, dataSize: UInt32) throws -> T {
        var dataSize = dataSize
        var data = UnsafeMutablePointer<T>.allocate(capacity: Int(dataSize))
        defer {
            data.deallocate(capacity: Int(dataSize))
        }
        try AudioFileGetProperty(reference, property, &dataSize, data).audioError("Getting AudioFile property")
        return data.pointee
    }
    
    public func setValue<T>(_ value: T, for property: AudioFilePropertyID, dataSize: UInt32) throws {
        var data = value
        try AudioFileSetProperty(reference, property, dataSize, &data).audioError("Setting AudioFile property")
    }

}

extension AudioFile {
    
    public var fileFormat: AudioFileTypeID? {
        return try? value(for: Property.fileFormat)
    }
    
    public var dataFormat: AudioStreamBasicDescription? {
        return try? value(for: Property.dataFormat)
    }

    public var properties: NSDictionary? {
        let properties: CFDictionary? = try? value(for: Property.infoDictionary)
        return properties as NSDictionary?
    }
    
}

//public func AudioFileInitializeWithCallbacks(_ inClientData: UnsafeMutableRawPointer, _ inReadFunc: @escaping
//public func AudioFileOpenWithCallbacks(_ inClientData: UnsafeMutableRawPointer, _ inReadFunc: @escaping
//// close, optimise, read, write
/// The 'packets' ones are for VBR data
//public func AudioFileReadPacketData(_ inAudioFile: AudioFileID, _ inUseCache: Bool, _ ioNumBytes: UnsafeMutablePointer<UInt32>, _
//public func AudioFileReadPackets(_ inAudioFile: AudioFileID, _ inUseCache: Bool, _ outNumBytes: UnsafeMutablePointer<UInt32>, _
//public func AudioFileWritePackets(_ inAudioFile: AudioFileID, _ inUseCache: Bool, _ inNumBytes: UInt32, _ inPacketDescriptions:
//public func AudioFileCountUserData(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ outNumberItems: UnsafeMutablePointer<
//public func AudioFileGetUserDataSize(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ inIndex: UInt32, _ outUserDataSize:
//public func AudioFileGetUserData(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ inIndex: UInt32, _ ioUserDataSize:
//public func AudioFileSetUserData(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ inIndex: UInt32, _ inUserDataSize: UInt32,
//public func AudioFileRemoveUserData(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ inIndex: UInt32) -> OSStatus
//// Property info stuff
//public func AudioFileGetGlobalInfoSize(_ inPropertyID: AudioFilePropertyID, _ inSpecifierSize: UInt32, _ inSpecifier:
//public func AudioFileGetGlobalInfo(_ inPropertyID: AudioFilePropertyID, _ inSpecifierSize: UInt32, _ inSpecifier:
