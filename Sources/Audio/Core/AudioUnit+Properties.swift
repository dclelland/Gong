//
//  AudioUnit+Properties.swift
//  Pods
//
//  Created by Daniel Clelland on 02/04/17.
//

import Foundation
import AudioToolbox

// MARK: - AudioUnit properties

extension AudioUnit {
    
    /// Gets a value for a given property. Automatic casting; will crash for invalid properties.
    public func getValue<T>(for property: AudioUnitPropertyID) -> T {
        let (dataSize, _) = try! getPropertyInfo(property)
        return try! getProperty(property, dataSize: dataSize)
    }
    
    /// Sets a value for a given property. Automatic casting; will crash for invalid properties.
    public func setValue<T>(_ value: T, for property: AudioUnitPropertyID) {
        let (dataSize, _) = try! getPropertyInfo(property)
        return try! setProperty(property, dataSize: dataSize, data: value)
    }
}

// MARK: - Private methods

fileprivate extension AudioUnit {
    
    func getPropertyInfo(_ propertyID: AudioUnitPropertyID) throws -> (dataSize: UInt32, writable: Bool) {
        var dataSize: UInt32 = 0
        var writable: DarwinBoolean = false
        
        try AudioUnitGetPropertyInfo(self, propertyID, kAudioUnitScope_Global, 0, &dataSize, &writable).check()
        
        return (dataSize: dataSize, writable: writable.boolValue)
    }
    
    func getProperty<T>(_ propertyID: AudioUnitPropertyID, dataSize: UInt32) throws -> T {
        var dataSize = dataSize
        var data = UnsafeMutablePointer<T>.allocate(capacity: Int(dataSize))
        defer {
            data.deallocate(capacity: Int(dataSize))
        }
        
        try AudioUnitGetProperty(self, propertyID, kAudioUnitScope_Global, 0, data, &dataSize).check()
        
        return data.pointee
    }
    
    func setProperty<T>(_ propertyID: AudioUnitPropertyID, dataSize: UInt32, data: T) throws {
        var data = data
        
        try AudioFileSetProperty(self, propertyID, dataSize, &data).check()
    }

}
