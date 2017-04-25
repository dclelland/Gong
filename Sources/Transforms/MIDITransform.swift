//
//  MIDITransform.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public typealias Map<Value> = (Value) -> Value

public typealias Filter<Value> = (Value) -> Bool

public typealias Reduce<Value, Result> = (Result, Value) -> Result

public func transpose(_ interval: MIDIInterval) -> Map<MIDIKey> {
    return { key in
        key + interval
    }
}

public func stretch(_ ratio: Double) -> Map<MIDIDurationEvent> {
    return { event in
        var event = event
        event.time *= MIDITime(ratio)
        event.duration *= MIDIDuration(ratio)
        return event
    }
}

extension MIDISequence {
    
    public func test() {
        
        
    }

//    public func transposed(_ interval: MIDIInterval) -> MIDISequence {
//        return apply(transpose(1))
//    }
//    
////    public func looped(_ times: Int) -> MIDISequence {
////        
////    }
//
//    public func apply<Input: Element>(_ transform: MIDITransform<Input, Element>) -> MIDISequence {
//        let events = map { element -> Element in
//            guard let input = element as? Input else {
//                return element
//            }
//            
//            return transform(input)
//        }
//        return MIDISequence(events)
//    }
    
}
