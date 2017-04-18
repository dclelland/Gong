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
        do {
            return try MIDIClient(name: self.name) { notification in
                self.received(notification)
            }
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public lazy private(set) var input: MIDIPort<Input>? = {
        do {
            return try self.client?.createInput(name: self.name) { (source, packet) in
                self.received(packet, from: source)
            }
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public lazy private(set) var output: MIDIPort<Output>? = {
        do {
            return try self.client?.createOutput(name: self.name)
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public init(name: String) {
        self.name = name
    }
    
    public func connect() {
        for device in MIDIDevice.all {
            do {
                try input?.connect(device)
            } catch let error {
                print(error)
            }
        }
    }
    
    public func disconnect() {
        for device in MIDIDevice.all {
            do {
                try input?.disconnect(device)
            } catch let error {
                print(error)
            }
        }
    }
    
    private func received(_ notification: MIDIClient.Notification) {
        do {
            switch notification {
            case .objectAdded(_, let source as MIDIEndpoint<Source>):
                try input?.connect(source)
            case .objectRemoved(_, let source as MIDIEndpoint<Source>):
                try input?.disconnect(source)
            default:
                break
            }
        } catch let error {
            print(error)
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
            do {
                try output.send(packet, to: self)
            } catch let error {
                print(error)
            }
        }
    }
    
}

extension MIDIEntity {
    
    public func send(_ packet: MIDIPacket, with midi: MIDI? = MIDI.shared) {
        if let output = midi?.output {
            do {
                try output.send(packet, to: self)
            } catch let error {
                print(error)
            }
        }
    }
    
}

extension MIDIDevice {
    
    public func send(_ packet: MIDIPacket, with midi: MIDI? = MIDI.shared) {
        if let output = midi?.output {
            do {
                try output.send(packet, to: self)
            } catch let error {
                print(error)
            }
        }
    }
    
}
