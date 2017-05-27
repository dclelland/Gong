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
    
//    public static func value<T>(for property: AudioFormatPropertyID) -> T {
//        
//    }
//    
//    public static func array<T>(for property: AudioFormatPropertyID) -> [T] {
//        
//    }
    
}

extension AudioFormat {
    
    //public func AudioFormatGetPropertyInfo(_ inPropertyID: AudioFormatPropertyID, _ inSpecifierSize: UInt32, _ inSpecifier: UnsafeRawPointer?, _ outPropertyDataSize: UnsafeMutablePointer<UInt32>) -> OSStatus
    //public func AudioFormatGetProperty(_ inPropertyID: AudioFormatPropertyID, _ inSpecifierSize: UInt32, _ inSpecifier: UnsafeRawPointer?, _ ioPropertyDataSize: UnsafeMutablePointer<UInt32>?, _ outPropertyData: UnsafeMutableRawPointer?) -> OSStatus

}
