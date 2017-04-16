//
//  MIDIObject.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

public class MIDIObject {
    
    public let reference: MIDIObjectRef
    
    public init(reference: MIDIObjectRef) {
        self.reference = reference
    }
    
    public static func find(with uniqueID: MIDIUniqueID, type: MIDIObjectType? = nil) -> MIDIObject? {
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
            return try? getInteger(for: property) != 0
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
            return try? Int(getInteger(for: property))
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
            return try? getString(for: property) as String
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
            return try? getData(for: property) as Data
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
            return try? getDictionary(for: property)
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
    
    private func getInteger(for property: CFString) throws -> Int32 {
        var integer: Int32 = 0
        try MIDIObjectGetIntegerProperty(reference, property, &integer).check("Getting integer for property \"\(property)\" on MIDIObject")
        return integer
    }
    
    private func setInteger(_ integer: Int32, for property: CFString) throws {
        try MIDIObjectSetIntegerProperty(reference, property, integer).check("Setting integer for property \"\(property)\" on MIDIObject")
    }
    
    private func getString(for property: CFString) throws -> CFString {
        var string: Unmanaged<CFString>? = nil
        try MIDIObjectGetStringProperty(reference, property, &string).check("Getting string for property \"\(property)\" on MIDIObject")
        return string!.takeRetainedValue()
    }
    
    private func setString(_ string: CFString, for property: CFString) throws {
        try MIDIObjectSetStringProperty(reference, property, string).check("Setting string for property \"\(property)\" on MIDIObject")
    }
    
    private func getData(for property: CFString) throws -> CFData {
        var data: Unmanaged<CFData>? = nil
        try MIDIObjectGetDataProperty(reference, property, &data).check("Getting data for property \"\(property)\" on MIDIObject")
        return data!.takeRetainedValue()
    }
    
    private func setData(_ data: CFData, for property: CFString) throws {
        try MIDIObjectSetDataProperty(reference, property, data).check("Setting data for property \"\(property)\" on MIDIObject")
    }
    
    private func getDictionary(for property: CFString) throws -> CFDictionary {
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
    
    private func getProperties(deep: Bool = false) throws -> CFPropertyList {
        var propertyList: Unmanaged<CFPropertyList>? = nil
        try MIDIObjectGetProperties(reference, &propertyList, deep).check("Getting properties for MIDIObject")
        return propertyList!.takeRetainedValue()
    }
    
    
//    Packet lists
//    
//    public func MIDIPacketNext(_ pkt: UnsafePointer<MIDIPacket>) -> UnsafeMutablePointer<MIDIPacket>
//    public func MIDIPacketListInit(_ pktlist: UnsafeMutablePointer<MIDIPacketList>) -> UnsafeMutablePointer<MIDIPacket>
//    public func MIDIPacketListAdd(_ pktlist: UnsafeMutablePointer<MIDIPacketList>, _ listSize: Int, _ curPacket: UnsafeMutablePointer<
    
}

extension MIDIObject: Equatable {
    
    public static func == (lhs: MIDIObject, rhs: MIDIObject) -> Bool {
        return lhs.reference == rhs.reference
    }
    
}
