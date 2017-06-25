//
//  MIDITime.swift
//  Gong
//
//  Created by Daniel Clelland on 25/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

// MARK: - Time setters

extension Array where Element == MIDINote {
    
    public func setStart(_ start: Double) -> [MIDINote] {
        return mapStart { _ in
            return start
        }
    }
    
    public func mapStart(_ transform: (Double) -> Double) -> [MIDINote] {
        return map { note in
            var note = note
            note.start = transform(note.start)
            return note
        }
    }
    
    public func setDuration(_ duration: Double) -> [MIDINote] {
        return mapDuration { _ in
            return duration
        }
    }
    
    public func mapDuration(_ transform: (Double) -> Double) -> [MIDINote] {
        return map { note in
            var note = note
            note.duration = transform(note.duration)
            return note
        }
    }
    
    public func setSpan(_ span: (Double, Double)) -> [MIDINote] {
        return mapSpan { _ in
            return span
        }
    }
    
    public func mapSpan(_ transform: (Double, Double) -> (Double, Double)) -> [MIDINote] {
        return map { note in
            var note = note
            (note.start, note.duration) = transform(note.start, note.duration)
            return note
        }
    }
    
}

// MARK: - Time transformations

extension Array where Element == MIDINote {
    
    public func shift(earlier time: Double) -> [MIDINote] {
        return mapStart { start in
            return start + time
        }
    }
    
    public func shift(later time: Double) -> [MIDINote] {
        return mapStart { start in
            return start - time
        }
    }
    
    public func stretch(slower ratio: Double) -> [MIDINote] {
        return mapSpan { (start, duration) in
            return (start * ratio, duration * ratio)
        }
    }
    
    public func stretch(faster ratio: Double) -> [MIDINote] {
        return mapSpan { (start, duration) in
            return (start / ratio, duration / ratio)
        }
    }
    
}

// MARK: - Time tempo

extension Array where Element == MIDINote {
    
    public func tempo(_ bpm: Double) -> [MIDINote] {
        return stretch(faster: bpm / 60.0)
    }
    
}

// MARK: - Time constants

public let wholeNote = 1.0
public let halfNote = 0.5
public let quarterNote = 0.25
public let eighthNote = 0.125
public let sixteenthNote = 0.0625
public let thirtySecondNote = 0.03125
public let sixtyFourthNote = 0.015625
