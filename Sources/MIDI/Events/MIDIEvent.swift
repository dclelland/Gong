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
    
    func send(_ event: MIDIEvent, via output: MIDIOutput)
    
}

extension MIDIEventSender {
    
    public func send(_ events: [MIDIEvent], via output: MIDIOutput) {
        for event in events {
            send(event, via: output)
        }
    }
    
}

public protocol MIDIEventReceiver {
    
    func receive(_ event: MIDIEvent)
    
}

extension MIDIEventReceiver {
    
    public func receive(_ events: [MIDIEvent]) {
        for event in events {
            receive(event)
        }
    }
    
}

extension MIDIDevice: MIDIEventSender {
    
    public func send(_ event: MIDIEvent, via output: MIDIOutput) {
        for entity in entities {
            entity.send(event, via: output)
        }
    }
    
}

extension MIDIDevice: MIDIEventReceiver {
    
    public func receive(_ event: MIDIEvent) {
        for entity in entities {
            entity.receive(event)
        }
    }
    
}

extension MIDIEntity: MIDIEventSender {
    
    public func send(_ event: MIDIEvent, via output: MIDIOutput) {
        for destination in destinations {
            destination.send(event, via: output)
        }
    }
    
}

extension MIDIEntity: MIDIEventReceiver {
    
    public func receive(_ event: MIDIEvent) {
        for source in sources {
            source.receive(event)
        }
    }
    
}

extension MIDIDestination: MIDIEventSender {
    
    public func send(_ event: MIDIEvent, via output: MIDIOutput) {
        for packet in event.packets {
            do {
                try output.send(packet, to: self)
            } catch let error {
                print(error)
            }
        }
    }
    
}

extension MIDISource: MIDIEventReceiver {
    
    public func receive(_ event: MIDIEvent) {
        for packet in event.packets {
            do {
                try received(packet)
            } catch let error {
                print(error)
            }
        }
    }
    
}
