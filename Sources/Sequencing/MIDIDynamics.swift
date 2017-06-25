//
//  MIDIDynamics.swift
//  Gong
//
//  Created by Daniel Clelland on 25/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

/*
 Inventory:
 
 - setVelocity (takes numeric arg)
 - setVelocity (takes function)
 - louder
 - softer
 - compress
 - ramp(startTime:startVelocity:endTime:endVelocity:)
 - fadeIn(start:end:)
 - fadeOut(start:end:)
 
 */

// MARK: - Velocity constants

public let ppp = 16
public let pp = 33
public let p = 49
public let mp = 64
public let mf = 80
public let f = 96
public let ff = 112
public let fff = 127
