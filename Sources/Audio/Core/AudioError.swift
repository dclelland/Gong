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
        
        
//        kAUGraphErr_NodeNotFound 				= -10860,
//        kAUGraphErr_InvalidConnection 			= -10861,
//        kAUGraphErr_OutputNodeErr				= -10862,
//        kAUGraphErr_CannotDoInCurrentContext	= -10863,
//        kAUGraphErr_InvalidAudioUnit			= -10864
        
        
        
//        kAudioFileUnspecifiedError						= 'wht?',		// 0x7768743F, 2003334207
//        kAudioFileUnsupportedFileTypeError 				= 'typ?',		// 0x7479703F, 1954115647
//        kAudioFileUnsupportedDataFormatError 			= 'fmt?',		// 0x666D743F, 1718449215
//        kAudioFileUnsupportedPropertyError 				= 'pty?',		// 0x7074793F, 1886681407
//        kAudioFileBadPropertySizeError 					= '!siz',		// 0x2173697A,  561211770
//        kAudioFilePermissionsError	 					= 'prm?',		// 0x70726D3F, 1886547263
//        kAudioFileNotOptimizedError						= 'optm',		// 0x6F70746D, 1869640813
//        // file format specific error codes
//        kAudioFileInvalidChunkError						= 'chk?',		// 0x63686B3F, 1667787583
//        kAudioFileDoesNotAllow64BitDataSizeError		= 'off?',		// 0x6F66663F, 1868981823
//        kAudioFileInvalidPacketOffsetError				= 'pck?',		// 0x70636B3F, 1885563711
//        kAudioFileInvalidFileError						= 'dta?',		// 0x6474613F, 1685348671
//        kAudioFileOperationNotSupportedError			= 0x6F703F3F, 	// 'op??', integer used because of trigraph
//        // general file error codes
//        kAudioFileNotOpenError							= -38,
//        kAudioFileEndOfFileError						= -39,
//        kAudioFilePositionError							= -40,
//        kAudioFileFileNotFoundError						= -43
        
        case unknown(status: OSStatus)
        
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
            self.init(.unknown(status: status), comment: comment)
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
