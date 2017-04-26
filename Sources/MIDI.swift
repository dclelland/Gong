//
//  MIDI.swift
//  Gong
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIObserver: class {
    
    func receive(_ notification: MIDINotification)
    
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
    
    private static var observers = [MIDIObserver]()
    
    public static func addObserver(_ observer: MIDIObserver) {
        observers.append(observer)
    }
    
    public static func removeObserver(_ observer: MIDIObserver) {
        observers = observers.filter { $0 !== observer }
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
        
        for observer in observers {
            observer.receive(notification)
        }
    }
    
    private static func receive(_ packet: MIDIPacket, from source: MIDISource) {
        for observer in observers {
            observer.receive(packet, from: source)
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
