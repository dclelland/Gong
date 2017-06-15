//
//  Pointer.swift
//  Gong
//
//  Created by Daniel Clelland on 15/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

extension UnsafeMutablePointer {
    
    internal static func allocate(initializingTo pointee: Pointee) -> UnsafeMutablePointer {
        let capacity = MemoryLayout.stride(ofValue: pointee)
        let pointer = UnsafeMutablePointer.allocate(capacity: capacity)
        pointer.initialize(to: pointee)
        return pointer
    }
    
}
