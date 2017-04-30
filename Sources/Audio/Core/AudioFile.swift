//
//  AudioFile.swift
//  Gong
//
//  Created by Daniel Clelland on 30/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioFile {
    
    public let reference: AudioFileID
    
    public init(_ reference: AudioFileID) {
        self.reference = reference
    }
    
    public convenience init(url: URL, permissions: AudioFilePermissions = .readWritePermission, typeHint: AudioFileTypeID = 0) throws {
        var audioFileReference: AudioFileID? = nil
        try AudioFileOpenURL(url as CFURL, permissions, typeHint, &audioFileReference).audioError("Initializing AudioFile with URL \"\(url)\"")
        self.init(audioFileReference!)
    }
    
    public func properties() throws -> NSDictionary {
        var dataSize: UInt32 = 0
        var isWritable: UInt32 = 0
        try AudioFileGetPropertyInfo(reference, kAudioFilePropertyInfoDictionary, &dataSize, &isWritable).audioError("Getting AudioFile property info")
        
        var dictionary: CFDictionary? = nil
        try AudioFileGetProperty(reference, kAudioFilePropertyInfoDictionary, &dataSize, &dictionary).audioError("Getting AudioFile property")
        
        return dictionary! as NSDictionary
    }
    
}

