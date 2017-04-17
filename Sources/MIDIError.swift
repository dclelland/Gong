//
//  MIDIError.swift
//  Gong
//
//  Created by Daniel Clelland on 14/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public struct MIDIError: Error {
    
    enum `Type` {
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
        
        public init(status: OSStatus) {
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
    
    let type: Type
    
    let message: String?
    
    init(status: OSStatus, message: String? = nil) {
        self.type = Type(status: status)
        self.message = message
    }
    
}

extension MIDIError: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        guard let message = message else {
            return "MIDIError(type: \(type))"
        }
        
        return "MIDIError(type: \(type), message: \(message))"
    }
    
}

extension OSStatus {
    
    internal func check(_ message: String) throws {
        if self != noErr {
            throw MIDIError(status: self, message: message)
        }
    }
    
}
