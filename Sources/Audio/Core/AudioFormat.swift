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
        public let formatInfo = kAudioFormatProperty_FormatInfo
        public let formatName = kAudioFormatProperty_FormatName
        public let encodeFormatIDs = kAudioFormatProperty_EncodeFormatIDs
        public let decodeFormatIDs = kAudioFormatProperty_DecodeFormatIDs
        public let formatList = kAudioFormatProperty_FormatList
        public let asbdFromESDS = kAudioFormatProperty_ASBDFromESDS
        public let channelLayoutFromESDS = kAudioFormatProperty_ChannelLayoutFromESDS
        public let outputFormatList = kAudioFormatProperty_OutputFormatList
        public let firstPlayableFormatFromList = kAudioFormatProperty_FirstPlayableFormatFromList
        public let formatIsVBR = kAudioFormatProperty_FormatIsVBR
        public let formatIsExternallyFramed = kAudioFormatProperty_FormatIsExternallyFramed
        public let formatIsEncrypted = kAudioFormatProperty_FormatIsEncrypted
        public let encoders = kAudioFormatProperty_Encoders
        public let decoders = kAudioFormatProperty_Decoders
        public let availableEncodeBitRates = kAudioFormatProperty_AvailableEncodeBitRates
        public let availableEncodeSampleRates = kAudioFormatProperty_AvailableEncodeSampleRates
        public let availableEncodeChannelLayoutTags = kAudioFormatProperty_AvailableEncodeChannelLayoutTags
        public let availableEncodeNumberChannels = kAudioFormatProperty_AvailableEncodeNumberChannels
        public let asbdFromMPEGPacket = kAudioFormatProperty_ASBDFromMPEGPacket
        public let bitmapForLayoutTag = kAudioFormatProperty_BitmapForLayoutTag
        public let matrixMixMap = kAudioFormatProperty_MatrixMixMap
        public let channelMap = kAudioFormatProperty_ChannelMap
        public let numberOfChannelsForLayout = kAudioFormatProperty_NumberOfChannelsForLayout
        public let areChannelLayoutsEquivalent = kAudioFormatProperty_AreChannelLayoutsEquivalent
        public let channelLayoutHash = kAudioFormatProperty_ChannelLayoutHash
        public let validateChannelLayout = kAudioFormatProperty_ValidateChannelLayout
        public let channelLayoutForTag = kAudioFormatProperty_ChannelLayoutForTag
        public let tagForChannelLayout = kAudioFormatProperty_TagForChannelLayout
        public let channelLayoutName = kAudioFormatProperty_ChannelLayoutName
        public let channelLayoutSimpleName = kAudioFormatProperty_ChannelLayoutSimpleName
        public let channelLayoutForBitmap = kAudioFormatProperty_ChannelLayoutForBitmap
        public let channelName = kAudioFormatProperty_ChannelName
        public let channelShortName = kAudioFormatProperty_ChannelShortName
        public let tagsForNumberOfChannels = kAudioFormatProperty_TagsForNumberOfChannels
        public let panningMatrix = kAudioFormatProperty_PanningMatrix
        public let balanceFade = kAudioFormatProperty_BalanceFade
        public let id3TagSize = kAudioFormatProperty_ID3TagSize
        public let id3TagToDictionary = kAudioFormatProperty_ID3TagToDictionary
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
