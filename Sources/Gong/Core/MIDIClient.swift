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
    
    public typealias PacketCallback = (_ packet: MIDIEventPacket, _ source: MIDISource) -> Void
    
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

    public func createInput(name: String, protocolID: MIDIProtocolID = ._1_0, callback: @escaping PacketCallback = { _, _  in }) throws -> MIDIInput {
        var portReference = MIDIPortRef()
        
        let block: MIDIReceiveBlock = { eventList, connectionContext in
            guard let endpointReference = connectionContext?.assumingMemoryBound(to: MIDIEndpointRef.self).pointee else {
                return
            }
            
            for packet in eventList.pointee.packets {
                callback(packet, MIDISource(endpointReference))
            }
        }
        
        try MIDIInputPortCreateWithProtocol(reference, name as CFString, protocolID, &portReference, block).midiError("Creating input port on MIDIClient with name \"\(name)\"")
        return MIDIInput(portReference)
    }
    
    public func createOutput(name: String) throws -> MIDIOutput {
        var portReference = MIDIPortRef()
        try MIDIOutputPortCreate(reference, name as CFString, &portReference).midiError("Creating output port on MIDIClient with name \"\(name)\"")
        return MIDIOutput(portReference)
    }
    
    public func createSource(name: String, protocolID: MIDIProtocolID = ._1_0) throws -> MIDISource {
        var endpointReference = MIDIEndpointRef()
        try MIDISourceCreateWithProtocol(reference, name as CFString, protocolID, &endpointReference).midiError("Creating source on MIDIClient")
        return MIDISource(endpointReference)
    }
    
    public func createDestination(name: String, protocolID: MIDIProtocolID = ._1_0, callback: @escaping PacketCallback = { _,_  in }) throws -> MIDIDestination {
        var endpointReference = MIDIEndpointRef()
        
        let block: MIDIReceiveBlock = { eventList, connectionContext in
            guard let sourceReference = connectionContext?.assumingMemoryBound(to: MIDIObjectRef.self).pointee else {
                return
            }
            
            for packet in eventList.pointee.packets {
                callback(packet, MIDISource(sourceReference))
            }
        }
        
        try MIDIDestinationCreateWithProtocol(reference, name as CFString, protocolID, &endpointReference, block).midiError("Creating destination on MIDIClient")
        return MIDIDestination(endpointReference)
    }

}

extension MIDIClient {
    
    public static func restart() throws {
        try MIDIRestart().midiError("Restarting MIDI")
    }
    
}
