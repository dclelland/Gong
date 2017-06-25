//
//  MIDIChannel.swift
//  Gong
//
//  Created by Daniel Clelland on 25/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: Channel setters

extension Array where Element == MIDINote {
    
    public func setChannel(_ channel: Int) -> [MIDINote] {
        return mapChannel { _ in
            return channel
        }
    }
    
    public func mapChannel(_ transform: (Int) -> Int) -> [MIDINote] {
        return map { note in
            var note = note
            note.channel = transform(note.channel)
            return note
        }
    }
    
}

// MARK: - Channel constants

public let defaultChannel = 0
