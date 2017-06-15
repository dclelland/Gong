//
//  Pointer.swift
//  Gong
//
//  Created by Daniel Clelland on 15/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

extension UnsafeMutableRawPointer {
    
    internal init<T>(pointee: T) {
        let capacity = MemoryLayout<T>.stride
        let alignment = MemoryLayout<T>.alignment
        
        self = UnsafeMutableRawPointer.allocate(bytes: capacity, alignedTo: alignment)
        self.initializeMemory(as: T.self, to: pointee)
    }
    
    internal func pointee<T>() -> T {
        return assumingMemoryBound(to: T.self).pointee
    }
    
}
