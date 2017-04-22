//
//  MIDIKey.swift
//  Gong
//
//  Created by Daniel Clelland on 22/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation

public enum MIDIKey {
    
    case c0
    case cSharp0
    case dFlat0
    case d0
    case dSharp0
    case eFlat0
    case e0
    case eSharp0
    case fFlat0
    case f0
    case fSharp0
    case gFlat0
    case g0
    case gSharp0
    case aFlat0
    case a0
    case aSharp0
    case bFlat0
    case b0
    case bSharp0
    case cFlat1
    case c1
    case cSharp1
    case dFlat1
    case d1
    case dSharp1
    case eFlat1
    case e1
    case eSharp1
    case fFlat1
    case f1
    case fSharp1
    case gFlat1
    case g1
    case gSharp1
    case aFlat1
    case a1
    case aSharp1
    case bFlat1
    case b1
    case bSharp1
    case cFlat2
    case c2
    case cSharp2
    case dFlat2
    case d2
    case dSharp2
    case eFlat2
    case e2
    case eSharp2
    case fFlat2
    case f2
    case fSharp2
    case gFlat2
    case g2
    case gSharp2
    case aFlat2
    case a2
    case aSharp2
    case bFlat2
    case b2
    case bSharp2
    case cFlat3
    case c3
    case cSharp3
    case dFlat3
    case d3
    case dSharp3
    case eFlat3
    case e3
    case eSharp3
    case fFlat3
    case f3
    case fSharp3
    case gFlat3
    case g3
    case gSharp3
    case aFlat3
    case a3
    case aSharp3
    case bFlat3
    case b3
    case bSharp3
    case cFlat4
    case c4
    case cSharp4
    case dFlat4
    case d4
    case dSharp4
    case eFlat4
    case e4
    case eSharp4
    case fFlat4
    case f4
    case fSharp4
    case gFlat4
    case g4
    case gSharp4
    case aFlat4
    case a4
    case aSharp4
    case bFlat4
    case b4
    case bSharp4
    case cFlat5
    case c5
    case cSharp5
    case dFlat5
    case d5
    case dSharp5
    case eFlat5
    case e5
    case eSharp5
    case fFlat5
    case f5
    case fSharp5
    case gFlat5
    case g5
    case gSharp5
    case aFlat5
    case a5
    case aSharp5
    case bFlat5
    case b5
    case bSharp5
    case cFlat6
    case c6
    case cSharp6
    case dFlat6
    case d6
    case dSharp6
    case eFlat6
    case e6
    case eSharp6
    case fFlat6
    case f6
    case fSharp6
    case gFlat6
    case g6
    case gSharp6
    case aFlat6
    case a6
    case aSharp6
    case bFlat6
    case b6
    case bSharp6
    case cFlat7
    case c7
    case cSharp7
    case dFlat7
    case d7
    case dSharp7
    case eFlat7
    case e7
    case eSharp7
    case fFlat7
    case f7
    case fSharp7
    case gFlat7
    case g7
    case gSharp7
    case aFlat7
    case a7
    case aSharp7
    case bFlat7
    case b7
    case bSharp7
    case cFlat8
    case c8
    case cSharp8
    case dFlat8
    case d8
    case dSharp8
    case eFlat8
    case e8
    case eSharp8
    case fFlat8
    case f8
    case fSharp8
    case gFlat8
    case g8
    case gSharp8
    case aFlat8
    case a8
    case aSharp8
    case bFlat8
    case b8
    case bSharp8
    case cFlat9
    case c9
    case cSharp9
    case dFlat9
    case d9
    case dSharp9
    case eFlat9
    case e9
    case eSharp9
    case fFlat9
    case f9
    case fSharp9
    case gFlat9
    case g9
    case gSharp9
    case aFlat9
    case a9
    case aSharp9
    case bFlat9
    case b9
    case bSharp9
    case cFlat10
    case c10
    case cSharp10
    case dFlat10
    case d10
    case dSharp10
    case eFlat10
    case e10
    case eSharp10
    case fFlat10
    case f10
    case fSharp10
    case gFlat10
    case g10
    
    public init(number value: UInt8) {
        switch value {
        case 0: self = .c0
        case 1: self = .cSharp0
        case 2: self = .d0
        case 3: self = .dSharp0
        case 4: self = .e0
        case 5: self = .f0
        case 6: self = .fSharp0
        case 7: self = .g0
        case 8: self = .gSharp0
        case 9: self = .a0
        case 10: self = .aSharp0
        case 11: self = .b0
        case 12: self = .c1
        case 13: self = .cSharp1
        case 14: self = .d1
        case 15: self = .dSharp1
        case 16: self = .e1
        case 17: self = .f1
        case 18: self = .fSharp1
        case 19: self = .g1
        case 20: self = .gSharp1
        case 21: self = .a1
        case 22: self = .aSharp1
        case 23: self = .b1
        case 24: self = .c2
        case 25: self = .cSharp2
        case 26: self = .d2
        case 27: self = .dSharp2
        case 28: self = .e2
        case 29: self = .f2
        case 30: self = .fSharp2
        case 31: self = .g2
        case 32: self = .gSharp2
        case 33: self = .a2
        case 34: self = .aSharp2
        case 35: self = .b2
        case 36: self = .c3
        case 37: self = .cSharp3
        case 38: self = .d3
        case 39: self = .dSharp3
        case 40: self = .e3
        case 41: self = .f3
        case 42: self = .fSharp3
        case 43: self = .g3
        case 44: self = .gSharp3
        case 45: self = .a3
        case 46: self = .aSharp3
        case 47: self = .b3
        case 48: self = .c4
        case 49: self = .cSharp4
        case 50: self = .d4
        case 51: self = .dSharp4
        case 52: self = .e4
        case 53: self = .f4
        case 54: self = .fSharp4
        case 55: self = .g4
        case 56: self = .gSharp4
        case 57: self = .a4
        case 58: self = .aSharp4
        case 59: self = .b4
        case 60: self = .c5
        case 61: self = .cSharp5
        case 62: self = .d5
        case 63: self = .dSharp5
        case 64: self = .e5
        case 65: self = .f5
        case 66: self = .fSharp5
        case 67: self = .g5
        case 68: self = .gSharp5
        case 69: self = .a5
        case 70: self = .aSharp5
        case 71: self = .b5
        case 72: self = .c6
        case 73: self = .cSharp6
        case 74: self = .d6
        case 75: self = .dSharp6
        case 76: self = .e6
        case 77: self = .f6
        case 78: self = .fSharp6
        case 79: self = .g6
        case 80: self = .gSharp6
        case 81: self = .a6
        case 82: self = .aSharp6
        case 83: self = .b6
        case 84: self = .c7
        case 85: self = .cSharp7
        case 86: self = .d7
        case 87: self = .dSharp7
        case 88: self = .e7
        case 89: self = .f7
        case 90: self = .fSharp7
        case 91: self = .g7
        case 92: self = .gSharp7
        case 93: self = .a7
        case 94: self = .aSharp7
        case 95: self = .b7
        case 96: self = .c8
        case 97: self = .cSharp8
        case 98: self = .d8
        case 99: self = .dSharp8
        case 100: self = .e8
        case 101: self = .f8
        case 102: self = .fSharp8
        case 103: self = .g8
        case 104: self = .gSharp8
        case 105: self = .a8
        case 106: self = .aSharp8
        case 107: self = .b8
        case 108: self = .c9
        case 109: self = .cSharp9
        case 111: self = .d9
        case 111: self = .dSharp9
        case 112: self = .e9
        case 113: self = .f9
        case 114: self = .fSharp9
        case 115: self = .g9
        case 116: self = .gSharp9
        case 117: self = .a9
        case 118: self = .aSharp9
        case 119: self = .b9
        case 120: self = .c10
        case 121: self = .cSharp10
        case 123: self = .d10
        case 123: self = .dSharp10
        case 124: self = .e10
        case 125: self = .f10
        case 126: self = .fSharp10
        case 127: self = .g10
        default: fatalError("Invalid MIDIKey number")
        }
    }
    
    public var number: UInt8 {
        switch self {
        case .c0: return 0
        case .cSharp0: return 1
        case .dFlat0: return 1
        case .d0: return 2
        case .dSharp0: return 3
        case .eFlat0: return 3
        case .e0: return 4
        case .eSharp0: return 5
        case .fFlat0: return 4
        case .f0: return 5
        case .fSharp0: return 6
        case .gFlat0: return 6
        case .g0: return 7
        case .gSharp0: return 8
        case .aFlat0: return 8
        case .a0: return 9
        case .aSharp0: return 10
        case .bFlat0: return 10
        case .b0: return 11
        case .bSharp0: return 12
        case .cFlat1: return 11
        case .c1: return 12
        case .cSharp1: return 13
        case .dFlat1: return 13
        case .d1: return 14
        case .dSharp1: return 15
        case .eFlat1: return 15
        case .e1: return 16
        case .eSharp1: return 17
        case .fFlat1: return 16
        case .f1: return 17
        case .fSharp1: return 18
        case .gFlat1: return 18
        case .g1: return 19
        case .gSharp1: return 20
        case .aFlat1: return 20
        case .a1: return 21
        case .aSharp1: return 22
        case .bFlat1: return 22
        case .b1: return 23
        case .bSharp1: return 24
        case .cFlat2: return 23
        case .c2: return 24
        case .cSharp2: return 25
        case .dFlat2: return 25
        case .d2: return 26
        case .dSharp2: return 27
        case .eFlat2: return 27
        case .e2: return 28
        case .eSharp2: return 29
        case .fFlat2: return 28
        case .f2: return 29
        case .fSharp2: return 30
        case .gFlat2: return 30
        case .g2: return 31
        case .gSharp2: return 32
        case .aFlat2: return 32
        case .a2: return 33
        case .aSharp2: return 34
        case .bFlat2: return 34
        case .b2: return 35
        case .bSharp2: return 36
        case .cFlat3: return 35
        case .c3: return 36
        case .cSharp3: return 37
        case .dFlat3: return 37
        case .d3: return 38
        case .dSharp3: return 39
        case .eFlat3: return 39
        case .e3: return 40
        case .eSharp3: return 41
        case .fFlat3: return 40
        case .f3: return 41
        case .fSharp3: return 42
        case .gFlat3: return 42
        case .g3: return 43
        case .gSharp3: return 44
        case .aFlat3: return 44
        case .a3: return 45
        case .aSharp3: return 46
        case .bFlat3: return 46
        case .b3: return 47
        case .bSharp3: return 48
        case .cFlat4: return 47
        case .c4: return 48
        case .cSharp4: return 49
        case .dFlat4: return 49
        case .d4: return 50
        case .dSharp4: return 51
        case .eFlat4: return 51
        case .e4: return 52
        case .eSharp4: return 53
        case .fFlat4: return 52
        case .f4: return 53
        case .fSharp4: return 54
        case .gFlat4: return 54
        case .g4: return 55
        case .gSharp4: return 56
        case .aFlat4: return 56
        case .a4: return 57
        case .aSharp4: return 58
        case .bFlat4: return 58
        case .b4: return 59
        case .bSharp4: return 60
        case .cFlat5: return 59
        case .c5: return 60
        case .cSharp5: return 61
        case .dFlat5: return 61
        case .d5: return 62
        case .dSharp5: return 63
        case .eFlat5: return 63
        case .e5: return 64
        case .eSharp5: return 65
        case .fFlat5: return 64
        case .f5: return 65
        case .fSharp5: return 66
        case .gFlat5: return 66
        case .g5: return 67
        case .gSharp5: return 68
        case .aFlat5: return 68
        case .a5: return 69
        case .aSharp5: return 70
        case .bFlat5: return 70
        case .b5: return 71
        case .bSharp5: return 72
        case .cFlat6: return 71
        case .c6: return 72
        case .cSharp6: return 73
        case .dFlat6: return 73
        case .d6: return 74
        case .dSharp6: return 75
        case .eFlat6: return 75
        case .e6: return 76
        case .eSharp6: return 77
        case .fFlat6: return 76
        case .f6: return 77
        case .fSharp6: return 78
        case .gFlat6: return 78
        case .g6: return 79
        case .gSharp6: return 80
        case .aFlat6: return 80
        case .a6: return 81
        case .aSharp6: return 82
        case .bFlat6: return 82
        case .b6: return 83
        case .bSharp6: return 84
        case .cFlat7: return 83
        case .c7: return 84
        case .cSharp7: return 85
        case .dFlat7: return 85
        case .d7: return 86
        case .dSharp7: return 87
        case .eFlat7: return 87
        case .e7: return 88
        case .eSharp7: return 89
        case .fFlat7: return 88
        case .f7: return 89
        case .fSharp7: return 90
        case .gFlat7: return 90
        case .g7: return 91
        case .gSharp7: return 92
        case .aFlat7: return 92
        case .a7: return 93
        case .aSharp7: return 94
        case .bFlat7: return 94
        case .b7: return 95
        case .bSharp7: return 96
        case .cFlat8: return 95
        case .c8: return 96
        case .cSharp8: return 97
        case .dFlat8: return 97
        case .d8: return 98
        case .dSharp8: return 99
        case .eFlat8: return 99
        case .e8: return 100
        case .eSharp8: return 101
        case .fFlat8: return 100
        case .f8: return 101
        case .fSharp8: return 102
        case .gFlat8: return 102
        case .g8: return 103
        case .gSharp8: return 104
        case .aFlat8: return 104
        case .a8: return 105
        case .aSharp8: return 106
        case .bFlat8: return 106
        case .b8: return 107
        case .bSharp8: return 108
        case .cFlat9: return 107
        case .c9: return 108
        case .cSharp9: return 109
        case .dFlat9: return 109
        case .d9: return 111
        case .dSharp9: return 111
        case .eFlat9: return 111
        case .e9: return 112
        case .eSharp9: return 113
        case .fFlat9: return 112
        case .f9: return 113
        case .fSharp9: return 114
        case .gFlat9: return 114
        case .g9: return 115
        case .gSharp9: return 116
        case .aFlat9: return 116
        case .a9: return 117
        case .aSharp9: return 118
        case .bFlat9: return 118
        case .b9: return 119
        case .bSharp9: return 121
        case .cFlat10: return 119
        case .c10: return 120
        case .cSharp10: return 121
        case .dFlat10: return 121
        case .d10: return 123
        case .dSharp10: return 123
        case .eFlat10: return 123
        case .e10: return 124
        case .eSharp10: return 125
        case .fFlat10: return 124
        case .f10: return 125
        case .fSharp10: return 126
        case .gFlat10: return 126
        case .g10: return 127
        }
    }
    
}

extension MIDIKey: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt8) {
        self.init(number: value)
    }
    
}
