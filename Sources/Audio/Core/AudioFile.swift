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
    
    //public func AudioFileInitializeWithCallbacks(_ inClientData: UnsafeMutableRawPointer, _ inReadFunc: @escaping
    
    public static func open(_ url: URL, permissions: AudioFilePermissions = .readWritePermission, typeHint: AudioFileTypeID = 0) throws -> AudioFile {
        var audioFileReference: AudioFileID? = nil
        try AudioFileOpenURL(url as CFURL, permissions, typeHint, &audioFileReference).audioError("Opening AudioFile with URL \"\(url)\"")
        return AudioFile(audioFileReference!)
    }
    
    //public func AudioFileOpenWithCallbacks(_ inClientData: UnsafeMutableRawPointer, _ inReadFunc: @escaping
    
    public func close() throws {
        try AudioFileClose(reference).audioError("Closing AudioFile")
    }
    
    public func optimize() throws {
        try AudioFileOptimize(reference).audioError("Optimizing AudioFile")
    }
    
}

extension AudioFile {
    
    public func readBytes(into buffer: UnsafeMutableRawPointer, start: Int64, count: UInt32, useCache: Bool = false) throws {
        var count = count
        try AudioFileReadBytes(reference, useCache, start, &count, buffer).audioError("Reading bytes from AudioFile")
    }
    
    public func writeBytes(from buffer: UnsafeRawPointer, start: Int64, count: UInt32, useCache: Bool = false) throws {
        var count = count
        try AudioFileWriteBytes(reference, useCache, start, &count, buffer).audioError("Writing bytes to AudioFile")
    }
    
}

//extension AudioFile {
//    
//    public func readPackets(into buffer: UnsafeMutableRawPointer, bytes: UInt32, packetDescriptions: [AudioStreamPacketDescription]? = nil, start: Int64, count: UInt32, useCache: Bool = false) throws {
//        var bytes = bytes
//        var packetDescriptions = packetDescriptions
//        var count = count
//        try AudioFileReadPacketData(reference, useCache, &bytes, packetDescriptions, start, &count, buffer).audioError("Reading packets from AudioFile")
//    }
//    
//    public func writePackets(from buffer: UnsafeRawPointer, bytes: UInt32, packetDescriptions: [AudioStreamPacketDescription]? = nil, start: Int64, count: UInt32, useCache: Bool = false) {
//        var bytes = bytes
//        var packetDescriptions = packetDescriptions
//        var count = count
//        try AudioFileWritePackets(reference, useCache, bytes, &packetDescriptions, start, &count, buffer).audioError("Writing packets to AudioFile")
//    }
//    
//}

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
        var (size, _) = try info(for: property)
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        return data.pointee
    }
    
    public func array<T>(for property: AudioFilePropertyID) throws -> [T] {
        var (size, _) = try info(for: property)
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        let count = Int(size) / MemoryLayout<T>.size
        return (0..<count).map { index in
            return data[index]
        }
    }
    
    public func set<T>(value: T, for property: AudioFilePropertyID) throws {
        let (size, _) = try info(for: property)
        var data = value
        return try set(data: &data, for: property, size: size)
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

extension AudioFile {
    
    internal func info(for property: AudioFilePropertyID) throws -> (size: UInt32, isWritable: Bool) {
        var size: UInt32 = 0
        var isWritable: UInt32 = 0
        try AudioFileGetPropertyInfo(reference, property, &size, &isWritable).audioError("Getting AudioFile property info")
        return (size: size, isWritable: isWritable != 0)
    }

    internal func data<T>(for property: AudioFilePropertyID, size: inout UInt32) throws -> UnsafeMutablePointer<T> {
        var size = size
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        try AudioFileGetProperty(reference, property, &size, data).audioError("Getting AudioFile property")
        return data
    }
    
    internal func set<T>(data: UnsafeMutablePointer<T>, for property: AudioFilePropertyID, size: UInt32) throws {
        try AudioFileSetProperty(reference, property, size, data).audioError("Setting AudioFile property")
    }

}

//public func AudioFileCountUserData(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ outNumberItems: UnsafeMutablePointer<
//public func AudioFileGetUserDataSize(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ inIndex: UInt32, _ outUserDataSize:
//public func AudioFileGetUserData(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ inIndex: UInt32, _ ioUserDataSize:
//public func AudioFileSetUserData(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ inIndex: UInt32, _ inUserDataSize: UInt32,
//public func AudioFileRemoveUserData(_ inAudioFile: AudioFileID, _ inUserDataID: UInt32, _ inIndex: UInt32) -> OSStatus

extension AudioFile {
    
    public struct GlobalProperty {
        public static let readableTypes = kAudioFileGlobalInfo_ReadableTypes        
        public static let writableTypes = kAudioFileGlobalInfo_WritableTypes        
        public static let fileTypeName = kAudioFileGlobalInfo_FileTypeName        
        public static let availableStreamDescriptionsForFormat = kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat
        public static let availableFormatIDs = kAudioFileGlobalInfo_AvailableFormatIDs        
        public static let allExtensions = kAudioFileGlobalInfo_AllExtensions        
        public static let allHFSTypeCodes = kAudioFileGlobalInfo_AllHFSTypeCodes        
        public static let allUTIs = kAudioFileGlobalInfo_AllUTIs        
        public static let allMIMETypes = kAudioFileGlobalInfo_AllMIMETypes        
        public static let extensionsForType = kAudioFileGlobalInfo_ExtensionsForType        
        public static let hfsTypeCodesForType = kAudioFileGlobalInfo_HFSTypeCodesForType        
        public static let utisForType = kAudioFileGlobalInfo_UTIsForType        
        public static let mimeTypesForType = kAudioFileGlobalInfo_MIMETypesForType        
        public static let typesForMIMEType = kAudioFileGlobalInfo_TypesForMIMEType        
        public static let typesForUTI = kAudioFileGlobalInfo_TypesForUTI        
        public static let typesForHFSTypeCode = kAudioFileGlobalInfo_TypesForHFSTypeCode        
        public static let typesForExtension = kAudioFileGlobalInfo_TypesForExtension        
    }
    
    public static func value<T>(for property: AudioFilePropertyID, specifier: Any? = nil) throws -> T {
        var size = try self.size(for: property, specifier: specifier)
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size, specifier: specifier)
        defer {
            data.deallocate(capacity: Int(size))
        }
        return data.pointee
    }
    
    public static func array<T>(for property: AudioFilePropertyID, specifier: Any? = nil) throws -> [T] {
        var size = try self.size(for: property, specifier: specifier)
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size, specifier: specifier)
        defer {
            data.deallocate(capacity: Int(size))
        }
        let count = Int(size) / MemoryLayout<T>.size
        return (0..<count).map { index in
            return data[index]
        }
    }
    
}

extension AudioFile {
    
    internal static func size(for property: AudioFilePropertyID, specifier: Any? = nil) throws -> UInt32 {
        var size: UInt32 = 0
        var specifier = specifier
        let specifierSize = UInt32(MemoryLayout.size(ofValue: specifier))
        
        try AudioFileGetGlobalInfoSize(property, specifierSize, &specifier, &size).audioError("Getting AudioFile global info size for property: \(property)")
        
        return size
    }
    
    internal static func data<T>(for property: AudioFilePropertyID, size: inout UInt32, specifier: Any? = nil) throws -> UnsafeMutablePointer<T> {
        var specifier = specifier
        let specifierSize = UInt32(MemoryLayout.size(ofValue: specifier))
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        
        try AudioFileGetGlobalInfo(property, specifierSize, &specifier, &size, data).audioError("Getting AudioFile global info size for property: \(property)")
        
        return data
    }
    
}
