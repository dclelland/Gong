//
//  AudioObject.swift
//  Gong
//
//  Created by Daniel Clelland on 11/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioObject {
    
    public let reference: AudioObjectID
    
    public init(_ reference: AudioObjectID) {
        self.reference = reference
    }
    
    public static let system = AudioObject(UInt32(kAudioObjectSystemObject))
    
}

extension AudioObject {
    
    public func value<T>(for address: AudioObjectPropertyAddress, qualifier: Any? = nil) throws -> T {
        var size = try self.size(for: address, qualifier: qualifier)
        let data: UnsafeMutablePointer<T> = try self.data(for: address, size: &size, qualifier: qualifier)
        defer {
            data.deallocate(capacity: Int(size))
        }
        return data.pointee
    }
    
    public func array<T>(for address: AudioObjectPropertyAddress, qualifier: Any? = nil) throws -> [T] {
        var size = try self.size(for: address, qualifier: qualifier)
        let data: UnsafeMutablePointer<T> = try self.data(for: address, size: &size, qualifier: qualifier)
        defer {
            data.deallocate(capacity: Int(size))
        }
        let count = Int(size) / MemoryLayout<T>.size
        return (0..<count).map { index in
            return data[index]
        }
    }
    
    public func set<T>(value: T, for address: AudioObjectPropertyAddress, qualifier: Any? = nil) throws {
        let size = try self.size(for: address, qualifier: qualifier)
        var data = value
        return try set(data: &data, for: address, size: size, qualifier: qualifier)
    }
    
}

extension AudioObject {
    
    internal func size(for address: AudioObjectPropertyAddress, qualifier: Any? = nil) throws -> UInt32 {
        var size: UInt32 = 0
        var address = address
        var qualifier = qualifier
        let qualifierSize = UInt32(MemoryLayout.size(ofValue: qualifier))
        
        try AudioObjectGetPropertyDataSize(reference, &address, qualifierSize, &qualifier, &size).audioError("Getting AudioObject property data size")
        
        return size
    }
    
    internal func data<T>(for address: AudioObjectPropertyAddress, size: inout UInt32, qualifier: Any? = nil) throws -> UnsafeMutablePointer<T> {
        var address = address
        var qualifier = qualifier
        let qualifierSize = UInt32(MemoryLayout.size(ofValue: qualifier))
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(size))
        
        try AudioObjectGetPropertyData(reference, &address, qualifierSize, &qualifier, &size, data).audioError("Getting AudioObject property data")
        
        return data
    }
    
    internal func set<T>(data: UnsafeMutablePointer<T>, for address: AudioObjectPropertyAddress, size: UInt32, qualifier: Any? = nil) throws {
        var address = address
        var qualifier = qualifier
        let qualifierSize = UInt32(MemoryLayout.size(ofValue: qualifier))
        
        try AudioObjectSetPropertyData(reference, &address, qualifierSize, &qualifier, size, data).audioError("Setting AudioObject property data")
    }
    
}
