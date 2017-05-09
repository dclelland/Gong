//
//  AudioQueue.swift
//  Gong
//
//  Created by Daniel Clelland on 8/05/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioQueue {
    
    public let reference: AudioQueueRef
    
    public init(_ reference: AudioQueueRef) {
        self.reference = reference
    }
    
    func test() {
    }

}

extension AudioQueue {
    
    public struct Property {
        public static let isRunning = kAudioQueueProperty_IsRunning
        public static let currentDevice = kAudioQueueProperty_CurrentDevice
        public static let magicCookie = kAudioQueueProperty_MagicCookie
        public static let maximumOutputPacketSize = kAudioQueueProperty_MaximumOutputPacketSize
        public static let streamDescription = kAudioQueueProperty_StreamDescription
        public static let channelLayout = kAudioQueueProperty_ChannelLayout
        public static let enableLevelMetering = kAudioQueueProperty_EnableLevelMetering
        public static let currentLevelMeter = kAudioQueueProperty_CurrentLevelMeter
        public static let currentLevelMeterDB = kAudioQueueProperty_CurrentLevelMeterDB
        public static let decodeBufferSizeFrames = kAudioQueueProperty_DecodeBufferSizeFrames
        public static let converterError = kAudioQueueProperty_ConverterError
        public static let enableTimePitch = kAudioQueueProperty_EnableTimePitch
        public static let timePitchAlgorithm = kAudioQueueProperty_TimePitchAlgorithm
        public static let timePitchBypass = kAudioQueueProperty_TimePitchBypass
    }
    
    public struct DeviceProperty {
        public static let sampleRate = kAudioQueueDeviceProperty_SampleRate
        public static let numberChannels = kAudioQueueDeviceProperty_NumberChannels
    }
    
}
