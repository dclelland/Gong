//
//  MIDIArray.swift
//  Gong
//
//  Created by Daniel Clelland on 25/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public protocol MIDIArray: MutableCollection, RangeReplaceableCollection, ExpressibleByArrayLiteral {
    
    associatedtype Element
    
    var elements: [Element] { get }
    
    init(_ elements: [Element])
    
}

extension MIDIArray {
    
    public var startIndex: Int {
        return elements.startIndex
    }
    
    public var endIndex: Int {
        return elements.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }
    
    public subscript(position: Int) -> Element {
        set {
            var elements = self.elements
            elements[position] = newValue
            self = Self(elements)
        }
        get {
            return elements[position]
        }
    }
    
}

extension MIDIArray {
    
    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Iterator.Element == Element {
        var elements = self.elements
        elements.replaceSubrange(subrange, with: newElements)
        self = Self(elements)
    }
    
}

extension MIDIArray {
    
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
}
