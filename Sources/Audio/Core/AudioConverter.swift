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
    
    public convenience init(source: AudioStreamBasicDescription, destination: AudioStreamBasicDescription) throws {
        var reference: AudioConverterRef? = nil
        var source = source
        var destination = destination
        try AudioConverterNew(&source, &destination, &reference).audioError("Creating AudioConverter")
        self.init(reference!)
    }
    
//    public convenience init(source: AudioStreamBasicDescription, destination: AudioStreamBasicDescription, classDescriptions: [AudioClassDescription]) throws {
//        var reference: AudioConverterRef? = nil
//        var source = source
//        var destination = destination
//        
//        try AudioConverterNewSpecific(&source, &destination, UInt32(classDescriptions.count), pointer, &reference).audioError("Creating AudioConverter with specific format")
//        
//        self.init(reference!)
//    }
    
    public func dispose() throws {
        try AudioConverterDispose(reference).audioError("Disposing of AudioConverter")
    }
    
}

extension AudioConverter {
    
    public struct Property {
        public static let propertyMinimumInputBufferSize = kAudioConverterPropertyMinimumInputBufferSize
        public static let propertyMinimumOutputBufferSize = kAudioConverterPropertyMinimumOutputBufferSize
        public static let propertyMaximumInputBufferSize = kAudioConverterPropertyMaximumInputBufferSize
        public static let propertyMaximumInputPacketSize = kAudioConverterPropertyMaximumInputPacketSize
        public static let propertyMaximumOutputPacketSize = kAudioConverterPropertyMaximumOutputPacketSize
        public static let propertyCalculateInputBufferSize = kAudioConverterPropertyCalculateInputBufferSize
        public static let propertyCalculateOutputBufferSize = kAudioConverterPropertyCalculateOutputBufferSize
        public static let propertyInputCodecParameters = kAudioConverterPropertyInputCodecParameters
        public static let propertyOutputCodecParameters = kAudioConverterPropertyOutputCodecParameters
        public static let sampleRateConverterAlgorithm = kAudioConverterSampleRateConverterAlgorithm
        public static let sampleRateConverterComplexity = kAudioConverterSampleRateConverterComplexity
        public static let sampleRateConverterQuality = kAudioConverterSampleRateConverterQuality
        public static let sampleRateConverterInitialPhase = kAudioConverterSampleRateConverterInitialPhase
        public static let codecQuality = kAudioConverterCodecQuality
        public static let primeMethod = kAudioConverterPrimeMethod
        public static let primeInfo = kAudioConverterPrimeInfo
        public static let channelMap = kAudioConverterChannelMap
        public static let decompressionMagicCookie = kAudioConverterDecompressionMagicCookie
        public static let compressionMagicCookie = kAudioConverterCompressionMagicCookie
        public static let encodeBitRate = kAudioConverterEncodeBitRate
        public static let encodeAdjustableSampleRate = kAudioConverterEncodeAdjustableSampleRate
        public static let inputChannelLayout = kAudioConverterInputChannelLayout
        public static let outputChannelLayout = kAudioConverterOutputChannelLayout
        public static let applicableEncodeBitRates = kAudioConverterApplicableEncodeBitRates
        public static let availableEncodeBitRates = kAudioConverterAvailableEncodeBitRates
        public static let applicableEncodeSampleRates = kAudioConverterApplicableEncodeSampleRates
        public static let availableEncodeSampleRates = kAudioConverterAvailableEncodeSampleRates
        public static let availableEncodeChannelLayoutTags = kAudioConverterAvailableEncodeChannelLayoutTags
        public static let currentOutputStreamDescription = kAudioConverterCurrentOutputStreamDescription
        public static let currentInputStreamDescription = kAudioConverterCurrentInputStreamDescription
        public static let propertySettings = kAudioConverterPropertySettings
        public static let propertyBitDepthHint = kAudioConverterPropertyBitDepthHint
        public static let propertyFormatList = kAudioConverterPropertyFormatList
    }
    
    public func value<T>(for property: AudioConverterPropertyID) throws -> T {
        var size = try info(for: property).size
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        return data.pointee
    }
    
    public func array<T>(for property: AudioConverterPropertyID) throws -> [T] {
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
    
    public func set<T>(value: T, for property: AudioConverterPropertyID) throws {
        let size = try info(for: property).size
        var data = value
        return try set(data: &data, for: property, size: size)
    }
    
}

extension AudioConverter {
    
    internal func info(for property: AudioConverterPropertyID) throws -> (size: UInt32, isWritable: Bool) {
        var size: UInt32 = 0
        var isWritable: DarwinBoolean = false
        try AudioFileStreamGetPropertyInfo(reference, property, &size, &isWritable).audioError("Getting AudioConverter property info")
        return (size: size, isWritable: isWritable.boolValue)
    }
    
    internal func data<T>(for property: AudioConverterPropertyID, size: inout UInt32) throws -> UnsafeMutablePointer<T> {
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        try AudioFileStreamGetProperty(reference, property, &size, data).audioError("Getting AudioConverter property")
        return data
    }
    
    internal func set<T>(data: UnsafeMutablePointer<T>, for property: AudioConverterPropertyID, size: UInt32) throws {
        try AudioFileStreamSetProperty(reference, property, size, data).audioError("Setting AudioConverter property")
    }
    
}

extension AudioConverter {
    
    
    public func convertBuffer() {
        //public func AudioConverterConvertBuffer(_ inAudioConverter: AudioConverterRef, _ inInputDataSize: UInt32, _ inInputData: UnsafeRawPointer, _ ioOutputDataSize: UnsafeMutablePointer<UInt32>, _ outOutputData: UnsafeMutableRawPointer) -> OSStatus
    }
    
    public func convertComplexBuffer() {
        //public func AudioConverterConvertComplexBuffer(_ inAudioConverter: AudioConverterRef, _ inNumberPCMFrames: UInt32, _ inInputData: UnsafePointer<AudioBufferList>, _ outOutputData: UnsafeMutablePointer<AudioBufferList>) -> OSStatus
    }
    
    public func fillComplexBuffer() {
        //public func AudioConverterFillComplexBuffer(_ inAudioConverter: AudioConverterRef, _ inInputDataProc: @escaping AudioToolbox.AudioConverterComplexInputDataProc, _ inInputDataProcUserData: UnsafeMutableRawPointer?, _ ioOutputDataPacketSize: UnsafeMutablePointer<UInt32>, _ outOutputData: UnsafeMutablePointer<AudioBufferList>, _ outPacketDescription: UnsafeMutablePointer<AudioStreamPacketDescription>?) -> OSStatus
    }
    
    
    public func reset() throws {
        try AudioConverterReset(reference).audioError("Resetting AudioConverter")
    }
    
}
