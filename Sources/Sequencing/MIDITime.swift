//
//  MIDITime.swift
//  Gong
//
//  Created by Daniel Clelland on 25/06/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation


/*
 Do this first, but once Swift 4 protocols are available, extend to MIDIControl, MIDIPitchBend, MIDIRest
 */


// Int, [Int], [[Int]], MIDINote, [MIDINote], [[MIDINote]]

extension Array where Element == Int {
    
    public func sequential() -> [MIDINote] {
        return enumerated().map { (offset, key) in
            return MIDINote(key: key, delay: Double(offset))
        }
    }
    
    public func parallel() -> [MIDINote] {
        return map { key in
            return MIDINote(key: key)
        }
    }
    
}

extension Array where Element == [MIDINote] {
    
    public func sequential() -> [MIDINote] {
        return []
    }
    
    public func parallel() -> [MIDINote] {
        return flatMap { $0 }
    }
    
}


/*
 Inventory:
 
 - setTime
 - setDuration
 
 - sequential
 - parallel
 
 - tempo
 */

// Music.Time.Internal.Transform

/*
 -- * Specific transformations
 -- ** Transformations
 delaying,
 undelaying,
 stretching,
 compressing,
 
 -- ** Transforming values
 delay,
 undelay,
 stretch,
 compress,
 (|*),
 (*|),
 (|/),
 
 
 infixl 7 |*
 infixr 7 *|
 infixr 7 |/
 
 -- | Infix version of 'stretch'.
 x |* d = stretch d x
 -- | Infix version of 'stretch'.
 d *| x = stretch d x
 -- | Infix version of 'compress'.
 x |/ d = compress d x
 
 */

// Music.Time.Juxtapose

/*
 
 -- * Align without composition
 lead,
 follow,
 
 -- * Standard composition
 after,
 before,
 during,
 (|>),
 (<|),
 
 -- ** More exotic
 sustain,
 palindrome,
 
 -- * Catenation
 scat,
 pcat,
 
 -- * Repetition
 times,
 */



/*
 toAbsoluteTime,
 toRelativeTime,
 toRelativeTimeN,
 toRelativeTimeN', -- TODO Fairbairn threshold
 
 -- * Time spans
 Span,
 
 -- ** Constructing spans
 (<->),
 (>->),
 (<-<),
 
 delta,
 range,
 codelta,
 onsetAndOffset,
 onsetAndDuration,
 durationAndOffset,
 
 stretchComponent,
 delayComponent,
 fixedDurationSpan,
 fixedOnsetSpan,
 
 -- ** Transformations
 normalizeSpan,
 reverseSpan,
 reflectSpan,
 
 -- ** Properties
 isEmptySpan,
 isForwardSpan,
 isBackwardSpan,
 
 -- delayComponent,
 -- stretchComponent,
 
 -- ** Points in spans
 inside,
 strictlyInside,
 closestPointInside,
 
 -- ** Partial orders
 encloses,
 properlyEncloses,
 overlaps,
 
 -- *** etc.
 isBefore,
 afterOnset,
 strictlyAfterOnset,
 beforeOnset,
 strictlyBeforeOnset,
 afterOffset,
 strictlyAfterOffset,
 beforeOffset,
 strictlyBeforeOffset,
 
 startsWhenStarts,
 startsWhenStops,
 stopsWhenStops,
 stopsWhenStarts,
 
 startsBefore,
 startsLater,
 stopsAtTheSameTime,
 stopsBefore,
 stopsLater,
 
 -- union
 -- intersection (alt name 'overlap')
 -- difference (would actually become a split)
 
 -- ** Read/Show
 showRange,
 showDelta,
 showCodelta,
 */


// MARK: - Duration constants

public let whole = 1.0
public let half = 0.5
public let quarter = 0.25
public let eighth = 0.125
public let sixteenth = 0.0625
public let thirtySecond = 0.03125
public let sixtyFourth = 0.015625
