//
//  StatusError.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 14/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

struct StatusError: Error {
    
    let message: String?
    let status: OSStatus
    let file: String
    let function: String
    let line: Int
    
    init(message: String?, status: OSStatus, file: String, function: String, line: Int) {
        self.message = message
        self.status = status
        self.file = file
        self.function = function
        self.line = line
    }
    
}

extension StatusError: CustomDebugStringConvertible {
    
    var debugDescription: String {
        guard let message = message else {
            return "Error of type \"\(type)\" thrown in \(function) \(filename):\(line)"
        }
        
        return "\(message): Error \"\(type)\" thrown in \(function) \(filename):\(line)"
    }
    
    private var type: String {
        return String(describing: MIDIServicesError(status))
    }
    
    private var filename: String {
        return URL(string: file)?.lastPathComponent ?? file
    }
    
}

enum MIDIServicesError: Error {
    
    case invalidClient
    case invalidPort
    case wrongEndpointType
    case noConnection
    case unknownEndpoint
    case unknownProperty
    case wrongPropertyType
    case noCurrentSetup
    case messageSendError
    case serverStartError
    case setupFormatError
    case wrongThread
    case objectNotFound
    case idNotUnique
    case notPermitted
    case unknown
    
    init(_ status: OSStatus) {
        switch status {
        case kMIDIInvalidClient: self = .invalidClient
        case kMIDIInvalidPort: self = .invalidPort
        case kMIDIWrongEndpointType: self = .wrongEndpointType
        case kMIDINoConnection: self = .noConnection
        case kMIDIUnknownEndpoint: self = .unknownEndpoint
        case kMIDIUnknownProperty: self = .unknownProperty
        case kMIDIWrongPropertyType: self = .wrongPropertyType
        case kMIDINoCurrentSetup: self = .noCurrentSetup
        case kMIDIMessageSendErr: self = .messageSendError
        case kMIDIServerStartErr: self = .serverStartError
        case kMIDISetupFormatErr: self = .setupFormatError
        case kMIDIWrongThread: self = .wrongThread
        case kMIDIObjectNotFound: self = .objectNotFound
        case kMIDIIDNotUnique: self = .idNotUnique
        case kMIDINotPermitted: self = .notPermitted
        default: self = .unknown
        }
    }
    
}

enum AUGraphError: Error {
    
    case nodeNotFound
    case invalidConnection
    case outputNodeError
    case cannotDoInCurrentContext
    case invalidAudioUnit
    case unknown
    
    init(_ status: OSStatus) {
        switch status {
        case kAUGraphErr_NodeNotFound: self = .nodeNotFound
        case kAUGraphErr_InvalidConnection: self = .invalidConnection
        case kAUGraphErr_OutputNodeErr: self = .outputNodeError
        case kAUGraphErr_CannotDoInCurrentContext: self = .cannotDoInCurrentContext
        case kAUGraphErr_InvalidAudioUnit: self = .invalidAudioUnit
        default: self = .unknown
        }
    }
    
}

// MARK: - Error implementation

extension OSStatus {
    
    func check(_ message: String? = nil, file: String = #file, function: String = #function, line: Int = #line) throws {
        if self != noErr {
            throw StatusError(message: message, status: self, file: file, function: function, line: line)
        }
    }
    
}
