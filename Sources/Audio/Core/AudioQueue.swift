//
//  AudioQueue.swift
//  Gong
//
//  Created by Daniel Clelland on 8/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioQueue {
    
    public let reference: AudioQueueRef
    
    public init(_ reference: AudioQueueRef) {
        self.reference = reference
    }
    
    func test() {
    }

}
