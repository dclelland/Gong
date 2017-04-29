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
    
    func receive(_ notice: MIDINotice)
    
    func receive(_ packet: MIDIPacket, from source: MIDISource)
    
}

public struct MIDI {
    
    public static var client: MIDIClient? = {
        do {
            return try MIDIClient(name: "Default client") { notice in
                receive(notice)
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
    
    private static func receive(_ notice: MIDINotice) {
        do {
            switch notice {
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
            observer.receive(notice)
        }
    }
    
    private static func receive(_ packet: MIDIPacket, from source: MIDISource) {
        for observer in observers {
            observer.receive(packet, from: source)
        }
    }

}
