//
//  MIDIKey.swift
//  Gong
//
//  Created by Daniel Clelland on 22/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public struct MIDIKey {
    
    public var number: Int
    
    public init(_ number: Int) {
        self.number = number
    }
    
    public static let c0: MIDIKey = 0
    public static let cSharp0: MIDIKey = 1
    public static let dFlat0: MIDIKey = 1
    public static let d0: MIDIKey = 2
    public static let dSharp0: MIDIKey = 3
    public static let eFlat0: MIDIKey = 3
    public static let e0: MIDIKey = 4
    public static let eSharp0: MIDIKey = 5
    public static let fFlat0: MIDIKey = 4
    public static let f0: MIDIKey = 5
    public static let fSharp0: MIDIKey = 6
    public static let gFlat0: MIDIKey = 6
    public static let g0: MIDIKey = 7
    public static let gSharp0: MIDIKey = 8
    public static let aFlat0: MIDIKey = 8
    public static let a0: MIDIKey = 9
    public static let aSharp0: MIDIKey = 10
    public static let bFlat0: MIDIKey = 10
    public static let b0: MIDIKey = 11
    public static let bSharp0: MIDIKey = 12
    public static let cFlat1: MIDIKey = 11
    public static let c1: MIDIKey = 12
    public static let cSharp1: MIDIKey = 13
    public static let dFlat1: MIDIKey = 13
    public static let d1: MIDIKey = 14
    public static let dSharp1: MIDIKey = 15
    public static let eFlat1: MIDIKey = 15
    public static let e1: MIDIKey = 16
    public static let eSharp1: MIDIKey = 17
    public static let fFlat1: MIDIKey = 16
    public static let f1: MIDIKey = 17
    public static let fSharp1: MIDIKey = 18
    public static let gFlat1: MIDIKey = 18
    public static let g1: MIDIKey = 19
    public static let gSharp1: MIDIKey = 20
    public static let aFlat1: MIDIKey = 20
    public static let a1: MIDIKey = 21
    public static let aSharp1: MIDIKey = 22
    public static let bFlat1: MIDIKey = 22
    public static let b1: MIDIKey = 23
    public static let bSharp1: MIDIKey = 24
    public static let cFlat2: MIDIKey = 23
    public static let c2: MIDIKey = 24
    public static let cSharp2: MIDIKey = 25
    public static let dFlat2: MIDIKey = 25
    public static let d2: MIDIKey = 26
    public static let dSharp2: MIDIKey = 27
    public static let eFlat2: MIDIKey = 27
    public static let e2: MIDIKey = 28
    public static let eSharp2: MIDIKey = 29
    public static let fFlat2: MIDIKey = 28
    public static let f2: MIDIKey = 29
    public static let fSharp2: MIDIKey = 30
    public static let gFlat2: MIDIKey = 30
    public static let g2: MIDIKey = 31
    public static let gSharp2: MIDIKey = 32
    public static let aFlat2: MIDIKey = 32
    public static let a2: MIDIKey = 33
    public static let aSharp2: MIDIKey = 34
    public static let bFlat2: MIDIKey = 34
    public static let b2: MIDIKey = 35
    public static let bSharp2: MIDIKey = 36
    public static let cFlat3: MIDIKey = 35
    public static let c3: MIDIKey = 36
    public static let cSharp3: MIDIKey = 37
    public static let dFlat3: MIDIKey = 37
    public static let d3: MIDIKey = 38
    public static let dSharp3: MIDIKey = 39
    public static let eFlat3: MIDIKey = 39
    public static let e3: MIDIKey = 40
    public static let eSharp3: MIDIKey = 41
    public static let fFlat3: MIDIKey = 40
    public static let f3: MIDIKey = 41
    public static let fSharp3: MIDIKey = 42
    public static let gFlat3: MIDIKey = 42
    public static let g3: MIDIKey = 43
    public static let gSharp3: MIDIKey = 44
    public static let aFlat3: MIDIKey = 44
    public static let a3: MIDIKey = 45
    public static let aSharp3: MIDIKey = 46
    public static let bFlat3: MIDIKey = 46
    public static let b3: MIDIKey = 47
    public static let bSharp3: MIDIKey = 48
    public static let cFlat4: MIDIKey = 47
    public static let c4: MIDIKey = 48
    public static let cSharp4: MIDIKey = 49
    public static let dFlat4: MIDIKey = 49
    public static let d4: MIDIKey = 50
    public static let dSharp4: MIDIKey = 51
    public static let eFlat4: MIDIKey = 51
    public static let e4: MIDIKey = 52
    public static let eSharp4: MIDIKey = 53
    public static let fFlat4: MIDIKey = 52
    public static let f4: MIDIKey = 53
    public static let fSharp4: MIDIKey = 54
    public static let gFlat4: MIDIKey = 54
    public static let g4: MIDIKey = 55
    public static let gSharp4: MIDIKey = 56
    public static let aFlat4: MIDIKey = 56
    public static let a4: MIDIKey = 57
    public static let aSharp4: MIDIKey = 58
    public static let bFlat4: MIDIKey = 58
    public static let b4: MIDIKey = 59
    public static let bSharp4: MIDIKey = 60
    public static let cFlat5: MIDIKey = 59
    public static let c5: MIDIKey = 60
    public static let cSharp5: MIDIKey = 61
    public static let dFlat5: MIDIKey = 61
    public static let d5: MIDIKey = 62
    public static let dSharp5: MIDIKey = 63
    public static let eFlat5: MIDIKey = 63
    public static let e5: MIDIKey = 64
    public static let eSharp5: MIDIKey = 65
    public static let fFlat5: MIDIKey = 64
    public static let f5: MIDIKey = 65
    public static let fSharp5: MIDIKey = 66
    public static let gFlat5: MIDIKey = 66
    public static let g5: MIDIKey = 67
    public static let gSharp5: MIDIKey = 68
    public static let aFlat5: MIDIKey = 68
    public static let a5: MIDIKey = 69
    public static let aSharp5: MIDIKey = 70
    public static let bFlat5: MIDIKey = 70
    public static let b5: MIDIKey = 71
    public static let bSharp5: MIDIKey = 72
    public static let cFlat6: MIDIKey = 71
    public static let c6: MIDIKey = 72
    public static let cSharp6: MIDIKey = 73
    public static let dFlat6: MIDIKey = 73
    public static let d6: MIDIKey = 74
    public static let dSharp6: MIDIKey = 75
    public static let eFlat6: MIDIKey = 75
    public static let e6: MIDIKey = 76
    public static let eSharp6: MIDIKey = 77
    public static let fFlat6: MIDIKey = 76
    public static let f6: MIDIKey = 77
    public static let fSharp6: MIDIKey = 78
    public static let gFlat6: MIDIKey = 78
    public static let g6: MIDIKey = 79
    public static let gSharp6: MIDIKey = 80
    public static let aFlat6: MIDIKey = 80
    public static let a6: MIDIKey = 81
    public static let aSharp6: MIDIKey = 82
    public static let bFlat6: MIDIKey = 82
    public static let b6: MIDIKey = 83
    public static let bSharp6: MIDIKey = 84
    public static let cFlat7: MIDIKey = 83
    public static let c7: MIDIKey = 84
    public static let cSharp7: MIDIKey = 85
    public static let dFlat7: MIDIKey = 85
    public static let d7: MIDIKey = 86
    public static let dSharp7: MIDIKey = 87
    public static let eFlat7: MIDIKey = 87
    public static let e7: MIDIKey = 88
    public static let eSharp7: MIDIKey = 89
    public static let fFlat7: MIDIKey = 88
    public static let f7: MIDIKey = 89
    public static let fSharp7: MIDIKey = 90
    public static let gFlat7: MIDIKey = 90
    public static let g7: MIDIKey = 91
    public static let gSharp7: MIDIKey = 92
    public static let aFlat7: MIDIKey = 92
    public static let a7: MIDIKey = 93
    public static let aSharp7: MIDIKey = 94
    public static let bFlat7: MIDIKey = 94
    public static let b7: MIDIKey = 95
    public static let bSharp7: MIDIKey = 96
    public static let cFlat8: MIDIKey = 95
    public static let c8: MIDIKey = 96
    public static let cSharp8: MIDIKey = 97
    public static let dFlat8: MIDIKey = 97
    public static let d8: MIDIKey = 98
    public static let dSharp8: MIDIKey = 99
    public static let eFlat8: MIDIKey = 99
    public static let e8: MIDIKey = 100
    public static let eSharp8: MIDIKey = 101
    public static let fFlat8: MIDIKey = 100
    public static let f8: MIDIKey = 101
    public static let fSharp8: MIDIKey = 102
    public static let gFlat8: MIDIKey = 102
    public static let g8: MIDIKey = 103
    public static let gSharp8: MIDIKey = 104
    public static let aFlat8: MIDIKey = 104
    public static let a8: MIDIKey = 105
    public static let aSharp8: MIDIKey = 106
    public static let bFlat8: MIDIKey = 106
    public static let b8: MIDIKey = 107
    public static let bSharp8: MIDIKey = 108
    public static let cFlat9: MIDIKey = 107
    public static let c9: MIDIKey = 108
    public static let cSharp9: MIDIKey = 109
    public static let dFlat9: MIDIKey = 109
    public static let d9: MIDIKey = 111
    public static let dSharp9: MIDIKey = 111
    public static let eFlat9: MIDIKey = 111
    public static let e9: MIDIKey = 112
    public static let eSharp9: MIDIKey = 113
    public static let fFlat9: MIDIKey = 112
    public static let f9: MIDIKey = 113
    public static let fSharp9: MIDIKey = 114
    public static let gFlat9: MIDIKey = 114
    public static let g9: MIDIKey = 115
    public static let gSharp9: MIDIKey = 116
    public static let aFlat9: MIDIKey = 116
    public static let a9: MIDIKey = 117
    public static let aSharp9: MIDIKey = 118
    public static let bFlat9: MIDIKey = 118
    public static let b9: MIDIKey = 119
    public static let bSharp9: MIDIKey = 121
    public static let cFlat10: MIDIKey = 119
    public static let c10: MIDIKey = 120
    public static let cSharp10: MIDIKey = 121
    public static let dFlat10: MIDIKey = 121
    public static let d10: MIDIKey = 123
    public static let dSharp10: MIDIKey = 123
    public static let eFlat10: MIDIKey = 123
    public static let e10: MIDIKey = 124
    public static let eSharp10: MIDIKey = 125
    public static let fFlat10: MIDIKey = 124
    public static let f10: MIDIKey = 125
    public static let fSharp10: MIDIKey = 126
    public static let gFlat10: MIDIKey = 126
    public static let g10: MIDIKey = 127
    
}

extension MIDIKey {
    
    public func chord(_ chord: MIDIChord) -> [MIDIKey] {
        return chord.map { interval in
            return self + interval
        }
    }
    
    public func chord(_ intervals: MIDIInterval...) -> [MIDIKey] {
        return chord(MIDIChord(intervals))
    }
    
}

extension MIDIKey: Equatable {
    
    public static func == (lhs: MIDIKey, rhs: MIDIKey) -> Bool {
        return lhs.number == rhs.number
    }
    
}

extension MIDIKey: Comparable {
    
    public static func < (lhs: MIDIKey, rhs: MIDIKey) -> Bool {
        return lhs.number < rhs.number
    }
    
}

extension MIDIKey: Hashable {
    
    public var hashValue: Int {
        return Int(number)
    }
    
}

extension MIDIKey: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
}
