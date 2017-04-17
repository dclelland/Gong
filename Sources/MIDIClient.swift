//
//  MIDIClient.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

public class MIDIClient: MIDIObject {
    
    public typealias NotifyCallback = (MIDINotification) -> Void
    
    public convenience init(name: String, callback: @escaping NotifyCallback = { _ in }) throws {
        var client = MIDIClientRef()
        let context = UnsafeMutablePointer.wrap(callback)
        let procedure: MIDINotifyProc = { (notification, context) in
            context?.assumingMemoryBound(to: NotifyCallback.self).pointee(notification.pointee)
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

fileprivate extension UnsafeMutablePointer {
    
    static func wrap(_ value: Pointee) -> UnsafeMutablePointer<Pointee> {
        let pointer = UnsafeMutablePointer<Pointee>.allocate(capacity: MemoryLayout<Pointee>.stride)
        pointer.initialize(to: value)
        return pointer
    }
    
}
