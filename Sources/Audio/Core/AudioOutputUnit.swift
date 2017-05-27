//
//  AudioOutputUnit.swift
//  Gong
//
//  Created by Daniel Clelland on 27/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioOutputUnit: AudioUnit {
    
    public func start() throws {
        try AudioOutputUnitStart(reference).audioError("Starting AudioOutputUnit")
    }
    
    public func stop() throws {
        try AudioOutputUnitStop(reference).audioError("Stopping AudioOutputUnit")
    }
    
}
