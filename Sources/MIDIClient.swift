//
//  MIDIClient.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

public class MIDIClient: MIDIObject {
    
    /// Bug when you unplug a keyboard on macOS 10.11: https://lists.apple.com/archives/coreaudio-api/2015/Oct/msg00059.html
    
    public static let `default` = try? MIDIClient(name: "Default client") { notification in
        print(notification)
    }
    
    public enum Notification {
        
        case setupChanged
        
        case objectAdded(parent: MIDIObject, child: MIDIObject)
        
        case objectRemoved(parent: MIDIObject, child: MIDIObject)
        
        case propertyChanged(object: MIDIObject, property: CFString)
        
        case throughConnectionsChanged
        
        case serialPortOwnerChanged
        
        case ioError(device: MIDIDevice, error: MIDIServicesError)
        
        fileprivate init(_ pointer: UnsafePointer<MIDINotification>) {
            let notification = pointer.pointee
            switch notification.messageID {
            case .msgSetupChanged:
                self = .setupChanged
            case .msgObjectAdded:
                let notification: MIDIObjectAddRemoveNotification = pointer.cast(size: Int(notification.messageSize))
                let parent = MIDIObject.create(with: notification.parent, type: notification.parentType)
                let child = MIDIObject.create(with: notification.child, type: notification.childType)
                self = .objectAdded(parent: parent, child: child)
            case .msgObjectRemoved:
                let notification: MIDIObjectAddRemoveNotification = pointer.cast(size: Int(notification.messageSize))
                let parent = MIDIObject.create(with: notification.parent, type: notification.parentType)
                let child = MIDIObject.create(with: notification.child, type: notification.childType)
                self = .objectRemoved(parent: parent, child: child)
            case .msgPropertyChanged:
                let notification: MIDIObjectPropertyChangeNotification = pointer.cast(size: Int(notification.messageSize))
                let object = MIDIObject.create(with: notification.object, type: notification.objectType)
                let property = notification.propertyName.takeRetainedValue()
                self = .propertyChanged(object: object, property: property)
            case .msgThruConnectionsChanged:
                self = .throughConnectionsChanged
            case .msgSerialPortOwnerChanged:
                self = .serialPortOwnerChanged
            case .msgIOError:
                let notification: MIDIIOErrorNotification = pointer.cast(size: Int(notification.messageSize))
                let device = MIDIDevice(reference: notification.driverDevice)
                let error = MIDIServicesError(notification.errorCode)
                self = .ioError(device: device, error: error)
            }
        }
    }
    
    public typealias NotifyCallback = (Notification) -> Void
    
    public convenience init(name: String, callback: @escaping NotifyCallback = { _ in }) throws {
        var client = MIDIClientRef()
        let context = UnsafeMutablePointer.wrap(callback)
        let procedure: MIDINotifyProc = { (notification, context) in
            context?.assumingMemoryBound(to: NotifyCallback.self).pointee(Notification(notification))
        }
        try MIDIClientCreate(name as CFString, procedure, context, &client).check("Creating MIDIClient with name \"\(name)\"")
        self.init(reference: client)
    }
    
    public typealias ReadCallback = ([MIDIPacket]) -> Void
    
    public func createInput(name: String, callback: @escaping ReadCallback = { _ in }) throws -> MIDIPort<Input> {
        var port = MIDIPortRef()
        let context = UnsafeMutablePointer.wrap(callback)
        let procedure: MIDIReadProc = { (packetList, context, connectionContext) in
            context?.assumingMemoryBound(to: ReadCallback.self).pointee(packetList.pointee.packets)
        }
        try MIDIInputPortCreate(reference, name as CFString, procedure, context, &port).check("Creating input port on MIDIClient with name \"\(name)\"")
        return MIDIPort(reference: port)
    }
    
    public func createOutput(name: String) throws -> MIDIPort<Output> {
        var port = MIDIPortRef()
        try MIDIOutputPortCreate(reference, name as CFString, &port).check("Creating output port on MIDIClient with name \"\(name)\"")
        return MIDIPort(reference: port)
    }
    
    public func dispose() throws {
        try MIDIClientDispose(reference).check("Disposing of MIDIClient")
    }

}

extension MIDIClient {
    
    public func createDestination(name: String, callback: @escaping ReadCallback = { _ in }) throws -> MIDIEndpoint<Destination> {
        var endpoint = MIDIEndpointRef()
        let context = UnsafeMutablePointer.wrap(callback)
        let procedure: MIDIReadProc = { (packetList, context, connectionContext) in
            context?.assumingMemoryBound(to: ReadCallback.self).pointee(packetList.pointee.packets)
        }
        try MIDIDestinationCreate(reference, name as CFString, procedure, context, &endpoint).check("Creating destination on MIDIClient")
        return MIDIEndpoint<Destination>(reference: endpoint)
    }
    
    public func createSource(name: String) throws -> MIDIEndpoint<Source> {
        var endpoint = MIDIEndpointRef()
        try MIDISourceCreate(reference, name as CFString, &endpoint).check("Creating source on MIDIClient")
        return MIDIEndpoint<Source>(reference: endpoint)
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

fileprivate extension UnsafePointer {
    
    func cast<T>(size capacity: Int) -> T {
        return withMemoryRebound(to: T.self, capacity: capacity, { $0.pointee })
    }
    
}

fileprivate extension UnsafeMutablePointer {
    
    static func wrap(_ value: Pointee) -> UnsafeMutablePointer<Pointee> {
        let pointer = UnsafeMutablePointer<Pointee>.allocate(capacity: MemoryLayout<Pointee>.stride)
        pointer.initialize(to: value)
        return pointer
    }
    
}
