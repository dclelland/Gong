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
    
    public typealias NotificationCallback = (MIDINotification) -> Void
    
    public typealias PacketCallback = (MIDIPacket, MIDIEndpoint<Source>) -> Void
    
    public convenience init(name: String, callback: @escaping NotificationCallback = { _ in }) throws {
        var clientReference = MIDIClientRef()
        let context = UnsafeMutablePointer.wrap(callback)
        
        let procedure: MIDINotifyProc = { (notificationPointer, context) in
            guard let callback: NotificationCallback = context?.unwrap() else {
                return
            }
            
            callback(MIDINotification(notificationPointer))
        }
        
        try MIDIClientCreate(name as CFString, procedure, context, &clientReference).check("Creating MIDIClient with name \"\(name)\"")
        self.init(clientReference)
    }
    
    public func createInput(name: String, callback: @escaping PacketCallback = { _ in }) throws -> MIDIPort<Input> {
        var portReference = MIDIPortRef()
        let context = UnsafeMutablePointer.wrap(callback)
        
        let procedure: MIDIReadProc = { (packetList, context, connectionContext) in
            guard let callback: PacketCallback = context?.unwrap() else {
                return
            }
            
            guard let endpointReference: MIDIEndpointRef = connectionContext?.unwrap() else {
                return
            }
            
            for packet in packetList.pointee.packets {
                callback(packet, MIDIEndpoint<Source>(endpointReference))
            }
        }
        
        try MIDIInputPortCreate(reference, name as CFString, procedure, context, &portReference).check("Creating input port on MIDIClient with name \"\(name)\"")
        return MIDIPort(portReference)
    }
    
    public func createOutput(name: String) throws -> MIDIPort<Output> {
        var portReference = MIDIPortRef()
        try MIDIOutputPortCreate(reference, name as CFString, &portReference).check("Creating output port on MIDIClient with name \"\(name)\"")
        return MIDIPort(portReference)
    }
    
    public func createSource(name: String) throws -> MIDIEndpoint<Source> {
        var endpointReference = MIDIEndpointRef()
        try MIDISourceCreate(reference, name as CFString, &endpointReference).check("Creating source on MIDIClient")
        return MIDIEndpoint<Source>(endpointReference)
    }
    
    public func createDestination(name: String, callback: @escaping PacketCallback = { _ in }) throws -> MIDIEndpoint<Destination> {
        var endpointReference = MIDIEndpointRef()
        let context = UnsafeMutablePointer.wrap(callback)
        
        let procedure: MIDIReadProc = { (packetList, context, connectionContext) in
            guard let callback: PacketCallback = context?.unwrap() else {
                return
            }
            
            guard let sourceReference: MIDIObjectRef = connectionContext?.unwrap() else {
                return
            }
            
            for packet in packetList.pointee.packets {
                callback(packet, MIDIEndpoint<Source>(sourceReference))
            }
        }
        
        try MIDIDestinationCreate(reference, name as CFString, procedure, context, &endpointReference).check("Creating destination on MIDIClient")
        return MIDIEndpoint<Destination>(endpointReference)
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

extension UnsafeMutablePointer {
    
    internal static func wrap(_ value: Pointee) -> UnsafeMutablePointer<Pointee> {
        let pointer = UnsafeMutablePointer<Pointee>.allocate(capacity: MemoryLayout<Pointee>.stride)
        pointer.initialize(to: value)
        return pointer
    }
    
}

extension UnsafeMutableRawPointer {
    
    internal func unwrap<T>() -> T {
        return assumingMemoryBound(to: T.self).pointee
    }
    
}
