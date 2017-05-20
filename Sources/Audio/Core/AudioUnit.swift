//
//  AudioUnit.swift
//  Gong
//
//  Created by Daniel Clelland on 02/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

#if os(iOS)

extension AudioUnit {
    
    public func value<T>(for property: AudioUnitPropertyID) -> T? {
        do {
            let (size, _) = try info(for: property)
            return try value(for: property, size: size)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    public func set<T>(value: T, for property: AudioUnitPropertyID) {
        do {
            let (size, _) = try info(for: property)
            return try setValue(value, for: property, size: size, data: value)
        } catch let error {
            print(error)
        }
    }
    
}

extension AudioUnit {
    
    public func value<T>(for property: AudioUnitPropertyID, size: UInt32) throws -> T {
        // TODO: Support arrays
        var size = size
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        defer {
            data.deallocate(capacity: Int(size))
        }
        try AudioUnitGetProperty(self, property, kAudioUnitScope_Global, 0, data, &size).check()
        return data.pointee
    }
    
    public func set<T>(value: T, for property: AudioUnitPropertyID, size: UInt32, data: T) throws {
        var data = value
        try AudioFileSetProperty(self, property, size, &data).check()
    }
    
    public func info(for property: AudioUnitPropertyID) throws -> (size: UInt32, isWritable: Bool) {
        var size: UInt32 = 0
        var isWritable: DarwinBoolean = false
        try AudioUnitGetPropertyInfo(self, property, kAudioUnitScope_Global, 0, &size, &isWritable).check()
        return (size: size, writable: isWritable.boolValue)
    }
    
}

extension AudioUnit {
    
    public func add(listener: AudioUnitPropertyListener, to property: AudioUnitPropertyID) {
        try! addPropertyListener(listener, toProperty: property)
    }
    
    public func remove(listener: AudioUnitPropertyListener, from property: AudioUnitPropertyID) {
        try! removePropertyListener(listener, fromProperty: property)
    }
    
}

public struct AudioUnitPropertyListener {
    
    public typealias Callback = (_ audioUnit: AudioUnit, _ property: AudioUnitPropertyID) -> Void
    
    fileprivate let proc: AudioUnitPropertyListenerProc
    
    fileprivate let procInput: UnsafeMutablePointer<Callback>
    
    public init(_ callback: @escaping Callback) {
        self.proc = { (inRefCon, inUnit, inID, inScope, inElement) in
            inRefCon.assumingMemoryBound(to: Callback.self).pointee(inUnit, inID)
        }
        
        self.procInput = UnsafeMutablePointer<Callback>.allocate(capacity: MemoryLayout<Callback>.stride)
        self.procInput.initialize(to: callback)
    }
    
}

fileprivate extension AudioUnit {
    
    func addPropertyListener(_ listener: AudioUnitPropertyListener, toProperty propertyID: AudioUnitPropertyID) throws {
        try AudioUnitAddPropertyListener(self, propertyID, listener.proc, listener.procInput).check()
    }
    
    func removePropertyListener(_ listener: AudioUnitPropertyListener, fromProperty propertyID: AudioUnitPropertyID) throws {
        try AudioUnitRemovePropertyListenerWithUserData(self, propertyID, listener.proc, listener.procInput).check()
    }
    
}

    
#endif
