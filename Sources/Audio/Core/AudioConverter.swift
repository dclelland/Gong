//
//  AudioConverter.swift
//  Gong
//
//  Created by Daniel Clelland on 27/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioConverter {
    
    public let reference: AudioConverterRef
    
    public init(_ reference: AudioConverterRef) {
        self.reference = reference
    }
    
}

extension AudioConverter {
    
    public struct Property {
        static let propertyMinimumInputBufferSize = kAudioConverterPropertyMinimumInputBufferSize
        static let propertyMinimumOutputBufferSize = kAudioConverterPropertyMinimumOutputBufferSize
        static let propertyMaximumInputBufferSize = kAudioConverterPropertyMaximumInputBufferSize
        static let propertyMaximumInputPacketSize = kAudioConverterPropertyMaximumInputPacketSize
        static let propertyMaximumOutputPacketSize = kAudioConverterPropertyMaximumOutputPacketSize
        static let propertyCalculateInputBufferSize = kAudioConverterPropertyCalculateInputBufferSize
        static let propertyCalculateOutputBufferSize = kAudioConverterPropertyCalculateOutputBufferSize
        static let propertyInputCodecParameters = kAudioConverterPropertyInputCodecParameters
        static let propertyOutputCodecParameters = kAudioConverterPropertyOutputCodecParameters
        static let sampleRateConverterAlgorithm = kAudioConverterSampleRateConverterAlgorithm
        static let sampleRateConverterComplexity = kAudioConverterSampleRateConverterComplexity
        static let sampleRateConverterQuality = kAudioConverterSampleRateConverterQuality
        static let sampleRateConverterInitialPhase = kAudioConverterSampleRateConverterInitialPhase
        static let codecQuality = kAudioConverterCodecQuality
        static let primeMethod = kAudioConverterPrimeMethod
        static let primeInfo = kAudioConverterPrimeInfo
        static let channelMap = kAudioConverterChannelMap
        static let decompressionMagicCookie = kAudioConverterDecompressionMagicCookie
        static let compressionMagicCookie = kAudioConverterCompressionMagicCookie
        static let encodeBitRate = kAudioConverterEncodeBitRate
        static let encodeAdjustableSampleRate = kAudioConverterEncodeAdjustableSampleRate
        static let inputChannelLayout = kAudioConverterInputChannelLayout
        static let outputChannelLayout = kAudioConverterOutputChannelLayout
        static let applicableEncodeBitRates = kAudioConverterApplicableEncodeBitRates
        static let availableEncodeBitRates = kAudioConverterAvailableEncodeBitRates
        static let applicableEncodeSampleRates = kAudioConverterApplicableEncodeSampleRates
        static let availableEncodeSampleRates = kAudioConverterAvailableEncodeSampleRates
        static let availableEncodeChannelLayoutTags = kAudioConverterAvailableEncodeChannelLayoutTags
        static let currentOutputStreamDescription = kAudioConverterCurrentOutputStreamDescription
        static let currentInputStreamDescription = kAudioConverterCurrentInputStreamDescription
        static let propertySettings = kAudioConverterPropertySettings
        static let propertyBitDepthHint = kAudioConverterPropertyBitDepthHint
        static let propertyFormatList = kAudioConverterPropertyFormatList
    }
    
}

//public func AudioConverterNew(_ inSourceFormat: UnsafePointer<AudioStreamBasicDescription>, _ inDestinationFormat: UnsafePointer<AudioStreamBasicDescription>, _ outAudioConverter: UnsafeMutablePointer<AudioConverterRef?>) -> OSStatus
//public func AudioConverterNewSpecific(_ inSourceFormat: UnsafePointer<AudioStreamBasicDescription>, _ inDestinationFormat: UnsafePointer<AudioStreamBasicDescription>, _ inNumberClassDescriptions: UInt32, _ inClassDescriptions: UnsafePointer<AudioClassDescription>, _ outAudioConverter: UnsafeMutablePointer<AudioConverterRef?>) -> OSStatus
//public func AudioConverterDispose(_ inAudioConverter: AudioConverterRef) -> OSStatus
//public func AudioConverterReset(_ inAudioConverter: AudioConverterRef) -> OSStatus
//public func AudioConverterGetPropertyInfo(_ inAudioConverter: AudioConverterRef, _ inPropertyID: AudioConverterPropertyID, _ outSize: UnsafeMutablePointer<UInt32>?, _ outWritable: UnsafeMutablePointer<DarwinBoolean>?) -> OSStatus
//public func AudioConverterGetProperty(_ inAudioConverter: AudioConverterRef, _ inPropertyID: AudioConverterPropertyID, _ ioPropertyDataSize: UnsafeMutablePointer<UInt32>, _ outPropertyData: UnsafeMutableRawPointer) -> OSStatus
//public func AudioConverterSetProperty(_ inAudioConverter: AudioConverterRef, _ inPropertyID: AudioConverterPropertyID, _ inPropertyDataSize: UInt32, _ inPropertyData: UnsafeRawPointer) -> OSStatus
//public func AudioConverterConvertBuffer(_ inAudioConverter: AudioConverterRef, _ inInputDataSize: UInt32, _ inInputData: UnsafeRawPointer, _ ioOutputDataSize: UnsafeMutablePointer<UInt32>, _ outOutputData: UnsafeMutableRawPointer) -> OSStatus
//public func AudioConverterFillComplexBuffer(_ inAudioConverter: AudioConverterRef, _ inInputDataProc: @escaping AudioToolbox.AudioConverterComplexInputDataProc, _ inInputDataProcUserData: UnsafeMutableRawPointer?, _ ioOutputDataPacketSize: UnsafeMutablePointer<UInt32>, _ outOutputData: UnsafeMutablePointer<AudioBufferList>, _ outPacketDescription: UnsafeMutablePointer<AudioStreamPacketDescription>?) -> OSStatus
//public func AudioConverterConvertComplexBuffer(_ inAudioConverter: AudioConverterRef, _ inNumberPCMFrames: UInt32, _ inInputData: UnsafePointer<AudioBufferList>, _ outOutputData: UnsafeMutablePointer<AudioBufferList>) -> OSStatus
