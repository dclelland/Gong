//
//  MIDI.swift
//  Gong
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIReceiver: MIDINotificationReceiver, MIDIPacketReceiver { }

public protocol MIDINotificationReceiver: class {
    
    func receive(_ notification: MIDINotification)
    
}

public protocol MIDIPacketReceiver: class {
    
    func receive(_ packet: MIDIPacket, from source: MIDISource)
    
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
    
    public static var input: MIDIInput? = {
        do {
            return try client?.createInput(name: "Default input") { (packet, source) in
                receive(packet, from: source)
            }
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static var output: MIDIOutput? = {
        do {
            return try client?.createOutput(name: "Default output")
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static func connect() {
        for source in MIDISource.all {
            do {
                try input?.connect(source)
            } catch let error {
                print(error)
            }
        }
    }
    
    public static func disconnect() {
        for source in MIDISource.all {
            do {
                try input?.disconnect(source)
            } catch let error {
                print(error)
            }
        }
    }
    
    public static func addReceiver(_ receiver: MIDIReceiver) {
        addNotificationReceiver(receiver)
        addPacketReceiver(receiver)
    }
    
    public static func removeReceiver(_ receiver: MIDIReceiver) {
        removeNotificationReceiver(receiver)
        removePacketReceiver(receiver)
    }
    
    private static var notificationReceivers = [MIDINotificationReceiver]()
    
    public static func addNotificationReceiver(_ receiver: MIDINotificationReceiver) {
        notificationReceivers.append(receiver)
    }
    
    public static func removeNotificationReceiver(_ receiver: MIDINotificationReceiver) {
        notificationReceivers = notificationReceivers.filter { $0 !== receiver }
    }
    
    private static var packetReceivers = [MIDIPacketReceiver]()
    
    public static func addPacketReceiver(_ receiver: MIDIPacketReceiver) {
        packetReceivers.append(receiver)
    }
    
    public static func removePacketReceiver(_ receiver: MIDIPacketReceiver) {
        packetReceivers = packetReceivers.filter { $0 !== receiver }
    }
    
    private static func receive(_ notification: MIDINotification) {
        do {
            switch notification {
            case .objectAdded(_, let source as MIDISource):
                try input?.connect(source)
            case .objectRemoved(_, let source as MIDISource):
                try input?.disconnect(source)
            default:
                break
            }
        } catch let error {
            print(error)
        }
        
        for receiver in notificationReceivers {
            receiver.receive(notification)
        }
    }
    
    private static func receive(_ packet: MIDIPacket, from source: MIDISource) {
        for receiver in packetReceivers {
            receiver.receive(packet, from: source)
        }
    }

}

extension MIDIDevice {
    
    public func receive(_ packet: MIDIPacket) {
        for entity in entities {
            entity.receive(packet)
        }
    }
    
    public func send(_ packet: MIDIPacket, via output: MIDIOutput? = MIDI.output) {
        for entity in entities {
            entity.send(packet, via: output)
        }
    }
    
}

extension MIDIEntity {
    
    public func receive(_ packet: MIDIPacket) {
        for source in sources {
            source.receive(packet)
        }
    }
    
    public func send(_ packet: MIDIPacket, via output: MIDIOutput? = MIDI.output) {
        for destination in destinations {
            destination.send(packet, via: output)
        }
    }
    
}

extension MIDISource {
    
    public func receive(_ packet: MIDIPacket) {
        do {
            try received(packet)
        } catch let error {
            print(error)
        }
    }

}

extension MIDIDestination {
    
    public func send(_ packet: MIDIPacket, via output: MIDIOutput? = MIDI.output) {
        guard let output = output else {
            return
        }
        
        do {
            try output.send(packet, to: self)
        } catch let error {
            print(error)
        }
    }
    
}
