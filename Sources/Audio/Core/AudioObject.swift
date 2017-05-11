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
        var dataSize = try self.dataSize(for: address, qualifier: qualifier)
        let data: UnsafeMutablePointer<T> = try self.data(for: address, dataSize: &dataSize, qualifier: qualifier)
        defer {
            data.deallocate(capacity: Int(dataSize))
        }
        return data.pointee
    }
    
    public func array<T>(for address: AudioObjectPropertyAddress, qualifier: Any? = nil) throws -> [T] {
        var dataSize = try self.dataSize(for: address, qualifier: qualifier)
        let data: UnsafeMutablePointer<T> = try self.data(for: address, dataSize: &dataSize, qualifier: qualifier)
        defer {
            data.deallocate(capacity: Int(dataSize))
        }
        let count = Int(dataSize) / MemoryLayout<T>.size
        return (0..<count).map { index in
            return data[index]
        }
    }
    
    public func setValue<T>(_ value: T, for address: AudioObjectPropertyAddress, qualifier: Any? = nil) throws {
        let dataSize = try self.dataSize(for: address, qualifier: qualifier)
        var data = value
        return try setData(&data, for: address, dataSize: dataSize, qualifier: qualifier)
    }
    
}

extension AudioObject {
    
    internal func dataSize(for address: AudioObjectPropertyAddress, qualifier: Any? = nil) throws -> UInt32 {
        var dataSize: UInt32 = 0
        var address = address
        var qualifier = qualifier
        let qualifierSize = UInt32(MemoryLayout.size(ofValue: qualifier))
        
        try AudioObjectGetPropertyDataSize(reference, &address, qualifierSize, &qualifier, &dataSize).audioError("Getting AudioObject property data size")
        
        return dataSize
    }
    
    internal func data<T>(for address: AudioObjectPropertyAddress, dataSize: inout UInt32, qualifier: Any? = nil) throws -> UnsafeMutablePointer<T> {
        var address = address
        var qualifier = qualifier
        let qualifierSize = UInt32(MemoryLayout.size(ofValue: qualifier))
        let data = UnsafeMutablePointer<T>.allocate(capacity: Int(dataSize))
        
        try AudioObjectGetPropertyData(reference, &address, qualifierSize, &qualifier, &dataSize, data).audioError("Getting AudioObject property data")
        
        return data
    }
    
    internal func setData<T>(_ data: UnsafeMutablePointer<T>, for address: AudioObjectPropertyAddress, dataSize: UInt32, qualifier: Any? = nil) throws {
        var address = address
        var qualifier = qualifier
        let qualifierSize = UInt32(MemoryLayout.size(ofValue: qualifier))
        
        try AudioObjectSetPropertyData(reference, &address, qualifierSize, &qualifier, dataSize, data).audioError("Setting AudioObject property data")
    }
    
}
