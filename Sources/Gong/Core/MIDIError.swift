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
    
    public enum Message {
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
        case unknown(status: OSStatus)        
    }
    
    public let message: Message
    
    public let comment: String
    
    public init(_ message: Message, comment: String) {
        self.message = message
        self.comment = comment
    }
    
}

extension MIDIError {
    
    public init(status: OSStatus, comment: String) {
        switch status {
        case kMIDIInvalidClient:
            self.init(.invalidClient, comment: comment)
        case kMIDIInvalidPort:
            self.init(.invalidPort, comment: comment)
        case kMIDIWrongEndpointType:
            self.init(.wrongEndpointType, comment: comment)
        case kMIDINoConnection:
            self.init(.noConnection, comment: comment)
        case kMIDIUnknownEndpoint:
            self.init(.unknownEndpoint, comment: comment)
        case kMIDIUnknownProperty:
            self.init(.unknownProperty, comment: comment)
        case kMIDIWrongPropertyType:
            self.init(.wrongPropertyType, comment: comment)
        case kMIDINoCurrentSetup:
            self.init(.noCurrentSetup, comment: comment)
        case kMIDIMessageSendErr:
            self.init(.messageSendError, comment: comment)
        case kMIDIServerStartErr:
            self.init(.serverStartError, comment: comment)
        case kMIDISetupFormatErr:
            self.init(.setupFormatError, comment: comment)
        case kMIDIWrongThread:
            self.init(.wrongThread, comment: comment)
        case kMIDIObjectNotFound:
            self.init(.objectNotFound, comment: comment)
        case kMIDIIDNotUnique:
            self.init(.idNotUnique, comment: comment)
        case kMIDINotPermitted:
            self.init(.notPermitted, comment: comment)
        default:
            self.init(.unknown(status: status), comment: comment)
        }
    }
    
}

extension MIDIError: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "MIDIError(message: \(message), comment: \(comment))"
    }
    
}

extension OSStatus {
    
    public func midiError(_ comment: String) throws {
        if self != noErr {
            throw MIDIError(status: self, comment: comment)
        }
    }
    
}
