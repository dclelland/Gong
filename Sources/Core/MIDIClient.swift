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
    
    public typealias NoticeCallback = (_ notice: MIDINotice) -> Void
    
    public typealias PacketCallback = (_ packet: MIDIPacket, _ source: MIDISource) -> Void
    
    public convenience init(name: String, callback: @escaping NoticeCallback = { _ in }) throws {
        var clientReference = MIDIClientRef()
        
        let context = UnsafeMutablePointer<NoticeCallback>.allocate(capacity: 1)
        context.initialize(to: callback)
        
        let procedure: MIDINotifyProc = { (notificationReference, context) in
            guard let callback = context?.assumingMemoryBound(to: NoticeCallback.self).pointee else {
                return
            }
            
            callback(MIDINotice(notificationReference))
        }
        
        try MIDIClientCreate(name as CFString, procedure, context, &clientReference).midiError("Creating MIDIClient with name \"\(name)\"")
        self.init(clientReference)
    }
    
    public func dispose() throws {
        try MIDIClientDispose(reference).midiError("Disposing of MIDIClient")
    }
    
}

extension MIDIClient {

    public func createInput(name: String, callback: @escaping PacketCallback = { _, _  in }) throws -> MIDIInput {
        var portReference = MIDIPortRef()
        
        let context = UnsafeMutablePointer<PacketCallback>.allocate(capacity: 1)
        context.initialize(to: callback)
        
        let procedure: MIDIReadProc = { (packetList, context, connectionContext) in
            guard let callback = context?.assumingMemoryBound(to: PacketCallback.self).pointee else {
                return
            }
            
            guard let source = connectionContext?.assumingMemoryBound(to: MIDISource.self).pointee else {
                return
            }
            
            for packet in packetList.pointee.packets {
                callback(packet, source)
            }
        }
        
        try MIDIInputPortCreate(reference, name as CFString, procedure, context, &portReference).midiError("Creating input port on MIDIClient with name \"\(name)\"")
        return MIDIInput(portReference)
    }
    
    public func createOutput(name: String) throws -> MIDIOutput {
        var portReference = MIDIPortRef()
        try MIDIOutputPortCreate(reference, name as CFString, &portReference).midiError("Creating output port on MIDIClient with name \"\(name)\"")
        return MIDIOutput(portReference)
    }
    
    public func createSource(name: String) throws -> MIDISource {
        var endpointReference = MIDIEndpointRef()
        try MIDISourceCreate(reference, name as CFString, &endpointReference).midiError("Creating source on MIDIClient")
        return MIDISource(endpointReference)
    }
    
    public func createDestination(name: String, callback: @escaping PacketCallback = { _,_  in }) throws -> MIDIDestination {
        var endpointReference = MIDIEndpointRef()
        
        let context = UnsafeMutablePointer<PacketCallback>.allocate(capacity: 1)
        context.initialize(to: callback)
        
        let procedure: MIDIReadProc = { (packetList, context, connectionContext) in
            guard let callback = context?.assumingMemoryBound(to: PacketCallback.self).pointee else {
                return
            }
            
            guard let source = connectionContext?.assumingMemoryBound(to: MIDISource.self).pointee else {
                return
            }
            
            for packet in packetList.pointee.packets {
                callback(packet, source)
            }
        }
        
        try MIDIDestinationCreate(reference, name as CFString, procedure, context, &endpointReference).midiError("Creating destination on MIDIClient")
        return MIDIDestination(endpointReference)
    }

}

extension MIDIClient {
    
    public static func restart() throws {
        try MIDIRestart().midiError("Restarting MIDI")
    }
    
}
