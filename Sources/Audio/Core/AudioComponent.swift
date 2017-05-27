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
    
    //AudioComponentFindNext(_ inComponent: AudioComponent?, _ inDesc: UnsafePointer<AudioComponentDescription>) -> AudioComponent?
    //AudioComponentCount(_ inDesc: UnsafePointer<AudioComponentDescription>) -> UInt32
    //AudioComponentCopyName(_ inComponent: AudioComponent, _ outName: UnsafeMutablePointer<Unmanaged<CFString>?>) -> OSStatus

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

extension AudioComponent {
    
    public class Instance {
        
        public let reference: AudioComponentInstance
        
        public init(_ reference: AudioComponentInstance) {
            self.reference = reference
        }
        
        public func dispose() throws {
            try AudioComponentInstanceDispose(reference).audioError("Disposing of AudioComponent instance")
        }
        
        public var component: AudioComponent {
            let componentReference = AudioComponentInstanceGetComponent(reference)
            return AudioComponent(componentReference)
        }
        
        public func canDo(selectorID: Int16) -> Bool {
            return AudioComponentInstanceCanDo(reference, selectorID)
        }
        
    }
    
    public func createInstance() throws -> Instance {
        var instanceReference: AudioComponentInstance? = nil
        try AudioComponentInstanceNew(reference, &instanceReference).audioError("Creating AudioComponent instance")
        return Instance(instanceReference!)
    }
    
    public func instantiate() {
        //AudioComponentInstantiate(_ inComponent: AudioComponent, _ inOptions: AudioComponentInstantiationOptions, _ inCompletionHandler: @escaping (AudioComponentInstance?, OSStatus) -> Swift.Void)
    }
    
}

extension AudioComponent {
    
    public func register() {
        //AudioComponentRegister(_ inDesc: UnsafePointer<AudioComponentDescription>, _ inName: CFString, _ inVersion: UInt32, _ inFactory: @escaping AudioToolbox.AudioComponentFactoryFunction) -> AudioComponent
    }
    
    public func copyConfigurationInfo() {
        //AudioComponentCopyConfigurationInfo(_ inComponent: AudioComponent, _ outConfigurationInfo: UnsafeMutablePointer<Unmanaged<CFDictionary>?>) -> OSStatus
    }
    
    public func validate() {
        //AudioComponentValidate(_ inComponent: AudioComponent, _ inValidationParameters: CFDictionary?, _ outValidationResult: UnsafeMutablePointer<AudioComponentValidationResult>) -> OSStatus
    }
    
}
