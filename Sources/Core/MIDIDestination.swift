//
//  MIDIDestination.swift
//  Gong
//
//  Created by Daniel Clelland on 26/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public class MIDIDestination: MIDIEndpoint {
    
    public convenience init?(named name: String) {
        guard let destination = MIDIDestination.all.first(where: { $0.name == name }) else {
            return nil
        }
        
        self.init(destination.reference)
    }
    
    public static var all: [MIDIDestination] {
        let count = MIDIGetNumberOfDestinations()
        return (0..<count).lazy.map { index in
            return MIDIDestination(MIDIGetDestination(index))
        }
    }
    
}

extension MIDIDestination {
    
    public func flushOutput() throws {
        try MIDIFlushOutput(reference).midiError("Flushing MIDIDestination output")
    }
    
}

extension MIDIDestination {
    
    public typealias SystemExclusiveEventCompletion = (Void) -> Void
    
    // Disclaimer: I'm fairly certain this doesn't work
    public func send(systemExclusiveEvent bytes: [UInt8], completion: @escaping SystemExclusiveEventCompletion = {}) throws {
        let completionReference = UnsafeMutablePointer.allocate(initializingTo: completion)
        let completionProcedure: MIDICompletionProc = { requestPointer in
            guard let completion = requestPointer.pointee.completionRefCon?.assumingMemoryBound(to: SystemExclusiveEventCompletion.self).pointee else {
                return
            }
            
            completion()
        }
        
        var request = Data(bytes: bytes).withUnsafeBytes { pointer in
            return MIDISysexSendRequest(
                destination: reference,
                data: pointer,
                bytesToSend: UInt32(bytes.count),
                complete: false,
                reserved: (0, 0, 0),
                completionProc: completionProcedure,
                completionRefCon: completionReference
            )
        }
        
        try MIDISendSysex(&request).midiError("Sending system exclusive event")
    }
    
}
