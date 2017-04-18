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
    
    public static let shared = MIDI(name: "Shared")
    
    public let name: String
    
    public lazy private(set) var client: MIDIClient? = {
        return try? MIDIClient(name: self.name) { notification in
            self.received(notification)
        }
    }()
    
    public lazy private(set) var input: MIDIPort<Input>? = {
        guard let client = self.client else {
            return nil
        }
        
        return try? client.createInput(name: self.name) { (source, packet) in
            self.received(packet, from: source)
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
            try? input?.connect(device)
        }
    }
    
    public func disconnect() {
        for device in MIDIDevice.all {
            try? input?.disconnect(device)
        }
    }
    
    private func received(_ notification: MIDIClient.Notification) {
        switch notification {
        case .objectAdded(_, let source as MIDIEndpoint<Source>):
            try? input?.connect(source)
        case .objectRemoved(_, let source as MIDIEndpoint<Source>):
            try? input?.disconnect(source)
        default:
            break
        }
    }
    
    private func received(_ packet: MIDIPacket, from source: MIDIEndpoint<Source>) {
        switch packet.message {
        case .noteOn, .noteOff:
            print(packet.message, source)
        default:
            break
        }
    }

}

extension MIDIEndpoint where Type == Destination {
    
    public func send(_ packet: MIDIPacket, with midi: MIDI? = MIDI.shared) {
        if let output = midi?.output {
            try? output.send(packet, to: self)
        }
    }
    
}

extension MIDIEntity {
    
    public func send(_ packet: MIDIPacket, with midi: MIDI? = MIDI.shared) {
        if let output = midi?.output {
            try? output.send(packet, to: self)
        }
    }
    
}

extension MIDIDevice {
    
    public func send(_ packet: MIDIPacket, with midi: MIDI? = MIDI.shared) {
        if let output = midi?.output {
            try? output.send(packet, to: self)
        }
    }
    
}
