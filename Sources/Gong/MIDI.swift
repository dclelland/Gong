//
//  MIDI.swift
//  Gong
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIObserver {
    
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
    
    public static func addObserver<Observer>(_ observer: Observer) where Observer: MIDIObserver {
        NotificationCenter.default.addObserver(forName: .MIDIObserverReceiveNotice, object: nil, queue: nil) { notification in
            guard let notice = notification.userInfo?[Notification.MIDINoticeKey] as? MIDINotice else {
                return
            }
            
            observer.receive(notice)
        }
        NotificationCenter.default.addObserver(forName: .MIDIObserverReceivePacket, object: nil, queue: nil) { notification in
            guard let packet = notification.userInfo?[Notification.MIDIPacketKey] as? MIDIPacket else {
                return
            }
            
            guard let source = notification.userInfo?[Notification.MIDISourceKey] as? MIDISource else {
                return
            }
            
            observer.receive(packet, from: source)
        }
    }
    
    public static func removeObserver<Observer>(_ observer: Observer) where Observer: MIDIObserver {
        NotificationCenter.default.removeObserver(observer, name: .MIDIObserverReceiveNotice, object: nil)
        NotificationCenter.default.removeObserver(observer, name: .MIDIObserverReceivePacket, object: nil)
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
        
        NotificationCenter.default.post(name: .MIDIObserverReceiveNotice, object: nil, userInfo: [Notification.MIDINoticeKey: notice])
    }
    
    private static func receive(_ packet: MIDIPacket, from source: MIDISource) {
        NotificationCenter.default.post(name: .MIDIObserverReceivePacket, object: nil, userInfo: [Notification.MIDIPacketKey: packet, Notification.MIDISourceKey: source])
    }

}

extension Notification {
    
    internal static let MIDINoticeKey = "MIDINotice"
    
    internal static let MIDIPacketKey = "MIDIPacket"
    
    internal static let MIDISourceKey = "MIDISource"
    
}

extension Notification.Name {
    
    internal static let MIDIObserverReceiveNotice = Notification.Name("MIDIObserverReceiveNotice")
    
    internal static let MIDIObserverReceivePacket = Notification.Name("MIDIObserverReceivePacket")
    
}
