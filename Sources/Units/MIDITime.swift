//
//  MIDITime.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public typealias MIDITime = MIDIDouble<MIDITimeUnit>

public enum MIDITimeUnit: MIDIDoubleUnit { }

extension MIDIDouble where UnitType == MIDITimeUnit {

//    public static var now: MIDITime { return 0.0 }

}
