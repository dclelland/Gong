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
    
    public subscript(property: CFString) -> Bool? {
        get {
            return try? integer(for: property) != 0
        }
        set {
            if let boolean = newValue {
                try? setInteger(boolean ? 1 : 0, for: property)
            } else {
                try? removeProperty(property)
            }
        }
    }
    
    public subscript(property: CFString) -> Int? {
        get {
            return try? Int(integer(for: property))
        }
        set {
            if let integer = newValue {
                try? setInteger(Int32(truncatingBitPattern: integer), for: property)
            } else {
                try? removeProperty(property)
            }
        }
    }
    
    public subscript(property: CFString) -> String? {
        get {
            return try? string(for: property) as String
        }
        set {
            if let string = newValue {
                try? setString(string as CFString, for: property)
            } else {
                try? removeProperty(property)
            }
        }
    }
    
    public subscript(property: CFString) -> Data? {
        get {
            return try? data(for: property) as Data
        }
        set {
            if let data = newValue {
                try? setData(data as CFData, for: property)
            } else {
                try? removeProperty(property)
            }
        }
    }
    
    public subscript(property: CFString) -> CFDictionary? {
        get {
            return try? dictionary(for: property)
        }
        set {
            if let dictionary = newValue {
                try? setDictionary(dictionary, for: property)
            } else {
                try? removeProperty(property)
            }
        }
    }
    
    // MARK: Private helpers
    
    private func integer(for property: CFString) throws -> Int32 {
        var integer: Int32 = 0
        try MIDIObjectGetIntegerProperty(reference, property, &integer).check("Getting integer for property \"\(property)\" on MIDIObject")
        return integer
    }
    
    private func setInteger(_ integer: Int32, for property: CFString) throws {
        try MIDIObjectSetIntegerProperty(reference, property, integer).check("Setting integer for property \"\(property)\" on MIDIObject")
    }
    
    private func string(for property: CFString) throws -> CFString {
        var string: Unmanaged<CFString>? = nil
        try MIDIObjectGetStringProperty(reference, property, &string).check("Getting string for property \"\(property)\" on MIDIObject")
        return string!.takeRetainedValue()
    }
    
    private func setString(_ string: CFString, for property: CFString) throws {
        try MIDIObjectSetStringProperty(reference, property, string).check("Setting string for property \"\(property)\" on MIDIObject")
    }
    
    private func data(for property: CFString) throws -> CFData {
        var data: Unmanaged<CFData>? = nil
        try MIDIObjectGetDataProperty(reference, property, &data).check("Getting data for property \"\(property)\" on MIDIObject")
        return data!.takeRetainedValue()
    }
    
    private func setData(_ data: CFData, for property: CFString) throws {
        try MIDIObjectSetDataProperty(reference, property, data).check("Setting data for property \"\(property)\" on MIDIObject")
    }
    
    private func dictionary(for property: CFString) throws -> CFDictionary {
        var dictionary: Unmanaged<CFDictionary>? = nil
        try MIDIObjectGetDictionaryProperty(reference, property, &dictionary).check("Getting dictionary for property \"\(property)\" on MIDIObject")
        return dictionary!.takeRetainedValue()
    }
    
    private func setDictionary(_ dictionary: CFDictionary, for property: CFString) throws {
        try MIDIObjectSetDictionaryProperty(reference, property, dictionary).check("Setting dictionary for property \"\(property)\" on MIDIObject")
    }
    
    private func removeProperty(_ property: CFString) throws {
        try MIDIObjectRemoveProperty(reference, property).check("Removing property \"\(property)\" from MIDIObject")
    }
    
    private func properties(deep: Bool = false) throws -> CFPropertyList {
        var propertyList: Unmanaged<CFPropertyList>? = nil
        try MIDIObjectGetProperties(reference, &propertyList, deep).check("Getting properties for MIDIObject")
        return propertyList!.takeRetainedValue()
    }
    
}

extension MIDIObject {
    
    public var name: String? {
        return self[kMIDIPropertyName]
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
