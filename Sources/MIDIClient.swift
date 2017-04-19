//
//  MIDIClient.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIClient: MIDIObject {
    
    public typealias NotifyCallback = (Notification) -> Void
    
    public typealias ReadCallback = (MIDIEndpoint<Source>, MIDIPacket) -> Void
    
    public enum Notification {
        
        case setupChanged
        
        case objectAdded(parent: MIDIObject, child: MIDIObject)
        
        case objectRemoved(parent: MIDIObject, child: MIDIObject)
        
        case propertyChanged(object: MIDIObject, property: CFString)
        
        case throughConnectionsChanged
        
        case serialPortOwnerChanged
        
        case ioError(device: MIDIDevice, error: MIDIError)
        
        fileprivate init(_ pointer: UnsafePointer<MIDINotification>) {
            let notification = pointer.pointee
            switch notification.messageID {
            case .msgSetupChanged:
                self = .setupChanged
            case .msgObjectAdded:
                let notification: MIDIObjectAddRemoveNotification = pointer.unwrap(size: Int(notification.messageSize))
                let parent = MIDIObject.create(with: notification.parent, type: notification.parentType)
                let child = MIDIObject.create(with: notification.child, type: notification.childType)
                self = .objectAdded(parent: parent, child: child)
            case .msgObjectRemoved:
                let notification: MIDIObjectAddRemoveNotification = pointer.unwrap(size: Int(notification.messageSize))
                let parent = MIDIObject.create(with: notification.parent, type: notification.parentType)
                let child = MIDIObject.create(with: notification.child, type: notification.childType)
                self = .objectRemoved(parent: parent, child: child)
            case .msgPropertyChanged:
                let notification: MIDIObjectPropertyChangeNotification = pointer.unwrap(size: Int(notification.messageSize))
                let object = MIDIObject.create(with: notification.object, type: notification.objectType)
                let property = notification.propertyName.takeUnretainedValue()
                self = .propertyChanged(object: object, property: property)
            case .msgThruConnectionsChanged:
                self = .throughConnectionsChanged
            case .msgSerialPortOwnerChanged:
                self = .serialPortOwnerChanged
            case .msgIOError:
                let notification: MIDIIOErrorNotification = pointer.unwrap(size: Int(notification.messageSize))
                let device = MIDIDevice(reference: notification.driverDevice)
                let error = MIDIError(status: notification.errorCode)
                self = .ioError(device: device, error: error)
            }
        }
    }
    
    public convenience init(name: String, callback: @escaping NotifyCallback = { _ in }) throws {
        var client = MIDIClientRef()
        let context = UnsafeMutablePointer.wrap(callback)
        
        let procedure: MIDINotifyProc = { (notification, context) in
            guard let callback: NotifyCallback = context?.unwrap() else {
                return
            }
            
            callback(Notification(notification))
        }
        
        try MIDIClientCreate(name as CFString, procedure, context, &client).check("Creating MIDIClient with name \"\(name)\"")
        self.init(reference: client)
    }
    
    public func createInput(name: String, callback: @escaping ReadCallback = { _ in }) throws -> MIDIPort<Input> {
        var port = MIDIPortRef()
        let context = UnsafeMutablePointer.wrap(callback)
        
        let procedure: MIDIReadProc = { (packetList, context, connectionContext) in
            guard let callback: ReadCallback = context?.unwrap() else {
                return
            }
            
            guard let reference: MIDIEndpointRef = connectionContext?.unwrap() else {
                return
            }
            
            for packet in packetList.pointee.packets {
                callback(MIDIEndpoint<Source>(reference: reference), packet)
            }
        }
        
        try MIDIInputPortCreate(reference, name as CFString, procedure, context, &port).check("Creating input port on MIDIClient with name \"\(name)\"")
        return MIDIPort(reference: port)
    }
    
    public func createOutput(name: String) throws -> MIDIPort<Output> {
        var port = MIDIPortRef()
        try MIDIOutputPortCreate(reference, name as CFString, &port).check("Creating output port on MIDIClient with name \"\(name)\"")
        return MIDIPort(reference: port)
    }
    
    public func createSource(name: String) throws -> MIDIEndpoint<Source> {
        var endpoint = MIDIEndpointRef()
        try MIDISourceCreate(reference, name as CFString, &endpoint).check("Creating source on MIDIClient")
        return MIDIEndpoint<Source>(reference: endpoint)
    }
    
    public func createDestination(name: String, callback: @escaping ReadCallback = { _ in }) throws -> MIDIEndpoint<Destination> {
        var endpoint = MIDIEndpointRef()
        let context = UnsafeMutablePointer.wrap(callback)
        
        let procedure: MIDIReadProc = { (packetList, context, connectionContext) in
            guard let callback: ReadCallback = context?.unwrap() else {
                return
            }
            
            guard let sourceReference: MIDIObjectRef = connectionContext?.unwrap() else {
                return
            }
            
            for packet in packetList.pointee.packets {
                callback(MIDIEndpoint<Source>(reference: sourceReference), packet)
            }
        }
        
        try MIDIDestinationCreate(reference, name as CFString, procedure, context, &endpoint).check("Creating destination on MIDIClient")
        return MIDIEndpoint<Destination>(reference: endpoint)
    }
    
    public func dispose() throws {
        try MIDIClientDispose(reference).check("Disposing of MIDIClient")
    }

}

extension MIDIClient {
    
    public static func sendSystemExclusiveEvent(request: UnsafeMutablePointer<MIDISysexSendRequest>) throws {
        try MIDISendSysex(request).check("Sending system exclusive event")
    }
    
    public static func restart() throws {
        try MIDIRestart().check("Restarting MIDI")
    }
    
}

internal extension UnsafePointer {
    
    func unwrap<T>(size capacity: Int) -> T {
        return withMemoryRebound(to: T.self, capacity: capacity, { $0.pointee })
    }
    
}

internal extension UnsafeMutableRawPointer {
    
    func unwrap<T>() -> T {
        return assumingMemoryBound(to: T.self).pointee
    }
    
}

internal extension UnsafeMutablePointer {
    
    static func wrap(_ value: Pointee) -> UnsafeMutablePointer<Pointee> {
        let pointer = UnsafeMutablePointer<Pointee>.allocate(capacity: MemoryLayout<Pointee>.stride)
        pointer.initialize(to: value)
        return pointer
    }
    
}
