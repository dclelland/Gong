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
