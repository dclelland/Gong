//
//  AudioUnit.swift
//  Gong
//
//  Created by Daniel Clelland on 02/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

#if os(iOS)
import AudioToolbox
#elseif os(macOS)
import AudioUnit
#endif

public class AudioUnit {
    
    public let reference: AudioToolbox.AudioUnit
    
    public init(_ reference: AudioToolbox.AudioUnit) {
        self.reference = reference
    }
    
}

extension AudioUnit {
    
    public func initialize() throws {
        try AudioUnitInitialize(reference).audioError("Initializing AudioUnit")
    }
    
    public func uninitialize() throws {
        try AudioUnitUninitialize(reference).audioError("Uninitializing AudioUnit")
    }
    
}

extension AudioUnit {
    
    public func value<T>(for property: AudioUnitPropertyID, scope: AudioUnitScope = kAudioUnitScope_Global, element: AudioUnitElement = 0) throws -> T {
        var size = try info(for: property, scope: scope, element: element).size
        let data: UnsafeMutablePointer<T> = try self.data(for: property, scope: scope, element: element, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        return data.pointee
    }
    
    public func array<T>(for property: AudioUnitPropertyID, scope: AudioUnitScope = kAudioUnitScope_Global, element: AudioUnitElement = 0) throws -> [T] {
        var size = try info(for: property, scope: scope, element: element).size
        let data: UnsafeMutablePointer<T> = try self.data(for: property, scope: scope, element: element, size: &size)
        defer {
            data.deallocate(capacity: Int(size))
        }
        let count = Int(size) / MemoryLayout<T>.size
        return (0..<count).map { index in
            return data[index]
        }
    }
    
    public func set<T>(value: T, for property: AudioUnitPropertyID, scope: AudioUnitScope = kAudioUnitScope_Global, element: AudioUnitElement = 0) throws {
        let size = try info(for: property, scope: scope, element: element).size
        var data = value
        return try set(data: &data, for: property, scope: scope, element: element, size: size)
    }
    
}

extension AudioUnit {
    
    internal func data<T>(for property: AudioUnitPropertyID, scope: AudioUnitScope, element: AudioUnitElement, size: inout UInt32) throws -> UnsafeMutablePointer<T> {
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        try AudioUnitGetProperty(reference, property, scope, element, data, &size).audioError("Getting AudioUnit property")
        return data
    }
    
    internal func set<T>(data: UnsafeMutablePointer<T>, for property: AudioUnitPropertyID, scope: AudioUnitScope, element: AudioUnitElement, size: UInt32) throws {
        try AudioUnitSetProperty(reference, property, scope, element, data, size).audioError("Setting AudioUnit property")
    }
    
    internal func info(for property: AudioUnitPropertyID, scope: AudioUnitScope, element: AudioUnitElement) throws -> (size: UInt32, isWritable: Bool) {
        var size: UInt32 = 0
        var isWritable: DarwinBoolean = false
        try AudioUnitGetPropertyInfo(reference, property, scope, element, &size, &isWritable).audioError("Getting AudioUnit property info")
        return (size: size, isWritable: isWritable.boolValue)
    }
    
}

extension AudioUnit {
    
    public class PropertyListener {
        
        public typealias Callback = (_ audioUnit: AudioUnit, _ property: AudioUnitPropertyID, _ scope: AudioUnitScope, _ element: AudioUnitElement) -> Void
        
        fileprivate let procedure: AudioUnitPropertyListenerProc
        
        fileprivate let referenceContext: UnsafeMutablePointer<Callback>
        
        public init(_ callback: @escaping Callback) {
            self.procedure = { (referenceContext, unitReference, property, scope, element) in
                guard let callback: Callback = referenceContext.unwrap() else {
                    return
                }
                
                callback(AudioUnit(unitReference), property, scope, element)
            }
            
            self.referenceContext = UnsafeMutablePointer.wrap(callback)
        }
        
    }
    
    public func add(listener: PropertyListener, to property: AudioUnitPropertyID) throws {
        try AudioUnitAddPropertyListener(reference, property, listener.procedure, listener.referenceContext).audioError("Adding listener to AudioUnit property")
    }
    
    public func remove(listener: PropertyListener, from property: AudioUnitPropertyID) throws {
        // TODO: There is also AudioUnitRemovePropertyListener, what's the deal?
        try AudioUnitRemovePropertyListenerWithUserData(reference, property, listener.procedure, listener.referenceContext).audioError("Removing listener from AudioUnit property")
    }
    
}

extension AudioUnit {
    
    public class RenderCallback {
        
        public typealias Callback = () -> OSStatus
        
        fileprivate let callback: AURenderCallback
        
        fileprivate let referenceContext: UnsafeMutablePointer<Callback>
        
        public init(_ callback: @escaping Callback) {
            self.callback = { (referenceContext, actionFlags, timeStamp, bus, numberOfFrames, bufferList) in
                guard let callback: Callback = referenceContext.unwrap() else {
                    return noErr
                }
                
                return callback()
            }
            
            self.referenceContext = UnsafeMutablePointer.wrap(callback)
        }
        
    }
    
    public func add(renderCallback: RenderCallback) throws {
        try AudioUnitAddRenderNotify(reference, renderCallback.callback, renderCallback.referenceContext).audioError("Adding render callback to Audiounit")
    }
    
    public func remove(renderCallback: RenderCallback) throws {
        try AudioUnitRemoveRenderNotify(reference, renderCallback.callback, renderCallback.referenceContext).audioError("Removing render callback from Audiounit")
    }
    
}

extension AudioUnit {
    
    public func value(for parameter: AudioUnitParameterID, scope: AudioUnitScope = kAudioUnitScope_Global, element: AudioUnitElement = 0) throws -> AudioUnitParameterValue {
        var value: AudioUnitParameterValue = 0.0
        try AudioUnitGetParameter(reference, parameter, scope, element, &value).audioError("Setting AudioUnit parameter")
        return value
    }
    
    public func set(value: Float32, for parameter: AudioUnitParameterID, scope: AudioUnitScope = kAudioUnitScope_Global, element: AudioUnitElement = 0, offset: UInt32 = 0) throws {
        try AudioUnitSetParameter(reference, parameter, scope, element, value, offset).audioError("Setting AudioUnit parameter")
    }
    
//    public func schedule(parameters: [AudioUnitParameterEvent]) throws {
//        parameters.withUnsafeBufferPointer { pointer in
//            try AudioUnitScheduleParameters(reference, UnsafePointer<AudioUnitParameterEvent>(pointer), UInt32(parameters.count)).audioError("Scheduling AudioUnit parameters")
//        }
//    }
    
}

extension AudioUnit {
    
//    public func render(buffers: inout AudioBufferList, timeStamp: AudioTimeStamp, bus: UInt32, numberOfFrames: UInt32, flags: AudioUnitRenderActionFlags) throws {
//        var timeStamp = timeStamp
//        var flags = flags
//        try AudioUnitRender(reference, &flags, &timeStamp, bus, numberOfFrames, &buffers).audioError("Rendering AudioUnit")
//    }
//    
//    public func process(buffers: inout AudioBufferList, timeStamp: AudioTimeStamp, numberOfFrames: UInt32, flags: AudioUnitRenderActionFlags) throws {
//        var timeStamp = timeStamp
//        var flags = flags
//        try AudioUnitProcess(reference, &flags, &timeStamp, numberOfFrames, &buffers).audioError("Processing AudioUnit buffers")
//    }
//    
//    public func processMultiple(inputs: inout [AudioBufferList], outputs: inout [AudioBufferList], timeStamp: AudioTimeStamp, numberOfFrames: UInt32, flags: AudioUnitRenderActionFlags) {
//        var timeStamp = timeStamp
//        var flags = flags
//        inputs.withUnsafeBufferPointer { inputsPointer in
//            outputs.withUnsafeBufferPointer { outputsPointer in
//                try AudioUnitProcessMultiple(reference, &flags, &timeStamp, numberOfFrames, UInt32(inputs.count), inputsPointer, UInt32(outputs.count), outputsPointer).audioError("Processing multiple AudioUnit buffers")
//            }
//        }
//    }
    
}

extension AudioUnit {
    
    public func reset(scope: AudioUnitScope = kAudioUnitScope_Global, element: AudioUnitElement = 0) throws {
        try AudioUnitReset(reference, scope, element).audioError("Resetting AudioUnit")
    }
    
}
