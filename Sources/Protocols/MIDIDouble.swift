//
//  MIDIDouble.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public protocol MIDIDouble: FloatingPoint, ExpressibleByFloatLiteral {
    
    var value: Double { get }
    
    init(_ value: Double)
    
}

extension MIDIDouble {
    
    public init(sign: FloatingPointSign, exponent: Int, significand: Self) {
        self.init(Double(sign: sign, exponent: exponent, significand: significand.value))
    }
    
    public init(signOf: Self, magnitudeOf: Self) {
        self.init(Double(signOf: signOf.value, magnitudeOf: magnitudeOf.value))
    }
    
    public init(_ value: UInt8) {
        self.init(Double(value))
    }
    
    public init(_ value: Int8) {
        self.init(Double(value))
    }
    
    public init(_ value: UInt16) {
        self.init(Double(value))
    }
    
    public init(_ value: Int16) {
        self.init(Double(value))
    }
    
    public init(_ value: UInt32) {
        self.init(Double(value))
    }
    
    public init(_ value: Int32) {
        self.init(Double(value))
    }
    
    public init(_ value: UInt64) {
        self.init(Double(value))
    }
    
    public init(_ value: Int64) {
        self.init(Double(value))
    }
    
    public init(_ value: UInt) {
        self.init(Double(value))
    }
    
    public init(_ value: Int) {
        self.init(Double(value))
    }
    
    public static var radix: Int {
        return Double.radix
    }
    
    public static var nan: Self {
        return Self(Double.nan)
    }
    
    public static var signalingNaN: Self {
        return Self(Double.signalingNaN)
    }
    
    public static var infinity: Self {
        return Self(Double.infinity)
    }
    
    public static var greatestFiniteMagnitude: Self {
        return Self(Double.greatestFiniteMagnitude)
    }
    
    public static var pi: Self {
        return Self(Double.pi)
    }
    
    public var ulp: Self {
        return Self(value.ulp)
    }
    
    public static var leastNormalMagnitude: Self {
        return Self(Double.leastNormalMagnitude)
    }
    
    public static var leastNonzeroMagnitude: Self {
        return Self(Double.leastNonzeroMagnitude)
    }
    
    public var sign: FloatingPointSign {
        return value.sign
    }
    
    public var exponent: Int {
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

    public func distance(to other: Self) -> Double {
        return value.distance(to: other.value)
    }

    public func advanced(by n: Double) -> Self {
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
        self.init(Double(value))
    }
    
}

extension MIDIDouble {
    
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
}
