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
    
    public init(_ reference: MIDIObjectRef) {
        self.reference = reference
    }
    
    public static func create(with reference: MIDIObjectRef, type: MIDIObjectType) -> MIDIObject {
        switch type {
        case .other:
            return MIDIObject(reference)
        case .device, .externalDevice:
            return MIDIDevice(reference)
        case .entity, .externalEntity:
            return MIDIEntity(reference)
        case .source, .externalSource:
            return MIDISource(reference)
        case .destination, .externalDestination:
            return MIDIDestination(reference)
        @unknown default:
            fatalError("Unrecognized MIDI object type")
        }
    }
    
    public static func find(with uniqueID: MIDIUniqueID, type: MIDIObjectType) -> MIDIObject? {
        var reference = MIDIObjectRef()
        do {
            try MIDIObjectFindByUniqueID(uniqueID, &reference, nil).midiError("Finding MIDIObject with unique ID \"\(uniqueID)\"")
            return MIDIObject(reference)
        } catch let error {
            print(error)
            return nil
        }
    }
    
}

extension MIDIObject {
    
    public struct Property {
        public static let name = kMIDIPropertyName as String
        public static let manufacturer = kMIDIPropertyManufacturer as String
        public static let model = kMIDIPropertyModel as String
        public static let uniqueID = kMIDIPropertyUniqueID as String
        public static let deviceID = kMIDIPropertyDeviceID as String
        public static let receiveChannels = kMIDIPropertyReceiveChannels as String
        public static let transmitChannels = kMIDIPropertyTransmitChannels as String
        public static let maximumSystemExclusiveSpeed = kMIDIPropertyMaxSysExSpeed as String
        public static let advanceScheduleTimeInMicroseconds = kMIDIPropertyAdvanceScheduleTimeMuSec as String
        public static let isEmbeddedEntity = kMIDIPropertyIsEmbeddedEntity as String
        public static let isBroadcast = kMIDIPropertyIsBroadcast as String
        public static let singleRealtimeEntity = kMIDIPropertySingleRealtimeEntity as String
        public static let connectionUniqueID = kMIDIPropertyConnectionUniqueID as String
        public static let offline = kMIDIPropertyOffline as String
        public static let `private` = kMIDIPropertyPrivate as String
        public static let driverOwner = kMIDIPropertyDriverOwner as String
        public static let nameConfiguration = kMIDIPropertyNameConfiguration as String
        public static let image = kMIDIPropertyImage as String
        public static let driverVersion = kMIDIPropertyDriverVersion as String
        public static let supportsGeneralMIDI = kMIDIPropertySupportsGeneralMIDI as String
        public static let supportsMMC = kMIDIPropertySupportsMMC as String
        public static let canRoute = kMIDIPropertyCanRoute as String
        public static let receivesClock = kMIDIPropertyReceivesClock as String
        public static let receivesMTC = kMIDIPropertyReceivesMTC as String
        public static let receivesNotes = kMIDIPropertyReceivesNotes as String
        public static let receivesProgramChanges = kMIDIPropertyReceivesProgramChanges as String
        public static let receivesBankSelectMostSignificantByte = kMIDIPropertyReceivesBankSelectMSB as String
        public static let receivesBankSelectLeastSignificantByte = kMIDIPropertyReceivesBankSelectLSB as String
        public static let transmitsClock = kMIDIPropertyTransmitsClock as String
        public static let transmitsMTC = kMIDIPropertyTransmitsMTC as String
        public static let transmitsNotes = kMIDIPropertyTransmitsNotes as String
        public static let transmitsProgramChanges = kMIDIPropertyTransmitsProgramChanges as String
        public static let transmitsBankSelectMostSignificantByte = kMIDIPropertyTransmitsBankSelectMSB as String
        public static let transmitsBankSelectLeastSignificantByte = kMIDIPropertyTransmitsBankSelectLSB as String
        public static let panDisruptsStereo = kMIDIPropertyPanDisruptsStereo as String
        public static let isSampler = kMIDIPropertyIsSampler as String
        public static let isDrumMachine = kMIDIPropertyIsDrumMachine as String
        public static let isMixer = kMIDIPropertyIsMixer as String
        public static let isEffectUnit = kMIDIPropertyIsEffectUnit as String
        public static let maximumReceiveChannels = kMIDIPropertyMaxReceiveChannels as String
        public static let maximumTransmitChannels = kMIDIPropertyMaxTransmitChannels as String
        public static let driverDeviceEditorApp = kMIDIPropertyDriverDeviceEditorApp as String
        public static let supportsShowControl = kMIDIPropertySupportsShowControl as String
        public static let displayName = kMIDIPropertyDisplayName as String
    }

    public func integer(for property: String) throws -> Int32 {
        var integer: Int32 = 0
        try MIDIObjectGetIntegerProperty(reference, property as CFString, &integer).midiError("Getting integer for property \"\(property)\" on MIDIObject")
        return integer
    }
    
    public func set(integer: Int32, for property: String) throws {
        try MIDIObjectSetIntegerProperty(reference, property as CFString, integer).midiError("Setting integer for property \"\(property)\" on MIDIObject")
    }
    
    public func string(for property: String) throws -> String {
        var string: Unmanaged<CFString>? = nil
        try MIDIObjectGetStringProperty(reference, property as CFString, &string).midiError("Getting string for property \"\(property)\" on MIDIObject")
        return string!.takeUnretainedValue() as String
    }
    
    public func set(string: String, for property: String) throws {
        try MIDIObjectSetStringProperty(reference, property as CFString, string as CFString).midiError("Setting string for property \"\(property)\" on MIDIObject")
    }
    
    public func data(for property: String) throws -> Data {
        var data: Unmanaged<CFData>? = nil
        try MIDIObjectGetDataProperty(reference, property as CFString, &data).midiError("Getting data for property \"\(property)\" on MIDIObject")
        return data!.takeUnretainedValue() as Data
    }
    
    public func set(data: Data, for property: String) throws {
        try MIDIObjectSetDataProperty(reference, property as CFString, data as CFData).midiError("Setting data for property \"\(property)\" on MIDIObject")
    }
    
    public func dictionary(for property: String) throws -> NSDictionary {
        var dictionary: Unmanaged<CFDictionary>? = nil
        try MIDIObjectGetDictionaryProperty(reference, property as CFString, &dictionary).midiError("Getting dictionary for property \"\(property)\" on MIDIObject")
        return dictionary!.takeUnretainedValue() as NSDictionary
    }
    
    public func set(dictionary: NSDictionary, for property: String) throws {
        try MIDIObjectSetDictionaryProperty(reference, property as CFString, dictionary as CFDictionary).midiError("Setting dictionary for property \"\(property)\" on MIDIObject")
    }
    
    public func remove(property: String) throws {
        try MIDIObjectRemoveProperty(reference, property as CFString).midiError("Removing property \"\(property)\" from MIDIObject")
    }
    
    public func properties(deep: Bool = false) throws -> NSDictionary {
        var propertyList: Unmanaged<CFPropertyList>? = nil
        try MIDIObjectGetProperties(reference, &propertyList, deep).midiError("Getting properties for MIDIObject")
        return propertyList!.takeUnretainedValue() as! NSDictionary
    }
    
}

extension MIDIObject {
    
    public var properties: NSDictionary? {
        return try? properties(deep: true)
    }
    
    public var name: String? {
        return try? string(for: Property.name)
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
