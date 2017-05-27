//
//  AudioComponent.swift
//  Gong
//
//  Created by Daniel Clelland on 27/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioComponent {
    
    public let reference: AudioToolbox.AudioComponent
    
    public init(_ reference: AudioToolbox.AudioComponent) {
        self.reference = reference
    }
    
}

extension AudioComponent {
    
    func description() throws -> AudioComponentDescription {
        var description = AudioComponentDescription()
        try AudioComponentGetDescription(reference, &description).audioError("Getting AudioComponent description")
        return description
    }
    
    func version() throws -> UInt32 {
        var version: UInt32 = 0
        try AudioComponentGetVersion(reference, &version).audioError("Getting AudioComponent version")
        return version
    }
    
    func icon() -> NSImage? {
        if #available(OSX 10.11, *) {
            return AudioComponentGetIcon(reference)
        } else {
            return nil
        }
    }
    
}

//AudioComponentFindNext(_ inComponent: AudioComponent?, _ inDesc: UnsafePointer<AudioComponentDescription>) -> AudioComponent?
//AudioComponentCount(_ inDesc: UnsafePointer<AudioComponentDescription>) -> UInt32
//AudioComponentCopyName(_ inComponent: AudioComponent, _ outName: UnsafeMutablePointer<Unmanaged<CFString>?>) -> OSStatus


//AudioComponentInstanceNew(_ inComponent: AudioComponent, _ outInstance: UnsafeMutablePointer<AudioComponentInstance?>) -> OSStatus
//AudioComponentInstantiate(_ inComponent: AudioComponent, _ inOptions: AudioComponentInstantiationOptions, _ inCompletionHandler: @escaping (AudioComponentInstance?, OSStatus) -> Swift.Void)
//AudioComponentInstanceDispose(_ inInstance: AudioComponentInstance) -> OSStatus
//AudioComponentInstanceGetComponent(_ inInstance: AudioComponentInstance) -> AudioComponent
//AudioComponentInstanceCanDo(_ inInstance: AudioComponentInstance, _ inSelectorID: Int16) -> Bool

//AudioComponentRegister(_ inDesc: UnsafePointer<AudioComponentDescription>, _ inName: CFString, _ inVersion: UInt32, _ inFactory: @escaping AudioToolbox.AudioComponentFactoryFunction) -> AudioComponent
//AudioComponentCopyConfigurationInfo(_ inComponent: AudioComponent, _ outConfigurationInfo: UnsafeMutablePointer<Unmanaged<CFDictionary>?>) -> OSStatus
//AudioComponentValidate(_ inComponent: AudioComponent, _ inValidationParameters: CFDictionary?, _ outValidationResult: UnsafeMutablePointer<AudioComponentValidationResult>) -> OSStatus

