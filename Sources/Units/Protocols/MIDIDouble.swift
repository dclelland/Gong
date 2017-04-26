//
//  MIDIDouble.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public protocol MIDIDouble: FloatingPoint, ExpressibleByFloatLiteral, Hashable {
    
    typealias Value = Double
    
    var value: Value { get }
    
    init(_ value: Value)
    
}

extension MIDIDouble {
    
    public init(sign: FloatingPointSign, exponent: Value.Exponent, significand: Self) {
        self.init(Value(sign: sign, exponent: exponent, significand: significand.value))
    }
    
    public init(signOf: Self, magnitudeOf: Self) {
        self.init(Value(signOf: signOf.value, magnitudeOf: magnitudeOf.value))
    }
    
    public init(_ value: UInt8) {
        self.init(Value(value))
    }
    
    public init(_ value: Int8) {
        self.init(Value(value))
    }
    
    public init(_ value: UInt16) {
        self.init(Value(value))
    }
    
    public init(_ value: Int16) {
        self.init(Value(value))
    }
    
    public init(_ value: UInt32) {
        self.init(Value(value))
    }
    
    public init(_ value: Int32) {
        self.init(Value(value))
    }
    
    public init(_ value: UInt64) {
        self.init(Value(value))
    }
    
    public init(_ value: Int64) {
        self.init(Value(value))
    }
    
    public init(_ value: UInt) {
        self.init(Value(value))
    }
    
    public init(_ value: Int) {
        self.init(Value(value))
    }
    
    public static var radix: Int {
        return Value.radix
    }
    
    public static var nan: Self {
        return Self(Value.nan)
    }
    
    public static var signalingNaN: Self {
        return Self(Value.signalingNaN)
    }
    
    public static var infinity: Self {
        return Self(Value.infinity)
    }
    
    public static var greatestFiniteMagnitude: Self {
        return Self(Value.greatestFiniteMagnitude)
    }
    
    public static var pi: Self {
        return Self(Value.pi)
    }
    
    public var ulp: Self {
        return Self(value.ulp)
    }
    
    public static var leastNormalMagnitude: Self {
        return Self(Value.leastNormalMagnitude)
    }
    
    public static var leastNonzeroMagnitude: Self {
        return Self(Value.leastNonzeroMagnitude)
    }
    
    public var sign: FloatingPointSign {
        return value.sign
    }
    
    public var exponent: Value.Exponent {
        return value.exponent
    }
    
    public var significand: Self {
        return Self(value.significand)
    }
    
    public mutating func add(_ other: Self) {
        self = Self(value.adding(other.value))
    }
    
    public mutating func negate() {
        self = Self(value.negated())
    }
    
    public mutating func subtract(_ other: Self) {
        self = Self(value.subtracting(other.value))
    }
    
    public mutating func multiply(by other: Self) {
        self = Self(value.multiplied(by: other.value))
    }
    
    public mutating func divide(by other: Self) {
        self = Self(value.divided(by: other.value))
    }
    
    public mutating func formRemainder(dividingBy other: Self) {
        self = Self(value.remainder(dividingBy: other.value))
    }
    
    public mutating func formTruncatingRemainder(dividingBy other: Self) {
        self = Self(value.truncatingRemainder(dividingBy: other.value))
    }
    
    public mutating func formSquareRoot() {
        self = Self(value.squareRoot())
    }
    
    public mutating func addProduct(_ lhs: Self, _ rhs: Self) {
        self = Self(value.addingProduct(lhs.value, rhs.value))
    }
    
    public mutating func round(_ rule: FloatingPointRoundingRule) {
        self = Self(value.rounded(rule))
    }
    
    public var nextUp: Self {
        return Self(value.nextUp)
    }
    
    public func isEqual(to other: Self) -> Bool {
        return value.isEqual(to: other.value)
    }
    
    public func isLess(than other: Self) -> Bool {
        return value.isLess(than: other.value)
    }
    
    public func isLessThanOrEqualTo(_ other: Self) -> Bool {
        return value.isLessThanOrEqualTo(other.value)
    }
    
    public func isTotallyOrdered(belowOrEqualTo other: Self) -> Bool {
        return value.isTotallyOrdered(belowOrEqualTo: other.value)
    }
    
    public var isNormal: Bool {
        return value.isNormal
    }
    
    public var isFinite: Bool {
        return value.isFinite
    }
    
    public var isZero: Bool {
        return value.isZero
    }
    
    public var isSubnormal: Bool {
        return value.isSubnormal
    }
    
    public var isInfinite: Bool {
        return value.isInfinite
    }
    
    public var isNaN: Bool {
        return value.isNaN
    }
    
    public var isSignalingNaN: Bool {
        return value.isSignalingNaN
    }
    
    public var isCanonical: Bool {
        return value.isCanonical
    }
    
}

extension MIDIDouble {

    public func distance(to other: Self) -> Value.Stride {
        return value.distance(to: other.value)
    }

    public func advanced(by n: Value.Stride) -> Self {
        return Self(value.advanced(by: n))
    }

}

extension MIDIDouble {
    
    public static func abs(_ x: Self) -> Self {
        return Self(Swift.abs(x.value))
    }
    
}

extension MIDIDouble {
    
    public init(integerLiteral value: Int) {
        self.init(Value(value))
    }
    
}

extension MIDIDouble {
    
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(Value(floatLiteral: value))
    }
    
}

extension MIDIDouble {
    
    public var hashValue: Int {
        return value.hashValue
    }
    
}
