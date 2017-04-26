//
//  MIDIChannelEvent.swift
//  Gong
//
//  Created by Daniel Clelland on 26/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public protocol MIDIChannelEvent: MIDIEvent {
    
    var channel: MIDIChannel { set get }
    
}
