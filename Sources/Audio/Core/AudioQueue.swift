//
//  AudioQueue.swift
//  Gong
//
//  Created by Daniel Clelland on 8/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioQueue {
    
    public let reference: AudioQueueRef
    
    public init(_ reference: AudioQueueRef) {
        self.reference = reference
    }
    
    public func dispose(immediately: Bool = true) throws {
        try AudioQueueDispose(reference, immediately).audioError("Disposing of AudioQueue")
    }
    
}

extension AudioQueue {
    
    public typealias OutputCallback = (_ queue: AudioQueue, _ buffer: Buffer) -> Void
    
    public typealias InputCallback = (_ queue: AudioQueue, _ buffer: Buffer, _ timeStamp: AudioTimeStamp, _ packetDescriptions: [AudioStreamPacketDescription]?) -> Void
    
    public static func createOutput(format: AudioStreamBasicDescription, runLoop: CFRunLoop? = nil, runLoopMode: String? = nil, callback: @escaping OutputCallback = { (_, _) in }) throws -> AudioQueue {
        var queueReference: AudioQueueRef? = nil
        var format = format
        
        let userData = UnsafeMutablePointer.wrap(callback)
        let procedure: AudioQueueOutputCallback = { (userData, queueReference, bufferReference) in
            guard let callback: OutputCallback = userData?.unwrap() else {
                return
            }
            
            callback(AudioQueue(queueReference), Buffer(bufferReference))
        }
        
        try AudioQueueNewOutput(&format, procedure, userData, runLoop, runLoopMode as CFString?, 0, &queueReference).audioError("Creating new output AudioQueue")
        return AudioQueue(queueReference!)
    }
    
    public static func createInput(format: AudioStreamBasicDescription, runLoop: CFRunLoop? = nil, runLoopMode: String? = nil, callback: @escaping InputCallback = { (_, _, _, _) in }) throws -> AudioQueue {
        var queueReference: AudioQueueRef? = nil
        var format = format
        
        let userData = UnsafeMutablePointer.wrap(callback)
        let procedure: AudioQueueInputCallback = { (userData, queueReference, bufferReference, timeStamp, numberOfPacketDescriptions, packetDescriptions) in
            guard let callback: InputCallback = userData?.unwrap() else {
                return
            }
            
            if let packetDescriptions = packetDescriptions {
                let count = Int(numberOfPacketDescriptions)
                let data = UnsafeMutablePointer<AudioStreamPacketDescription>.allocate(capacity: count)
                defer {
                    data.deallocate(capacity: count)
                }
                
                let array = (0..<count).map { index in
                    return packetDescriptions[index]
                }
                
                callback(AudioQueue(queueReference), Buffer(bufferReference), timeStamp.pointee, array)
            } else {
                callback(AudioQueue(queueReference), Buffer(bufferReference), timeStamp.pointee, nil)
            }
        }
        
        try AudioQueueNewInput(&format, procedure, userData, runLoop, runLoopMode as CFString?, 0, &queueReference).audioError("Creating new input AudioQueue")
        return AudioQueue(queueReference!)
    }
    
    public static func createOutput(format: AudioStreamBasicDescription, dispatchQueue: DispatchQueue, callback: @escaping OutputCallback = { (_, _) in }) throws -> AudioQueue {
        var queueReference: AudioQueueRef? = nil
        var format = format
        
        let block: AudioQueueOutputCallbackBlock = { (queueReference, bufferReference) in
            callback(AudioQueue(queueReference), Buffer(bufferReference))
        }
        
        try AudioQueueNewOutputWithDispatchQueue(&queueReference, &format, 0, dispatchQueue, block).audioError("Creating new output AudioQueue with dispatch queue")
        
        return AudioQueue(queueReference!)
    }
    
    public static func createInput(format: AudioStreamBasicDescription, dispatchQueue: DispatchQueue, callback: @escaping InputCallback = { (_, _, _, _) in }) throws -> AudioQueue {
        var queueReference: AudioQueueRef? = nil
        var format = format
        
        let block: AudioQueueInputCallbackBlock = { (queueReference, bufferReference, timeStamp, numberOfPacketDescriptions, packetDescriptions) in
            if let packetDescriptions = packetDescriptions {
                let count = Int(numberOfPacketDescriptions)
                let data = UnsafeMutablePointer<AudioStreamPacketDescription>.allocate(capacity: count)
                defer {
                    data.deallocate(capacity: count)
                }
                
                let array = (0..<count).map { index in
                    return packetDescriptions[index]
                }
                
                callback(AudioQueue(queueReference), Buffer(bufferReference), timeStamp.pointee, array)
            } else {
                callback(AudioQueue(queueReference), Buffer(bufferReference), timeStamp.pointee, nil)
            }
        }
        
        try AudioQueueNewInputWithDispatchQueue(&queueReference, &format, 0, dispatchQueue, block).audioError("Creating new input AudioQueue with dispatch queue")
        
        return AudioQueue(queueReference!)
    }
    
}

extension AudioQueue {
    
    public class Buffer {
        
        public let reference: AudioQueueBufferRef
        
        public init(_ reference: AudioQueueBufferRef) {
            self.reference = reference
        }
        
    }
    
    public func allocateBuffer(byteSize: UInt32, numberOfPacketDescriptions: UInt32? = nil) throws -> Buffer {
        var bufferReference: AudioQueueBufferRef? = nil
        if let numberOfPacketDescriptions = numberOfPacketDescriptions {
            try AudioQueueAllocateBufferWithPacketDescriptions(reference, byteSize, numberOfPacketDescriptions, &bufferReference).audioError("Allocating AudioQueue buffer with packet descriptions")
        } else {
            try AudioQueueAllocateBuffer(reference, byteSize, &bufferReference).audioError("Allocating AudioQueue buffer")
        }
        return Buffer(bufferReference!)
    }
    
    public func free(buffer: Buffer) throws {
        try AudioQueueFreeBuffer(reference, buffer.reference).audioError("Freeing AudioQueue buffer")
    }
    
    public func enqueue(buffer: Buffer, packetDescriptions: [AudioStreamPacketDescription]? = nil) throws {
        if var packetDescriptions = packetDescriptions {
            let numberOfPacketDescriptions = UInt32(packetDescriptions.count)
            try AudioQueueEnqueueBuffer(reference, buffer.reference, numberOfPacketDescriptions, &packetDescriptions).audioError("Enqueuing AudioQueue buffer")
        } else {
            try AudioQueueEnqueueBuffer(reference, buffer.reference, 0, nil).audioError("Enqueuing AudioQueue buffer")
        }
    }
    
}

extension AudioQueue {

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

extension AudioQueue {
    
    public struct Parameter {
        public static let volume = kAudioQueueParam_Volume
        public static let playRate = kAudioQueueParam_PlayRate
        public static let pitch = kAudioQueueParam_Pitch
        public static let volumeRampTime = kAudioQueueParam_VolumeRampTime
        public static let pan = kAudioQueueParam_Pan
    }
    
    public func value(for parameter: AudioQueueParameterID) throws -> AudioQueueParameterValue {
        var value: AudioQueueParameterValue = 0
        try AudioQueueGetParameter(reference, parameter, &value).audioError("Getting AudioQueue parameter value")
        return value
    }
    
    public func set(value: AudioQueueParameterValue, for parameter: AudioQueueParameterID) throws {
        try AudioQueueSetParameter(reference, parameter, value).audioError("Setting AudioQueue parameter value")
    }
    
}

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
    
    
    public func value<T>(for property: AudioQueuePropertyID) throws -> T {
        var size = try self.size(for: property)
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        return data.pointee
    }
    
    public func array<T>(for property: AudioQueuePropertyID) throws -> [T] {
        var size = try self.size(for: property)
        let data: UnsafeMutablePointer<T> = try self.data(for: property, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        let count = Int(size) / MemoryLayout<T>.size
        return (0..<count).map { index in
            return data[index]
        }
    }
    
    public func set<T>(value: T, for property: AudioQueuePropertyID) throws {
        let size = try self.size(for: property)
        var data = value
        return try set(data: &data, for: property, size: size)
    }
    
}


extension AudioQueue {
    
    internal func size(for property: AudioQueuePropertyID) throws -> UInt32 {
        var size: UInt32 = 0
        try AudioQueueGetPropertySize(reference, property, &size).audioError("Getting AudioQueue property size")
        return size
    }

    internal func data<T>(for property: AudioQueuePropertyID, size: inout UInt32) throws -> UnsafeMutablePointer<T> {
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        try AudioQueueGetProperty(reference, property, data, &size).audioError("Getting AudioQueue property")
        return data
    }

    internal func set<T>(data: UnsafeMutablePointer<T>, for property: AudioQueuePropertyID, size: UInt32) throws {
        try AudioQueueSetProperty(reference, property, data, size).audioError("Setting AudioQueue property")
    }
    
}

extension AudioQueue {

    public class PropertyListener {
        
        public typealias Callback = (_ audioUnit: AudioQueue, _ property: AudioUnitPropertyID) -> Void
        
        fileprivate let procedure: AudioQueuePropertyListenerProc
        
        fileprivate let userData: UnsafeMutablePointer<Callback>
        
        public init(_ callback: @escaping Callback) {
            self.procedure = { (userData, queueReference, property) in
                guard let callback: Callback = userData?.unwrap() else {
                    return
                }
                
                callback(AudioQueue(queueReference), property)
            }
            
            self.userData = UnsafeMutablePointer.wrap(callback)
        }
        
    }
    
    public func add(listener: PropertyListener, to property: AudioQueuePropertyID) throws {
        try AudioQueueAddPropertyListener(reference, property, listener.procedure, listener.userData).audioError("Adding AudioQueue property listener")
    }
    
    public func remove(listener: PropertyListener, from property: AudioQueuePropertyID) throws {
        try AudioQueueRemovePropertyListener(reference, property, listener.procedure, listener.userData).audioError("Removing AudioQueue property listener")
    }
    
}

extension AudioQueue {
    
    public class Timeline {
        
        public let reference: AudioQueueTimelineRef
        
        public init(_ reference: AudioQueueTimelineRef) {
            self.reference = reference
        }
        
    }
    
    public func createTimeline() throws -> Timeline {
        var timelineReference: AudioQueueTimelineRef? = nil
        try AudioQueueCreateTimeline(reference, &timelineReference).audioError("Creating AudioQueue timeline")
        return Timeline(timelineReference!)
    }
    
    public func disposeTimeline(_ timeline: Timeline) throws {
        try AudioQueueDisposeTimeline(reference, timeline.reference).audioError("Disposing of AudioQueue timeline")
    }
    
}

extension AudioQueue {
    
    public func currentTime(in timeline: Timeline? = nil) throws -> (timeStamp: AudioTimeStamp, hasDiscontinuities: Bool) {
        var timeStamp = AudioTimeStamp()
        var hasDiscontinuities: DarwinBoolean = false
        try AudioQueueGetCurrentTime(reference, timeline?.reference, &timeStamp, &hasDiscontinuities).audioError("Getting AudioQueue current time")
        return (timeStamp: timeStamp, hasDiscontinuities: hasDiscontinuities.boolValue)
    }
    
    public func currentDeviceTime() throws -> AudioTimeStamp {
        var timeStamp = AudioTimeStamp()
        try AudioQueueDeviceGetCurrentTime(reference, &timeStamp).audioError("Getting AudioQueue device current time")
        return timeStamp
    }
    
    public func translateDeviceTime(_ timeStamp: AudioTimeStamp) throws -> AudioTimeStamp {
        var inputTimeStamp = timeStamp
        var outputTimeStamp = AudioTimeStamp()
        try AudioQueueDeviceTranslateTime(reference, &inputTimeStamp, &outputTimeStamp).audioError("Translating AudioQueue device time")
        return outputTimeStamp
    }
    
    public func nearestStartTime(to timeStamp: AudioTimeStamp) throws -> AudioTimeStamp {
        var timeStamp = timeStamp
        try AudioQueueDeviceGetNearestStartTime(reference, &timeStamp, 0).audioError("Getting AudioQueue nearest start time")
        return timeStamp
    }
    
}

extension AudioQueue {
    
    public enum OfflineRenderFormat {
        case disabled
        case enabled(format: AudioStreamBasicDescription, layout: AudioChannelLayout)
    }
    
    public func setOfflineRenderFormat(_ format: OfflineRenderFormat) throws {
        switch format {
        case .disabled:
            try AudioQueueSetOfflineRenderFormat(reference, nil, nil).audioError("Disabling AudioQueue offline render format")
        case .enabled(var format, var layout):
            try AudioQueueSetOfflineRenderFormat(reference, &format, &layout).audioError("Enabling AudioQueue offline render format")
        }
    }
    
    public func offlineRender(timeStamp: AudioTimeStamp, buffer: Buffer, numberOfFrames: UInt32) throws {
        var timeStamp = timeStamp
        try AudioQueueOfflineRender(reference, &timeStamp, buffer.reference, numberOfFrames).audioError("AudioQueue rendering offline")
    }
    
}

extension AudioQueue {
    
    public class ProcessingTap {
        
        public let reference: AudioQueueProcessingTapRef
        
        public init(_ reference: AudioQueueProcessingTapRef) {
            self.reference = reference
        }
        
        // TODO: Figure out what to do about ioTimeStamp etc
        
        public func sourceAudio(numberOfFrames: UInt32, timeStamp: AudioTimeStamp) throws -> AudioBufferList {
            var timeStamp = timeStamp
            var flags = AudioQueueProcessingTapFlags()
            var outNumberOfFrames: UInt32 = 0
            var bufferList = AudioBufferList()
            
            try AudioQueueProcessingTapGetSourceAudio(reference, numberOfFrames, &timeStamp, &flags, &outNumberOfFrames, &bufferList).audioError("Getting AudioQueue.ProcessingTap source audio")
            
            return bufferList
        }
        
        public func queueTime() throws -> (sampleTime: Float64, frameCount: UInt32) {
            var sampleTime: Float64 = 0.0
            var frameCount: UInt32 = 0
            
            try AudioQueueProcessingTapGetQueueTime(reference, &sampleTime, &frameCount).audioError("Getting AudioQueue.ProcessingTap queue time")
            
            return (sampleTime: sampleTime, frameCount: frameCount)
        }
        
        public func dispose() throws {
            try AudioQueueProcessingTapDispose(reference).audioError("Disposing of AudioQueue.ProcessingTap")
        }
        
    }
    
    public typealias ProcessingTapCallback = (_ processingTap: ProcessingTap, _ numberOfFrames: UInt32, _ timeStamp: AudioTimeStamp, _ flags: AudioQueueProcessingTapFlags, _ dataNumberOfFrames: UInt32, _ bufferList: AudioBufferList) -> Void
    
    // TODO: Make tapFlags typesafe, also figure out what ought to be done with the inout arguments in the callback
    
    public func createProcessingTap(flags: AudioQueueProcessingTapFlags, callback: ProcessingTapCallback) throws -> (processingTap: ProcessingTap, maximumFrames: UInt32, format: AudioStreamBasicDescription) {
        var processingTapReference: AudioQueueTimelineRef? = nil
        var maximumFrames: UInt32 = 0
        var format = AudioStreamBasicDescription()
        let clientData = UnsafeMutablePointer.wrap(callback)
        
        let procedure: AudioQueueProcessingTapCallback = { (clientData, tapReference, numberOfFrames, timeStamp, flags, dataNumberOfFrames, data) in
            guard let callback: ProcessingTapCallback = clientData.unwrap() else {
                return
            }
            
            callback(ProcessingTap(tapReference), numberOfFrames, timeStamp.pointee, flags.pointee, dataNumberOfFrames.pointee, data.pointee)
        }
        
        try AudioQueueProcessingTapNew(reference, procedure, clientData, flags, &maximumFrames, &format, &processingTapReference).audioError("Creating AudioQueue processing tap")
        
        return (processingTap: ProcessingTap(processingTapReference!), maximumFrames: maximumFrames, format: format)
    }
    
}
