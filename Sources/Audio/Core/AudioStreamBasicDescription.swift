//
//  AudioStreamBasicDescription.swift
//  Gong
//
//  Created by Daniel Clelland on 1/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

//public enum Endianness {
//    case little
//    case big
//}

public protocol AudioStreamType {
    
    static var bitsPerChannel: UInt32 { get }
    
    static func bytesPerFrame(with channelsPerFrame: UInt32) -> UInt32
    
    static func framesPerPacket(with channelsPerFrame: UInt32) -> UInt32
    
    static func bytesPerPacket(with channelsPerFrame: UInt32) -> UInt32
    
}

public extension AudioStreamType {
    
    static func bytesPerFrame(with channelsPerFrame: UInt32) -> UInt32 {
        return bitsPerChannel / 8 * channelsPerFrame
    }
    
    static func framesPerPacket(with channelsPerFrame: UInt32) -> UInt32 {
        return 1
    }
    
    static func bytesPerPacket(with channelsPerFrame: UInt32) -> UInt32 {
        return bytesPerFrame(with: channelsPerFrame) * framesPerPacket(with: channelsPerFrame)
    }
    
}

extension AudioStreamType {
    
    
    //    @struct         AudioStreamBasicDescription
    //    @abstract       This structure encapsulates all the information for describing the basic
    //    format properties of a stream of audio data.
    //    @discussion     This structure is sufficient to describe any constant bit rate format that  has
    //    channels that are the same size. Extensions are required for variable bit rate
    //    data and for constant bit rate data where the channels have unequal sizes.
    //    However, where applicable, the appropriate fields will be filled out correctly
    //    for these kinds of formats (the extra data is provided via separate properties).
    //    In all fields, a value of 0 indicates that the field is either unknown, not
    //    applicable or otherwise is inapproprate for the format and should be ignored.
    //    Note that 0 is still a valid value for most formats in the mFormatFlags field.
    //
    //    In audio data a frame is one sample across all channels. In non-interleaved
    //    audio, the per frame fields identify one channel. In interleaved audio, the per
    //    frame fields identify the set of n channels. In uncompressed audio, a Packet is
    //    one frame, (mFramesPerPacket == 1). In compressed audio, a Packet is an
    //    indivisible chunk of compressed data, for example an AAC packet will contain
    //    1024 sample frames.
    //
    //    @field          mSampleRate
    //    The number of sample frames per second of the data in the stream.
    //    @field          mFormatID
    //    The AudioFormatID indicating the general kind of data in the stream.
    //    @field          mFormatFlags
    //    The AudioFormatFlags for the format indicated by mFormatID.
    //    @field          mBytesPerPacket
    //    The number of bytes in a packet of data.
    //    @field          mFramesPerPacket
    //    The number of sample frames in each packet of data.
    //    @field          mBytesPerFrame
    //    The number of bytes in a single sample frame of data.
    //    @field          mChannelsPerFrame
    //    The number of channels in each frame of data.
    //    @field          mBitsPerChannel
    //    The number of bits of sample data for each channel in a frame of data.
    //    @field          mReserved
    //    Pads the structure out to force an even 8 byte alignment.
    
    public static func audioStreamDescription(sampleRate: Float64, format: AudioFormatID, channelsPerFrame: UInt32 = 1) -> AudioStreamBasicDescription {
        return AudioStreamBasicDescription(
            mSampleRate: sampleRate,
            mFormatID: format,
            mFormatFlags: kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
            mBytesPerPacket: bytesPerPacket(with: channelsPerFrame),
            mFramesPerPacket: framesPerPacket(with: channelsPerFrame),
            mBytesPerFrame: bytesPerFrame(with: channelsPerFrame),
            mChannelsPerFrame: channelsPerFrame,
            mBitsPerChannel: bitsPerChannel,
            mReserved: 0
        )
    }
    
}

extension Int16: AudioStreamType {
    
    public static var bitsPerChannel: UInt32 { return 16 }

}

//extension Int32: AudioStreamType {}
//
//extension Float: AudioStreamType {}
//
//extension Double: AudioStreamType {}

