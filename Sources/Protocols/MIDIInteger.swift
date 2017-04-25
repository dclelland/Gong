//
//  MIDIInteger.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public protocol MIDIInteger: SignedInteger, Comparable, Equatable {
    
    var value: Int { get }
    
    init(_ value: Int)
    
}

extension MIDIInteger {
    
    public init(_ value: IntMax) {
        self.init(Int(value))
    }
    
    public init(_builtinIntegerLiteral value: _MaxBuiltinIntegerType) {
        self.init(Int(_builtinIntegerLiteral: value))
    }
    
}

extension MIDIInteger {
    
    public static func addWithOverflow(_ lhs: Self, _ rhs: Self) -> (Self, overflow: Bool) {
        let (value, overflow) = Int.addWithOverflow(lhs.value, rhs.value)
        return (Self(value), overflow)
    }
    
    public static func subtractWithOverflow(_ lhs: Self, _ rhs: Self) -> (Self, overflow: Bool) {
        let (value, overflow) = Int.subtractWithOverflow(lhs.value, rhs.value)
        return (Self(value), overflow)
    }
    
    public static func multiplyWithOverflow(_ lhs: Self, _ rhs: Self) -> (Self, overflow: Bool) {
        let (value, overflow) = Int.multiplyWithOverflow(lhs.value, rhs.value)
        return (Self(value), overflow)
    }
    
    public static func divideWithOverflow(_ lhs: Self, _ rhs: Self) -> (Self, overflow: Bool) {
        let (value, overflow) = Int.divideWithOverflow(lhs.value, rhs.value)
        return (Self(value), overflow)
    }
    
    public static func remainderWithOverflow(_ lhs: Self, _ rhs: Self) -> (Self, overflow: Bool) {
        let (value, overflow) = Int.remainderWithOverflow(lhs.value, rhs.value)
        return (Self(value), overflow)
    }
    
    public func toIntMax() -> IntMax {
        return value.toIntMax()
    }
    
}

extension MIDIInteger {
    
    public static func & (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value & rhs.value)
    }
    
    public static func | (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value | rhs.value)
    }
    
    public static func ^ (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value ^ rhs.value)
    }
    
    prefix public static func ~ (x: Self) -> Self {
        return Self(~x.value)
    }
    
    public static var allZeros: Self {
        return Self(Int.allZeros)
    }
    
}

extension MIDIInteger {
    
    public var hashValue: Int {
        return value
    }
    
}

extension MIDIInteger {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
    
}

extension MIDIInteger {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
    
}

extension MIDIInteger {
    
    public var description: String {
        return value.description
    }
    
}

extension MIDIInteger {
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
}
