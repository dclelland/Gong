//
//  MIDI.swift
//  Gong
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDI {
    
    public static var client: MIDIClient? = {
        do {
            return try MIDIClient(name: "Default client") { notification in
                process(notification)
            }
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static var input: MIDIPort<Input>? = {
        do {
            return try client?.createInput(name: "Default input") { (source, packet) in
                process(packet, from: source)
            }
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static var output: MIDIPort<Output>? = {
        do {
            return try client?.createOutput(name: "Default output")
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static func connect() {
        for source in MIDIEndpoint<Source>.all {
            do {
                try input?.connect(source)
            } catch let error {
                print(error)
            }
        }
    }
    
    public static func disconnect() {
        for source in MIDIEndpoint<Source>.all {
            do {
                try input?.disconnect(source)
            } catch let error {
                print(error)
            }
        }
    }
    
    private static func process(_ notification: MIDIClient.Notification) {
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
    
    private static func process(_ packet: MIDIPacket, from source: MIDIEndpoint<Source>) {
        switch packet.message {
        case .noteOn, .noteOff:
            print(packet.message, source)
        default:
            break
        }
    }

}

extension MIDIDevice {
    
    public func send(_ packet: MIDIPacket, via output: MIDIPort<Output>? = MIDI.output) {
        for entity in entities {
            entity.send(packet, via: output)
        }
    }
    
    public func recieve(_ packet: MIDIPacket) {
        for entity in entities {
            entity.recieve(packet)
        }
    }
    
}

extension MIDIEntity {
    
    public func send(_ packet: MIDIPacket, via output: MIDIPort<Output>? = MIDI.output) {
        for destination in destinations {
            destination.send(packet, via: output)
        }
    }
    
    public func recieve(_ packet: MIDIPacket) {
        for source in sources {
            source.receive(packet)
        }
    }
    
}

extension MIDIEndpoint where Type == Destination {
    
    public func send(_ packet: MIDIPacket, via output: MIDIPort<Output>? = MIDI.output) {
        guard let output = output else {
            return
        }
        
        do {
            try output.send(packet, to: self)
        } catch let error {
            print(error)
        }
    }
    
    public func receive(_ packet: MIDIPacket) {
        do {
            recieved(packet)
        } catch let error {
            print(error)
        }
    }
    
}
