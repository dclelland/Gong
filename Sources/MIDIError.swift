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
    
    public enum `Type` {
        
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
        
    }
    
    public let type: Type
    
    public let message: String
    
    public init(_ type: Type, message: String) {
        self.type = type
        self.message = message
    }
    
}

extension MIDIError {
    
    internal init(status: OSStatus, message: String) {
        switch status {
        case kMIDIInvalidClient:
            self.init(.invalidClient, message: message)
        case kMIDIInvalidPort:
            self.init(.invalidPort, message: message)
        case kMIDIWrongEndpointType:
            self.init(.wrongEndpointType, message: message)
        case kMIDINoConnection:
            self.init(.noConnection, message: message)
        case kMIDIUnknownEndpoint:
            self.init(.unknownEndpoint, message: message)
        case kMIDIUnknownProperty:
            self.init(.unknownProperty, message: message)
        case kMIDIWrongPropertyType:
            self.init(.wrongPropertyType, message: message)
        case kMIDINoCurrentSetup:
            self.init(.noCurrentSetup, message: message)
        case kMIDIMessageSendErr:
            self.init(.messageSendError, message: message)
        case kMIDIServerStartErr:
            self.init(.serverStartError, message: message)
        case kMIDISetupFormatErr:
            self.init(.setupFormatError, message: message)
        case kMIDIWrongThread:
            self.init(.wrongThread, message: message)
        case kMIDIObjectNotFound:
            self.init(.objectNotFound, message: message)
        case kMIDIIDNotUnique:
            self.init(.idNotUnique, message: message)
        case kMIDINotPermitted:
            self.init(.notPermitted, message: message)
        default:
            self.init(.unknown, message: message)
        }
    }
    
}

extension MIDIError: CustomDebugStringConvertible {
    
    public var debugDescription: String {
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
