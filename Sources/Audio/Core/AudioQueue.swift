//
//  AudioQueue.swift
//  Gong
//
//  Created by Daniel Clelland on 8/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox



//public func AudioQueueNewOutput(_ inFormat: UnsafePointer<AudioStreamBasicDescription>, _ inCallbackProc: @escaping
//public func AudioQueueNewInput(_ inFormat: UnsafePointer<AudioStreamBasicDescription>, _ inCallbackProc: @escaping
//public func AudioQueueNewOutputWithDispatchQueue(_ outAQ: UnsafeMutablePointer<AudioQueueRef?>, _ inFormat: UnsafePointer<
//public func AudioQueueNewInputWithDispatchQueue(_ outAQ: UnsafeMutablePointer<AudioQueueRef?>, _ inFormat: UnsafePointer<
//public func AudioQueueDispose(_ inAQ: AudioQueueRef, _ inImmediate: Bool) -> OSStatus
//public func AudioQueueAllocateBuffer(_ inAQ: AudioQueueRef, _ inBufferByteSize: UInt32, _ outBuffer: UnsafeMutablePointer<
//public func AudioQueueAllocateBufferWithPacketDescriptions(_ inAQ: AudioQueueRef, _ inBufferByteSize: UInt32, _
//public func AudioQueueFreeBuffer(_ inAQ: AudioQueueRef, _ inBuffer: AudioQueueBufferRef) -> OSStatus
//public func AudioQueueEnqueueBuffer(_ inAQ: AudioQueueRef, _ inBuffer: AudioQueueBufferRef, _ inNumPacketDescs: UInt32, _
//public func AudioQueueEnqueueBufferWithParameters(_ inAQ: AudioQueueRef, _ inBuffer: AudioQueueBufferRef, _ inNumPacketDescs:

public class AudioQueue {
    
    public let reference: AudioQueueRef
    
    public init(_ reference: AudioQueueRef) {
        self.reference = reference
    }
    
    public func start(time: AudioTimeStamp) throws {
        var time = time
        try AudioQueueStart(reference, &time).audioError("Starting AudioQueue")
    }
    
    public func prime(numberOfFrames: UInt32 = 0) throws {
        try AudioQueuePrime(reference, numberOfFrames, nil).audioError("Priming AudioQueue")
    }
    
    public func stop(immediately: Bool = true) throws {
        try AudioQueueStop(reference, immediately).audioError("Stopping AudioQueue")
    }
    
    public func pause() throws {
        try AudioQueuePause(reference).audioError("Pausing AudioQueue")
    }
    
    public func flush() throws {
        try AudioQueueFlush(reference).audioError("Flushing AudioQueue")
    }
    
    public func reset() throws {
        try AudioQueueReset(reference).audioError("Resetting AudioQueue")
    }
    
}

//public func AudioQueueGetParameter(_ inAQ: AudioQueueRef, _ inParamID: AudioQueueParameterID, _ outValue: UnsafeMutablePointer<
//public func AudioQueueSetParameter(_ inAQ: AudioQueueRef, _ inParamID: AudioQueueParameterID, _ inValue:
//public func AudioQueueGetProperty(_ inAQ: AudioQueueRef, _ inID: AudioQueuePropertyID, _ outData: UnsafeMutableRawPointer, _
//public func AudioQueueSetProperty(_ inAQ: AudioQueueRef, _ inID: AudioQueuePropertyID, _ inData: UnsafeRawPointer, _ inDataSize:
//public func AudioQueueGetPropertySize(_ inAQ: AudioQueueRef, _ inID: AudioQueuePropertyID, _ outDataSize: UnsafeMutablePointer<
//public func AudioQueueAddPropertyListener(_ inAQ: AudioQueueRef, _ inID: AudioQueuePropertyID, _ inProc: @escaping
//public func AudioQueueRemovePropertyListener(_ inAQ: AudioQueueRef, _ inID: AudioQueuePropertyID, _ inProc: @escaping
//public func AudioQueueCreateTimeline(_ inAQ: AudioQueueRef, _ outTimeline: UnsafeMutablePointer<AudioQueueTimelineRef?>) ->
//public func AudioQueueDisposeTimeline(_ inAQ: AudioQueueRef, _ inTimeline: AudioQueueTimelineRef) -> OSStatus
//public func AudioQueueGetCurrentTime(_ inAQ: AudioQueueRef, _ inTimeline: AudioQueueTimelineRef?, _ outTimeStamp:
//public func AudioQueueDeviceGetCurrentTime(_ inAQ: AudioQueueRef, _ outTimeStamp: UnsafeMutablePointer<AudioTimeStamp>) ->
//public func AudioQueueDeviceTranslateTime(_ inAQ: AudioQueueRef, _ inTime: UnsafePointer<AudioTimeStamp>, _ outTime:
//public func AudioQueueDeviceGetNearestStartTime(_ inAQ: AudioQueueRef, _ ioRequestedStartTime: UnsafeMutablePointer<
//public func AudioQueueSetOfflineRenderFormat(_ inAQ: AudioQueueRef, _ inFormat: UnsafePointer<AudioStreamBasicDescription>?, _
//public func AudioQueueOfflineRender(_ inAQ: AudioQueueRef, _ inTimestamp: UnsafePointer<AudioTimeStamp>, _ ioBuffer:
//public func AudioQueueProcessingTapNew(_ inAQ: AudioQueueRef, _ inCallback: @escaping
//public func AudioQueueProcessingTapDispose(_ inAQTap: AudioQueueProcessingTapRef) -> OSStatus
//public func AudioQueueProcessingTapGetSourceAudio(_ inAQTap: AudioQueueProcessingTapRef, _ inNumberFrames: UInt32, _ ioTimeStamp:
//public func AudioQueueProcessingTapGetQueueTime(_ inAQTap: AudioQueueProcessingTapRef, _ outQueueSampleTime: UnsafeMutablePointer<

extension AudioQueue {
    
    public struct Property {
        public static let isRunning = kAudioQueueProperty_IsRunning
        public static let currentDevice = kAudioQueueProperty_CurrentDevice
        public static let magicCookie = kAudioQueueProperty_MagicCookie
        public static let maximumOutputPacketSize = kAudioQueueProperty_MaximumOutputPacketSize
        public static let streamDescription = kAudioQueueProperty_StreamDescription
        public static let channelLayout = kAudioQueueProperty_ChannelLayout
        public static let enableLevelMetering = kAudioQueueProperty_EnableLevelMetering
        public static let currentLevelMeter = kAudioQueueProperty_CurrentLevelMeter
        public static let currentLevelMeterDB = kAudioQueueProperty_CurrentLevelMeterDB
        public static let decodeBufferSizeFrames = kAudioQueueProperty_DecodeBufferSizeFrames
        public static let converterError = kAudioQueueProperty_ConverterError
        public static let enableTimePitch = kAudioQueueProperty_EnableTimePitch
        public static let timePitchAlgorithm = kAudioQueueProperty_TimePitchAlgorithm
        public static let timePitchBypass = kAudioQueueProperty_TimePitchBypass
    }
    
    public struct DeviceProperty {
        public static let sampleRate = kAudioQueueDeviceProperty_SampleRate
        public static let numberChannels = kAudioQueueDeviceProperty_NumberChannels
    }
    
}
