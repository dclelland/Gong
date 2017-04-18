//
//  MIDI.swift
//  Pods
//
//  Created by Daniel Clelland on 17/04/17.
//
//

import Foundation
import CoreMIDI

public class MIDI {
    
    public static let `default` = MIDI(name: "Default")
    
    public let name: String
    
    public lazy private(set) var client: MIDIClient? = {
        return try? MIDIClient(name: self.name) { notification in
            self.received(notification: notification)
        }
    }()
    
    public lazy private(set) var input: MIDIPort<Input>? = {
        guard let client = self.client else {
            return nil
        }
        
        return try? client.createInput(name: self.name) { (source, packet) in
            self.received(packet: packet, from: source)
        }
    }()
    
    public lazy private(set) var output: MIDIPort<Output>? = {
        guard let client = self.client else {
            return nil
        }
        
        return try? client.createOutput(name: self.name)
    }()
    
    public init(name: String) {
        self.name = name
    }
    
    public func connect() {
        for device in MIDIDevice.all {
            print("CONNECT", device)
            try? input?.connect(device)
        }
    }
    
    public func disconnect() {
        for device in MIDIDevice.all {
            print(device)
            print("DISCONNECT", device)
            try? input?.disconnect(device)
        }
    }
    
    private func received(notification: MIDIClient.Notification) {
        print(notification)
        
        switch notification {
        case .objectAdded(_, let source as MIDIEndpoint<Source>):
            try? input?.connect(source)
        case .objectRemoved(_, let source as MIDIEndpoint<Source>):
            try? input?.disconnect(source)
        default:
            break
        }
    }
    
    private func received(packet: MIDIPacket, from source: MIDIEndpoint<Source>) {
        switch packet.message {
        case .noteOn, .noteOff:
            print(packet.message, source)
        default:
            break
        }
    }

}
