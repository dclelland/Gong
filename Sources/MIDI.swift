//
//  MIDI.swift
//  Gong
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIReceiver: MIDIEventReceiver, MIDIMessageReceiver { }

public protocol MIDIEventReceiver: class {
    
    func receive(_ event: MIDIEvent)
    
}

public protocol MIDIMessageReceiver: class {
    
    func receive(_ message: MIDIMessage, from source: MIDIEndpoint<Source>)
    
}

public struct MIDI {
    
    public static var client: MIDIClient? = {
        do {
            return try MIDIClient(name: "Default client") { notification in
                receive(notification)
            }
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static var input: MIDIPort<Input>? = {
        do {
            return try client?.createInput(name: "Default input") { (message, source) in
                receive(message, from: source)
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
    
    public static func addReceiver(_ receiver: MIDIReceiver) {
        addEventReceiver(receiver)
        addMessageReceiver(receiver)
    }
    
    public static func removeReceiver(_ receiver: MIDIReceiver) {
        removeEventReceiver(receiver)
        removeMessageReceiver(receiver)
    }
    
    private static var eventReceivers = [MIDIEventReceiver]()
    
    public static func addEventReceiver(_ receiver: MIDIEventReceiver) {
        eventReceivers.append(receiver)
    }
    
    public static func removeEventReceiver(_ receiver: MIDIEventReceiver) {
        eventReceivers = eventReceivers.filter { $0 !== receiver }
    }
    
    private static var messageReceivers = [MIDIMessageReceiver]()
    
    public static func addMessageReceiver(_ receiver: MIDIMessageReceiver) {
        messageReceivers.append(receiver)
    }
    
    public static func removeMessageReceiver(_ receiver: MIDIMessageReceiver) {
        messageReceivers = messageReceivers.filter { $0 !== receiver }
    }
    
    private static func receive(_ event: MIDIEvent) {
        do {
            switch event {
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
        
        for receiver in eventReceivers {
            receiver.receive(event)
        }
    }
    
    private static func receive(_ message: MIDIMessage, from source: MIDIEndpoint<Source>) {
        for receiver in messageReceivers {
            receiver.receive(message, from: source)
        }
    }

}

extension MIDIDevice {
    
    public func receive(_ message: MIDIMessage) {
        for entity in entities {
            entity.receive(message)
        }
    }
    
    public func send(_ message: MIDIMessage, via output: MIDIPort<Output>? = MIDI.output) {
        for entity in entities {
            entity.send(message, via: output)
        }
    }
    
}

extension MIDIEntity {
    
    public func receive(_ message: MIDIMessage) {
        for source in sources {
            source.receive(message)
        }
    }
    
    public func send(_ message: MIDIMessage, via output: MIDIPort<Output>? = MIDI.output) {
        for destination in destinations {
            destination.send(message, via: output)
        }
    }
    
}

extension MIDIEndpoint where Type == Source {
    
    public func receive(_ message: MIDIMessage) {
        do {
            try received(message)
        } catch let error {
            print(error)
        }
    }

}

extension MIDIEndpoint where Type == Destination {
    
    public func send(_ message: MIDIMessage, via output: MIDIPort<Output>? = MIDI.output) {
        guard let output = output else {
            return
        }
        
        do {
            try output.send(message, to: self)
        } catch let error {
            print(error)
        }
    }
    
}
