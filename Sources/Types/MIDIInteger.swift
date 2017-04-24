//
//  MIDIInteger.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public protocol MIDIIntegerUnit { }

public struct MIDIInteger<UnitType: MIDIIntegerUnit> {
    
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
}

extension MIDIInteger: SignedInteger {
    
    public init(_ value: IntMax) {
        self.init(Int(value))
    }
    
    public init(_builtinIntegerLiteral value: _MaxBuiltinIntegerType) {
        self.init(Int(_builtinIntegerLiteral: value))
    }
    
}

extension MIDIInteger: IntegerArithmetic {
    
    public static func addWithOverflow<UnitType>(_ lhs: MIDIInteger<UnitType>, _ rhs: MIDIInteger<UnitType>) -> (MIDIInteger<UnitType>, overflow: Bool) {
        let (value, overflow) = Int.addWithOverflow(lhs.value, rhs.value)
        return (MIDIInteger<UnitType>(value), overflow)
    }
    
    public static func subtractWithOverflow<UnitType>(_ lhs: MIDIInteger<UnitType>, _ rhs: MIDIInteger<UnitType>) -> (MIDIInteger<UnitType>, overflow: Bool) {
        let (value, overflow) = Int.subtractWithOverflow(lhs.value, rhs.value)
        return (MIDIInteger<UnitType>(value), overflow)
    }
    
    public static func multiplyWithOverflow<UnitType>(_ lhs: MIDIInteger<UnitType>, _ rhs: MIDIInteger<UnitType>) -> (MIDIInteger<UnitType>, overflow: Bool) {
        let (value, overflow) = Int.multiplyWithOverflow(lhs.value, rhs.value)
        return (MIDIInteger<UnitType>(value), overflow)
    }
    
    public static func divideWithOverflow<UnitType>(_ lhs: MIDIInteger<UnitType>, _ rhs: MIDIInteger<UnitType>) -> (MIDIInteger<UnitType>, overflow: Bool) {
        let (value, overflow) = Int.divideWithOverflow(lhs.value, rhs.value)
        return (MIDIInteger<UnitType>(value), overflow)
    }
    
    public static func remainderWithOverflow<UnitType>(_ lhs: MIDIInteger<UnitType>, _ rhs: MIDIInteger<UnitType>) -> (MIDIInteger<UnitType>, overflow: Bool) {
        let (value, overflow) = Int.remainderWithOverflow(lhs.value, rhs.value)
        return (MIDIInteger<UnitType>(value), overflow)
    }
    
    public func toIntMax() -> IntMax {
        return value.toIntMax()
    }
    
}

extension MIDIInteger: BitwiseOperations {
    
    public static func & <UnitType>(lhs: MIDIInteger<UnitType>, rhs: MIDIInteger<UnitType>) -> MIDIInteger<UnitType> {
        return MIDIInteger<UnitType>(lhs.value & rhs.value)
    }
    
    public static func | <UnitType>(lhs: MIDIInteger<UnitType>, rhs: MIDIInteger<UnitType>) -> MIDIInteger<UnitType> {
        return MIDIInteger<UnitType>(lhs.value | rhs.value)
    }
    
    public static func ^ <UnitType>(lhs: MIDIInteger<UnitType>, rhs: MIDIInteger<UnitType>) -> MIDIInteger<UnitType> {
        return MIDIInteger<UnitType>(lhs.value ^ rhs.value)
    }
    
    prefix public static func ~ <UnitType>(x: MIDIInteger<UnitType>) -> MIDIInteger<UnitType> {
        return MIDIInteger<UnitType>(~x.value)
    }
    
    public static var allZeros: MIDIInteger<UnitType> {
        return MIDIInteger<UnitType>(Int.allZeros)
    }
    
}

extension MIDIInteger: Hashable {
    
    public var hashValue: Int {
        return value
    }
    
}

extension MIDIInteger: Equatable {
    
    public static func == <UnitType>(lhs: MIDIInteger<UnitType>, rhs: MIDIInteger<UnitType>) -> Bool {
        return lhs.value == rhs.value
    }
    
}

extension MIDIInteger: Comparable {
    
    public static func < <UnitType>(lhs: MIDIInteger<UnitType>, rhs: MIDIInteger<UnitType>) -> Bool {
        return lhs.value < rhs.value
    }
    
}

extension MIDIInteger: CustomStringConvertible {
    
    public var description: String {
        return value.description
    }
    
}

extension MIDIInteger: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
}
