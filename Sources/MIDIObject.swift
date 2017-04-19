//
//  MIDIObject.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIObject {
    
    public let reference: MIDIObjectRef
    
    public init(reference: MIDIObjectRef) {
        self.reference = reference
    }
    
    public static func create(with reference: MIDIObjectRef, type: MIDIObjectType) -> MIDIObject {
        switch type {
        case .other:
            return MIDIObject(reference: reference)
        case .device, .externalDevice:
            return MIDIDevice(reference: reference)
        case .entity, .externalEntity:
            return MIDIEntity(reference: reference)
        case .source, .externalSource:
            return MIDIEndpoint<Source>(reference: reference)
        case .destination, .externalDestination:
            return MIDIEndpoint<Destination>(reference: reference)
        }
    }
    
    public static func find(with uniqueID: MIDIUniqueID, type: MIDIObjectType) -> MIDIObject? {
        var object = MIDIObjectRef()
        do {
            try MIDIObjectFindByUniqueID(uniqueID, &object, nil).check("Finding MIDIObject with unique ID \"\(uniqueID)\"")
            return MIDIObject(reference: object)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    public func integer(for property: CFString) throws -> Int32 {
        var integer: Int32 = 0
        try MIDIObjectGetIntegerProperty(reference, property, &integer).check("Getting integer for property \"\(property)\" on MIDIObject")
        return integer
    }
    
    public func setInteger(_ integer: Int32, for property: CFString) throws {
        try MIDIObjectSetIntegerProperty(reference, property, integer).check("Setting integer for property \"\(property)\" on MIDIObject")
    }
    
    public func string(for property: CFString) throws -> String {
        var string: Unmanaged<CFString>? = nil
        try MIDIObjectGetStringProperty(reference, property, &string).check("Getting string for property \"\(property)\" on MIDIObject")
        return string!.takeUnretainedValue() as String
    }
    
    public func setString(_ string: String, for property: CFString) throws {
        try MIDIObjectSetStringProperty(reference, property, string as CFString).check("Setting string for property \"\(property)\" on MIDIObject")
    }
    
    public func data(for property: CFString) throws -> Data {
        var data: Unmanaged<CFData>? = nil
        try MIDIObjectGetDataProperty(reference, property, &data).check("Getting data for property \"\(property)\" on MIDIObject")
        return data!.takeUnretainedValue() as Data
    }
    
    public func setData(_ data: CFData, for property: CFString) throws {
        try MIDIObjectSetDataProperty(reference, property, data).check("Setting data for property \"\(property)\" on MIDIObject")
    }
    
    public func dictionary(for property: CFString) throws -> NSDictionary {
        var dictionary: Unmanaged<CFDictionary>? = nil
        try MIDIObjectGetDictionaryProperty(reference, property, &dictionary).check("Getting dictionary for property \"\(property)\" on MIDIObject")
        return dictionary!.takeUnretainedValue() as NSDictionary
    }
    
    public func setDictionary(_ dictionary: NSDictionary, for property: CFString) throws {
        try MIDIObjectSetDictionaryProperty(reference, property, dictionary as CFDictionary).check("Setting dictionary for property \"\(property)\" on MIDIObject")
    }
    
    public func removeProperty(_ property: CFString) throws {
        try MIDIObjectRemoveProperty(reference, property).check("Removing property \"\(property)\" from MIDIObject")
    }
    
    public func properties(deep: Bool = false) throws -> NSDictionary {
        var propertyList: Unmanaged<CFPropertyList>? = nil
        try MIDIObjectGetProperties(reference, &propertyList, deep).check("Getting properties for MIDIObject")
        return propertyList!.takeUnretainedValue() as! NSDictionary
    }
    
}

extension MIDIObject {
    
    public var properties: NSDictionary? {
        return try? properties(deep: true)
    }
    
    public var name: String? {
        return try? string(for: kMIDIPropertyName)
    }

}

extension MIDIObject: Equatable {
    
    public static func == (lhs: MIDIObject, rhs: MIDIObject) -> Bool {
        return lhs.reference == rhs.reference
    }
    
}

extension MIDIObject: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        guard let name = name else {
            return "\(type(of: self))()"
        }
        
        return "\(type(of: self))(name: \(name))"
    }
    
}
