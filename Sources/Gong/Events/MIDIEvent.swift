//
//  MIDIEvent.swift
//  Gong
//
//  Created by Daniel Clelland on 29/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIEvent {
    
    var packets: [MIDIPacket] { get }
    
}

public protocol MIDIEventSender {
    
    func send(_ packet: MIDIPacket, via output: MIDIOutput)
    
}

extension MIDIEventSender {
    
    public func send(_ packets: [MIDIPacket], via output: MIDIOutput) {
        for packet in packets {
            send(packet, via: output)
        }
    }
    
    public func send(_ event: MIDIEvent, via output: MIDIOutput) {
        send(event.packets, via: output)
    }
    
    public func send(_ events: [MIDIEvent], via output: MIDIOutput) {
        for event in events {
            send(event, via: output)
        }
    }
    
}

public protocol MIDIEventReceiver {
    
    func receive(_ packet: MIDIPacket)
    
}

extension MIDIEventReceiver {
    
    public func receive(_ packets: [MIDIPacket]) {
        for packet in packets {
            receive(packet)
        }
    }
    
    public func receive(_ event: MIDIEvent) {
        receive(event.packets)
    }
    
    public func receive(_ events: [MIDIEvent]) {
        for event in events {
            receive(event)
        }
    }
    
}

extension MIDIDevice: MIDIEventSender {
    
    public func send(_ packet: MIDIPacket, via output: MIDIOutput) {
        for entity in entities {
            entity.send(packet, via: output)
        }
    }
    
}

extension MIDIDevice: MIDIEventReceiver {
    
    public func receive(_ packet: MIDIPacket) {
        for entity in entities {
            entity.receive(packet)
        }
    }
    
}

extension MIDIEntity: MIDIEventSender {
    
    public func send(_ packet: MIDIPacket, via output: MIDIOutput) {
        for destination in destinations {
            destination.send(packet, via: output)
        }
    }
    
}

extension MIDIEntity: MIDIEventReceiver {
    
    public func receive(_ packet: MIDIPacket) {
        for source in sources {
            source.receive(packet)
        }
    }
    
}

extension MIDIDestination: MIDIEventSender {
    
    public func send(_ packet: MIDIPacket, via output: MIDIOutput) {
        do {
            try output.send(packet, to: self)
        } catch let error {
            print(error)
        }
    }
    
}

extension MIDISource: MIDIEventReceiver {
    
    public func receive(_ packet: MIDIPacket) {
        do {
            try received(packet)
        } catch let error {
            print(error)
        }
    }
    
}
