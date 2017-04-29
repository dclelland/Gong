//
//  AudioError.swift
//  Gong
//
//  Created by Daniel Clelland on 29/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public struct AudioError: Error {
    
    public enum Message {
        
        case unknown
        
    }
    
    public let message: Message
    
    public let comment: String
    
    public init(_ message: Message, comment: String) {
        self.message = message
        self.comment = comment
    }
    
}

extension AudioError {
    
    public init(status: OSStatus, comment: String) {
        switch status {
        default:
            self.init(.unknown, comment: comment)
        }
    }
    
}

extension AudioError: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "AudioError(message: \(message), comment: \(comment))"
    }
    
}

extension OSStatus {
    
    public func audioError(_ comment: String) throws {
        if self != noErr {
            throw AudioError(status: self, comment: comment)
        }
    }
    
}
