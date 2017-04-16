//
//  MIDIClient.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI.MIDIServices

class MIDIClient: MIDIObject {
    
    convenience init(name: String, context: UnsafeMutableRawPointer? = nil, procedure: MIDINotifyProc? = nil) throws {
        var client = MIDIClientRef()
        try MIDIClientCreate(name as CFString, procedure, context, &client).check("Creating MIDIClient with name \"\(name)\"")
        self.init(reference: client)
    }
    
    convenience init(name: String, block: MIDINotifyBlock? = nil) throws {
        var client = MIDIClientRef()
        try MIDIClientCreateWithBlock(name as CFString, &client, block).check("Creating MIDIClient with name \"\(name)\"")
        self.init(reference: client)
    }
    
    func createInputPort(name: String, context: UnsafeMutableRawPointer? = nil, procedure: @escaping MIDIReadProc) throws -> MIDIPort {
        var port = MIDIPortRef()
        try MIDIInputPortCreate(reference, name as CFString, procedure, context, &port).check("Creating input port on MIDIClient with name \"\(name)\"")
        return MIDIPort(reference: port)
    }
    
    func createInputPort(name: String, block: @escaping MIDIReadBlock) throws -> MIDIPort {
        var port = MIDIPortRef()
        try MIDIInputPortCreateWithBlock(reference, name as CFString, &port, block).check("Creating input port on MIDIClient with name \"\(name)\"")
        return MIDIPort(reference: port)
    }
    
    func createOutputPort(name: String) throws -> MIDIPort {
        var port = MIDIPortRef()
        try MIDIOutputPortCreate(reference, name as CFString, &port).check("Creating output port on MIDIClient with name \"\(name)\"")
        return MIDIPort(reference: port)
    }
    
    func dispose() throws {
        try MIDIClientDispose(reference).check("Disposing of MIDIClient")
    }

}

extension MIDIClient {
    
    func createDestination(name: String, context: UnsafeMutableRawPointer? = nil, procedure: @escaping MIDIReadProc) throws -> MIDIEndpoint<Destination> {
        var endpoint = MIDIEndpointRef()
        try MIDIDestinationCreate(reference, name as CFString, procedure, context, &endpoint).check("Creating destination on MIDIClient")
        return MIDIEndpoint<Destination>(reference: endpoint)
    }
    
    func createDestination(name: String, block: @escaping MIDIReadBlock) throws -> MIDIEndpoint<Destination> {
        var endpoint = MIDIEndpointRef()
        try MIDIDestinationCreateWithBlock(reference, name as CFString, &endpoint, block).check("Creating destination on MIDIClient")
        return MIDIEndpoint<Destination>(reference: endpoint)
    }
    
    func createSource(name: String) throws -> MIDIEndpoint<Source> {
        var endpoint = MIDIEndpointRef()
        try MIDISourceCreate(reference, name as CFString, &endpoint).check("Creating source on MIDIClient")
        return MIDIEndpoint<Source>(reference: endpoint)
    }
    
}

extension MIDIClient {
    
    static func sendSystemExclusiveEvent(request: UnsafeMutablePointer<MIDISysexSendRequest>) throws {
        try MIDISendSysex(request).check("Sending system exclusive event")
    }
    
    static func restart() throws {
        try MIDIRestart().check("Restarting MIDI")
    }
    
}
