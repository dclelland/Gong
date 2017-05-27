//
//  AudioFormat.swift
//  Gong
//
//  Created by Daniel Clelland on 27/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox.AudioFormat

public class AudioFormat {
    
    public struct Property {
        public static let formatInfo = kAudioFormatProperty_FormatInfo
        public static let formatName = kAudioFormatProperty_FormatName
        public static let encodeFormatIDs = kAudioFormatProperty_EncodeFormatIDs
        public static let decodeFormatIDs = kAudioFormatProperty_DecodeFormatIDs
        public static let formatList = kAudioFormatProperty_FormatList
        public static let asbdFromESDS = kAudioFormatProperty_ASBDFromESDS
        public static let channelLayoutFromESDS = kAudioFormatProperty_ChannelLayoutFromESDS
        public static let outputFormatList = kAudioFormatProperty_OutputFormatList
        public static let firstPlayableFormatFromList = kAudioFormatProperty_FirstPlayableFormatFromList
        public static let formatIsVBR = kAudioFormatProperty_FormatIsVBR
        public static let formatIsExternallyFramed = kAudioFormatProperty_FormatIsExternallyFramed
        public static let formatIsEncrypted = kAudioFormatProperty_FormatIsEncrypted
        public static let encoders = kAudioFormatProperty_Encoders
        public static let decoders = kAudioFormatProperty_Decoders
        public static let availableEncodeBitRates = kAudioFormatProperty_AvailableEncodeBitRates
        public static let availableEncodeSampleRates = kAudioFormatProperty_AvailableEncodeSampleRates
        public static let availableEncodeChannelLayoutTags = kAudioFormatProperty_AvailableEncodeChannelLayoutTags
        public static let availableEncodeNumberChannels = kAudioFormatProperty_AvailableEncodeNumberChannels
        public static let asbdFromMPEGPacket = kAudioFormatProperty_ASBDFromMPEGPacket
        public static let bitmapForLayoutTag = kAudioFormatProperty_BitmapForLayoutTag
        public static let matrixMixMap = kAudioFormatProperty_MatrixMixMap
        public static let channelMap = kAudioFormatProperty_ChannelMap
        public static let numberOfChannelsForLayout = kAudioFormatProperty_NumberOfChannelsForLayout
        public static let areChannelLayoutsEquivalent = kAudioFormatProperty_AreChannelLayoutsEquivalent
        public static let channelLayoutHash = kAudioFormatProperty_ChannelLayoutHash
        public static let validateChannelLayout = kAudioFormatProperty_ValidateChannelLayout
        public static let channelLayoutForTag = kAudioFormatProperty_ChannelLayoutForTag
        public static let tagForChannelLayout = kAudioFormatProperty_TagForChannelLayout
        public static let channelLayoutName = kAudioFormatProperty_ChannelLayoutName
        public static let channelLayoutSimpleName = kAudioFormatProperty_ChannelLayoutSimpleName
        public static let channelLayoutForBitmap = kAudioFormatProperty_ChannelLayoutForBitmap
        public static let channelName = kAudioFormatProperty_ChannelName
        public static let channelShortName = kAudioFormatProperty_ChannelShortName
        public static let tagsForNumberOfChannels = kAudioFormatProperty_TagsForNumberOfChannels
        public static let panningMatrix = kAudioFormatProperty_PanningMatrix
        public static let balanceFade = kAudioFormatProperty_BalanceFade
        public static let id3TagSize = kAudioFormatProperty_ID3TagSize
        public static let id3TagToDictionary = kAudioFormatProperty_ID3TagToDictionary
    }
    
    public static func value<T>(for property: AudioFormatPropertyID, specifier: Any? = nil) throws -> T {
        var size = try self.size(for: property, specifier: specifier)
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size, specifier: specifier)
        defer {
            data.deallocate(capacity: Int(size))
        }
        return data.pointee
    }
    
    public static func array<T>(for property: AudioFormatPropertyID, specifier: Any? = nil) throws -> [T] {
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

extension AudioFormat {
    
    internal static func size(for property: AudioFormatPropertyID, specifier: Any? = nil) throws -> UInt32 {
        var size: UInt32 = 0
        var specifier = specifier
        let specifierSize = UInt32(MemoryLayout.size(ofValue: specifier))
        
        try AudioFormatGetPropertyInfo(property, specifierSize, &specifier, &size).audioError("Getting AudioFormat info for property")
        
        return size
    }
    
    internal static func data<T>(for property: AudioFormatPropertyID, size: inout UInt32, specifier: Any? = nil) throws -> UnsafeMutablePointer<T> {
        var specifier = specifier
        let specifierSize = UInt32(MemoryLayout.size(ofValue: specifier))
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        
        try AudioFormatGetProperty(property, specifierSize, &specifier, &size, data).audioError("Getting AudioFormat property")
        
        return data
    }

}
